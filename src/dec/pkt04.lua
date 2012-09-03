
-- cursor trans in ACK?
local function diss_pkt04(buf, pinfo, tree, goffset)
    -- handle common part
    res = dec_header(buf, pinfo, tree, goffset)
    if res < 0 then return res end

    -- the rest
    local offset = goffset + res


    -- sequence number of 'cursor trans in' (0x03) pkt that is ACK-ed
    add_named_tree_field(buf, tree, offset, 4, "Response to seq nr")
    offset = offset + 4


    -- state of caps/num/scroll lock keys on slave
    add_named_tree_field(buf, tree, offset, 4, "Lock flags"):append_text(
        _F(" (%s)", decode_lock_flags(get_uint32_le(buf, offset))))
    offset = offset + 4

    -- x coord of screen we come from
    add_named_tree_field(buf, tree, offset, 2, "Slave Screen X?")
    offset = offset + 2

    -- y coord of screen we come from
    add_named_tree_field(buf, tree, offset, 2, "Slave Screen Y?")
    offset = offset + 2

    -- 
    add_named_tree_field(buf, tree, offset, 2, "Unknown1a")
    offset = offset + 2

    -- 
    add_named_tree_field(buf, tree, offset, 2, "Unknown1b")
    offset = offset + 2

    -- add_zeros_field(buf, pinfo, tree, goffset, len = nil)
    offset = offset + add_zeros_field(buf, pinfo, tree, offset)


    -- handled 'offset' bytes
    return (offset - goffset)
end
