
SOURCES=bookinfo.docbook tibae-module.docbook

DOCBOOK_ROOT := $(shell ./get-docbook-root.sh)

all: tibae-module-doc.html

tibae-module-doc.html: $(SOURCES)
	xsltproc --stringparam html.stylesheet qore-style.css \
                 --stringparam use.id.as.filename 1 \
                 --stringparam generate.toc "book toc,title" \
                 --stringparam toc.max.depth 2 \
                 --output $@ \
                 ${DOCBOOK_ROOT}/docbook.xsl \
		 module.docbook
