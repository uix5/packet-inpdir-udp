-- Shortcut Cursor Return
local function diss_pkt09(buf, pinfo, tree, goffset)
    -- handle common part
    res = dec_header(buf, pinfo, tree, goffset)
    if res < 0 then return res end

    -- the rest
    local offset = goffset + res



    -- Seems to be the number of keys in the shortcut?
    add_named_tree_field(buf, tree, offset, 4, "Shortcut Key Count?")
    offset = offset + 4

    -- dunno constant
    add_named_tree_field(buf, tree, offset, 4, "Unknown2")
    offset = offset + 4

    -- number of slave we are returning from
    add_named_tree_field(buf, tree, offset, 4, "Slave Number")
    offset = offset + 4


    -- add_zeros_field(buf, pinfo, tree, goffset, len = nil)
    offset = offset + add_zeros_field(buf, pinfo, tree, offset)

    -- handled 'offset' bytes
    return (offset - goffset)
end
