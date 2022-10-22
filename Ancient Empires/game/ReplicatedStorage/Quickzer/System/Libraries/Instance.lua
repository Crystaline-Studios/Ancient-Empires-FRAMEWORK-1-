--Created By Carrotoplia on Sun Oct  9 20:07:34 2022
-- For Creating instances and LuaObjects.

----------------------------->> Services <<---------------------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local StarterPlayer = game:GetService("StarterPlayer")
local RunService = game:GetService("RunService")

local Get = require(game:GetService("ReplicatedStorage").Get)
local Objectify = require(Get("Objectify"))
local ObjectStore = require(Get("Objectstore"))

----------------------------->> Assets <<---------------------------------
local ClientSystem = StarterPlayer:FindFirstChild("Clientside System")
local ReplicatedSystem = script:FindFirstAncestor("System")
local ServerSystem; if ServerScriptService then
	ServerSystem = ServerScriptService:FindFirstChild("Serverside System")
end

----------------------------->> Variables <<---------------------------------

local IsClient = RunService:IsClient()
local IsServer = RunService:IsServer()

----------------------------->> Library <<---------------------------------

local Library = {}
Library.Class = "InstanceLibrary"

Library.New = Instance.new
Library.new = Instance.new

function Library.LNew(Index, ...)
	assert(Index, "Missing Object ClassName.")
	assert(type(Index) == "string", "String Expected got: " .. typeof(Index))
	
	local Object = Get(Index, "LuaObjects")
	if Object then
		Object = require(Object)
		if rawget(Object, "new") then
			Object = Object.new(...)
		else
			Object = Object.Bind(...)
		end
		return Object
	else
		error("Attempted to create missing object: '" .. Index .. "'")
	end
end
Library.lnew = Library.LNew

function Library.Value(Config)
	assert(Config.Value, "Missing Parameter: Config.Value")
	
end

local Holder = Objectify(Library)
return Library