if COND_SINGLE_COMPILATION_UNIT
TIBAE_SOURCES = single-compilation-unit.cc
else
TIBAE_SOURCES = QoreApp.cc QC_TibcoAdapter.cc TibCommandLine.cc tibae.cc tibae-module.cc 
endif

lib_LTLIBRARIES = tibae.la
tibae_la_SOURCES = $(TIBAE_SOURCES)
tibae_la_LDFLAGS = -module -avoid-version $(TIBAE_LDFLAGS) ${TIBRV_LDFLAGS}
tibae_la_CPPFLAGS = $(TIBAE_CPPFLAGS) $(TIBRV_CPPFLAGS)

INCLUDES = -I$(top_srcdir)/include

AM_CPPFLAGS = ${QORE_CPPFLAGS}

if COND_PROFILE
AM_CXXFLAGS=-g -pg
else
if COND_DEBUG
AM_CXXFLAGS=-g
endif
endif

install-exec-hook:
	mv $(DESTDIR)$(libdir)/tibae.$(MODULE_SUFFIX) $(DESTDIR)$(libdir)/tibae-api-$(MODULE_API).qmod
	rm -f $(DESTDIR)$(libdir)/tibae.la

