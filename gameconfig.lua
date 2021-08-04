GameConfig = {}
GameConfig.__index = GameConfig

--[[
    Puzzle mode
    1 = 3x3
    2 = 4x4
    3 = 5x5
]]
function GameConfig:new(puzzleMode)

    local instance = {}
    setmetatable(instance, GameField)

    self.puzzleMode = puzzleMode

    return instance

end