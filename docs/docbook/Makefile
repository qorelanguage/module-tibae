
SOURCES=bookinfo.docbook tibae-module.docbook

all: tibae-module-doc.html

tibae-module-doc.html: $(SOURCES)
	#docbook2html -u module.docbook
	xsltproc -o $@ driver.xsl module.docbook

