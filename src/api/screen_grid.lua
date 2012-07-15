


local function diss_screen_grid(buf, pinfo, tree, goffset)

    local offset = goffset

    -- overlay over all screen ids
    local max_cells = (5 * 6)
    local temp_screen_setup_sz = 5 + (max_cells * 2)
    local mt = tree:add(buf(offset, temp_screen_setup_sz), "Slave screen setup")


    add_named_tree_field(buf, mt, offset, 1, "Unknown0")
    offset = offset + 1

    add_named_tree_field(buf, mt, offset, 1, "Unknown1")
    offset = offset + 1


    -- dimensions of grid used by master
    local slave_cols = buf(offset, 1):le_uint()
    add_named_tree_field(buf, mt, offset, 1, "Grid cols")
    offset = offset + 1

    local slave_rows = buf(offset, 1):le_uint()
    add_named_tree_field(buf, mt, offset, 1, "Grid rows")
    offset = offset + 1

    -- whether or not the master is configured to use windows monitor IDs
    -- (== whether the data sent contains those)
    local slave_mon_ids_int = buf(offset, 1):le_uint()
    local slave_mon_ids_enabled = (slave_mon_ids_int ~= 0)
    mt:add(buf(offset, 1), _F("Master uses Windows monitor IDs: %s", 
        yes_no_str_or_unknown(slave_mon_ids_int)))
    -- add_named_tree_field(buf, mt, offset, 1, "Master uses Windows monitor IDs")
    offset = offset + 1

    -- total nr of grid cells
    local grid_cells = (slave_rows * slave_cols)
    mt = mt:add(buf(offset, (grid_cells * 2)), 
        _F("Grid (%d x %d, column order)", 
        slave_cols, slave_rows))




    -- draws an ascii art of the screen grid
    local mtd = mt:add(buf(offset, (grid_cells * 2)), "Diagram")
    local mon_cnt = 0

    -- walk grid row major (not too efficient perhaps)
    for r = 0,slave_rows-1 do
        local rtt = mtd:add("|")

        for c = 0,slave_cols-1 do

            local scr_idx = c*slave_rows + r

            local cell_occupied = (buf(offset + (scr_idx * 2), 1):le_uint() ~= 0)

            if slave_mon_ids_enabled and cell_occupied then
                -- get id
                local sid = buf(offset + (scr_idx * 2) + 1, 1):le_uint()
                rtt:append_text(_F("%2d|", sid + 1))

            -- no ids, just use screen nr
            elseif cell_occupied then
                mon_cnt = mon_cnt + 1
                rtt:append_text(_F("%2d|", mon_cnt))

            -- no screen, use space to represent
            else
                rtt:append_text("  |")
            end
        end
    end






    -- add a 'Screen' entry for every grid cell
    -- this is column major
    for i = 0,grid_cells-1 do
        -- extract occupied or not first
        local cell_occupied = (buf(offset, 1):le_uint() ~= 0)

        -- 
        if cell_occupied then
            local temp_tree = mt:add(buf(offset, 2), _F("Cell %d", i))

            add_named_tree_field(buf, temp_tree, offset, 1, _F("Occupied ", i))
            offset = offset + 1

            -- only show ids if master uses them
            if slave_mon_ids_enabled and cell_occupied then
                add_named_tree_field(buf, temp_tree, offset, 1, _F("Screen ID", i))
            end

            -- but always increase byte pointer
            offset = offset + 1
        else
            local temp_tree = mt:add(buf(offset, 2), _F("Cell %d (empty)", i))
            offset = offset + 2
        end
    end


    -- add 'garbage' marker
    local garbage_len = (temp_screen_setup_sz - (grid_cells * 2) - 5)
    mt:add(buf(offset, garbage_len), "Garbage"):append_text(
        _F(", %u bytes", garbage_len))

    -- fixup offset
    offset = offset + garbage_len


    -- return nr of bytes handled
    return (offset - goffset)
end

