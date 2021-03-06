
local function dec_header(buf, pinfo, tree, goffset)
    local offset = goffset

    -- pseudo header length
    local maybe_header_len_offset = 4 * 3
    local maybe_header_len = buf(offset + maybe_header_len_offset, 4):le_uint()
    local pho = tree:add(buf(offset, maybe_header_len), 
        _F("Pseudo header overlay (%d bytes)", maybe_header_len))
    pho:set_generated()

    -- overlay common size on pkt
    lt = tree:add(buf(offset, COMMON_LENGTH), _F("Common (%d bytes)", COMMON_LENGTH))

    -- magic
    local magic_sz = 4 * 3
    lt:add(f.magic, buf(offset, magic_sz))
    offset = offset + magic_sz

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
    local guid_sz = 16
    lt:add(f.session_key, buf(offset, guid_sz))
    offset = offset + guid_sz

    local slt = lt:add(buf(offset, 8), "Sender Info")
    -- ip of sender of packet
    slt:add(f.ip_src, buf(offset, 4))
    offset = offset + 4

    -- port of sender of packet
    slt:add_le(f.port_src, buf(offset, 4))
    offset = offset + 4

    -- dunno: seems to be same as header len field
    add_named_tree_field(buf, lt, offset, 4, "Header Length Repeat?")
    offset = offset + 4

    -- encryption stuff
    local elt = lt:add(buf(offset, 4), "Encryption Settings")

    -- encryption type used
    local enc_type = buf(offset, 1):le_uint()
    add_named_tree_field(buf, elt, offset, 1, "Payload encryption"):append_text(
        _F(" (%s)", encryption_type_str_or_unknown(enc_type)))
    offset = offset + 1

    -- also encryption related
    add_named_tree_field(buf, elt, offset, 1, "Encrypted pw check byte")
    offset = offset + 1

    -- dunno: 
    add_named_tree_field(buf, elt, offset, 2, "Unknown")
    offset = offset + 2

    -- handled X bytes
    return (offset - goffset)
end
