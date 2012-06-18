
-- something with encryption
-- perhaps a 'I do not support encryption' ?
local function diss_pkt19(buf, pinfo, tree, goffset)
    -- handle common part
    res = dec_header(buf, pinfo, tree, goffset)
    if res < 0 then return res end

    -- the rest
    local offset = goffset + res


    -- sequence number we respond to?
    add_named_tree_field(buf, tree, offset, 4, "Response to seq nr")
    offset = offset + 4

    -- encryption type used
    local enc_type = buf(offset, 1):le_uint()
    add_named_tree_field(buf, tree, offset, 1, "Our encryption type"):append_text(
        _F(": %s", encryption_type_str_or_unknown(enc_type)))
    offset = offset + 1

    -- also encryption related
    add_named_tree_field(buf, tree, offset, 1, "Our encrypted pw check byte")
    offset = offset + 1

    -- dunno: 
    add_named_tree_field(buf, tree, offset, 2, "Unknown")
    offset = offset + 2


    -- add_zeros_field(buf, pinfo, tree, goffset, len = nil)
    offset = offset + add_zeros_field(buf, pinfo, tree, offset)


    -- handled 'offset' bytes
    return (offset - goffset)
end
