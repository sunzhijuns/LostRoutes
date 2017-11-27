require("app.Common")
require("app.Camp")
local Map = require("app.Map")
local Tank = require("app.Tank")
local PlayerTank = require("app.PlayerTank")
local Factory = require("app.Factory")
local TitleScene = class("TitleScene", cc.load("mvc").ViewBase)

function TitleScene:onCreate()
    cc.SpriteFrameCache:getInstance():addSpriteFrames("tex.plist")
end
function TitleScene:onEnter()
    self.map = Map.new(self)

    self.tank = PlayerTank.new(self,"tank_green", self.map,"player")
    self.tank:SetPos(5, 1)
    self:ProcessInput()
end

function TitleScene:ProcessInput()
    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(function (keyCode, event)
        printLog(("key: " .. keyCode .. " was clicked"))
        if self.tank ~= nil then
            --a
            if keyCode == 124 then
                self.tank:SetPos(5, 1)
            --d
            elseif keyCode == 127 then
                self.tank:SetPos(11, 1)
            --j
            elseif keyCode == 133 then
                
            --k
            elseif keyCode == 134 then
                local sceneName
                local x,_ = self.tank:GetPos()
                if x==5 then
                    sceneName = "MainScene"
                else
                    sceneName = "EditorScene"
                end
                require("app.MyApp"):create():enterScene(sceneName)--,"fade",0.6,display.COLOR_BLACK)
            end
        end
    end,cc.Handler.EVENT_KEYBOARD_RELEASED)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

function TitleScene:onExit()
    self.tank:Destroy()
end


return TitleScene
