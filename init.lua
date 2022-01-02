-- GamepadGuesser
--
-- Guess the platform of your lua Joysticks from their names.
--
-- https://github.com/idbrii/love-gamepadguesser
--
-- Copyright © 2022 idbrii.
-- Released under the MIT License.


local gamepadguesser = {}


local all_patterns = {
    playstation = {
        "%f[%w]PS%d%f[%D]", "Sony%f[%W]", "Play[Ss]tation",
    },
    nintendo = {
        "Wii%f[%L]", "%f[%u]S?NES%f[%U]", "%f[%l]s?nes%f[%L]", "%f[%u]Switch%f[%L]", "Joy[- ]Cons?%f[%L]",
    },
    sega = {
        -- Be very cautious since sega gamepads are rare.
        "%f[%a]Sega%f[%W]",
    },
}

local function getNameFromMapping(mapping)
    return mapping:match("^%x*,(.-),")
end

function gamepadguesser.test_printAllGuesses(db_fpath)
    local f = io.open(db_fpath, "r")
    for line in f:lines() do
        if line:match('^%x') then
            local name = getNameFromMapping(line)
            assert(name, line)
            local console = gamepadguesser.joystickNameToConsole(name)
            if name then
                print(console, '<-', name)
            end
        end
    end
    f:close()
end



-- Load gamepad db to get support for more gamepads.
--
-- Call from love.load.
function gamepadguesser.loadMappings()
    local fpath = package.searchpath('gamepadguesser', package.path)
    fpath = fpath:gsub("init.lua", "assets/db/gamecontrollerdb.txt")
    love.joystick.loadGamepadMappings(fpath)
end


-- Map a joystick name (e.g., from gamecontrollerdb) to a console.
function gamepadguesser.joystickNameToConsole(name)
    for console,patterns in pairs(all_patterns) do
        for _,pat in ipairs(patterns) do
            if name:match(pat) then
                return console
            end
        end
    end
    -- Xbox button layout is ubiquitous
    return "xbox"
end

-- Map a love2d Joystick to a console.
--
-- Useful to get map to a folder name containing input images.
--
-- Returns:
--   "nintendo"
--   "playstation"
--   "sega"
--   or
--   "xbox"
function gamepadguesser.joystickToConsole(joystick)
    local name = getNameFromMapping(joystick:getGamepadMappingString())
    if not name or name:len() < 3 then
        name = joystick:getName()
    end
    return gamepadguesser.joystickNameToConsole(name)
end

return gamepadguesser
