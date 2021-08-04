
local composer = require( "composer" )
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

    require( "gamefield" )
    require( "stopwatch" )
    require( "gameconfig" )
    -- require( "sqlite3" )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    -- Create gamefield
    local mode = GameConfig.puzzleMode
    local game = nil

    if mode == 1 then
        game = GameField:new(25, 4)
    elseif mode == 2 then
        game = GameField:new(25, 9)
    elseif mode == 3 then
        game = GameField:new(25, 16)
    end
   
    sceneGroup:insert(game.group)

    -- Listener
    for i = 1, table.getn(GameField.gameStones) do   
        if game.gameStones[i] ~= -1 then
            game.gameStones[i]:addEventListener( "tap", function(event) GameField:moveStone(event) end )
        end
    end
    
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