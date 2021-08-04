GameField = {}
GameField.__index = GameField

local widget = require( "widget" )
local stopwatch = require( "stopwatch" )
local composer = require( "composer" )

function GameField:new(numberOfPuzzleStones, numberOfExamplePuzzleStones)

    require( "globals" )
    -- require( "scene" )
    require( "gameconfig" )

    local instance = {}
    setmetatable(instance, GameField)

    math.randomseed(os.time())

    -- Constants
    Globals:new()

    -- Display group
    self.group = display.newGroup()

    -- Stop watch
    self.stopWatchStarted = false

    -- Contains all puzzle gameStones of the gamefield
    self.gameStones = {}

    -- Contains all puzzle stones of the example puzzle
    self.exampleStones = {}

    -- Initialize background colors and interface design
    GameField:addBackground()
    GameField:addMenuButton()

    self.stopWatch = StopWatch:initialize(self.stopWatchText)
  
    -- Border  
    local gameplayBackgroundBottomBorderX = self.gameplayBackgroundBottom.contentWidth - (self.gameplayBackgroundBottom.contentWidth / 8)
    local gameplayBackgroundBottomBorderY = self.gameplayBackgroundBottom.contentHeight - (self.gameplayBackgroundBottom.contentHeight / 8)
    
    local puzzleGamePlayHeight = self.gameplayBackgroundBottom.height / 6 -- we need 5 rows and one additional for the space between the rows
    local puzzleGamePlayWidth = puzzleGamePlayHeight

    self.stoneWidth = puzzleGamePlayWidth
    self.stoneHeight = self.stoneWidth

    -- Offset between x/y of two stones = stone width + spacing
    self.spacingBetweenGameStones = math.floor(self.stoneWidth + (self.stoneWidth / 6)) -- we need for each row and column 4 spacings
    self.spacing = self.spacingBetweenGameStones - self.stoneWidth

    -- Initial position of the first stone in the first row
    self.initialPosX = (self.gameplayBackgroundBottom.contentWidth - (5 * self.stoneWidth + (4 * (self.spacingBetweenGameStones - self.stoneWidth)))) / 2
    self.initialPosY = display.contentCenterY + (self.gameplayBackgroundBottom.contentHeight - (5 * self.stoneWidth + (4 * (self.spacingBetweenGameStones - self.stoneWidth)))) / 2
   
    -- Used for calculating the open spot of the missing rectangle
    self.openSpotX = 0
    self.openSpotY = 0

    -- GameField:addExampleFieldStroke(numberOfExamplePuzzleStones)

    -- Generate Puzzle
    GameField:generateExamplePuzzle(numberOfExamplePuzzleStones)
    GameField:generatePuzzle(numberOfPuzzleStones)
    
    -- 
    GameField:removeStoneForGap()

    -- Colorize the puzzle
    self.mode = GameConfig.puzzleMode
    if self.mode == 1 then
        GameField:colorizePuzzle(self.exampleStones, 1)
        GameField:colorizePuzzle(self.gameStones, 4)
    elseif self.mode == 2 then
        GameField:colorizePuzzle(self.exampleStones, 2)
        GameField:colorizePuzzle(self.gameStones, 4)
    elseif self.mode == 3 then
        GameField:colorizePuzzle(self.exampleStones, 3)
        GameField:colorizePuzzle(self.gameStones, 4)
    end

    --
    GameField:addGapStone()

    -- Puzzle Destination
    GameField:showRandomDestination()


    return instance

end

