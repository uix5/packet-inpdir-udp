
local function dec_header(buf, pinfo, tree, goffset)
    local offset = goffset

    local minimum_sz = 64

    if buf:len() < minimum_sz then return -1 end


    -- overlay header size on pkt
    local maybe_header_len = buf(offset + (4 * 3), 4):le_uint()
    lt = tree:add(buf(offset, maybe_header_len), _F("Common (%d bytes)", maybe_header_len))


    lt:add(f.magic, buf(offset, 4 * 3))
    offset = offset + (4 * 3)

    -- len of 'header' or common part
    lt:add_le(f.hdr_len, buf(offset, 4))
    offset = offset + 4

    -- protocol version
    lt:add_le(f.version, buf(offset, 4))
    offset = offset + 4

    -- packet type
    lt:add_le(f.payl_type, buf(offset, 4))
    offset = offset + 4

    -- length of the payload
    lt:add_le(f.payl_len, buf(offset, 4))
    offset = offset + 4

    -- msg sequence nr
    lt:add_le(f.msg_nr, buf(offset, 4))
    offset = offset + 4

    -- 'authentication' guid
    lt:add(f.session_key, buf(offset, 16))
    offset = offset + 16

    -- ip of sender of packet
    lt:add(f.ip_src, buf(offset, 4))
    offset = offset + 4

    -- port of sender of packet
    lt:add_le(f.port_src, buf(offset, 4))
    offset = offset + 4

    -- dunno: seems to be same as header len field
    add_named_tree_field(buf, lt, offset, 4, "Unknown")
    offset = offset + 4

    -- encryption type used
    local enc_type = buf(offset, 1):le_uint()
    add_named_tree_field(buf, lt, offset, 1, "Payload encryption"):append_text(
        _F(": %s", encryption_type_str_or_unknown(enc_type)))
    offset = offset + 1

    -- also encryption related
    add_named_tree_field(buf, lt, offset, 1, "Encrypted pw check byte")
    offset = offset + 1

    -- dunno: 
    add_named_tree_field(buf, lt, offset, 2, "Unknown")
    offset = offset + 2

    -- handled X bytes
    return (offset - goffset)
end
