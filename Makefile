VERSIONNUM=1.2.8
VERSIONDATE="2024-05-13"
PROGNAME=queueing

DISTNAME=$(PROGNAME)-$(VERSIONNUM)
SUBDIRS=inst doc test devel
DISTFILES=COPYING NEWS DESCRIPTION CITATION INDEX README.md INSTALL
DISTSUBDIRS=inst inst/private doc

.PHONY: clean check

ALL: DESCRIPTION queueing.yaml doc/conf.texi
	for d in $(SUBDIRS); do \
		$(MAKE) -C $$d ALL; \
	done

doc/conf.texi:
	\rm -f doc/conf.texi
	echo "@set VERSION $(VERSIONNUM)" > doc/conf.texi
	echo "@set VERSIONDATE $(VERSIONDATE)" >> doc/conf.texi

DESCRIPTION: DESCRIPTION.in
	cat $< | \
	sed "s/PROGNAME/$(PROGNAME)/g" | \
	sed "s/VERSIONNUM/$(VERSIONNUM)/g" | \
	sed "s/VERSIONDATE/$(VERSIONDATE)/g" > $@

queueing.yaml: queueing.yaml.in
	cat $< | \
	sed "s/PROGNAME/$(PROGNAME)/g" | \
	sed "s/VERSIONNUM/$(VERSIONNUM)/g" | \
	sed "s/VERSIONDATE/$(VERSIONDATE)/g" > $@

check:
	$(MAKE) -C test check

clean:
	for d in $(SUBDIRS); do \
		$(MAKE) -C $$d $(MAKECMDGOALS); \
	done
	\rm -r -f *~ $(DISTNAME).tar.gz $(DISTNAME).tar.gz.uue $(PROGNAME) $(PROGNAME)-html.tar.gz $(PROGNAME)-html.tar.gz.uue $(PROGNAME)-html INSTALL

distclean: clean
	for d in $(SUBDIRS); do \
		$(MAKE) -C $$d $(MAKECMDGOALS); \
	done
	\rm -r -f doc/conf.texi fname DESCRIPTION $(PROGNAME)-html

$(DISTNAME).tar.gz:
	\rm -r -f $(PROGNAME) fname
	echo "$(PROGNAME)" > fname
	mkdir $(PROGNAME)
	for d in $(DISTSUBDIRS); do \
		mkdir -p $(PROGNAME)/$$d; \
		$(MAKE) -C $$d $(MAKECMDGOALS); \
	done
	ln $(DISTFILES) $(PROGNAME)/
	tar cfz $(DISTNAME).tar.gz $(PROGNAME)/

$(PROGNAME)-html.tar.gz:
	octave-cli -qf --eval "pkg install -local $(DISTNAME).tar.gz; pkg load $(PROGNAME); pkg load generate_html;  generate_package_html ('$(PROGNAME)', '$(PROGNAME)-html', 'octave-forge'); pkg uninstall $(PROGNAME)"
	tar cfz $(PROGNAME)-html.tar.gz $(PROGNAME)-html

dist: ALL $(DISTNAME).tar.gz $(PROGNAME)-html.tar.gz
	md5sum $(DISTNAME).tar.gz
	md5sum $(PROGNAME)-html.tar.gz



