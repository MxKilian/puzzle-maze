-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local widget = require( "widget" )

local scene = composer.newScene()
 
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()
function scene:create( event )

    require( "gameconfig" )
    require( "globals")
    require( "widgets.button" )
    require( "widgets.logo" )
 
    local sceneGroup = self.view
    local globals = Globals:new()
    local NUMBER_OF_BUTTONS_PER_ROW = 2
    -- local SPACING_FROM_VERTICAL_EDGE = display.contentWidth / 8
    -- local SPACING_FROM_HORIZONTAL_EDGE = display.contentHeight / 20 

    -- Background
    local background = display.newImageRect("images/background.jpg", display.contentWidth, display.contentHeight)
    background.anchorX = 0
    background.anchorY = 0
    background:setFillColor(33/255,33/255,33/255)


    -- Logo
    --[[
    local logo = Logo:new()
    local headline = logo:get(display.contentWidth - 2 * SPACING_FROM_VERTICAL_EDGE, (display.contentHeight / 2) - 2 * SPACING_FROM_HORIZONTAL_EDGE)
    headline.x = display.contentCenterX
    headline.y = 500
    ]]

    --[[
        We want to divide the display into two sections, both have the height of half the screen.
        Every object should be adjust to this two sections
    ]]

    -- Game name
    --[[
    local gameName1Y = display.contentHeight / 2
    gameName1Y = 0 + (gameName1Y / 3)
    local gameName1 = display.newText("Puzzle", display.contentCenterX, gameName1Y, native.systemFont, 120)
    local gameName2 = display.newText("Maze", display.contentCenterX, gameName1.y + gameName1.height, native.systemFont, 200)

    local quickPlayLabelY = display.contentHeight / 2
    local quickPlayLabel = display.newText( "Level", SPACING_FROM_VERTICAL_EDGE, quickPlayLabelY, native.systemFont, 65)
    quickPlayLabel.anchorX = 0
    quickPlayLabel.anchorY = 0
    ]]

    -- Button handler
    local function handle2x2()
        GameConfig:new(1)
        composer.gotoScene( "scene.game" ) 
    end

    local function handle3x3()
        GameConfig:new(2)
        composer.gotoScene( "scene.game" ) 
    end

    local function handle4x4()
        GameConfig:new(3)
        composer.gotoScene( "scene.game" ) 
    end

    -- Buttons
    local customButton = Button:new()
    local upperLimit = display.contentHeight / 2

    local button2x2 = customButton:newButton("2x2", 200, 200, "rect", "2x2")
    button2x2:addEventListener( "tap", function(event) handle2x2() end )

    local button3x3 = customButton:newButton("3x3", 200, 200, "rect", "3x3")
    button3x3:addEventListener( "tap", function(event) handle3x3() end )

    local button4x4 = customButton:newButton("4x4", 200, 200, "rect", "4x4")
    button4x4:addEventListener( "tap", function(event) handle4x4() end )

    button2x2.x = globals.SPACING_FROM_VERTICAL_EDGE
    button2x2.y = upperLimit + (button2x2.contentHeight / 2)


    sceneGroup:insert(background)
    sceneGroup:insert(button2x2)
    sceneGroup:insert(button3x3)
    sceneGroup:insert(button4x4)
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view

    composer.removeScene( "menu" )
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene