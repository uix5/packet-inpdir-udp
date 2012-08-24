


local function diss_neighbour_list(buf, pinfo, tree, goffset, nr_of_screens)

    local offset = goffset

    -- overlay over entire neighbour list
    local cell_sz = 4
    local max_cells = 8
    local max_cells_sz = (max_cells * cell_sz)
    local mt = tree:add(buf(offset, max_cells_sz), "Slave neighbours")

    local screen_i = nr_of_screens
    if screen_i > max_cells then
        screen_i = max_cells
    end

    for i = 1,nr_of_screens do
        add_named_tree_field(buf, mt, offset, cell_sz, _F("Screen %d", i)):append_text(
            _F(" (%s)", decode_side_flags(get_uint32_le(buf, offset))))
        offset = offset + cell_sz
    end

    -- correct offset
    offset = offset + (max_cells_sz - (nr_of_screens * cell_sz))

    -- return nr of bytes handled
    return (offset - goffset)
end

