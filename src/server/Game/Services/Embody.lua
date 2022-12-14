local Players = game:GetService("Players")
	

local Get = require(game:GetService("ReplicatedStorage").Get)
local SConfig = require(Get("SConfig"))
local table = require(Get("table"))
local ModerationService = require(script.Parent.ModerationService)


local Config = SConfig.Embody


local Service = {}
Service.Class = "EmbodyService"


function Service:Respawn(Player)
	assert(Player, "Missing Parameter: Player")
	Player:LoadCharacter()

	local Character = Player.Character or Player.CharacterAdded:Wait()
	task.spawn(function()
		local Root = Character:WaitForChild("HumanoidRootPart")
		if Config.RespawnMethod == "Random" then
			ModerationService:TP(Player)
			Root.CFrame = CFrame.new(table.random(Config.RespawnLocations))

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

return Service