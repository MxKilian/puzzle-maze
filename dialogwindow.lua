DialogWindow = {}
DialogWindow.__index = DialogWindow

local widget = require( "widget" )
local composer = require( "composer" )

function DialogWindow:new(button, message)

    local instance = {}
    setmetatable(instance, DialogWindow)

    --
    self.group = display.newGroup()

    local dialogOffset = display.contentWidth - ((display.contentWidth - (display.contentWidth / 10) / 2))
    self.dialogBackground = display.newRoundedRect(display.contentCenterX, display.contentCenterY, display.contentWidth - (2 * dialogOffset), display.contentHeight / 5, 6)

    if message == "VICTORY" then
        self.dialogBackground:setFillColor(76/255,175/255,80/255)
    else
        self.dialogBackground:setFillColor(244/255,67/255,54/255)
    end
    
    -- Adjust text of dialog
    self.message = display.newText( message, 0, 0, native.systemFont, 80 )
    self.message:setFillColor(1,1,1)
    self.message.x = display.contentCenterX -- - (self.message.width / 2)
    self.message.y = self.dialogBackground.y - (self.dialogBackground.height / 2) + self.message.height

    self.group:insert(self.dialogBackground)
    self.group:insert(self.message)

    if button == 1 then
        DialogWindow:createYesNoButton()
        -- DialogWindow:createOkButton()
    end

    return instance

end

local function handleButtonEvent()
    local currScene = composer.getSceneName( "overlay" )
    composer.removeScene( currScene )
end

function DialogWindow:createOkButton()

    local posX = self.dialogBackground.x + self.dialogBackground.width
    local posY = self.dialogBackground.y + self.dialogBackground.height

    local width = self.dialogBackground.width / 3
    local height = self.dialogBackground.height / 4

    self.close = widget.newButton(
        {
            shape = "roundedRect",
            cornerRadius = 12,
            width = width,
            height = height,
            fontSize = 60,
            id = "close",
            label = "Close",
            labelColor = { default={ 1, 1, 1 }, default={ 1, 1, 1 } },
            fillColor = { default={ 0, 0, 0, 0.5 }, over={ 0, 0, 0, 0.3 } },
            onPress = handleButtonEvent
        }
    )

    self.close.x = self.dialogBackground.x
    self.close.y = self.dialogBackground.y + (self.dialogBackground.height / 2) - height -- + self.dialogBackground.height

    self.group:insert(self.close)

end

function DialogWindow:createYesNoButton()

    local width = self.dialogBackground.contentWidth / 2
    local height = self.dialogBackground.contentHeight / 4

    self.yes = widget.newButton(
        {
            shape = "rect",
            width = width,
            height = height,
            fontSize = 60,
            id = "yes",
            label = "Yes",
            labelColor = { default={ 1, 1, 1 }, default={ 1, 1, 1 } },
            fillColor = { default={ 0, 0, 0, 0.5 }, over={ 0, 0, 0, 0.3 } },
            onPress = handleButtonEvent
        }
    )

    self.no = widget.newButton(
        {
            shape = "rect",
            width = width,
            height = height,
            fontSize = 60,
            id = "no",
            label = "No",
            -- strokeColor = { default={ 0, 0, 0 }, over={ 0,0,0 } },
            -- strokeWidth = 2,
            labelColor = { default={ 1, 1, 1 }, default={ 1, 1, 1 } },
            fillColor = { default={ 0, 0, 0, 0.5 }, over={ 0, 0, 0, 0.3 } },
            onPress = handleButtonEvent
        }
    )

    self.yes.x = self.dialogBackground.x + (self.dialogBackground.contentWidth / 2) - (self.yes.contentWidth / 2)
    self.yes.y = self.dialogBackground.y + (self.dialogBackground.contentHeight / 2) - (self.yes.contentHeight / 2)

    self.no.x = self.dialogBackground.x - (self.dialogBackground.contentWidth / 2) + (self.no.contentWidth / 2)
    self.no.y = self.dialogBackground.y + (self.dialogBackground.contentHeight / 2) - (self.no.contentHeight / 2)

    local separatorY = self.dialogBackground.y + (self.dialogBackground.contentHeight / 2) - (self.yes.contentHeight/2)
    self.buttonSeparator = display.newRect(self.dialogBackground.x, separatorY, 2, self.yes.contentHeight)
    self.buttonSeparator:setFillColor( 1,1,1 )

    self.group:insert(self.yes)
    self.group:insert(self.no)
    self.group:insert(self.buttonSeparator)

end