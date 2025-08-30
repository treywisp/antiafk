--[[

This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <https://unlicense.org>

]]

sciprt_name("antiafk")
script_author("treywisp")

local memory = require("memory")
local sampev = require("samp.events")

local is_active = false
local custom_font = renderCreateFont(Arial, 12, 4)

function main()

    sampRegisterChatCommand("afk", function() is_active = not is_active userNotification(is_active and "Скрипт успешно активирован" or "Скрипт успешно деактивирован") end)

    while true do
        wait(0)

        if is_active then
            memory.setuint8(7634870, 1, false)
            memory.setuint8(7635034, 1, false)
            memory.fill(7623723, 144, 8, false)
            memory.fill(5499528, 144, 6, false)
            local x_screen, y_screen = getScreenResolution()
            renderFontDrawText(custom_font, "ANTIAFK АКТИВИРОВАН", x_screen * 0.005, y_screen * 0.98, -1)
        else
            memory.setuint8(7634870, 0, false)
            memory.setuint8(7635034, 0, false)
            memory.hex2bin('0F 84 7B 01 00 00', 7623723, 8)
            memory.hex2bin('50 51 FF 15 00 83 85 00', 5499528, 6)
        end

    end

end

function sampev.onServerMessage(color, text)
    if text:match("^ Вы уснули. %(%( Используйте команду %/sleep чтобы проснуться %)%)") and is_active then
        lua_thread.create(function()
            math.randomseed(os.time())
            wait(10000 + math.random(290000))
            sampSendChat("/sleep")
        end)
    end
end

function userNotification(userNotificationText)
    sampAddChatMessage("[AntiAFK] {FFFFFF}"..userNotificationText, 0xFF7F50)
end