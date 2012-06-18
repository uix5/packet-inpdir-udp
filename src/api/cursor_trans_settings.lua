



local function diss_cursor_trans_settings(buf, pinfo, tree, goffset)
    local offset = goffset

    -- create node in treeview
    local mt = tree:add(buf(offset, 4), "Cursor transition settings")

    -- when to transition?
    add_named_tree_field(buf, mt, offset, 1, "Transition flags"):append_text(
        _F(": %s", decode_screen_edge_trans_flags(buf(offset, 1):le_uint())))
    offset = offset + 1

    -- special
    add_named_tree_field(buf, mt, offset, 1, "Additional flags"):append_text(
        _F(": %s", decode_screen_edge_trans_extra_flags(buf(offset, 1):le_uint())))
    offset = offset + 1

    -- master pref: on double tap of edge within X ms?
    add_named_tree_field(buf, mt, offset, 2, "Transition time-out"):append_text(" ms")
    offset = offset + 2

    -- 
    return (offset - goffset)
end
