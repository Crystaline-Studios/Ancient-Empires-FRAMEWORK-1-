--Created By Carrotoplia on Tue Oct 11 16:17:50 2022
-- For quickzer framework.

----------------------------->> Modules and Services <<---------------------------------

local Get = require(game:GetService("ReplicatedStorage").Get)
local Objectify = require(Get("Objectify"))
local OSignal = require(Get("QuickSignal"))

----------------------------->> ObjectS and Asset <<---------------------------------

local Signal = OSignal.new()
local Services = {}

----------------------------->> Object <<---------------------------------
local Creator = {}
Creator.Class = "LuaServiceHolder"
Creator.class = Creator.Class

local Meta = {}
Meta.__index = function(Key, Index)
	print(Index)
	print(Key)
	if rawget(Services, Index) == nil then
		if game:GetService(Index) then
			return game:GetService(Index)
		else
			return game[Index]
		end
	else
		local Value =  rawget(Services, Index)
		if typeof(Value) == "Instance" then
			local Holder = require(Value)
			rawset(Services, Index, Holder)
			return Holder
		else
			return Value
		end
	end
end
setmetatable(Creator, Meta)





function Creator:WaitForService(Name)
	Signal:WaitWithCheck(function(ServiceName)
		if Name == ServiceName then 
			return true
		end
	end)
end
Creator.waitforservice = Creator.WaitForService
Creator.waitForService = Creator.WaitForService



function Creator:CreateService(Name, Value)
	Services[Name] = Value
	Signal:Fire(Name)
end
Creator.createservice = Creator.CreateService
Creator.createService = Creator.CreateService




function Creator:CreateFromFolder(Folder)
	for _,Service in pairs(Folder:GetChildren()) do
		if Service:IsA("ModuleScript") then
			
			if Service:FindFirstChild("LoadInstantly") and Service.LoadInstantly.Value then
				task.spawn(function()
					Services[Service.Name] = require(Service)
					Signal:Fire(Service.Name)
				end)
			else
				Services[Service.Name] = Service
				Signal:Fire(Service.Name)
			end
			
		elseif Service:IsA("Folder") then
			for _,ServiceA in pairs(Service:GetChildren()) do
				if ServiceA:IsA("ModuleScript") then
					if ServiceA:FindFirstChild("LoadInstantly") and ServiceA.LoadInstantly.Value then
						task.spawn(function()
							Services[ServiceA.Name] = require(ServiceA)
							Signal:Fire(ServiceA.Name)
						end)
					else
						Services[ServiceA.Name] = ServiceA
					end
				end
			end
		end
	end
end
Creator.createfromfolder = Creator.CreateFromFolder
Creator.createFromFolder = Creator.CreateFromFolder




local Holder = Objectify(Creator)
return Creator
