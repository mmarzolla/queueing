DOC=queueing
CHAPTERS=$(patsubst %.txi, %.texi, $(wildcard *.txi))
FIGS=qn_open_single qn_closed_single qn_web_model qn_closed_multi web power qn_closed_multi_apl qn_closed_multi_cs snakes_and_ladders snakes_and_ladders_board
FIGS_EPS=$(FIGS:%=%.eps)
FIGS_PDF=$(FIGS:%=%.pdf)
FIGS_PNG=$(FIGS:%=%.png)
FIGS_TO_REMOVE=$(filter-out $(FIGS_EPS) $(FIGS_PDF) $(FIGS_PNG), snakes_and_ladders_board.eps)
DISTFILES=demo_web.m conf.texi $(DOC).pdf $(DOC).html $(DOC).texi $(CHAPTERS) $(FIGS_PDF) $(FIGS_PNG) $(wildcard *.fig)

.PHONY: clean dist

ALL: html pdf ../INSTALL

html: $(DOC).html

pdf: $(DOC).pdf

info: $(DOC).info

../INSTALL: installation.texi
	-$(MAKEINFO) -D INSTALLONLY \
	  --no-validate --no-headers --no-split --output $@ $<

$(DOC).html: $(DOC).texi conf.texi $(CHAPTERS) $(FIGS_PNG)
	-$(MAKEINFO) --html --no-split $(DOC).texi

$(DOC).pdf: $(DOC).texi conf.texi $(CHAPTERS) $(FIGS_PDF)
	texi2pdf  -o $(DOC).pdf $(DOC).texi

$(DOC).info: $(DOC).texi conf.texi $(CHAPTERS)
	-$(MAKEINFO) $(DOC).texi

%.texi: %.txi
	octave -p../inst/ -q munge-texi.m $< ../inst/ > $@

%.png: %.fig
	fig2dev -L png -m 3 $< $@

## NB: Direct fig->pdf conversion does not work with fig2dev 3.2.7a
## since it produces a PDF 1.7 file, while pdftex expects PDF 1.5.
## Therefore, the following rule is commented out, and fig->pdf
## conversion happens through the longer chain fig->eps->pdf

#%.pdf: %.fig
#	fig2dev -L pdf $< $@

%.eps: %.fig
	fig2dev -L eps $< $@

web.eps power.eps: demo_web.m
	octave -p../inst/ -q $<

snakes_and_ladders.eps: markovchains_figures.m
	octave -p../inst/ -q $<

%.pdf: %.eps
	epstopdf $<

%.png: %.eps
	convert -density 300 -background white -flatten $< $@

dist: $(DISTFILES)
	ln $(DISTFILES) ../`cat ../fname`/doc/

clean:
	\rm -f *.fns $(DOC).pdf *.aux *.log $(DOC).dvi *.out *.info $(DOC).html *.ky *.tp *.toc *.vr *.cp *.fn *.pg *.op *.au *.aus *.cps x.log *~ DOCSTRINGS $(CHAPTERS)

distclean: clean
	\rm -f $(FIGS_PDF) $(FIGS_PNG)
