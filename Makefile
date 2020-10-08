MYDIR	= .
BLDDIR	= $(MYDIR)/build
FW	= $(MYDIR)/framework
CC	= ../../gbdk/bin/lcc -tempdir=$(BLDDIR) -Wl-j -Wl-m -Wl-w -Wl-yt2 -Wl-yo4 -Wl-ya4
EMU	= ../../bgb/bgb
CHK	= python $(FW)/unit_checker.py

all: clean prepare execute

clean: 
	mkdir -p $(BLDDIR)
	rm -f $(BLDDIR)/*
	rm -f $(MYDIR)/*.noi
	rm -f $(MYDIR)/*.map
	rm -f $(MYDIR)/*.gb
	rm -f $(MYDIR)/*.sna
	rm -f $(MYDIR)/*.bmp

prepare:
	$(CC) -c -o $(BLDDIR)/main.o $(FW)/main.c

execute: $(MYDIR)/*.json
	for file in $(patsubst %.json,%,$^) ; do \
		$(CC) -o $${file}.gb $(BLDDIR)/main.o $${file}.c ; \
		$(EMU) -set "DebugSrcBrk=1" -hf -stateonexit -screenonexit $(MYDIR)/$${file}.bmp -rom $${file}.gb ; \
		$(CHK) $${file}.json $${file}.noi $${file}.sna $${file}.bmp ; \
#		[[ $$? != 0 ]] && exit -1; \
	done
