
-- input mirroring
local function diss_pkt0B(buf, pinfo, tree, goffset)
    -- handle common part
    res = dec_header(buf, pinfo, tree, goffset)
    if res < 0 then return res end

    -- the rest
    local offset = goffset + res

    -- nr of input events?
    local nr_of_events = get_uint32_le(buf, offset)
    add_named_tree_field(buf, tree, offset, 4, "Nr of events?")
    offset = offset + 4


    add_named_tree_field(buf, tree, offset, 4, "Unknown")
    offset = offset + 4

    -- some garbage
    local zlen = 92
    tree:add(buf(offset, zlen), "Unknown"):append_text(_F(", %u bytes", zlen))
    offset = offset + zlen


    -- handle input events
    --local ret = diss_input_event(buf, pinfo, tree, offset)
    --offset = offset + ret

    -- get temp event type and size
    -- local temp_event_sz = input_event_sz_map[buf(offset, 1):le_uint()]
    local temp_event_sz = 28

    -- overlay over all event types
    mt = tree:add(buf(offset, 
        (nr_of_events * temp_event_sz)), 
        _F("Input Events (%d)", nr_of_events))

    -- input event struct(s)
    for i = 1,nr_of_events do
        res = diss_input_event(buf, pinfo, mt, offset)
        offset = offset + res
    end


    -- add_zeros_field(buf, pinfo, tree, goffset, len = nil)
    offset = offset + add_zeros_field(buf, pinfo, tree, offset)

    -- handled 'offset' bytes
    return (offset - goffset)
end
