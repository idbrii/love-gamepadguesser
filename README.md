# GamepadGuesser

Guess what a gamepad should look like and provide a default set of art that
matches the input gamepad.

*Not an input mapping library. If you want to define input bindings, I recommend [baton](https://github.com/tesselode/baton).*

Simplify showing gamepad icons with gamepadguesser. It loads the extensive
[SDL_GameControllerDB](https://github.com/gabomdq/SDL_GameControllerDB), maps
joysticks to appearance (console-specific buttons like Xbox, PS, Nintendo), and
builds images as you request them.

You can start displaying the correct image for your buttons in only a few lines
of code:

```lua
local gamepadguesser = require "gamepadguesser"

function love.gamepadpressed(joystick, button)
    joy = joy or gamepadguesser.createJoystickData("gamepadguesser")
    image = joy:getImage(joystick, button)
end

function love.draw()
    if image then
        love.graphics.draw(image, 0, 0)
    end
end
```

See main.lua for a more extensive example.


You can also use gamepadguesser with your own art. The easiest way is to modify
the art in gamepadguesser/assets/images/ to ensure the correct file names.

You can also get the name of the console associated with the joystick:

```lua
function love.gamepadpressed(joystick, button)
    text = gamepadguesser.joystickToConsole(joystick)
end

function love.draw()
    love.graphics.printf(text or "", 0, 0, 100)
end
```


## License

* gamepadguesser - idbrii - MIT
* [SDL_GameControllerDB](https://github.com/gabomdq/SDL_GameControllerDB) - Sam Lantinga - [SDL License](https://github.com/gabomdq/SDL_GameControllerDB/blob/master/LICENSE)
* [gamepad art in assets/images/](https://thoseawesomeguys.com/prompts/) - Nicolae (Xelu) Berbece - [CC0](https://creativecommons.org/share-your-work/public-domain/cc0/)
