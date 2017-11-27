require("app.Common")
require("app.Camp")
local Map = require("app.Map")
local Tank = require("app.Tank")
local PlayerTank = require("app.PlayerTank")
local Factory = require("app.Factory")
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function MainScene:onCreate()
    -- add background image
    -- display.newSprite("tex.png")
    --     :move(display.center)
    --     :addTo(self)

    -- add HelloWorld label
    -- cc.Label:createWithSystemFont("Hello World", "Arial", 40)
    --     :move(display.cx, display.cy + 200)
    --     :addTo(self)
    cc.SpriteFrameCache:getInstance():addSpriteFrames("tex.plist")
    Camp_SetHostile("player", "enemy", true)
    Camp_SetHostile("enemy", "player", true)

    Camp_SetHostile("player.bullet", "enemy", true)
    Camp_SetHostile("enemy.bullet", "player", true)

    Camp_SetHostile("player.bullet", "enemy.bullet", true)
    Camp_SetHostile("enemy.bullet", "player.bullet", true)

    


end
function MainScene:onEnter()
        -- display.newSprite("tex.png")
        -- :move(display.center)
        -- :addTo(self)
        self.map = Map.new(self)

        self.factory = Factory.new(self,self.map)

        local size = cc.Director:getInstance():getWinSize()
        self.tank = PlayerTank.new(self,"tank_green", self.map,"player")
        self.tank:SetPos(5, 5)

        Tank.new(self, "tank_blue", self.map, "enemy"):SetPos(3, 4)

        self:ProcessInput()
end

function MainScene:ProcessInput( )
    local listener = cc.EventListenerKeyboard:create()
        listener:registerScriptHandler(function (keyCode, event)
        printLog(("key: " .. keyCode .. " was clicked"))
        if self.tank ~= nil then
            -- w
            if keyCode == 146 then
                self.tank:MoveBegin("up")
            --s
            elseif keyCode == 142 then
                self.tank:MoveBegin("down")
            --a
            elseif keyCode == 124 then
                self.tank:MoveBegin("left")
            --d
            elseif keyCode == 127 then
                self.tank:MoveBegin("right")

            end
        end
    end,cc.Handler.EVENT_KEYBOARD_PRESSED)
    listener:registerScriptHandler(function (keyCode, event)
        printLog(("key: " .. keyCode .. " was clicked"))
        if self.tank ~= nil then
            -- w
            if keyCode == 146 then
                self.tank:MoveEnd("up")
            --s
            elseif keyCode == 142 then
                self.tank:MoveEnd("down")
            --a
            elseif keyCode == 124 then
                self.tank:MoveEnd("left")
            --d
            elseif keyCode == 127 then
                self.tank:MoveEnd("right")
            --j
            elseif keyCode == 133 then
                self.tank:Fire()
            --k
            elseif keyCode == 134 then
                self.factory:SpawnRandom()
            --f4
            elseif keyCode == 50 then
                self.map:Load(editorFileName)
            end
        end
    end,cc.Handler.EVENT_KEYBOARD_RELEASED)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end


return MainScene
