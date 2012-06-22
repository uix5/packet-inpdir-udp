
local function diss_pkt02(buf, pinfo, tree, goffset)
    -- handle common part
    local res = dec_header(buf, pinfo, tree, goffset)
    if res < 0 then return res end

    -- the rest
    local offset = goffset + res


    -- encryption hack
    -- read byte 4 bytes back
    local b_encrypted = (buf(offset -4, 1):le_uint() ~= 0)



    -- nr of input events?
    local nr_of_events = buf(offset, 4):le_uint()
    add_named_tree_field(buf, tree, offset, 4, "Nr of events?")
    offset = offset + 4

    -- dunno constant
    add_named_tree_field(buf, tree, offset, 4, "Unknown1"):append_text(" (D:0x01?)")
    offset = offset + 4

    -- number of slave we are directing
    add_named_tree_field(buf, tree, offset, 4, "Slave Number")
    offset = offset + 4


    -- keyboard layout settings
    offset = offset + diss_keyboard_settings(buf, pinfo, tree, offset)


    -- dunno
    offset = offset + add_unknown_field(buf, pinfo, tree, offset, 16)


    -- dunno constant
    offset = offset + add_unknown_fields(buf, pinfo, tree, offset, 2, 4)


    -- absolute coordinate of where cursor transitioned
    local abs_coord = (buf(offset, 4):le_uint() / 65536.0) * 100.0
    add_named_tree_field(buf, tree, offset, 4, "Enter Abs Coord? (G)"):append_text(
        _F(", %.2f%%", abs_coord))
    offset = offset + 4


    -- side where cursor came from?
    local cursor_origin = buf(offset, 4):le_uint()
    add_named_tree_field(buf, tree, offset, 4, "Enter Side? (G)"):append_text(
        _F(": %s", decode_side_flags(cursor_origin)))
    offset = offset + 4


    -- dunno constant
    local cb_list_len = buf(offset, 1):le_uint()
    add_named_tree_field(buf, tree, offset, 4, "Clipboard format list len (G)")
    offset = offset + 4

    -- some sort of ip mask
    add_named_tree_field_ipv4(buf, tree, offset, 4, "Mask / IP?")
    offset = offset + 4

    -- seems to be the port again
    add_named_tree_field(buf, tree, offset, 2, "Port?")
    offset = offset + 4




    -- master mouse preferences on slave
    res = diss_mouse_settings(buf, pinfo, tree, offset)
    offset = offset + res


    -- cursor transition flags
    offset = offset + diss_cursor_trans_settings(buf, pinfo, tree, offset)


    -- no point in continuing if payload encrypted
    if b_encrypted then
        offset = offset + add_encrypted_field(buf, pinfo, tree, offset)
        return (offset - goffset)
    end


    -- dunno again
    offset = offset + add_unknown_field(buf, pinfo, tree, offset, 16)


    -- input events start at payload start
    local payload_start = HDR_LEN
    offset = payload_start


    -- get temp event type and size
    -- TODO: fix magic number event size
    local temp_event_sz = 28


    -- overlay over all event types
    mt = tree:add(buf(offset, 
        (nr_of_events * temp_event_sz)), 
        _F("Input Events (%d)", nr_of_events))

    -- input event struct(s)
    for i = 1,nr_of_events do
        res = diss_input_event(buf, pinfo, mt, offset)
        offset = offset + res
    end



    -- only add if there are remaining bytes
    local remaining = buf:len() - offset
    if remaining ~= 0 then
        tree:add(buf(offset), _F("Unknown (%d bytes)", remaining))
        offset = offset + remaining
    end


    return (offset - goffset)
end

