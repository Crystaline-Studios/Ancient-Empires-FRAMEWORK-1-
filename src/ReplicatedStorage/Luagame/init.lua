-- Created By Carrotoplia on Tue Oct 11 16:18:47 2022
-- Luagamezer made for Luagame easy scripting


----------------------------->> Services and modules <<---------------------------------

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local LocalPlayerScripts; if LocalPlayer then LocalPlayerScripts = LocalPlayer.PlayerScripts end

local Get = require(game:GetService("ReplicatedStorage").Get)
local Object = require(Get("Object"))
local QuickSignal = require(Get("QuickSignal"))

----------------------------->> Variables <<---------------------------------

local IsClient = RunService:IsClient()

local Libraries = {}
local Services = {}

local TrackedCoroutines = {}
local TrackedScriptData = {}

local ServiceAdded = QuickSignal.new()

----------------------------->> Object <<---------------------------------


local Luagame = {}
Luagame.Class = "Engine"
Luagame.ServiceAdded = ServiceAdded

setmetatable(Luagame, {
    __index = function(Index)
		if rawget(Libraries, Index) then
			return rawget(Libraries, Index)
        elseif rawget(Services, Index) == nil then
            if game:GetService(Index) then
                return game:GetService(Index)
            else
                return game[Index]
            end
        else
            local Value = rawget(Services, Index)
            if typeof(Value) == "Instance" then
                local Holder = require(Value)
                rawset(Services, Index, Holder)
                return Holder
            else
                return Value
            end
        end
    end
})


------------- Services Loader
-- Loads stuff in this order
-- system replicated services
-- system server/client services then your services
-- finally your replicated services
-- it will override the oldest created services.

function CreateFromFolder(Folder)
    for _,Service in pairs(Folder:GetChildren()) do
		if Service:IsA("ModuleScript") then
			
			if Service:FindFirstChild("LoadInstantly") and Service.LoadInstantly.Value then
				task.spawn(function()
					Services[Service.Name] = require(Service)
					ServiceAdded:Fire(Service.Name)
				end)
			else
				Services[Service.Name] = Service
				ServiceAdded:Fire(Service.Name)
			end
			
		elseif Service:IsA("Folder") then
			for _,ServiceA in pairs(Service:GetChildren()) do
				if ServiceA:IsA("ModuleScript") then
					if ServiceA:FindFirstChild("LoadInstantly") and ServiceA.LoadInstantly.Value then
						task.spawn(function()
							Services[ServiceA.Name] = require(ServiceA)
							ServiceAdded:Fire(ServiceA.Name)
						end)
					else
						Services[ServiceA.Name] = ServiceA
					end
				end
			end
		end
	end
end

CreateFromFolder(script.Services)
if IsClient then
	-- Client
	CreateFromFolder(LocalPlayerScripts["Clientside System"].Services)
	CreateFromFolder(LocalPlayerScripts.Game.Services)
else
	-- Server
	CreateFromFolder(ServerScriptService["Serverside System"].Services)
	CreateFromFolder(ServerScriptService.Game.Services)
end
CreateFromFolder(ReplicatedStorage.Game.Services)


function Luagame:GetService(Name)
    return ServiceAdded:WaitWithCheck(function(NName)
        if NName == Name then
            return true
        end
    end)
end



---------- Libraries
for _,Library in pairs(script.Libraries:GetChildren()) do
	Libraries[Library.Name] = require(Library)
end
if IsClient then
	for _,Library in pairs(LocalPlayerScripts["Clientside System"].Libraries:GetChildren()) do
		Libraries[Library.Name] = require(Library)
	end
else
	for _,Library in pairs(ServerScriptService["Serverside System"].Libraries:GetChildren()) do
		Libraries[Library.Name] = require(Library)
	end
end


function Luagame:GetLibraries()
	return Libraries
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