
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local LocalPlayerScripts = if Players.LocalPlayer then Players.LocalPlayer.PlayerScripts else nil 



local GET = require(game:GetService("ReplicatedStorage").Get)
local GoodSignal = require(GET("GoodSignal"))


local Libraries = {}
local Services = {}

local TrackedCoroutines = {}
local TrackedScriptData = {}

local ServiceAdded = GoodSignal.new()


--[=[
	@class Luagame

	The way you access everything in the framework.
	You can access services and libraries and gameproperties through this example: 

	game.Workspace
	runs getservice for the service

	game.PlaceID
	gives placeid

	game.ModerationService
]=]
local Luagame = {}
Luagame.Class = "Engine"
Luagame.ServiceAdded = ServiceAdded

local Metatable = {}

function Metatable:__index(_, Index)
	if rawget(Libraries, Index) then
		return rawget(Libraries, Index)


	elseif rawget(Services, Index) then
		local Value = rawget(Services, Index)
		if typeof(Value) == "Instance" then
			local Holder = require(Value)
			rawset(Services, Index, Holder)
			return Holder
		else
			return Value
		end


	else
		if game:GetService(Index) then
			return game:GetService(Index)
		else
			return game[Index]
		end
	end
end
setmetatable(Luagame, Metatable)

--/------- Services
for _,Service in pairs(ReplicatedStorage.Game.Services:GetDescendants()) do
	if Service:IsA("ModuleScript") then 
		if Services[Service.Name] then
			error("Overlapping service names :skull:")
		end

		task.spawn(function()
			Services[Service.Name] = require(Service)
		end)
	end
end
if RunService:IsServer() then
	for _,Service in pairs(ServerScriptService.Game.Services:GetDescendants()) do
		if Service:IsA("ModuleScript") then 
			if Services[Service.Name] then
				error("Overlapping service names :skull:")
			end
	
			task.spawn(function()
				Services[Service.Name] = require(Service)
			end)
		end
	end
else
	for _,Service in pairs(LocalPlayerScripts.Game.Services:GetDescendants()) do
		if Service:IsA("ModuleScript") then 
			if Services[Service.Name] then
				error("Overlapping service names :skull:")
			end
	
			task.spawn(function()
				Services[Service.Name] = require(Service)
			end)
		end
	end
end

--[=[
	Yields until that Luabased service is finished loading then returns it

	@param Name string -- The services name
	@return service -- The service you asked for
]=]
function Luagame:GetService(Name)
	return ServiceAdded:WaitWithCheck(function(NName)
		if NName == Name then
			return true
		end
	end)
end



--/------ Instance Creation

--[=[
	Creates LuaObjects very quickly and easily

	@param Type string -- the objects classname
	@param ... turple -- extra stuff to shove in the .new or .bind
	@return LuaObject -- An brand new luaobject.
]=]
function Luagame.Create(Type, ...)
	local Module
	for _,SChild in pairs(ReplicatedStorage.Game.LuaObjects:GetDescendants()) do
		if SChild:IsA("ModuleScript") and SChild.Name == Type then
			Module = SChild
		end
	end

	if not Module then 
		if RunService:IsServer() then
			for _,SChild in pairs(ServerScriptService.Game.LuaObjects:GetDescendants()) do
				if SChild:IsA("ModuleScript") and SChild.Name == Type then
					Module = SChild
				end
			end
		else
			for _,SChild in pairs(LocalPlayerScripts.Game.LuaObjects:GetDescendants()) do
				if SChild:IsA("ModuleScript") and SChild.Name == Type then
					Module = SChild
				end
			end
		end
	end
	assert(Module, "Object not found. (IT CANT FIND IT)")

	if Module.Bind then
		return Module.Bind(...)
	else
		return Module.New(...)
	end
end


--/-------- Script State Control
--[=[
	Unlocks the ability to yield / resume remotely 

	@param Script instance -- just use script keyword
	@param Yield bool -- True or false value determaining if it yields instantly
]=]
function Luagame:Track(Script, Yield)
	assert(typeof(Script) == "Instance" and Script:IsA("Script"), "Script isn't a SCRIPT >:(")

	local Tab = {Coroutine = coroutine.running(), Value = true}
	TrackedCoroutines[Script] = Tab
	
	if Yield then
		coroutine.yield()
	end

	return Tab
end

--[=[
	Yields the script provided.(It has to be tracked with track)

	@param Script instance -- Script that you want to yield
]=]
function Luagame:Yield(Script)
	assert(Script, "Missing Parameter: Script")
	
	if not TrackedCoroutines[Script] then
		error("Attempted to yield a non captured script.")
	else
		TrackedCoroutines[Script].Value = false
		coroutine.yield(TrackedCoroutines[Script].Coroutine)
	end
	return TrackedScriptData[Script]
end

--[=[
	Resumes the script provided.(It has to be tracked with track)

	@param Script instance -- Script that you want to resume
]=]
function Luagame:Release(Script)
	assert(Script, "Missing Parameter: Script")

	if not TrackedCoroutines[Script] then
		error("Attempted to release a non captured script.")
	else
		coroutine.resume(TrackedCoroutines[Script].Coroutine)
	end 
end

--[=[
	Yields the children of the instance provided.

	@param Folder instance -- Folder to get the children of
]=]
function Luagame:YieldFolder(Folder)
	assert(Folder, "Missing Parameter: Folder")
	for _,Child in pairs(Folder:GetChildren()) do
		if Child:IsA("Script") or Child:IsA("LocalScript") then
			local  _, _  = pcall(function()
				Luagame:Yield(Child)
			end)
		end
	end
end

--[=[
	Resumes the children of the instance provided.

	@param Folder instance -- Instance to get the children of
]=]
function Luagame:ReleaseFolder(Folder)
	assert(Folder, "Missing Parameter: Folder")
	for _,Child in pairs(Folder:GetChildren()) do
		if Child:IsA("Script") or Child:IsA("LocalScript") then
			local  _, _  = pcall(function()
				Luagame:Release(Child)
			end)
		end
	end
end

--[=[
	Yields the descendants of the instance provided.

	@param Folder instance -- Folder to get the descendants of
]=]
function Luagame:YieldFolderDeep(Folder)
	assert(Folder, "Missing Parameter: Folder")

	for _,Child in pairs(Folder:GetDescendants()) do
		if Child:IsA("Script") or Child:IsA("LocalScript") then
			local _, _ = pcall(function()
				Luagame:Yield(Child)
			end)
		end
	end
end

--[=[
	resumes the descendants of the instance provided.

	@param Folder instance -- Folder to get the descendants of
]=]
function Luagame:ReleaseFolderDeep(Folder)
	assert(Folder, "Missing Parameter: Folder")
	for _,Child in pairs(Folder:GetDescendants()) do
		if Child:IsA("Script") or Child:IsA("LocalScript") then
			local  _, _  = pcall(function()
				Luagame:Release(Child)
			end)
		end
	end
end

return Luagame