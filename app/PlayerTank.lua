local Tank = require("app.Tank")
local socket = require("socket")

local PlayerTank = class("PlayerTank", Tank)

function PlayerTank:ctor(node , name)
	PlayerTank.super.ctor(self, node, name)
	self.dirTable = {}
end

function PlayerTank:MoveBegin(dir)
	self.dirTable[dir] = socket.gettime()
	printLog("Scoket", self.dirTable[dir])
	self:updateDir()
end

function PlayerTank:MoveEnd(dir)
	self.dirTable[dir] = 0
	printLog("Scoket", self.dirTable[dir])
	self:updateDir()
end

function PlayerTank:updateDir()
	local maxTime = 0
	local maxDir
	for k,d in pairs(self.dirTable) do
		if d > maxTime then
			maxTime = d
			maxDir = k
		end
	end

	self:SetDir(maxDir)
end

return PlayerTank