function GameField:addBackground()

    -- Menu bar for buttons at the bottom of the display
    local menuBarBottomHeight = display.contentHeight - (display.contentHeight - 100)
    self.menuBarBottom = display.newRoundedRect(0, display.contentHeight - (display.contentHeight / 10), display.contentWidth, menuBarBottomHeight, 1)
    self.menuBarBottom.anchorX = 0
    self.menuBarBottom.anchorY = 0
    self.menuBarBottom:setFillColor(0,0,0)
    -- self.menuBarBottom:setStrokeColor(1,1,1)

    -- Upper half of the display
    self.gameplayBackgroundTop = display.newRect(0, 0, display.contentWidth, display.contentHeight / 2)
    self.gameplayBackgroundTop:setFillColor( 233/255, 233/255, 233/255 )
    self.gameplayBackgroundTop.anchorX = 0
    self.gameplayBackgroundTop.anchorY = 0 

    -- Lower half of the display
    local gameplayBackgroundBottomHeight = (display.contentHeight / 2) - self.menuBarBottom.height
    self.gameplayBackgroundBottom = display.newRect(0, display.contentCenterY, display.contentWidth, gameplayBackgroundBottomHeight)
    self.gameplayBackgroundBottom:setFillColor( 233/255, 233/255, 233/255 )
    self.gameplayBackgroundBottom.anchorX = 0
    self.gameplayBackgroundBottom.anchorY = 0 

    -- Calculate the y - position of the rect, which will be used by the rect and the text object
    local stopWatchRectY = display.contentHeight / 2
    stopWatchRectY = stopWatchRectY / 5

    -- Stop Watch
    self.stopWatchText = display.newText( "0:0:0", display.contentCenterX, stopWatchRectY, native.systemFont, Globals.fontSize)
    self.stopWatchText:setFillColor( 1,1,1 )

    -- Stop watch rect
    self.stopWatchRect = display.newRect(display.contentCenterX, stopWatchRectY, self.stopWatchText.contentWidth * 2, self.stopWatchText.contentHeight * 1.5)
    self.stopWatchRect:setFillColor( 33/255, 33/255, 33/255)

    -- Put stop watch into rect
    self.stopWatchText.x = self.stopWatchRect.x
    self.stopWatchText.y = self.stopWatchRect.y

    self.group:insert(self.menuBarBottom)
    self.group:insert(self.gameplayBackgroundTop)
    self.group:insert(self.gameplayBackgroundBottom)
    self.group:insert(self.stopWatchRect)
    self.group:insert(self.stopWatchText)

end

function GameField:handleFinishButtonEvent()
   
    local options =
    {
        params = {
            finish = 1
        }
    }

    local result = true
    for i = 1, table.getn(self.destIndexValues) do

        local tmpIndex = self.destIndexValues[i]

        if self.gameStones[tmpIndex] ~= -1 then
            if self.gameStones[tmpIndex]["color"] == self.exampleStones[i]["color"] then
                result = result and true
            else 
                result = result and false
            end
        else 
            result = result and false
        end

        if result == false then
            options.params.finish = 0
        end

    end

    composer.showOverlay( "scene.dialog.finishdialog", options )

end

function GameField:handleCancelButtonEvent()

    -- Stop timer
    StopWatch:cancel()

    local currScene = composer.getSceneName( "current" )
    composer.removeScene( currScene )
    composer.gotoScene( "scene.menu" )

end

function GameField:addMenuButton()

    self.finishButton = widget.newButton(
        {
            shape = "roundedRect",
            width = display.contentWidth / 2,
            height = self.menuBarBottom.height,
            fontSize = 60,
            id = "finish",
            label = "Finish",
            labelColor = { default={ 1, 1, 1, 1 }, over={ 1, 1, 1, 1 } },
            fillColor = { default={ 117/255,117/255,117/255 }, over={ 117/255,117/255,117/255 } },
            onPress = function(event) GameField:handleFinishButtonEvent() end
        }
    )

    self.cancelButton = widget.newButton(
        {
            shape = "roundedRect",
            width = display.contentWidth / 2,
            height = self.menuBarBottom.height,
            fontSize = 60,
            id = "cancel",
            label = "Cancel",
            labelColor = { default={ 1, 1, 1, 1 }, over={ 1, 1, 1, 1 } },
            fillColor = { default={ 117/255,117/255,117/255 }, over={ 117/255,117/255,117/255 } },
            onPress = function(event) GameField:handleCancelButtonEvent() end
        }
    )

    self.finishButton.anchorX = 0
    self.finishButton.anchorY = 0
    self.finishButton.x = display.contentWidth / 2
    self.finishButton.y = display.contentHeight - self.menuBarBottom.height

    -- Add the image next to the button
    self.finishButtonImage = display.newImageRect( "images/racing-flag.png", 64, 64 )
    self.finishButtonImage.anchorX = 0
    self.finishButtonImage.anchorY = 0
    self.finishButtonImage.x = self.finishButton.x + (self.finishButton.width / 8)
    self.finishButtonImage.y = self.finishButton.y + ((self.menuBarBottom.height - 64) / 2)

    --
    self.cancelButton.anchorX = 0
    self.cancelButton.anchorY = 0
    self.cancelButton.x = 0
    self.cancelButton.y = display.contentHeight - self.menuBarBottom.height

    --
    self.group:insert(self.finishButton)
    self.group:insert(self.cancelButton)
    self.group:insert(self.finishButtonImage)

