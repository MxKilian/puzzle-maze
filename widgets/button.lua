
Button = {}
Button.__index = Button

local widget = require( "widget" )

function Button:new()    

    local instance = {}
    setmetatable(instance, self)

    return instance
end

function Button:newButton(buttonLabel, buttonWidth, buttonHeight, shape, buttonId)

    local button = widget.newButton(
        {
            shape = shape,
            cornerRadius = radius,
            width = buttonWidth,
            height = buttonHeight,
            fontSize = 60,
            id = buttonId,
            label = buttonLabel,
            labelColor = { default={ 1, 1, 1 }, default={ 1, 1, 1 } },
            fillColor = { default={ 1, 1, 1, 0.2 }, over={ 1, 1, 1, 0.2 } },
        }
    )

    return button
end