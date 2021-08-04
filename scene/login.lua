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
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    -- Background
    local background = display.newRect(0, 0, display.contentWidth, display.contentHeight)
    background.anchorX = 0
    background.anchorY = 0
    background:setFillColor(0,0,0)

    local function handleButtonEvent( event )
        composer.gotoScene( "game" )
    end

    local username = native.newTextField( 150, 150, 180, 30 )

    -- username.text = "E-Mail/Username"
    -- username.hasBackground = false
    -- username:addEventListener( "userInput", textListener )  

    local login = widget.newButton(
        {
            shape = "roundedRect",
            width = display.contentWidth / 1.25,
            height = display.contentHeight / 12,
            fontSize = 60,
            id = "login",
            label = "SOLO",
            labelColor = { default={ 1, 1, 1 }, default={ 1, 1, 1 } },
            fillColor = { default={ 1, 1, 1, 0.5 }, over={ 1, 1, 1, 0.3 } },
            onPress = handleButtonEvent
        }
    )
   
    login.x = display.contentCenterX
    login.y = display.contentCenterY

    sceneGroup:insert(background)
    sceneGroup:insert(login)
    
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