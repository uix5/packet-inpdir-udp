
-- bitfield
-- from:
--  http://msdn.microsoft.com/en-us/library/windows/desktop/ms646271
--  http://source.winehq.org/source/include/winuser.h
local input_key_up_down_str = {
    -- [0x00] = "KeyDown?",
    [0x01] = "ExtendedKey",
    [0x02] = "KeyUp",
    [0x04] = "Unicode",
    [0x08] = "Scancode"
}

-- same as key event codes
-- decode bitfield
-- from:
--   http://msdn.microsoft.com/en-us/library/windows/desktop/ms646273
--   http://source.winehq.org/source/include/winuser.h
local mouse_event_field_str = {
    [0x0001] = "Move",
    [0x0002] = "Left Down",
    [0x0004] = "Left Up",
    [0x0008] = "Right Down",
    [0x0010] = "Right Up",
    [0x0020] = "Middle Down",
    [0x0040] = "Middle Up",
    [0x0080] = "X Down",
    [0x0100] = "X Up",
    [0x0800] = "Wheel",
    [0x1000] = "H Wheel",
    [0x2000] = "Move No Coalesce",
    [0x4000] = "Virtual Desk",
    [0x8000] = "Absolute"
}


-- some virtual keys
-- from:
--   http://msdn.microsoft.com/en-us/library/windows/desktop/dd375731
local input_VK_str = {
    [0x10] = "Shift",
    [0x11] = "Ctrl",
    [0x12] = "Alt",
    [0x1B] = "Escape",
    [0x5B] = "Left Windows",
    [0x5C] = "Right Windows",
    [0x6A] = "Multiply",
    [0x6F] = "Divide",
    [0x0A] = "Shift",
    [0xA0] = "Left Shift",
    [0xA1] = "Right Shift",
    [0xA2] = "Left Control",
    [0xA3] = "Right Control",
    [0xA4] = "Left Menu (Alt)",
    [0xA5] = "Right Menu (Alt)"
}


local on_off_str = {
    [0x00] = "Off",
    [0x01] = "On "
}


local yes_no_str = {
    [0x00] = "No",
    [0x01] = "Yes"
}

local lock_key_state_str = {
    [0x00] = "None",
    [0x01] = "Num",
    [0x02] = "Scroll",
    [0x04] = "Caps"
}



local screen_enter_pos_str = {
    [0x01] = "Left",
    [0x02] = "Right",
    [0x04] = "Top",
    [0x08] = "Bottom",
    [0x10] = "No side (shortcut)"
}



local global_config_master_mouse_settings_str = {
    [0x02] = "Use master settings for slaves",
    [0x08] = "Unknown flag"
}


local screen_edge_trans_flags_str = {
    [0x01] = "On double tap of edge",
    [0x02] = "On cursor lingering",
}


local screen_edge_trans_extra_flags_str = {
    [0x01] = "Don't allow transitions near corners",
}


local reliable_comms_flags_str = {
    [0x01] = "Unknown flag",
    [0x04] = "Enable reliable comms",
}

local kb_layout_flags_str = {
    [0x02] = "Use master's KB layout",
}


local encryption_type_str = {
    [0x00] = "None",
    [0x01] = "AES 128bit",
    [0x02] = "AES 192bit",
    [0x03] = "AES 256bit",
}



-- From "Standard Clipboard Formats"
--  http://msdn.microsoft.com/en-us/library/windows/desktop/ff729168
local win32_standard_clipboard_formats = {
    [0x01] = "CF_TEXT",
    [0x02] = "CF_BITMAP",
    [0x03] = "METAFILEPICT",
    [0x04] = "CF_SYLK",
    [0x05] = "CF_DIF",
    [0x06] = "CF_TIFF",
    [0x07] = "CF_OEMTEXT",
    [0x08] = "CF_DIB",
    [0x09] = "CF_PALETTE",
    [0x0A] = "CF_PENDATA",
    [0x0B] = "CF_RIFF",
    [0x0C] = "CF_WAVE",
    [0x0D] = "CF_UNICODETEXT",
    [0x0E] = "CF_ENHMETAFILE",
    [0x0F] = "CF_HDROP",
    [0x10] = "CF_LOCALE",
    [0x11] = "CF_DIBV5",
    [0x80] = "CF_OWNERDISPLAY",
    [0x81] = "CF_DSPTEXT",
    [0x82] = "CF_DSPBITMAP",
    [0x83] = "CF_DSPMETAFILEPICT",
    [0x8E] = "CF_DSPENHMETAFILE",
    [0x200] = "CF_PRIVATEFIRST",
    [0x2FF] = "CF_PRIVATELAST",
    [0x300] = "CF_GDIOBJFIRST",
    [0x3FF] = "CF_GDIOBJLAST",
}














