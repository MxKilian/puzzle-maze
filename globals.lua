Globals = {}
Globals.__index = Globals

function Globals:new()

    local instance = {}
    setmetatable(instance, GameField)

    instance.SPACING_FROM_VERTICAL_EDGE = display.contentWidth / 8
    instance.SPACING_FROM_HORIZONTAL_EDGE = display.contentHeight / 20 

    -- self.fontSize = 0
    if display.contentWidth <= 640 then
        self.fontSize = 60
    else 
        self.fontSize = 75
    end

    return instance

end