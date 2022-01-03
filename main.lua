local gamepadguesser = require "gamepadguesser"

local joy
local image
local diagram
local press = {
    width = 1000,
}
local instruction = {
    width = 1000,
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
end

function love.gamepadpressed(joystick, button)
    image = joy:getImage(joystick, button)
    diagram = joy:getImage(joystick, "diagram")
    press.text:setf(button, press.width, "center")
end

function love.gamepadaxis(joystick, axis, value)
    if math.abs(value) < 0.25 then
        return
    end
    image = joy:getImage(joystick, axis)
    diagram = joy:getImage(joystick, "diagram")
    press.text:setf(("%s %.1f"):format(axis, value), press.width, "center")
end

function love.draw()
    love.graphics.draw(instruction.text, centre.x - instruction.width/2, 75)
    if image then
        local w,h = image:getDimensions()
        local im_x,im_y = centre.x - w/2, centre.y - h/2
        love.graphics.draw(image, im_x, im_y)
        love.graphics.draw(press.text, centre.x - press.width/2, im_y - h/2)

        w,h = diagram:getDimensions()
        local scale = 0.25
        w = w * scale
        h = h * scale
        love.graphics.draw(diagram, centre.x - w/2, centre.y - h/2 + 180, nil, scale, scale)
    end
end

