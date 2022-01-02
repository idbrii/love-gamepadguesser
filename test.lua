package.path = '?.lua;' .. package.path

local gamepadguesser = require "init"

local function script_path()
    local str = debug.getinfo(2, "S").source
    return str:match("@?(.*/)") or "."
end

gamepadguesser.test_printAllGuesses(script_path() .."/assets/db/gamecontrollerdb.txt")
