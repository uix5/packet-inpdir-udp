
local function diss_pkt06(buf, pinfo, tree, goffset)
    -- handle common part
    res = dec_header(buf, pinfo, tree, goffset)
    if res < 0 then return res end

    -- the rest
    local offset = goffset + res


    -- seems to be acked 0x05 packet sequence nr
    add_named_tree_field(buf, tree, offset, 4, "ACK on sequence nr")
    offset = offset + 4

    -- Slave resolution width?
    add_named_tree_field(buf, tree, offset, 4, "Slave res w?")
    offset = offset + 4

    -- Slave resolution height?
    add_named_tree_field(buf, tree, offset, 4, "Slave res h?")
    offset = offset + 4

    -- some flag?
    add_named_tree_field(buf, tree, offset, 4, "Flags?")
    offset = offset + 4

    -- add_zeros_field(buf, pinfo, tree, goffset, len = nil)
    offset = offset + add_zeros_field(buf, pinfo, tree, offset)

    -- handled 'offset' bytes
    return (offset - goffset)
end
