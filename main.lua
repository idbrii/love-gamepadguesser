local gamepadguesser = require "gamepadguesser"

local joy
local gamepad
local action
local press = {
    width = 1000,
}
local instruction = {
    width = 1000,
}
local fakeui = {
    width = 100,
}
local centre = { x=0, y=0, }

function love.load()
    joy = gamepadguesser.createJoystickData("gamepadguesser")
    centre.x, centre.y = love.window.getMode()
    centre.x = centre.x * 0.5
    centre.y = centre.y * 0.5
    press.text = love.graphics.newText(love.graphics.getFont())
    instruction.text = love.graphics.newText(love.graphics.getFont())
    instruction.text:setf("Press a gamepad button.", instruction.width, "center")
    fakeui.text = love.graphics.newText(love.graphics.getFont())
    fakeui.text:setf("Jump", fakeui.width, "left")
end

function love.joystickadded(joystick)
    if joystick:isGamepad() then
        gamepad = joystick
    end
end

function love.gamepadpressed(joystick, button)
    gamepad = joystick
    action = button
    press.text:setf(button, press.width, "center")
end

function love.gamepadaxis(joystick, axis, value)
    if math.abs(value) < 0.25 then
        return
    end
    gamepad = joystick
    action = axis
    press.text:setf(("%s %.1f"):format(axis, value), press.width, "center")
end

function love.draw()
    if love.system.getOS() == 'Web' then
        love.graphics.printf("lovejs makes all gamepads appear to be xbox!", 0, 0, 1000)
    end
    love.graphics.draw(instruction.text, centre.x - instruction.width/2, 75)
    if gamepad then
        if action then
            local art = joy:getImage(gamepad, action)
            local w,h = art:getDimensions()
            local im_x,im_y = centre.x - w/2, centre.y - h/2
            love.graphics.draw(art, im_x, im_y)
            love.graphics.draw(press.text, centre.x - press.width/2, im_y - h/2)
        end

        local art = joy:getImage(gamepad, "diagram")
        local w,h = art:getDimensions()
        local scale = 0.25
        w = w * scale
        h = h * scale
        love.graphics.draw(art, centre.x - w/2, centre.y - h/2 + 180, nil, scale, scale)

        art = joy:getImage(gamepad, "a")
        w,h = art:getDimensions()
        scale = 0.25
        w = w * scale
        h = h * scale
        local ui_x,ui_y = love.window.getMode()
        ui_x = ui_x - fakeui.width
        ui_y = ui_y - 40
        love.graphics.draw(fakeui.text, ui_x, ui_y)
        ui_x,ui_y = ui_x - w - 10, ui_y - 5
        love.graphics.draw(art, ui_x, ui_y, nil, scale, scale)
    end
end

