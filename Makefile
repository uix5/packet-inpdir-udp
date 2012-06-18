MKDIR?=mkdir
RM?=rm
ZIP?=zip
PERL?=/usr/bin/perl

# Windows note: use w32-filepp.exe directly, in case no perl available
FILEPP=$(PERL) tools/filepp/filepp
FILEPP_FLAGS= \
	-m pb-utils.pm \
	-m literal.pm

GCUFLAGS?=-p packet-inpdir-udp -s "packet-inpdir-udp plugin"

PKGNAME=packet-inpdir-udp
DISTNAME=packet-inpdir-udp-src
VERSION:=$(shell date +%Y%m%d)

PKG = \
	build/packet-inpdir-udp.lua

SOURCES = \
	src/banner.lua \
	src/constants.lua \
	src/core.lua \
	src/decoders.lua \
	src/utils.lua \
	src/valuemaps.lua \
	src/api/clipboard_format_list.lua \
	src/api/cursor_trans_settings.lua \
	src/api/input_event.lua \
	src/api/mouse_settings.lua \
	src/api/screen_grid.lua \
	src/dec/common.lua \
	src/dec/pkt02.lua \
	src/dec/pkt03.lua \
	src/dec/pkt04.lua \
	src/dec/pkt05.lua \
	src/dec/pkt06.lua \
	src/dec/pkt07.lua \
	src/dec/pkt09.lua \
	src/dec/pkt0a.lua \
	src/dec/pkt0b.lua \
	src/dec/pkt0f.lua \
	src/dec/pkt10.lua \
	src/dec/pkt12.lua \
	src/dec/pkt13.lua \
	src/dec/pkt14.lua \
	src/dec/pkt16.lua \
	src/dec/pkt17.lua \
	src/dec/pkt19.lua \
	src/dec/pkt1a.lua \
	src/dec/pkt1b.lua \
	src/dec/pkt1c.lua \
	src/dec/pkt1d.lua \


DIST = \
	$(SOURCES) \
	$(PKG) \
	tools/filepp.exe \
	Makefile


src/packet-inpdir-udp.lua: $(SOURCES)
	$(MKDIR) -p build
	$(FILEPP) $(FILEPP_FLAGS) src/core.lua > build/packet-inpdir-udp.lua


.PHONY: pkg clean

$(PKGNAME)-$(VERSION).zip: $(PKG)
	$(MKDIR) $(PKGNAME)-$(VERSION) && (\
		( cp $(PKG) $(PKGNAME)-$(VERSION) && \
		  $(ZIP) -9 -r $(PKGNAME)-$(VERSION).zip $(PKGNAME)-$(VERSION) ); \
		$(RM) -r $(PKGNAME)-$(VERSION) )

pkg: $(PKGNAME)-$(VERSION).zip

clean:
	$(RM) build/packet-inpdir-udp.lua

# copy dissector to Wireshark plugin dir on Windows
install-win: src/packet-inpdir-udp.lua
	(cp build/packet-inpdir-udp.lua "$(APPDATA)\\wireshark\\plugins")


-include Makefile.local
