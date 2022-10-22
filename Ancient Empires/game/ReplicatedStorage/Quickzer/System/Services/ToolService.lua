-- Created By Carrotoplia on Sat Oct 15 00:16:48 2022
-- Used for quickly loading players in

----------------------------->> Modules / Services <<---------------------------------

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Get = require(game:GetService("ReplicatedStorage").Get)
local Objectify = require(Get("Objectify"))
local QuickSignal = require(Get("QuickSignal"))
local RConfig = require(ReplicatedStorage.ReplicatedConfig)

----------------------------->> Variables <<---------------------------------

local PlayerTools = {}
local Config = RConfig.T

----------------------------->> THE ONLY SERVICE <<---------------------------------

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



local Holder = Objectify(Service)
return Service