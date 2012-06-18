


local function diss_clipboard_format_list(buf, pinfo, tree, goffset, cb_list_len)
    local offset = goffset


    -- clipboard format list length
    local cb_format_elem_sz = 4
    local cb_max_format_num = 4
    local cb_format_list_sz = cb_format_elem_sz * cb_list_len

    local mt = tree:add(buf(offset, cb_format_list_sz), "Clipboard format list")

    for i = 1,cb_list_len do
        -- dunno constant
        local cb_fmt = buf(offset, 1):le_uint()
        add_named_tree_field(buf, mt, offset, cb_format_elem_sz, _F("Type %u", i)):append_text(
            _F(": %s", win32_standard_clipboard_formats_str_or_unknown(cb_fmt)))
        offset = offset + cb_format_elem_sz
    end


    -- add 'garbage' marker
    -- local cb_garbage_len = cb_format_list_sz - (cb_list_len * cb_format_elem_sz)
    -- mt:add(buf(offset, cb_garbage_len), "Garbage"):append_text(
    --  _F(", %u bytes", cb_garbage_len))

    -- -- fixup offset
    -- offset = offset + cb_garbage_len

    -- 
    return (offset - goffset)
end
