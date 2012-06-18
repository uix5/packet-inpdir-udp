
-- toggle screen transitions enable / disable
local function diss_pkt16(buf, pinfo, tree, goffset)
    -- handle common part
    res = dec_header(buf, pinfo, tree, goffset)
    if res < 0 then return res end

    -- the rest
    local offset = goffset + res


    -- edge transition state
    add_named_tree_field(buf, tree, offset, 4, "Transitions disabled")
    offset = offset + 4

    -- add_zeros_field(buf, pinfo, tree, goffset, len = nil)
    offset = offset + add_zeros_field(buf, pinfo, tree, offset)

    -- handled 'offset' bytes
    return (offset - goffset)
end