end

function GameField:addExampleFieldStroke(numberOfExamplePuzzleStones)
    
    local stonesPerRow = math.sqrt(numberOfExamplePuzzleStones)
    local spacing = self.spacingBetweenGameStones - self.stoneWidth
    local examplePuzzleWidth = (stonesPerRow * self.stoneWidth) + (stonesPerRow + 1) * spacing

    -- Contains the boundaries of the example puzzle rect stroke
    examplePuzzleRectXPos = (display.contentWidth - examplePuzzleWidth) / 2
    examplePuzzleRectYPos = (self.gameplayBackgroundTop.height / 2) - (examplePuzzleWidth / 2) + 100

    -- Example puzzle rect
    self.gameplayExamplePuzzleRect = display.newRect(examplePuzzleRectXPos, examplePuzzleRectYPos, examplePuzzleWidth, examplePuzzleWidth)
    self.gameplayExamplePuzzleRect:setFillColor(117/255,117/255,117/255)
    self.gameplayExamplePuzzleRect:setStrokeColor(1,1,1)
    self.gameplayExamplePuzzleRect.strokeWidth = 8
    self.gameplayExamplePuzzleRect.anchorX = 0
    self.gameplayExamplePuzzleRect.anchorY = 0

    --
    self.group:insert(self.gameplayExamplePuzzleRect)

end

function GameField:generatePuzzle(numberOfgameStones)

    local offsetX = 0
    local offsetY = 0

    for i = 1, numberOfgameStones do

        local tmpRect = display.newRect(self.initialPosX + offsetX, self.initialPosY + offsetY, self.stoneWidth, self.stoneHeight)
        tmpRect.anchorX = 0
        tmpRect.anchorY = 0

        self.gameStones[i] = tmpRect 
        self.group:insert(tmpRect)     
        offsetX = offsetX + self.spacingBetweenGameStones

        if i % 5 == 0 then
            offsetX = 0
            offsetY = offsetY + self.spacingBetweenGameStones
            -- self.initialPosY = self.initialPosY + self.spacingBetweenGameStones
        end
        
    end
end

function GameField:generateExamplePuzzle(numberOfExamplePuzzleStones)

    local stonesPerRow = math.sqrt( numberOfExamplePuzzleStones )
    local stopWatchRectBottomY = self.stopWatchRect.y + (self.stopWatchRect.contentHeight / 2)

    local widthForExamplePuzzleField = display.contentWidth
    local heightForExamplePuzzleField = (display.contentHeight / 2) - stopWatchRectBottomY
    heightForExamplePuzzleField = heightForExamplePuzzleField - (stonesPerRow - 1) * self.spacing -- Keep the used button spacing

    local examplePuzzleStoneWidth = heightForExamplePuzzleField / (stonesPerRow + 1)
    local examplePuzzleStoneHeight = examplePuzzleStoneWidth

    -- Remove the used button spacing as we have calculated the correct size of our game stones with button spacing
    heightForExamplePuzzleField = heightForExamplePuzzleField + (stonesPerRow - 1) * self.spacing

    local offset = 0

    local tmpOffsetXRow = (stonesPerRow * examplePuzzleStoneWidth)  + ((stonesPerRow - 1) * self.spacing)
    tmpOffsetXRow = (display.contentWidth - tmpOffsetXRow) / 2
    local offsetXRow = tmpOffsetXRow
    local offsetYRow = heightForExamplePuzzleField - ((stonesPerRow * examplePuzzleStoneWidth) + (self.spacing * (stonesPerRow - 1))) 
    offsetYRow = stopWatchRectBottomY + (offsetYRow / 2) 
    
    for i = 1, numberOfExamplePuzzleStones do
      
        local tmpRect = display.newRect(offsetXRow + offset, offsetYRow, examplePuzzleStoneWidth , examplePuzzleStoneHeight)
        tmpRect.anchorX = 0
        tmpRect.anchorY = 0

        self.exampleStones[i] = tmpRect
        self.group:insert(tmpRect)
        offset = offset + examplePuzzleStoneWidth + self.spacing
        if i % stonesPerRow == 0 then
            offset = 0
            offsetYRow = offsetYRow + examplePuzzleStoneWidth + self.spacing
        end
        
    end
