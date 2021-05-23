#!/usr/bin/bash

jupyter nbconvert $1 --TagRemovePreprocessor.remove_cell_tags 'noexport' \
        --TagRemovePreprocessor.remove_input_tags 'noinput' \
        --to 'latex' \
        --output $(echo $1 | cut -d. -f1).tex

latexmk -xelatex -f $(echo $1 | cut -d. -f1).tex

latexmk -c
