-- Open File On Share
local function diss_pkt20(buf, pinfo, tree, goffset)
    -- handle common part
    res = dec_header(buf, pinfo, tree, goffset)
    if res < 0 then return res end

    -- the rest
    local offset = goffset + res


    -- edge transition state
    add_named_tree_field(buf, tree, offset, 4, "Unknown")
    offset = offset + 4


    -- TODO: replace magic nr header len
    local payload_start = HDR_LEN
    offset = payload_start

    -- filename here
    local str_len = (buf:len() - payload_start)
    add_named_tree_field_str(buf, tree, offset, str_len, "Filename")


    -- handled 'offset' bytes
    return (offset - goffset)
end
