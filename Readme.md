# NMT experiments
Neural machine translation experiments, developed as part of my master thesis with collaboration of Coworkers.ai and FI MUNI Brno.

You can find different experiments on different branches of this project.

Included experiments so far:

* base transformer (vaswani model) trained with 16 point precision:
	* branch = base-model-czeng 
		* model trained on en -> cs NMT wth all czeng2.0 paralel corpus
	* branch = base-model-subtitles
		* model trained on en -> cs NMT with only open subtitles dataset
	* branch = base-model-czeng-cs2en
		* model trained on cs -> en NMT wth all czeng2.0 paralel corpus
