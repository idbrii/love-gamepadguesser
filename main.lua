-- Show output immediately (for debugging).
io.stdout:setvbuf("no")

local gamepadguesser = require "gamepadguesser"

local joy
local gamepad
local action
local centre = { x=0, y=0, }
local press = {
    width = 1000,
}
local instruction = {
    width = 1000,
}
local fakeui = {
    width = 100,
}
local selector = {
    width = 100,
    choices = { "Auto", },
    current = 1,
    x = 650,
    y = 10,
    refresh = function(self)
        local console = self.choices[self.current]
        self.text:setf(console, self.width, "center")
        if gamepad then
            if console == "Auto" then
                -- Pass nil to return to automatic
                console = nil
            end
            joy:overrideConsole(gamepad, console)
        end
    end
}
for _,val in ipairs(gamepadguesser.CONSOLES) do
    table.insert(selector.choices, val)
end

local function create_arrow_button(x, y, point_right)
    local function draw_button(self)
        love.graphics.setColor(0.7, 0.7, 0.7, 1)
        local swell = (self:contains(love.mouse.getPosition()) and 2 or 0)
        love.graphics.rectangle('fill', self.x - swell/2, self.y - swell/2, self.w + swell, self.h + swell)
        love.graphics.setColor(0.1, 0.1, 0.1, 1)
        local half_h = self.h/2
        local pad = 5 - swell
        local flip = 0
        if self.point_right then
            flip = self.w - pad * 2
        end
        love.graphics.polygon('fill',
            flip + self.x + pad,          self.y + half_h,
            -flip + self.x - pad + self.w, self.y + pad,
            -flip + self.x - pad + self.w, self.y + self.h - pad)
    end
    local function inside_button(self, px, py)
        return (self.x <= px and px <= self.x + self.w
            and self.y <= py and py <= self.y + self.h)
    end
    return {
        draw = draw_button,
        contains = inside_button,
        w = 30,
        h = 30,
        x = x,
        y = y,
        point_right = point_right,
    }
end
local btn_prev = create_arrow_button(selector.x - 30, selector.y, false)
local btn_next = create_arrow_button(selector.x + selector.width, selector.y, true)

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
    selector.text = love.graphics.newText(love.graphics.getFont())
    selector:refresh()
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

function love.mousepressed(mx, my, btn)
    if btn == 1 then
        if btn_prev:contains(mx,my) then
            selector.current = math.max(selector.current - 1, 1)
        elseif btn_next:contains(mx,my) then
            selector.current = math.min(selector.current + 1, #selector.choices)
        end
        selector:refresh()
    end
end

function love.draw()
    love.graphics.setColor(1,1,1,1)

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

    love.graphics.draw(selector.text, selector.x, selector.y)
    btn_next:draw()
    btn_prev:draw()
    
end

