MNAME=tibae

.qpp.cpp:
	qpp $<

GENERATED_SRC = ql_tibae.cpp
CLEANFILES = $(GENERATED_SRC)

if COND_SINGLE_COMPILATION_UNIT
single-compilation-unit.cc: $(GENERATED_SRC)
TIBAE_SOURCES = single-compilation-unit.cc
else
TIBAE_SOURCES = QoreApp.cc QC_TibcoAdapter.cc TibCommandLine.cc tibae.cc tibae-module.cc 
nodist_tibae_la_SOURCES = $(GENERATED_SRC)
endif

lib_LTLIBRARIES = tibae.la
tibae_la_SOURCES = $(TIBAE_SOURCES)
tibae_la_LDFLAGS = -module -avoid-version $(TIBAE_LDFLAGS) ${TIBRV_LDFLAGS}
tibae_la_CPPFLAGS = $(TIBAE_CPPFLAGS) $(TIBRV_CPPFLAGS) ${QORE_CPPFLAGS}

INCLUDES = -I$(top_srcdir)/include

if COND_PROFILE
AM_CXXFLAGS=-g -pg
else
if COND_DEBUG
AM_CXXFLAGS=-g
endif
endif

install-exec-hook:
	mv $(DESTDIR)$(libdir)/$(MNAME).$(MODULE_SUFFIX) $(DESTDIR)$(libdir)/$(MNAME)-api-$(MODULE_API).qmod
	$(RM) $(DESTDIR)$(libdir)/$(MNAME).la $(RM_OTHER)
