require("app.Common")
require("app.Camp")
local TankCursor = require("app.TankCursor")
local Map = require("app.Map")

local EditorScene = class("EditorScene", cc.load("mvc").ViewBase)


function EditorScene:onCreate()
    cc.SpriteFrameCache:getInstance():addSpriteFrames("tex.plist")
end

function EditorScene:onEnter()
        self.map = Map.new(self)

        self.tank = TankCursor.new(self,"tank_green", self.map)
        self.tank:PlaceCursor(MapWidth / 2, MapHeight/2)

        self:ProcessInput()
end



function EditorScene:ProcessInput( )
    local listener = cc.EventListenerKeyboard:create()

    listener:registerScriptHandler(function (keyCode, event)
        printLog(("key: " .. keyCode .. " was clicked"))
        if self.tank ~= nil then
            -- w
            if keyCode == 146 then
                self.tank:MoveCursor(0, 1)--("up")
            --s
            elseif keyCode == 142 then
                self.tank:MoveCursor(0, -1)--("down")
            --a
            elseif keyCode == 124 then
                self.tank:MoveCursor(-1, 0)--("left")
            --d
            elseif keyCode == 127 then
                self.tank:MoveCursor(1, 0)--("right")
            --j
            elseif keyCode == 133 then
                self.tank:SwitchBlock(1)
            --k
            elseif keyCode == 134 then
                self.tank:SwitchBlock(-1)
            --f3
            elseif keyCode == 49 then
                self.map:Save(editorFileName)
            --f4
            elseif keyCode == 50 then
                self.map:Load(editorFileName)
            end
        end
    end,cc.Handler.EVENT_KEYBOARD_RELEASED)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end


return EditorScene