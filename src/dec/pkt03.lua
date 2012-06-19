
local function diss_pkt03(buf, pinfo, tree, goffset)
    -- handle common part
    res = dec_header(buf, pinfo, tree, goffset)
    if res < 0 then return res end

    -- the rest
    local offset = goffset + res


    -- encryption hack
    -- read byte 4 bytes back
    local b_encrypted = (buf(offset -4, 1):le_uint() ~= 0)



    -- number of slave we are entering
    add_named_tree_field(buf, tree, offset, 4, "Slave Number")
    offset = offset + 4


    -- dunno constant
    add_named_tree_field(buf, tree, offset, 4, "Unknown1")
    offset = offset + 4


    -- at which sides does this slave have screens to transition to?
    local conn_at = buf(offset, 4):le_uint()
    add_named_tree_field(buf, tree, offset, 4, "Neighbours"):append_text(
        _F(": %s", decode_side_flags(conn_at)))
    offset = offset + 4


    -- dunno
    offset = offset + add_unknown_field(buf, pinfo, tree, offset, 20)


    -- dunno constant
    add_named_tree_field(buf, tree, offset, 4, "Unknown3")
    offset = offset + 4


    -- dunno constant
    add_named_tree_field(buf, tree, offset, 4, "Unknown4")
    offset = offset + 4


    -- absolute coordinate of where cursor transitioned
    local abs_coord = (buf(offset, 4):le_uint() / 65536.0) * 100.0
    add_named_tree_field(buf, tree, offset, 4, "Enter at"):append_text(
        _F(", %.2f%%", abs_coord))
    offset = offset + 4

    -- flag indicating which side cursor should 'enter' screen
    local enter_from = buf(offset, 1):le_uint()
    add_named_tree_field(buf, tree, offset, 4, "Enter from side"):append_text(
        _F(": %s", screen_enter_pos_str_or_unknown(enter_from)))
    offset = offset + 4

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

    
    -- master mouse preferences on slave
    offset = offset + diss_mouse_settings(buf, pinfo, tree, offset)


    -- cursor transition settings
    offset = offset + diss_cursor_trans_settings(buf, pinfo, tree, offset)



    -- no point in continuing if payload encrypted
    if b_encrypted then
        offset = offset + add_encrypted_field(buf, pinfo, tree, offset)
        return (offset - goffset)
    end



    -- add_zeros_field(buf, pinfo, tree, goffset, len = nil)
    offset = offset + add_unknown_field(buf, pinfo, tree, offset, 16)


    -- I think there is again a screen grid here, but not sure
    offset = offset + diss_screen_grid(buf, pinfo, tree, offset)


    -- clipboard stuff
    offset = offset + diss_clipboard_format_list(buf, pinfo, tree, offset, cb_list_len)


    -- add_zeros_field(buf, pinfo, tree, goffset, len = nil)
    offset = offset + add_unknown_field(buf, pinfo, tree, offset)


    return (offset - goffset)
end
