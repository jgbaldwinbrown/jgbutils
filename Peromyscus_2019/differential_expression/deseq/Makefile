SHELL := /bin/bash

all: combined_all.txt

combined_all.txt: combine_feature_counts.py full_sample_description.txt combine_all.py
	python combine_all.py
	touch $@