local function generic_str_or_none(arr, arg)
    return arr[arg] or "Unknown"
end

local function yes_no_str_or_unknown(arg)
    return generic_str_or_none(yes_no_str, arg)
end

local function input_type_str_or_unknown(arg)
    return generic_str_or_none(input_type_str, arg)
end

local function input_key_up_down_str_or_unknown(arg)
    return generic_str_or_none(input_key_up_down_str, arg)
end

local function pkt_types_str_or_unknown(arg)
    return generic_str_or_none(pkt_types_str, arg)
end

local function input_VK_str_or_unknown(arg)
    return generic_str_or_none(input_VK_str, arg)
end

local function mouse_event_field_str_or_unknown(arg)
    return generic_str_or_none(mouse_event_field_str, arg)
end

local function screen_enter_pos_str_or_unknown(arg)
    return generic_str_or_none(screen_enter_pos_str, arg)
end

local function lock_key_state_str_or_unknown(arg)
    return generic_str_or_none(lock_key_state_str, arg)
end

local function encryption_type_str_or_unknown(arg)
    return generic_str_or_none(encryption_type_str, arg)
end


local function win32_standard_clipboard_formats_str_or_unknown(arg)
    return generic_str_or_none(win32_standard_clipboard_formats, arg)
end















-- http://lua-users.org/wiki/BitUtils
local function testflag(set, flag)
    return set % (2*flag) >= flag
end

local function clrflag(set, flag) -- clear flag
    if set % (2*flag) >= flag then
        return set - flag
    end
    return set
end



local function stringify_bit_flags(t, iflags)
    local flag_str = ''
    local flags = iflags

    for k,v in pairs(t) do
        if testflag(flags, k) then
            flag_str = flag_str .. v .. ', '

            flags = clrflag(flags, k)
        end
    end

    -- see if there were any unknown flags
    if flags ~= 0 then
        return flag_str .. '(and some unknown flags)'
    else
        return flag_str:sub(1, flag_str:len() - 2)
    end
end




local function decode_input_event_flags(iflags)
    return stringify_bit_flags(mouse_event_field_str, iflags)
end


local function decode_keyboard_input_event(iflags)
    -- key down isn't really a flag
    if iflags == 0x00 then return "KeyDown?" end

    return stringify_bit_flags(input_key_up_down_str, iflags)
end


local function decode_lock_flags(iflags)
    -- 'none' isn't really a flag
    if iflags == 0x00 then return "None" end

    return stringify_bit_flags(lock_key_state_str, iflags)
end


local function decode_side_flags(iflags)
    -- 'none' isn't really a flag
    if iflags == 0x00 then return "None" end

    return stringify_bit_flags(screen_enter_pos_str, iflags)
end

local function decode_master_mouse_flags(iflags)
    return stringify_bit_flags(global_config_master_mouse_settings_str, iflags)
end

local function decode_screen_edge_trans_flags(iflags)
    -- 'immediately' isn't really a flag
    if iflags == 0x00 then return "Immediately" end

    return stringify_bit_flags(screen_edge_trans_flags_str, iflags)
end

local function decode_screen_edge_trans_extra_flags(iflags)
    -- 'none' isn't really a flag
    if iflags == 0x00 then return "None" end

    return stringify_bit_flags(screen_edge_trans_extra_flags_str, iflags)
end

local function decode_reliable_comms_flags(iflags)
    return stringify_bit_flags(reliable_comms_flags_str, iflags)
end

local function decode_kb_layout_flags(iflags)
    -- 'use slave's KB layout' isn't really a flag
    if iflags == 0x00 then return "use slave's KB layout" end

    return stringify_bit_flags(kb_layout_flags_str, iflags)
end

