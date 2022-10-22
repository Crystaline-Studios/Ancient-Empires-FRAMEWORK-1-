-- Created By Carrotoplia on Sat Oct 15 00:16:48 2022
-- Used for well World Management

----------------------------->> Modules / Services <<---------------------------------

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")


local Get = require(game:GetService("ReplicatedStorage").Get)
local Objectify = require(Get("Objectify"))
local ProfileService = require(script.Parent.ProfileService)

----------------------------->> THE ONLY SERVICE <<---------------------------------

local Service = {}

function Service:Cut(PosA, PosB)
	Workspace:GetPartBoundsInBox(PosA, PosB)
end


local Holder = Objectify(Service)
return Service
