



local function diss_mouse_settings(buf, pinfo, tree, goffset)

    local offset = goffset


    local temp_mouse_setup_sz = 5 * 4
    local mt = tree:add(buf(offset, temp_mouse_setup_sz), "Master mouse settings")


    -- flags?
    local mflags = buf(offset, 4):le_uint()
    add_named_tree_field(buf, mt, offset, 4, "Master mouse prefs"):append_text(
        _F(": %s", decode_master_mouse_flags(mflags)))
    offset = offset + 4

    -- flags?
    add_named_tree_field(buf, mt, offset, 4, "MouseThreshold1")
    offset = offset + 4

    -- flags?
    add_named_tree_field(buf, mt, offset, 4, "MouseThreshold2")
    offset = offset + 4

    -- flags?
    add_named_tree_field(buf, mt, offset, 4, "MouseSpeed")
    offset = offset + 4

    -- flags?
    add_named_tree_field(buf, mt, offset, 2, "MouseSensitivity")
    offset = offset + 2

    -- http://msdn.microsoft.com/en-us/library/windows/desktop/ms724385
    add_named_tree_field(buf, mt, offset, 2, "Switch primary / secondary buttons")
    offset = offset + 2



    -- how many bytes have we consumed
    return (offset - goffset)
end

