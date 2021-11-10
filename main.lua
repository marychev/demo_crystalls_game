require ("game.igame")

local game = IGame:new()
print("\r\n\tHi gamer, Are you ready?\r\n")
local description = [[
Режим игры (MODE) можно изменить в types/settings.lua

Дополнительно:
Использовать рандомную карту: раскоментировать self.area:do_random_map() 
Использовать свою карту:      раскоментировать self.area:do_level() 
]]
print(description)
print(game.help)


game:init()
game:dump()


while true do
    local tick = game:tick()
    local has_valid = tick[1]
    local msg = tick[2]

    if has_valid then
        game:move()
        game:dump()

        game:mix()
        game:dump()
    else
        if msg == "Exit" then
            print(msg)
            break
        else
            print("\r\nНевалидная команда: ", msg)
            print(game.help)
        end
    end
end

