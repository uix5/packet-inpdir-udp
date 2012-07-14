#include "banner.lua"
do
    -- cache globals to local for speed.
    -- copied from LLUDP_Dissector
    local _F=string.format
 
    -- wireshark API globals
    local Pref = Pref


    -- Plugin configurable parameters.
    local Config = {
        port = 31234,
        show_unknowns = true,
    }





    -- create protocol
    local p_inputdir = Proto("INPDIRv8", "Input Director UDP (v8)")

    p_inputdir.prefs["udp_port_start"] = Pref.string("UDP port range start", "31234", "Start of UDP port range")
    p_inputdir.prefs["udp_port_end"]   = Pref.string("UDP port range end", "31234", "End of UDP port range")
    p_inputdir.prefs["enable_ver_check"] = Pref.bool("Enable version check", true, "Should dissector abort on wrong protocol version?")


    local current_settings = {
        udp_port_start = -1,
        udp_port_end = -1,
    }

    local pkt_types_str = { 
    #include "constants.lua"
    }









    -- create protocol fields
    local f = p_inputdir.fields

    -- http://www.wireshark.org/docs/wsug_html_chunked/lua_module_Proto.html#lua_class_ProtoField
    -- common fields
    f.magic       = ProtoField.bytes ("inpdir.header.magic",       "Magic")
    f.hdr_len     = ProtoField.uint32("inpdir.header.len",         "Header Length",   base.DEC)
    f.version     = ProtoField.uint32("inpdir.header.version",     "Version",         base.DEC)
    f.payl_type   = ProtoField.uint8 ("inpdir.header.type",        "Type",            base.HEX, pkt_types_str)
    f.payl_len    = ProtoField.uint32("inpdir.header.plen",        "Packet Length",   base.DEC)
    f.msg_nr      = ProtoField.uint32("inpdir.header.seq",         "Sequence number", base.DEC)
    f.session_key = ProtoField.guid  ("inpdir.header.session_key", "Session key",     base.HEX)
    f.ip_src      = ProtoField.ipv4  ("inpdir.header.srcip",       "Sender IP",       base.DEC)
    f.port_src    = ProtoField.uint16("inpdir.header.srcport",     "Sender Port",     base.DEC)










    local MAGIC_STR0 = 0x17220100
    local MAGIC_STR1 = 0x038f3bd4
    local MAGIC_STR2 = MAGIC_STR0

    local HDR_LEN = 0xa4

    local INPDIR_VER = 0x8

    local COMMON_LENGTH = 64 -- bytes



    -- Windows INPUT type values
    -- from:
    --  http://msdn.microsoft.com/en-us/library/windows/desktop/ms646270
    local input_type_str = {
        [0x00] = "Mouse",
        [0x01] = "Keyboard",
        [0x02] = "Hardware"
    }

    local INPUT_MOUSE    = 0x00
    local INPUT_KEYBOARD = 0x01
    local INPUT_HARDWARE = 0x02

    local INPUT_SZ = 28 -- bytes
    local INPUT_MOUSE_SZ = 24
    local INPUT_KEYBOARD_SZ = 16
    local INPUT_HARDWARE_SZ = 8


    local input_event_sz_map = {
        [INPUT_MOUSE] = INPUT_MOUSE_SZ,
        [INPUT_KEYBOARD] = INPUT_KEYBOARD_SZ,
        [INPUT_HARDWARE] = INPUT_HARDWARE_SZ
    }





    #include "valuemaps.lua"
    #include "utils.lua"

    #include "api/input_event.lua"
    #include "api/mouse_settings.lua"
    #include "api/screen_grid.lua"
    #include "api/cursor_trans_settings.lua"
    #include "api/clipboard_format_list.lua"
    #include "api/keyboard_settings.lua"



    -- pkt decoders
    #include "decoders.lua"



    -- default handler
    local function diss_default(buf, pinfo, tree, goffset)
        -- handle common part
        res = dec_header(buf, pinfo, tree, goffset)
        if res < 0 then return res end

        -- the rest
        local offset = goffset + res

        -- add_zeros_field(buf, pinfo, tree, goffset, len = nil)
        offset = offset + add_zeros_field(buf, pinfo, tree, offset)

        -- handled 'offset' bytes
        return (offset - goffset)
    end



    -- map decoders to packet types
    local diss_f_array = {
        [PKT_INPUT_EVENT] = diss_pkt02,
        [PKT_CURSOR_ENTER] = diss_pkt03,
        [PKT_CURSOR_ENTER_ACK] = diss_pkt04,
        [PKT_SLAVE_CONFIG_REQUEST] = diss_pkt05,
        [PKT_SLAVE_CONFIG_REPLY] = diss_pkt06,
        [PKT_CURSOR_EXIT] = diss_pkt07,

        [PKT_CURSOR_SHORTCUT_RETURN] = diss_pkt09,
        [PKT_SLAVE_CLIPBOARD_STATUS] = diss_pkt0A,
        [PKT_INPUT_MIRROR] = diss_pkt0B,

        [PKT_SCREENSAVER_STATE] = diss_pkt0F,
        [PKT_CONFIGURATION_UPDATE] = diss_pkt14,

        [PKT_DISABLE_EDGE_TRANSITIONS] = diss_pkt16,

        [PKT_ENCRYPTION_CONFIG_MISMATCH] = diss_pkt19,
    }







    -- actual dissector method
    function p_inputdir.dissector (buf, pinfo, tree)
        if tree then
            -- check pkt len
            local pkt_len = buf:len()
            if (pkt_len <= 0) or (pkt_len < COMMON_LENGTH) then return end

            -- check version early
            local _ver_offset = 4 * 4
            local _ver = buf(_ver_offset, 4):le_uint()
            if p_inputdir.prefs.enable_ver_check and (_ver ~= INPDIR_VER) then
                -- don't add anything, just return, we can't dissect this
                pinfo.desegment_len = 0
                return 0
            end

            -- assume all is ok here, so
            -- clear any previous text
            if pinfo.columns.info then
                pinfo.columns.info:clear()
            end

            -- add protocol to tree
            local subtree = tree:add(p_inputdir, buf())

            -- primitive magic check
            if buf(0, 4):uint() ~= MAGIC_STR0 
                or buf(4, 4):uint() ~= MAGIC_STR1 
                or buf(8, 4):uint() ~= MAGIC_STR2 
            then
                -- not our pkt type
                subtree:add_expert_info(PI_MALFORMED, PI_ERROR, "Missing magic bytes")
                return
            end

            -- 
            local pkt_type_offset = 5 * 4
            local pkt_type = buf(pkt_type_offset, 4):le_uint()


            -- create string repr of packet type
            local pkt_t_str = pkt_types_str[pkt_type] or "Unknown"

            -- add some extra info to the protocol line in the packet treeview
            subtree:append_text(_F(", %s (0x%02x), %u bytes", 
                pkt_t_str, pkt_type, pkt_len))

            -- add info to top pkt view
            if pinfo.columns.protocol then
                pinfo.columns.protocol:set(p_inputdir.name)
            end

            if pinfo.columns.info then
                pinfo.cols.info:set(_F("%s (0x%02x)", pkt_t_str, pkt_type))
            end

            -- get hold of the decoding function
            local f = diss_f_array[pkt_type] or diss_default

            -- see if there is one, if not, uses generic decoder
            local offset = 0
            local res = f(buf, pinfo, subtree, offset)

            return res

        else
            -- nil 'tree', error
            error ("Input Director dissector called with 'nil' tree")

        end -- if tree then

    end



    local function unregister_udp_port_range(start_port, end_port)
        if not start_port or start_port <= 0 or not end_port or end_port <= 0 then
            return
        end
        local tcp_port_table = DissectorTable.get("udp.port")
        for port = start_port,end_port do
            tcp_port_table:remove(port, p_inputdir)
        end
    end


    local function register_udp_port_range(start_port, end_port)
        if not start_port or start_port <= 0 or not end_port or end_port <= 0 then
            return
        end
        local tcp_port_table = DissectorTable.get("udp.port")
        for port = start_port,end_port do
            tcp_port_table:add(port, p_inputdir)
        end
    end


    -- handle preferences changes.
    function p_inputdir.init(arg1, arg2)
        local old_start, old_end
        local new_start, new_end
        -- check if preferences have changed.
        for pref_name,old_v in pairs(current_settings) do
            local new_v = p_inputdir.prefs[pref_name]
            if new_v ~= old_v then
                if pref_name == "udp_port_start" then
                    old_start = old_v
                    new_start = new_v
                elseif pref_name == "udp_port_end" then
                    old_end = old_v
                    new_end = new_v
                end
                -- save new value.
                current_settings[pref_name] = new_v
            end
        end
        -- un-register old port range
        if old_start and old_end then
            unregister_udp_port_range(tonumber(old_start), tonumber(old_end))
        end
        -- register new port range.
        if new_start and new_end then
            register_udp_port_range(tonumber(new_start), tonumber(new_end))
        end
    end





    -- register a chained dissector for port
    local udp_dissector_table = DissectorTable.get("udp.port")
    dissector_udp = udp_dissector_table:get_dissector(Config.port)
    -- you can call dissector form function p_inputdir.dissector above
    -- so that the previous dissector gets called
    udp_dissector_table:add(Config.port, p_inputdir)


end -- of file
