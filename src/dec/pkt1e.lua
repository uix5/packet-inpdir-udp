-- Reliable Comms ACK
local function diss_pkt1E(buf, pinfo, tree, goffset)
    -- handle common part
    res = dec_header(buf, pinfo, tree, goffset)
    if res < 0 then return res end

    -- the rest
    local offset = goffset + res


    -- dunno
    add_named_tree_field(buf, tree, offset, 4, "ACK-ed reliable comms nr")
    offset = offset + 4

    -- dunno
    add_named_tree_field(buf, tree, offset, 4, "Unknown3")
    offset = offset + 4

    -- dunno
    add_named_tree_field(buf, tree, offset, 4, "Trans to slaves #?")
    offset = offset + 4

    -- dunno
    add_named_tree_field(buf, tree, offset, 4, "Unknown5")
    offset = offset + 4

    -- dunno
    add_named_tree_field(buf, tree, offset, 4, "Unknown6")
    offset = offset + 4


    -- add_zeros_field(buf, pinfo, tree, goffset, len = nil)
    offset = offset + add_zeros_field(buf, pinfo, tree, offset)

    -- handled 'offset' bytes
    return (offset - goffset)
end
