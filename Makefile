VERSIONNUM=1.2.8
VERSIONDATE="2024-05-13"
PROGNAME=queueing

DISTNAME=$(PROGNAME)-$(VERSIONNUM)
SUBDIRS=inst doc test devel
DISTFILES=COPYING NEWS DESCRIPTION CITATION INDEX README.md INSTALL
DISTSUBDIRS=inst inst/private doc

.PHONY: clean check htmldocs

ALL: DESCRIPTION queueing.yaml doc/conf.texi
	for d in $(SUBDIRS); do \
		$(MAKE) -C $$d $@; \
	done

doc/conf.texi:
	\rm -f doc/conf.texi
	echo "@set VERSION $(VERSIONNUM)" > doc/conf.texi
	echo "@set VERSIONDATE $(VERSIONDATE)" >> doc/conf.texi

% : %.in
	cat $< | \
	sed "s/PROGNAME/$(PROGNAME)/g" | \
	sed "s/VERSIONNUM/$(VERSIONNUM)/g" | \
	sed "s/VERSIONDATE/$(VERSIONDATE)/g" > $@

check:
	$(MAKE) -C test check

clean:
	for d in $(SUBDIRS); do \
		$(MAKE) -C $$d clean; \
	done
	\rm -r -f *~ $(DISTNAME).tar.gz $(DISTNAME).zip $(PROGNAME) $(PROGNAME)-html.tar.gz $(PROGNAME)-html INSTALL

distclean: clean
	for d in $(SUBDIRS); do \
		$(MAKE) -C $$d distclean; \
	done
	\rm -r -f doc/conf.texi docs/* fname DESCRIPTION queueing.yaml $(PROGNAME)-html

$(DISTNAME).tar.gz $(DISTNAME).zip:
	\rm -r -f $(PROGNAME) fname
	echo "$(PROGNAME)" > fname
	mkdir $(PROGNAME)
	for d in $(DISTSUBDIRS); do \
		mkdir -p $(PROGNAME)/$$d; \
		$(MAKE) -C $$d dist; \
	done
	ln $(DISTFILES) $(PROGNAME)/
	tar cfz $(DISTNAME).tar.gz $(PROGNAME)/
	zip -r $(DISTNAME).zip $(PROGNAME)/

htmldocs:
	octave -qf --eval "pkg install -local $(DISTNAME).tar.gz; pkg load $(PROGNAME); pkg load pkg-octave-doc; cd docs; package_texi2html(\"$(PROGNAME)\"); pkg uninstall $(PROGNAME); cd ..;"

## The following target is deprecated and has been replaced by `htmldocs`
## that generates html documentation according to the new style.
#$(PROGNAME)-html.tar.gz:
#	octave -qf --eval "pkg install -local $(DISTNAME).tar.gz; pkg load $(PROGNAME); pkg load generate_html;  generate_package_html ('$(PROGNAME)', '$(PROGNAME)-html', 'octave-forge'); pkg uninstall $(PROGNAME)"
#	tar cfz $(PROGNAME)-html.tar.gz $(PROGNAME)-html

dist: ALL $(DISTNAME).tar.gz $(DISTNAME).zip htmldocs
	sha256sum $(DISTNAME).tar.gz
	sha256sum $(DISTNAME).zip



