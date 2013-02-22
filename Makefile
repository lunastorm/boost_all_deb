SOURCE_LINK=http://downloads.sourceforge.net/project/boost/boost/1.53.0/boost_1_53_0.tar.bz2

TARBALL_NAME=$(shell echo $(SOURCE_LINK) | sed -e 's/.*\///g')

VERSION=$(shell echo $(TARBALL_NAME) | sed -e 's/\..*//g ; s/boost_// ; s/_/./g')

ROOT=tmp/libboost-all-$(VERSION)_amd64

DEST=usr/boost-$(VERSION)

all:	deb

deb:	$(ROOT)
	dpkg-deb --build $(ROOT)
	
$(ROOT):	boost/stage debian/control
	mkdir -p $(ROOT)/$(DEST)
	cp -rf boost/stage/* $(ROOT)/$(DEST)
	mkdir -p $(ROOT)/DEBIAN
	cp -rf debian/* $(ROOT)/DEBIAN/
	sed -i -e 's/\$$VERSION/$(VERSION)/' $(ROOT)/DEBIAN/control
	mkdir -p $(ROOT)/etc/ld.so.conf.d
	echo "/$(DEST)/lib" > $(ROOT)/etc/ld.so.conf.d/libboost-all.conf

boost/stage: $(TARBALL_NAME)
	mkdir -p boost
	tar -C boost --strip-components=1 -jxvf $(TARBALL_NAME)
	cd boost ; ./bootstrap.sh && ./b2

$(TARBALL_NAME):
	wget $(SOURCE_LINK)

.PHONY:
clean-boost:
	rm -rf boost

.PHONY:
clean-deb:
	rm -rf tmp
.PHONY:
clean: clean-boost clean-deb

