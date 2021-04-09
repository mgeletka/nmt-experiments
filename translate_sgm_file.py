from bs4 import BeautifulSoup


def parse_sgm_file(sgm_filename, output_filename):
    with open(sgm_filename) as sgm_file:
        with open(output_filename, 'a') as output_file:
            soup = BeautifulSoup(sgm_file.read())
            for document in soup.find_all('doc'):
                for segment in document.find_all('seg'):
                    output_file.write(f"{segment.text}\n")


def translate_sfm_file(source_filename, source_translated_filename, sgm_filename, output_filename):
    with open(source_filename) as source_file:
        with open(source_translated_filename) as translated_file:
            with open(sgm_filename) as sgm_file:
                soup = BeautifulSoup(sgm_file.read())
                source_file_lines = source_file.readlines()
                translated_file_lines = translated_file.readlines()
                for document in soup.find_all('doc'):
                    for segment in document.find_all('seg'):
                        segment_translation = [translated_file_lines[i] for i in range(len(source_file_lines))
                                               if source_file_lines[i].strip() == segment.text]
                        translation_to_write = segment_translation[
                            0] if segment_translation else 'TRANSLATION NOT AVAILABLE'
                        segment.string.replace_with(translation_to_write)

    with open(output_filename, 'w') as output_file:
        output_file.write(str(soup))


if __name__ == '__main__':
    #parse_sgm_file('/home/martin/master_thesis/nmt-experiments/data/raw-data/newstest2017/test/newstest2017-csen-src.cs.sgm', 'full-newstest2017.cs')
    translate_sfm_file('full-newstest2017.cs', 'full-newstest2017-translated.en',
                        'data/raw-data/newstest2017/test/newstest2017-encs-ref.cs.sgm', 'submission_wmt17-cs2en.sgm')
