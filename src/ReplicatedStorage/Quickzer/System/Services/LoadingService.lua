-- Created By Carrotoplia on Sat Oct 15 00:16:48 2022
-- Used for quickly loading players in

----------------------------->> Modules / Services <<---------------------------------

local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")


local Get = require(game:GetService("ReplicatedStorage").Get)
local Objectify = require(Get("Objectify"))
local ProfileService = require(script.Parent.ProfileService)

----------------------------->> THE ONLY SERVICE <<---------------------------------

local Service = {}
local LoadingS = {}
Service.LoadedCount = 0

function Service:Load(Script)
	assert(Script, "Missing Parameter: Script")
	LoadingS[Script] = true
	return function()
		LoadingS[Script] = false
		Script:SetAttribute("Loaded", true)
		rawset(Service, "LoadedCount", Service.LoadedCount + 1)
	end
end

function Service:IsLoaded(Object)
	assert(Object, "Missing Parameter: Object")
	if Object:GetAttribute("Loaded") then
		return true
	end
end

local Holder = Objectify(Service)
return Service
