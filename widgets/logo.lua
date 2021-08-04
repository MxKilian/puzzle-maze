Logo = {}
Logo.__index = Logo

function Logo:new()

    local instance = {}
    setmetatable(instance, Logo)

    return instance
end

function Logo:get(width, height)

    local container = display.newContainer(width, height)

    local headline1 = display.newText("Puzzle", 0, 0, native.systemFont, 202)
    local fontRatio = headline1.contentWidth / headline1.size 
    local tmp = width / fontRatio
    headline1.size = headline1.size
    -- local headline2 = display.newText("Maze", 100, 100, native.systemFont, 80)
    headline1.x = 0
    headline1.y = 0 - (container.height / 2) + (headline1.height / 2)

    local border = display.newRect(0, 0, width, height)
    border:setFillColor(0,0,0,0)
    border:setStrokeColor(1,1,1)
    border.strokeWidth = 10

    container:insert(border)
    container:insert(headline1)

    return container
end