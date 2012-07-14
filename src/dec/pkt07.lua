
local function diss_pkt07(buf, pinfo, tree, goffset)
    -- handle common part
    res = dec_header(buf, pinfo, tree, goffset)
    if res < 0 then return res end

    -- the rest
    local offset = goffset + res



    -- number of slave we are returning from
    add_named_tree_field(buf, tree, offset, 4, "Slave Number")
    offset = offset + 4

    -- dunno constant
    add_named_tree_field(buf, tree, offset, 4, "Unknown")
    offset = offset + 4

    -- absolute coordinate of where cursor transitioned
    add_named_tree_field(buf, tree, offset, 4, "Exit Abs Coord"):append_text(
        _F(" (%.2f%%)", mickeys_to_perc(get_uint32_le(buf, offset))))
    offset = offset + 4

    -- flag indicating which side cursor should 'enter' screen
    local enter_from = buf(offset, 1):le_uint()
    add_named_tree_field(buf, tree, offset, 4, "Exit Side"):append_text(
        _F(": %s", screen_enter_pos_str_or_unknown(enter_from)))
    offset = offset + 4

    -- add_zeros_field(buf, pinfo, tree, goffset, len = nil)
    offset = offset + add_zeros_field(buf, pinfo, tree, offset)

    -- handled 'offset' bytes
    return (offset - goffset)
end

