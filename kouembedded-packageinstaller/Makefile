DESTDIR=/
INSTALL_LOCATION=$(DESTDIR)/usr/

#CFLAGS:=$(shell dpkg-buildflags --get CFLAGS)
#LDFLAGS:=$(shell dpkg-buildflags --get LDFLAGS)

all:
	sleep 0

install: EmbeddedKOU-packageinstaller

EmbeddedKOU-packageinstaller:
	mkdir -p $(INSTALL_LOCATION)/bin

	cp kouembedded-packageinstaller.py $(INSTALL_LOCATION)/bin/kouembedded-packageinstaller
	chmod 755 $(INSTALL_LOCATION)/bin/kouembedded-packageinstaller

	cp update-kouembedded-xubuntu.py $(INSTALL_LOCATION)/bin/update-kouembedded-xubuntu
	chmod 755 $(INSTALL_LOCATION)/bin/update-kouembedded-xubuntu

	mkdir -p $(INSTALL_LOCATION)/share/applications
	cp kouembedded-packageinstaller.desktop $(INSTALL_LOCATION)/share/applications/

	mkdir -p $(INSTALL_LOCATION)/lib/kouembedded-packageinstaller/
	cp -r OS-updates/ $(INSTALL_LOCATION)/lib/kouembedded-packageinstaller/

clean:
	sleep 0

distclean: clean
