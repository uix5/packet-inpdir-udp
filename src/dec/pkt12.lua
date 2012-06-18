
-- Master -> Slave heartbeat
local function diss_pkt12(buf, pinfo, tree, goffset)
    -- handle common part
    res = dec_header(buf, pinfo, tree, goffset)
    if res < 0 then return res end

    -- the rest
    local offset = goffset + res

    -- rest is garbage
    -- seems pkt variables aren't reset properly?
    -- first thought it might have also included
    -- the master's view on screen topology (as in, where is
    -- the screen of the slave wrt the master), but this
    -- turned out not to be true (probably left over memory
    -- contents from another packet)
    -- add_zeros_field(buf, pinfo, tree, goffset, len = nil)
    offset = offset + add_zeros_field(buf, pinfo, tree, offset)

    -- handled 'offset' bytes
    return (offset - goffset)
end
