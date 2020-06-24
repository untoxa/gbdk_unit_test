MYDIR	= .
BLDDIR	= $(MYDIR)/build
FW	= $(MYDIR)/framework
CC	= ../../gbdk/bin/lcc -tempdir=$(BLDDIR) -Wl-m
EMU	= ../../bgb/bgb
CHK	= python $(FW)/unit_checker.py

all: clean prepare compile

clean: 
	mkdir -p $(BLDDIR)
	rm -f $(BLDDIR)/*
	rm -f $(MYDIR)/*.map
	rm -f $(MYDIR)/*.gb
	rm -f $(MYDIR)/*.sna
	rm -f $(MYDIR)/*.bmp

prepare:
	$(CC) -c -o $(BLDDIR)/main.o $(FW)/main.c

compile: $(MYDIR)/*.c
	for file in $(patsubst %.c,%,$^) ; do \
		$(CC) -o $${file}.gb $(BLDDIR)/main.o $${file}.c ; \
		$(EMU) -set "DebugSrcBrk=1" -hf -stateonexit -screenonexit $(MYDIR)/$${file}.bmp -rom $${file}.gb ; \
		$(CHK) $${file}.json $${file}.map $${file}.sna $${file}.bmp ; \
	done
