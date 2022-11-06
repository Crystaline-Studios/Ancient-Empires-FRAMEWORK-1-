-- Created By Carrotoplia on Sat Oct 15 00:16:48 2022
-- Used for quickly loading players in

----------------------------->> Modules / Services <<---------------------------------

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Get = require(game:GetService("ReplicatedStorage").Get)
local QuickSignal = require(Get("QuickSignal"))

----------------------------->> Variables <<---------------------------------

local PlayerTools = {}

----------------------------->> THE ONLY SERVICE <<---------------------------------
warn("tool service is not dead??")

local Service = {}

function Service:NewTool(Config)
	assert(Config, "Missing Parameter: Config")
	assert(Config.User, "Missing Parameter: Config.User")

	local Tool = {}
	Tool.Class = "Tool"

	Tool.DropOnDeath = Config.DropOnDeath or false
	Tool.Droppable = Config.Droppable or false

	Tool.User = Config.User
	Tool.ToolModel = Config.ToolModel

	if Tool.ToolModel then
		local Handle = Tool.ToolModel:FindFirstChild("Handle")
		assert(Handle, "Missing Handle in ToolModel")
		
		local Weld = Instance.new("Weld")
		Weld.Part0 = Handle
		local Character = Config.User.Character or Config.User.CharacterAdded:Wait()

		Weld.Part1 = Character:FindFirstChild("LeftArmHand")
	end

	return Tool
end

function Service:GetTools(Player)
	if not PlayerTools[Player] then
		PlayerTools[Player] = {}
	end
	return PlayerTools[Player]
end


return Service