end

function GameField:colorizePuzzle(stones, maxOccurenceOfColor)

    local yellow = { 255/255, 235/255,59/255 }
    local green = { 67/255,160/255,71/255 }
    local blue = { 3/255,155/255,229/255 }
    local red = { 244/255,81/255,30/255 }
    local purple = { 142/255,36/255,170/255 }
    local brown = { 109/255,76/255,65/255 }

    local colors = { { yellow, 0 }, { green, 0 }, { blue, 0 }, { red, 0}, { purple, 0 }, { brown, 0 } }

    -- math.randomseed(os.time())
    for i = 1, table.getn(stones) do

        local colorIndex1 = math.random(1, 6)
        if colors[colorIndex1][2] >= maxOccurenceOfColor then
            while 1 do
                local colorIndex2 = math.random(1, 6)
                if (colors[colorIndex2][2] < maxOccurenceOfColor) and (colorIndex1 ~= colorIndex2) then
                    stones[i]:setFillColor(unpack(colors[colorIndex2][1]))
                    stones[i]["color"] = colorIndex2
                    colors[colorIndex2][2] = colors[colorIndex2][2] + 1
                    break
                end
            end
        else
            stones[i]:setFillColor(unpack(colors[colorIndex1][1]))
            stones[i]["color"] = colorIndex1
            colors[colorIndex1][2] = colors[colorIndex1][2] + 1
        end 
    end

end

function GameField:getColor(colorNumber)

    local color = ""

    if colorNumber == 1 then
        color = "yellow"
    elseif colorNumber == 2 then
        color = "green"
    elseif colorNumber == 3 then
        color = "blue"
    elseif colorNumber == 4 then
        color = "red"
    elseif colorNumber == 5 then
        color = "purple"
    elseif colorNumber == 6 then
        color = "brown"
    end

    return color

end

function GameField:removeStoneForGap()

    self.removedStoneIndex = 13

    -- Save the x/y of the removed stone
    self.openSpotX = math.floor(self.gameStones[13].x)
    self.openSpotY = math.floor(self.gameStones[13].y)

    -- Remove object from gameplay
    self.gameStones[self.removedStoneIndex]:removeSelf()

    -- Remove object from table
    table.remove(self.gameStones, self.removedStoneIndex)
 
end

function GameField:addGapStone()
    table.insert(self.gameStones, 13, -1)
end

function GameField:switchStones(clickedStoneIndex, indexOfRemovedStone)
    local tmpStone = self.gameStones[clickedStoneIndex]
    self.gameStones[clickedStoneIndex] = -1
    self.gameStones[indexOfRemovedStone] = tmpStone
    self.removedStoneIndex = clickedStoneIndex
end

local function getIndexOfGameStone(gameStones, stone)   
    local index = 0
    for i = 1, table.getn(gameStones) do
        if gameStones[i] == stone then
            index = i
            break
        end
    end

    return index
end

function GameField:startStopWatch()
    
    if(self.stopWatchStarted == false) then
        self.stopWatchStarted = true
        StopWatch:start()
    end

end

function GameField:updateStopWatch()
    self.stopWatch.text = StopWatch:toString()
end

