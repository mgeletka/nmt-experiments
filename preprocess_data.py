import argparse
import regex as re
from bs4 import BeautifulSoup
import os.path


def preprocess_czeng20(input_filename, output_file_prefix, source_lang='en', target_lang='cs', take_from_sentence=None,
                       take_to_sentence=None):
    line_counter = 0
    with open(input_filename) as file:
        with open(f'{output_file_prefix}.{target_lang}', 'w') as cs_file:
            with open(f'{output_file_prefix}.{source_lang}', 'w') as en_file:
                while True:
                    line = file.readline()
                    if not line:
                        break
                    if line == '\n':
                        continue
                    if (take_from_sentence and line_counter >= take_from_sentence) or not take_from_sentence:
                        if (take_to_sentence and line_counter < take_to_sentence) or not take_to_sentence:
                            sentence_id, adq_score, _, _, cs_sentence, en_sentence = re.split(r'\t+', line)
                            cs_file.write(f"{en_sentence}")
                            en_file.write(f"{cs_sentence}\n")
                    line_counter += 1


def preprocess_newstest18(input_filename_prefix, output_file_prefix, source_lang='en', target_lang='cs',
                          take_from_sentence=None, take_to_sentence=None):
    source_filename = f"{input_filename_prefix}-src.{source_lang}.sgm"
    target_filename = f"{input_filename_prefix}-ref.{target_lang}.sgm"

    return preprocess_newstests(source_filename, target_filename, output_file_prefix, source_lang, target_lang,
                                take_from_sentence, take_to_sentence)


def preprocess_newstest19(input_filename_prefix, output_file_prefix, source_lang='en', target_lang='cs',
                          take_from_sentence=None, take_to_sentence=None):
    source_filename = f"{input_filename_prefix}-src-ts.{source_lang}.sgm"
    target_filename = f"{input_filename_prefix}-ref-ts.{target_lang}.sgm"

    if not os.path.isfile(source_filename) or not os.path.isfile(source_filename):
        # NOTE for some languages exists only one direction
        source_filename = f"{input_filename_prefix}-ref-ts.{source_lang}.sgm"
        target_filename = f"{input_filename_prefix}-src-ts.{target_lang}.sgm"

    return preprocess_newstests(source_filename, target_filename, output_file_prefix, source_lang, target_lang,
                                take_from_sentence, take_to_sentence)


def preprocess_newstests(source_filename, target_filename, output_file_prefix, source_lang='en', target_lang='cs',
                         take_from_sentence=None, take_to_sentence=None):
    line_counter = 0

    with open(source_filename) as source_file:
        with open(target_filename) as target_file:
            with open(f'{output_file_prefix}.{target_lang}', 'w') as output_target_file:
                with open(f'{output_file_prefix}.{source_lang}', 'w') as output_source_file:

                    soup_source = BeautifulSoup(source_file.read())
                    soup_target = BeautifulSoup(target_file.read())

                    for source_document in soup_source.find_all('doc', attrs={"origlang": source_lang}):
                        target_document = soup_target.find_all(name='doc', attrs={'docid': source_document['docid']})[0]
                        for target_segment in target_document.find_all('seg'):
                            source_segment = source_document.find_all(name='seg', attrs={'id': target_segment['id']})[0]
                            if source_segment.contents[0] == 'NO REFERENCE AVAILABLE' or target_segment.contents[
                                0] == 'NO REFERENCE AVAILABLE':
                                continue
                            else:
                                if (
                                        take_from_sentence and line_counter >= take_from_sentence) or not take_from_sentence:
                                    if (take_to_sentence and line_counter < take_to_sentence) or not take_to_sentence:
                                        output_target_file.write(f"{target_segment.contents[0]}\n")
                                        output_source_file.write(f"{source_segment.contents[0]}\n")
                                line_counter += 1


def preprocess_tedtalks(input_filename, output_file_prefix, source_lang='en', target_lang='cs', take_from_sentence=None,
                        take_to_sentence=None):
    line_counter = 0
    with open(input_filename) as tmx_file:
        with open(f'{output_file_prefix}.{target_lang}', 'w') as target_file:
            with open(f'{output_file_prefix}.{source_lang}', 'w') as source_file:
                soup = BeautifulSoup(tmx_file.read())
                for tu_element in soup.find_all('body')[0].find_all('tu'):
                    target_element = tu_element.find_all(name='tuv', attrs={'xml:lang': target_lang})[0]
                    source_element = tu_element.find_all(name='tuv', attrs={'xml:lang': source_lang})[0]
                    if target_element.contents[0].contents and source_element.contents[0].contents:
                        if (take_from_sentence and line_counter >= take_from_sentence) or not take_from_sentence:
                            if (take_to_sentence and line_counter < take_to_sentence) or not take_to_sentence:
                                target_file.write(f"{target_element.contents[0].contents[0]}\n")
                                source_file.write(f"{source_element.contents[0].contents[0]}\n")
                        line_counter += 1


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Preprocess raw data to obtain format supported in fairseq (2 files with paralel data)')

    parser.add_argument('--input-path',
                        help='Path to file with bilingual data or path prefix if parsing two files (newstest)',
                        required=True)
    parser.add_argument('--output-prefix',
                        help='Prefix to output files',
                        required=True)
    parser.add_argument('--type-of-file',
                        help='Type of file two',
                        choices=['czeng', 'tedtalks', 'newstest18', 'newstest19'],
                        required=True)
    parser.add_argument('--source-lang',
                        help='Source language shortcut',
                        required=True)
    parser.add_argument('--target-lang',
                        help='Target language shortcut',
                        required=True)
    parser.add_argument('--take-from-sentence',
                        type=int,
                        help='Ignore first n sentences and start writing to output file only after read n sentences (default read and write from the start)')
    parser.add_argument('--take-to-sentence',
                        type=int,
                        help='Write only only sentences to this number, and ignore sentences after (default read and write to the end)')

    args = parser.parse_args()
    if args.type_of_file == 'czeng':
        preprocess_czeng20(input_filename=args.input_path,
                           output_file_prefix=args.output_prefix,
                           take_from_sentence=args.take_from_sentence,
                           take_to_sentence=args.take_to_sentence,
                           source_lang=args.source_lang,
                           target_lang=args.target_lang
                           )

    elif args.type_of_file == 'newstest18':
        preprocess_newstest18(input_filename_prefix=args.input_path,
                             output_file_prefix=args.output_prefix,
                             take_from_sentence=args.take_from_sentence,
                             take_to_sentence=args.take_to_sentence,
                             source_lang=args.source_lang,
                             target_lang=args.target_lang
                             )

    elif args.type_of_file == 'newstest19':
        preprocess_newstest19(input_filename_prefix=args.input_path,
                             output_file_prefix=args.output_prefix,
                             take_from_sentence=args.take_from_sentence,
                             take_to_sentence=args.take_to_sentence,
                             source_lang=args.source_lang,
                             target_lang=args.target_lang
                             )

    elif args.type_of_file == 'tedtalks':
        preprocess_tedtalks(input_filename=args.input_path,
                            output_file_prefix=args.output_prefix,
                            take_from_sentence=args.take_from_sentence,
                            take_to_sentence=args.take_to_sentence,
                            source_lang=args.source_lang,
                            target_lang=args.target_lang
                            )
