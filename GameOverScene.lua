-- require "Cocos2d"
-- require "Cocos2dConstants"

require "SystemConst"

local size = cc.Director:getInstance():getWinSize()
local defaults = cc.UserDefault:getInstance()
local listener

local GameOverScene = class("GameOverScene",function()
    return cc.Scene:create()
end)

function GameOverScene.create(score)
    local scene = GameOverScene.new(score)
    scene:addChild(scene:createLayer())
    return scene
end

function GameOverScene:ctor(score)

    self.score = score

    --场景生命周期事件处理
    local function onNodeEvent(event)
        if event == "enter" then
            self:onEnter()
        elseif event == "enterTransitionFinish" then
            self:onEnterTransitionFinish()
        elseif event == "exit" then
            self:onExit()
        elseif event == "exitTransitionStart" then
            self:onExitTransitionStart()
        elseif event == "cleanup" then
            self:cleanup()
        end
    end
    self:registerScriptHandler(onNodeEvent)
end

-- create layer
function GameOverScene:createLayer()
    cclog("GameOverScene init")
    local layer = cc.Layer:create()

    --添加背景地图.
    local bg = cc.TMXTiledMap:create("map/blue_bg.tmx")
    layer:addChild(bg)

    --放置发光粒子背景
    local ps = cc.ParticleSystemQuad:create("particle/light.plist")
    ps:setPosition(cc.p(size.width/2, size.height/2  - 100))
    layer:addChild(ps)

    local top = cc.Sprite:createWithSpriteFrameName("gameover.page.png")
    --锚点在左下角
    top:setAnchorPoint(cc.p(0,0))
    top:setPosition(cc.p(0, size.height - top:getContentSize().height))
    layer:addChild(top)

    local defaults = cc.UserDefault:getInstance()
    local highScore = defaults:getIntegerForKey(HIGHSCORE_KEY, 0)
    if highScore < self.score then
        highScore = self.score
        defaults:setIntegerForKey(HIGHSCORE_KEY,highScore)
    end
    local text = string.format("%i points", highScore)
    local lblHighScore = cc.Label:createWithTTF("最高分：", "fonts/hanyi.ttf", 25)

    lblHighScore:setAnchorPoint(cc.p(0,0))
    local topX,topY = top:getPosition()
    lblHighScore:setPosition(cc.p(60 , topY - 30))

    layer:addChild(lblHighScore)

    local lblScore = cc.Label:createWithTTF(text, "fonts/hanyi.ttf", 24)
    lblScore:setColor(cc.c3b(75,255,255))
    lblScore:setAnchorPoint(cc.p(0,0))
    local lblHighScoreX,lblHighScoreY = lblHighScore:getPosition()
    lblScore:setPosition(cc.p(lblHighScoreX, lblHighScoreY - 40))
    layer:addChild(lblScore)

    local text2 = cc.Label:createWithTTF("Tap the Screen to Play", "fonts/hanyi.ttf", 24)
    text2:setAnchorPoint(cc.p(0,0))
    local lblScoreX,lblScoreY = lblScore:getPosition()
    text2:setPosition(cc.p(lblScoreX - 10, lblScoreY - 45))
    layer:addChild(text2)

    --接触事件回调函数
    local function touchBegan(touch, event)
        --播放音效
        if defaults:getBoolForKey(SOUND_KEY)  then
            AudioEngine.playEffect(sound_1)
        end
        cc.Director:getInstance():popScene()
        return false
    end

    --注册 触摸事件监听器
    listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    -- EVENT_TOUCH_BEGAN事件回调函数
    listener:registerScriptHandler(touchBegan,cc.Handler.EVENT_TOUCH_BEGAN)

    -- 添加 触摸事件监听器
    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)

    return layer
end


function GameOverScene:onEnter()
    cclog("GameOverScene onEnter")
end

function GameOverScene:onEnterTransitionFinish()
    cclog("GameOverScene onEnterTransitionFinish")
end

function GameOverScene:onExit()
    cclog("GameOverScene onExit")
    if nil ~= listener then
        cc.Director:getInstance():getEventDispatcher():removeEventListener(listener)
    end
end

function GameOverScene:onExitTransitionStart()
    cclog("GameOverScene onExitTransitionStart")
end

function GameOverScene:cleanup()
    cclog("GameOverScene cleanup")
end


return GameOverScene

