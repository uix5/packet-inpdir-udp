


local function diss_input_event(buf, pinfo, tree, goffset)

    local offset = goffset



    --[[
        seems to be a windows INPUT structure (winuser.h)
        INPUT.type tells which variant it is (keyboard, mouse, 
        hardware)

        INPUT:
          http://msdn.microsoft.com/en-us/library/windows/desktop/ms646270
        KEYBDINPUT:
          http://msdn.microsoft.com/en-us/library/windows/desktop/ms646271
        MOUSEINPUT:
          http://msdn.microsoft.com/en-us/library/windows/desktop/ms646273
        HARDWAREINPUT:
          http://msdn.microsoft.com/en-us/library/windows/desktop/ms646269
    ]]

    -- probably input event type
    local input_type = buf(offset, 4):le_uint()
    -- offset = offset + 4


    -- mouse input (24 bytes)
    if input_type == INPUT_MOUSE then
        local mt = tree:add(buf(offset, INPUT_MOUSE_SZ + (28 - INPUT_MOUSE_SZ)), 
            input_type_str_or_unknown(input_type) 
            .. " Event (type " .. input_type .. ")")
        offset = offset + 4


        -- INPUT.mi.dx
        mt:add(buf(offset, 4), "dx         : "):append_text(buf(offset, 4):le_int())
        offset = offset + 4

        -- INPUT.mi.dy
        mt:add(buf(offset, 4), "dy         : "):append_text(buf(offset, 4):le_int())
        offset = offset + 4

        -- INPUT.mi.mouseData
        mt:add(buf(offset, 4), "mouseData  : "):append_text(buf(offset, 4):le_int())
        offset = offset + 4

        -- INPUT.mi.dwFlags
        local s = buf(offset, 4):le_int()
        local t = add_named_tree_field(buf, mt, offset, 4, "dwFlags    ")
        offset = offset + 4
        t:append_text(": " .. decode_input_event_flags(s))


        -- INPUT.mi.time
        add_named_tree_field(buf, mt, offset, 4, "time       ")
        offset = offset + 4

        -- INPUT.mi.dwExtraInfo
        add_named_tree_field(buf, mt, offset, 4, "dwExtraInfo")
        offset = offset + 4



    -- keyboard (16 bytes)
    elseif input_type == INPUT_KEYBOARD then
        -- uses Windows Virtual Keys
        -- see:
        --  http://msdn.microsoft.com/en-us/library/dd375731

        -- a key event is 16 bytes long
        local mt = tree:add(buf(offset, INPUT_KEYBOARD_SZ + (28 - INPUT_KEYBOARD_SZ)),
            input_type_str_or_unknown(input_type) 
            .. " Event (type " .. input_type .. ")")
        offset = offset + 4

        -- keycode
        local t = add_named_tree_field(buf, mt, offset, 2, "wVk        ")

        -- tchar is actually the Virtual Key code, but 0-9 and a-z overlap
        -- with their ASCII code, so this works (sometimes)
        local tchar = buf(offset, 2):le_uint()

        if tchar >= 0x30 and tchar <= 0x5A then
            t:append_text(": '" .. buf(offset, 2):string() .. "'")
        else
            t:append_text(": '" .. input_VK_str_or_unknown(tchar) .. "'")
        end
        offset = offset + 2

        -- INPUT.ki.wScan
        add_named_tree_field(buf, mt, offset, 2, "wScan      ")
        offset = offset + 2

        -- INPUT.ki.dwFlags
        local dwFlags = buf(offset, 4):le_uint()
        local t = add_named_tree_field(buf, mt, offset, 4, "dwFlags    ")
        t:append_text(": " .. decode_keyboard_input_event(dwFlags))
        offset = offset + 4

        -- INPUT.ki.time
        add_named_tree_field(buf, mt, offset, 4, "time       ")
        offset = offset + 4

        -- INPUT.ki.dwExtraInfo
        add_named_tree_field(buf, mt, offset, 4, "dwExtraInfo")
        offset = offset + 4


        -- something unknown
        mt:add(buf(offset, 8), "Unknown")
        offset = offset + 8


    -- hardware (8 bytes)
    -- probably impossible for Input Director, but for completeness sake
    elseif input_type == INPUT_HARDWARE then
        local mt = tree:add(buf(offset, INPUT_HARDWARE_SZ + (28 - INPUT_HARDWARE_SZ)), 
            input_type_str_or_unknown(input_type) 
            .. " Event (type " .. input_type .. ")")
        offset = offset + 4


        -- INPUT.hi.uMsg
        add_named_tree_field(buf, mt, offset, 4, "uMsg       ")
        offset = offset + 4

        -- INPUT.hi.wParamL
        add_named_tree_field(buf, mt, offset, 2, "wParamL    ")
        offset = offset + 2

        -- INPUT.hi.wParamH
        add_named_tree_field(buf, mt, offset, 2, "wParamH    ")
        offset = offset + 2



    -- something else (haven't seen this yet, but still)
    else
        local mt = tree:add(buf(offset, 4), 
            input_type_str_or_unknown(input_type) 
            .. " Event (" .. input_type .. ")")

    end



    -- how many bytes have we consumed
    return (offset - goffset)
end
