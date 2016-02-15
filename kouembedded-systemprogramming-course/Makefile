DESTDIR=/
INSTALL_LOCATION=$(DESTDIR)/usr/

#CFLAGS:=$(shell dpkg-buildflags --get CFLAGS)
#LDFLAGS:=$(shell dpkg-buildflags --get LDFLAGS)

all:
	sleep 0

install: kouembedded-eclipse

kouembedded-eclipse:
	mkdir -p $(INSTALL_LOCATION)/bin
	cp kouembedded-reset-eclipse.sh $(INSTALL_LOCATION)/bin/kouembedded-reset-eclipse
	chmod 755 $(INSTALL_LOCATION)/bin/kouembedded-reset-eclipse
	cp kouembedded-run-eclipse.sh $(INSTALL_LOCATION)/bin/kouembedded-run-eclipse
	chmod 755 $(INSTALL_LOCATION)/bin/kouembedded-run-eclipse
	mkdir -p $(INSTALL_LOCATION)/share/applications
	cp kouembedded-eclipse.desktop $(INSTALL_LOCATION)/share/applications/

clean:
	sleep 0

distclean: clean