function GameField:moveStone( event )

    GameField:startStopWatch()

    local tmpStoneIndex = 0
    local stone = event.target
    local stoneX = math.floor(event.target.x)
    local stoneY = math.floor(event.target.y)

    tmpStoneIndex = getIndexOfGameStone(self.gameStones, stone)

    -- Move stone the right (+x direction)
    if stoneX + self.spacingBetweenGameStones == self.openSpotX and stoneY == self.openSpotY then
        self.openSpotX = stoneX
        self.openSpotY = stoneY
        GameField:switchStones(tmpStoneIndex, self.removedStoneIndex)
        transition.moveTo( stone, { x = stoneX + self.spacingBetweenGameStones, y = stoneY, time = 100 } )

    -- Move stone to the left (-x direction)
    elseif stoneX - self.spacingBetweenGameStones == self.openSpotX and stoneY == self.openSpotY then
        self.openSpotX = stoneX
        self.openSpotY = stoneY
        GameField:switchStones(tmpStoneIndex, self.removedStoneIndex)
        transition.moveTo( stone, { x = stoneX - self.spacingBetweenGameStones, y = stoneY, time = 100 } )

    -- Move stone to the bottom (+y direction)
    elseif (stoneX == self.openSpotX) and ((stoneY + self.spacingBetweenGameStones) == self.openSpotY) then
        self.openSpotX = stoneX
        self.openSpotY = stoneY
        GameField:switchStones(tmpStoneIndex, self.removedStoneIndex)
        transition.moveTo( stone, { x = stoneX, y = stoneY + self.spacingBetweenGameStones, time = 100 } )

    -- Move stone to the top (-y direction)
    elseif stoneX == self.openSpotX and stoneY - self.spacingBetweenGameStones == self.openSpotY then
        self.openSpotX = stoneX
        self.openSpotY = stoneY
        GameField:switchStones(tmpStoneIndex, self.removedStoneIndex)
        transition.moveTo( stone, { x = stoneX, y = stoneY - self.spacingBetweenGameStones, time = 100 } )
    end

end

function GameField:showRandomDestination()

    self.destIndexValues = {}

    -- Possible positions (for 5x5 puzzle) to start with destination rect can be one of the following numbers
    local possiblePos2x2 = { 1, 2, 3, 4, 6, 7, 8, 9, 11, 12, 13, 14, 16, 17, 18, 19 }
    local possiblePos3x3 = { 1, 2, 3, 6, 7, 8, 11, 12, 13 }
    local possiblePos4x4 = { 1, 2, 6, 7 }

    local index = nil
    local start = nil

    if self.mode == 1 then
        index = math.random(1, table.getn(possiblePos2x2))
        start = possiblePos2x2[index]
        self.destIndexValues = { start, start + 1, start + 5, start + 6 }

    elseif self.mode == 2 then
        index = math.random(1, table.getn(possiblePos3x3))
        start = possiblePos3x3[index]
        self.destIndexValues = { start, start + 1, start + 2, start + 5, start + 6, start + 7, start + 10, start + 11, start + 12 }

    elseif self.mode == 3 then
        index = math.random(1, table.getn(possiblePos4x4))
        start = possiblePos4x4[index]
        self.destIndexValues = { start, start + 1, start + 2, start + 3, 
            start + 5, start + 6, start + 7, start + 8,
            start +10, start + 11, start + 12, start + 13,
            start + 15, start + 16, start + 17, start + 18 }
    end

    -- Create the randomized destination by the x/y coordinates from the first field
    GameField:createDestinationRectangle(self.destIndexValues[1])

end

-- Let's initially assume, that we always have a 5x5 game field
function GameField:createDestinationRectangle(firstField, randomize)

        local width = nil
        local tmpX = nil
        local tmpY = nil

        if firstField == 13 then
            tmpX = self.openSpotX
            tmpY = self.openSpotY
        else
            tmpX = self.gameStones[firstField].x
            tmpY = self.gameStones[firstField].y
        end

        if self.mode == 1 then
            width = 2 * self.stoneWidth + self.spacing
        elseif self.mode == 2 then
            width = self.stoneWidth + (2 * self.spacingBetweenGameStones)
        elseif self.mode == 3 then
            width = (4 * self.stoneWidth) + (3 * self.spacing)
        end

        local height = width
        self.destinationRect = display.newRect(tmpX, tmpY, width, height)
        self.destinationRect:setFillColor(1,1,1,0)
        self.destinationRect:setStrokeColor(255/255,23/255,68/255)
        self.destinationRect.strokeWidth = 8
        self.destinationRect.anchorX = 0
        self.destinationRect.anchorY = 0

        --
        self.group:insert(self.destinationRect)

end