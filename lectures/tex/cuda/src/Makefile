PT_SRC = intro-cuda-pt.tex
PT_PDF = intro-cuda-pt.pdf

EN_SRC = intro-cuda-en.tex
EN_PDF = intro-cuda-en.pdf

TEXC = latexmk -xelatex -shell-escape

.PHONY: slides-en slides-pt

all: slides-en slides-pt

$(EN_PDF): $(EN_SRC)
	$(TEXC) $(EN_SRC)

$(PT_PDF): $(PT_SRC)
	$(TEXC) $(PT_SRC)

slides-en: $(EN_PDF)

slides-pt: $(PT_PDF)

clean:
	latexmk -c
