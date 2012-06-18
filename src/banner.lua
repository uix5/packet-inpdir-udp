--[[ packet-inpdir-udp.lua build on %time%

Stab at a dissector for the Input Director protocol, v8 (used by 1.2.2).

This runs over UDP, (normally) at port 31234.

Tested with Wireshark 1.6.x and nightlies.

Make sure Lua is enabled in Wireshark, build dissector (see Makefile), then 
copy it to the Wireshark plugins directory (in homedir).


Code on github: github.com/uix5/packet-inpdir-udp

uix5 (c) 2012

I'm not really a Lua coder, sorry.


Project setup inspired by (copied from) the packet-bnetp project:
  http://code.google.com/p/packet-bnetp

------------------------------------------------------------------------------]]

