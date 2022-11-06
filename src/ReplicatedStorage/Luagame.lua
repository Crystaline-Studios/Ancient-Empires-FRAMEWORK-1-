----------------------------->> Services and modules <<---------------------------------

local ReplicatedStorage      = game:GetService("ReplicatedStorage")
local ServerScriptService    = game:GetService("ServerScriptService")
local Players 				 = game:GetService("Players")
local LocalPlayerScripts     = if Players.LocalPlayer then Players.LocalPlayer.PlayerScripts else nil 



local Get = require(game:GetService("ReplicatedStorage").Get)
local QuickSignal = require(Get("QuickSignal"))

----------------------------->> Variables <<---------------------------------

local Libraries = {}
local Services = {}

local TrackedCoroutines = {}
local TrackedScriptData = {}

local ServiceAdded = QuickSignal.new()

----------------------------->> Object <<---------------------------------


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

--------- Services
for _,Service in pairs(ReplicatedStorage.Game.Services) do
	if Services[Service.Name] then
		error("Overlapping service names :skull:")
	end

	task.spawn(function()
		Services[Service.Name] = require(Service)
	end)
end
if ServerScriptService then
	for _,Service in pairs(ServerScriptService.Game.Services) do
		if Services[Service.Name] then
			error("Overlapping service names :skull:")
		end
		
		task.spawn(function()
			Services[Service.Name] = require(Service)
		end)
	end
else
	for _,Service in pairs(LocalPlayerScripts.Game.Services) do
		if Services[Service.Name] then
			error("Overlapping service names :skull:")
		end
		
		task.spawn(function()
			Services[Service.Name] = require(Service)
		end)
	end
end

function Luagame:GetService(Name)
    return ServiceAdded:WaitWithCheck(function(NName)
        if NName == Name then
            return true
        end
    end)
end



-------- Instance Creation


function Luagame.Create(Type, ...)
	local Module
	for _,SChild in pairs(ReplicatedStorage.Game.LuaObjects:GetDescendants()) do
		if SChild:IsA("ModuleScript") and SChild.Name == Type then
			Module = SChild
		end
	end

	if not Module then 
		if ServerScriptService then
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


---------- Script State Control

function Luagame:Track(Script, Yield)
	local Tab = {Coroutine = coroutine.running(), Value = true}
	TrackedCoroutines[Script] = Tab
	
	if Yield then
		coroutine.yield()
	end

	return Tab
end

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

function Luagame:Release(Script, ...)
	assert(Script, "Missing Parameter: Script")

	if not TrackedCoroutines[Script] then
		error("Attempted to release a non captured script.")
	else
		TrackedCoroutines[Script].Value = true
		TrackedScriptData[Script] = ...
		coroutine.resume(TrackedCoroutines[Script].Coroutine)
	end 
end

function Luagame:YieldFolder(Folder)
	assert(Folder, "Missing Parameter: Folder")
	for _,Child in pairs(Folder:GetChildren()) do
		if Child:IsA("Script") or Child:IsA("LocalScript") then
			Luagame:Yield(Child)
		end
	end
end

function Luagame:ReleaseFolder(Folder, ...)
	assert(Folder, "Missing Parameter: Folder")
	for _,Child in pairs(Folder:GetChildren()) do
		if Child:IsA("Script") or Child:IsA("LocalScript") then
			Luagame:Release(Child, ...)
		end
	end
end
function Luagame:YieldFolderDeep(Folder)
	assert(Folder, "Missing Parameter: Folder")
	for _,Child in pairs(Folder:GetDescendants()) do
		if Child:IsA("Script") or Child:IsA("LocalScript") then
			Luagame:Yield(Child)
		end
	end
end
function Luagame:ReleaseFolderDeep(Folder)
	assert(Folder, "Missing Parameter: Folder")
	for _,Child in pairs(Folder:GetDescendants()) do
		if Child:IsA("Script") or Child:IsA("LocalScript") then
			Luagame:Release(Child)
		end
	end
end

return Luagame