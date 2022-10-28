--Created By Carrotoplia on Fri Oct 14 00:26:39 2022
-- For easier spawning experience.

----------------------------->> Services and Modules <<---------------------------------

local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local Get = require(game:GetService("ReplicatedStorage").Get)
local Objectify = require(Get("Objectify"))
local SConfig = require(ServerScriptService.ServerConfig)
local table = require(Get("table"))
local ModerationService = require(script.Parent.ModerationService)

----------------------------->> Variables and crap <<---------------------------------

local Config = SConfig.Embody

----------------------------->> Service <<---------------------------------

local Service = {}
Service.Class = "EmbodyService"


function Service:Respawn(Player)
	assert(Player, "Missing Parameter: Player")
	Player:LoadCharacter()
	local Character = Player.Character or Player.CharacterAdded:Wait()
	task.spawn(function()
		local Root = Character:WaitForChild("HumanoidRootPart")
		if Config.RespawnMethod == "Random" then
			ModerationService:SafeMoveTo(Player, table.random(Config.RespawnLocations))
			
			
		elseif Config.RespawnMethod == "Far" then
			local Location
			local Distance
			for _,SpawnL in pairs(Config.RespawnLocations) do
				local PDistance
				for _,Player in pairs(Players:GetPlayers()) do
					if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
						if not PDistance or (SpawnL - Player.Character.HumanoidRootPart.Position).Magnitude < PDistance then
							PDistance = (SpawnL - Player.Character.HumanoidRootPart.Position).Magnitude
						end
					end
				end
				
				if not Distance or PDistance < Distance then
					Distance = PDistance
					Location = SpawnL
				end
			end
			ModerationService:SafeMoveTo(Player, Location)
			
			
		elseif Config.RespawnMethod == "Team" then
			if Player.Team ~= nil then
				local FinalLocation 
				local FinalLocationTeamDistance
				for _,Location in pairs(Config.RespawnLocations) do
					local TotalTeamDistance = 0
					for _,NPlayer in pairs(Players:GetPlayers()) do
						if NPlayer.Character and NPlayer.Character:FindFirstChild("HumanoidRootPart") then
							if NPlayer.Team and NPlayer.Team == Player.Team then
								TotalTeamDistance += (Location - NPlayer.Character.HumanoidRootPart.Position).Magnitude
							end
						end
					end
					if not FinalLocationTeamDistance or FinalLocationTeamDistance > TotalTeamDistance then
						FinalLocationTeamDistance = TotalTeamDistance
						FinalLocation = Location
					end
				end
				
				if FinalLocationTeamDistance == 0 then
					ModerationService:SafeMoveTo(Player, table.random(Config.RespawnLocations))
				else
					ModerationService:SafeMoveTo(Player, FinalLocation)
				end
			else
				ModerationService:SafeMoveTo(Player, table.random(Config.RespawnLocations))
			end
			
			
			
		elseif Config.RespawnMethod == "Friends" then
			if Player.Team ~= nil then
				local FinalLocation 
				local FinalLocationFriendDistance
				for _,Location in pairs(Config.RespawnLocations) do
					local TotalFriendDistance = 0
					for _,NPlayer in pairs(Players:GetPlayers()) do
						if NPlayer.Character and NPlayer.Character:FindFirstChild("HumanoidRootPart") then
							if NPlayer:IsFriendsWith(Player.UserId) then
								TotalFriendDistance += (Location - NPlayer.Character.HumanoidRootPart.Position).Magnitude
							end
						end
					end
					if not FinalLocationFriendDistance or FinalLocationFriendDistance > TotalFriendDistance then
						FinalLocationFriendDistance = TotalFriendDistance
						FinalLocation = Location
					end
				end

				if FinalLocationFriendDistance == 0 then
					ModerationService:SafeMoveTo(Player, table.random(Config.RespawnLocations))
				else
					ModerationService:SafeMoveTo(Player, FinalLocation)
				end
			else
				ModerationService:SafeMoveTo(Player, table.random(Config.RespawnLocations))
			end
			
		else
			error("Unknown RespawnMethod read the config in serverscriptservice.")
		end
	end)	
end
Service.respawn = Service.Respawn

Players.PlayerAdded:Connect(function(Player)
	Player.CharacterAdded:Connect(function(Character)
		Character.ChildRemoved:Connect(function(Child)
			if Child.Name == "HumanoidRootPart" and not Config.AllowRootDestroying 
				or Child.Name == "UpperTorso" and not Config.AllowTorsoDestroying 
				or Child.Name == "LowerTorso" and not Config.AllowTorsoDestroying
				or Child.Name == "Head" and not Config.AllowHeadDestroying
				or Child.Name ~= "Head" and Child.Name ~= "HumanoidRootPart" and Child.Name ~= "LowerTorso"
				and Child.Name ~= "UpperTorso" and Child:IsA("BasePart") and not Config.AllowLimbDestruction
			then
				if Character:FindFirstChild("Humanoid") then
					Character.Humanoid.Health = 0
				end
			end
		end)


		-- Auto Respawn
		Character:WaitForChild("Humanoid").Died:Connect(function()
			if Config.AutoRespawn then
				task.wait(Config.SpawnDelay)
				if Config.AutoRespawn then
					Service:Respawn(Player)
				end
			end
		end)
	end)
	
	if Config.AutoRespawn then
		Service:Respawn(Player)
	end
end)

local Holder = Objectify(Service)
return Service