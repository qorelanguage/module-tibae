AUTOMAKE_OPTIONS = foreign

SUBDIRS = src

noinst_HEADERS = src/QC_TibcoAdapter.h \
	src/QoreApp.h \
	src/tibae.h \
	src/tibae-module.h \
	src/TibCommandLine.h

EXTRA_DIST = COPYING ChangeLog AUTHORS README \
	test/tibae-test.q \
	docs/tibae-module-doc.html \
	docs/qore-style.css \
        docs/img/acrobat_a.gif \
        docs/img/acrobat.gif \
        docs/img/disk.gif \
        docs/img/qbullet-note_a.gif \
        docs/img/qbullet-note.gif \
        docs/img/remote_a.gif \
        docs/img/remote.gif \
        docs/img/scrollup_a.gif \
        docs/img/scrollup.gif \
        docs/img/word.gif \
	qore-tibae-module.spec

libtool: $(LIBTOOL_DEPS)
	$(SHELL) ./config.status --recheck
