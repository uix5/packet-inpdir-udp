
-- config update?
local function diss_pkt14(buf, pinfo, tree, goffset)
    -- handle common part
    res = dec_header(buf, pinfo, tree, goffset)
    if res < 0 then return res end

    -- the rest
    local offset = goffset + res

    -- encryption hack
    -- read byte 4 bytes back
    local b_encrypted = (buf(offset -4, 1):le_uint() ~= 0)


    -- see if this is a reset pkt
    local is_reset = get_uint32_le(buf, offset)
    add_named_tree_field(buf, tree, offset, 4, "Config valid?"):append_text(
        _F(" (%s)", yes_no_str_or_unknown(is_reset)))
    offset = offset + 4


    if is_reset == 0x00 then
        -- rest is garbage
        -- seems packets are not always properly reset
        local zlen = buf:len() - offset
        tree:add(buf(offset), "Zeros / Garbage"):append_text(_F(", %u bytes", zlen))
        offset = offset + zlen

        -- were done
        return (offset - goffset)
    end


    -- str len of hostname?
    local str_len = get_uint32_le(buf, offset)
    add_named_tree_field(buf, tree, offset, 4, "Slave Hostname strlen")
    offset = offset + 4

    -- ip again
    add_named_tree_field_ipv4(buf, tree, offset, 4, "Focus IP")
    offset = offset + 4

    -- dx, dy wrt master (or at least, where the cursor is at the 
    --  current time)
    add_named_tree_field_int(buf, tree, offset, 2, "Focus screen X")
    offset = offset + 2
    add_named_tree_field_int(buf, tree, offset, 2, "Focus screen Y")
    offset = offset + 2


    -- no point in continuing if payload encrypted
    if b_encrypted then
        offset = offset + add_encrypted_field(buf, pinfo, tree, offset)
        return (offset - goffset)
    end


    -- go to payload part
    -- TODO: fix hardcoded lengths
    local payload_start = HDR_LEN
    local len = payload_start - offset
    tree:add(buf(offset, len), _F("Unknown / Zeros (%d bytes)", len))
    offset = offset + len


    -- screen layout
    offset = offset + diss_screen_grid(buf, pinfo, tree, offset)


    -- hostname (or ip address as string) of host that has current input focus
    -- used in the 'Information Window'
    add_named_tree_field_str(buf, tree, offset, (str_len + 1), "Focus name")
    offset = offset + (str_len + 1)


    -- handled 'offset' bytes
    return (offset - goffset)
end
