


local function diss_keyboard_settings(buf, pinfo, tree, goffset)

    local offset = goffset


    local mt = tree:add(buf(offset, 4), "Master keyboard layout settings")
    -- keyboard layout of host?
    -- http://msdn.microsoft.com/en-us/library/windows/desktop/dd318693
    -- http://msdn.microsoft.com/en-us/library/ms892480.aspx
    -- http://msdn.microsoft.com/en-us/library/windows/desktop/ms646305
    -- http://msdn.microsoft.com/en-us/library/windows/desktop/ms646306
    add_named_tree_field(buf, mt, offset, 2, "Host KB layout")
    offset = offset + 2

    -- dunno constant
    local flags2 = buf(offset, 2):le_uint()
    add_named_tree_field(buf, mt, offset, 2, "Flags2"):append_text(
        _F(" (%s)", decode_kb_layout_flags(flags2)))
    offset = offset + 2




    -- return nr of bytes handled
    return (offset - goffset)
end

