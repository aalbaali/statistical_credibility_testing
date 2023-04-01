defaults: main.pdf

# Building main file
build_main: src/*.tex
	@echo "\033[92;1mBuilding '*.tex'\033[0m"
	@latexmk -cd -pdf --output-directory=$(CURDIR)/build src/main.tex -jobname=$(JOBNAME)

# Copy main pdf to root directory
main.pdf: build_main
	cp build/*.pdf $(shell basename $(CURDIR)).pdf

# Clean
clean:
	@latexmk -cd -pdf --output-directory=$(CURDIR)/build src/main.tex -jobname=$(JOBNAME) -c
	@if [ -d build ]; then \
		echo "\033[93;1mRemoving build/\033[0m\n" \
		&& rm -r build; \
	fi
