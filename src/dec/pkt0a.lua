

-- something with cursor return?
local function diss_pkt0A(buf, pinfo, tree, goffset)
    -- handle common part
    res = dec_header(buf, pinfo, tree, goffset)
    if res < 0 then return res end

    -- the rest
    local offset = goffset + res


    -- dunno constant
    local cb_list_len = buf(offset, 1):le_uint()
    add_named_tree_field(buf, tree, offset, 4, "Clipboard format list len")
    offset = offset + 4

    -- mask? ip?
    add_named_tree_field_ipv4(buf, tree, offset, 4, "Mask / IP?")
    offset = offset + 4

    -- port?
    add_named_tree_field(buf, tree, offset, 2, "Port?")
    offset = offset + 4


    -- some constants
    local bla = 88
    tree:add(buf(offset, bla), _F("Unknown (%d bytes)", bla))
    offset = offset + bla


    -- clipboard stuff
    offset = offset + diss_clipboard_format_list(buf, pinfo, tree, offset, cb_list_len)


    -- add_zeros_field(buf, pinfo, tree, goffset, len = nil)
    offset = offset + add_zeros_field(buf, pinfo, tree, offset)

    -- handled 'offset' bytes
    return (offset - goffset)
end

