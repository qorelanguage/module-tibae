AUTOMAKE_OPTIONS = foreign

SUBDIRS = src

noinst_HEADERS = src/QC_TibcoAdapter.h \
	src/QoreApp.h \
	src/tibae.h \
	src/tibae-module.h \
	src/TibCommandLine.h

EXTRA_DIST = COPYING ChangeLog AUTHORS README \
	test/tibae-test.q \
	qore-tibae-module.spec

libtool: $(LIBTOOL_DEPS)
	$(SHELL) ./config.status --recheck
