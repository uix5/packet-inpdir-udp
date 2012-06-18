
local function diss_pkt07(buf, pinfo, tree, goffset)
    -- handle common part
    res = dec_header(buf, pinfo, tree, goffset)
    if res < 0 then return res end

    -- the rest
    local offset = goffset + res



    -- dunno constant
    add_named_tree_field(buf, tree, offset, 4, "Center cursor on return?")
    offset = offset + 4

    -- dunno constant
    add_named_tree_field(buf, tree, offset, 4, "Again?")
    offset = offset + 4

    -- absolute coordinate of where cursor transitioned
    local abs_exit_pos = buf(offset, 4):le_uint()
    local abs_exit_pos_px = (abs_exit_pos / 65536.0) * 100.0
    add_named_tree_field(buf, tree, offset, 4, "Exit at"):append_text(
        _F(", %.2f%%", abs_exit_pos_px))
    offset = offset + 4

    -- flag indicating which side cursor should 'enter' screen
    local enter_from = buf(offset, 1):le_uint()
    add_named_tree_field(buf, tree, offset, 4, "Exit side"):append_text(
        _F(": %s", screen_enter_pos_str_or_unknown(enter_from)))
    offset = offset + 4

    -- add_zeros_field(buf, pinfo, tree, goffset, len = nil)
    offset = offset + add_zeros_field(buf, pinfo, tree, offset)

    -- handled 'offset' bytes
    return (offset - goffset)
end

