-- Created By Carrotoplia on Sat Oct 15 00:16:48 2022

----------------------------->> Modules / Services <<---------------------------------

local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local Get = require(game:GetService("ReplicatedStorage").Get)

local Object = require(Get("Object"))
local ProfileService = require(script.Parent.ProfileService)
local SConfig = require(ServerScriptService.ServerConfig)
local OSignal = require(Get("QuickSignal"))
local table = require(Get("table", "Libraries"))

----------------------------->> Tables / Variables / Misc <<---------------------------------

local Config = SConfig.Databank

local Vaults = {}
local PlayerVaults = {}
local PlayerData = {}
local PlayerFrameworkData = {}

-- PlayerData Loader/Unloader
function LoadData(Player)
	if not PlayerVaults[Player.UserId] then
		local ProfileStore = ProfileService.GetProfileStore("Playerdata:" .. Player.UserId, Config.DefaultPlayerProfile)
		PlayerVaults[Player.UserId] = ProfileStore

		local PlayerData1 = ProfileStore:LoadProfileAsync("PlayerData1")
		if PlayerData1 ~= nil then
			PlayerData1:AddUserId(Player.UserId)
			PlayerData1:Reconcile()
			PlayerData1:ListenToRelease(function()
				Player:Kick("ProfileService(datastore) Released your data report this as a bug if it happens often")
			end)
			if Player:IsDescendantOf(Players) == true then
				PlayerData[Player] = PlayerData1
			else
				-- Player left before the profile loaded:
				PlayerData1:Release()
			end
		else
			-- Multiple servers might be trying to read the profile at same time ether way they need to GO
			Player:Kick("ProfileService(datastore) Loading error if this happens often report it as a bug")
		end

		local PSystemData1 = ProfileStore:LoadProfileAsync("PlayerSystemData1", {
			Banned = false,
			BanReason = "You have been banned.",
			ModerationLogs = {},
			AnticheatLogs = {}
		})
		if PSystemData1 ~= nil then
			PSystemData1:AddUserId(Player.UserId)
			PSystemData1:Reconcile()
			PSystemData1:ListenToRelease(function()
				Player:Kick("ProfileService(datastore) Released your data report this as a bug if it happens often")
			end)
			if Player:IsDescendantOf(Players) == true then
				PlayerFrameworkData[Player] = PSystemData1
			else
				-- Player left before the profile loaded:
				PSystemData1:Release()
			end
		else
			-- Multiple servers might be trying to read the profile at same time ether way they need to GO
			Player:Kick("ProfileService(datastore) Loading error if this happens often report it as a bug")
		end
	end
end
Players.PlayerAdded:Connect(LoadData)


Players.PlayerRemoving:Connect(function(Player)
	local Profile = PlayerData[Player]
	if Profile ~= nil then
		Profile:Release()
		PlayerData[Player] = nil
	end
	
	local Profile = PlayerFrameworkData[Player]
	if Profile ~= nil then
		Profile:Release()
		PlayerFrameworkData[Player] = nil
	end
end)

----------------------------->> The Bank <<---------------------------------
local Bank, Finalize = Object "DataBankService"

function Bank:GetPlayerDataTable(Player)
	assert(Player, "Missing Parameter: Player")
	if PlayerData[Player] ~= nil then
		return PlayerData[Player].Data
	else
		return table:WaitForIndex(PlayerData, Player)
	end
end

-- WARNING DO NOT USE
-- USED INTERNALLY FOR STUFF LIKE ModerationService
function Bank:GetPlayerSystemDataTable(Player)
	assert(Player, "Missing Parameter: Player")
	if PlayerFrameworkData[Player] ~= nil then
		return PlayerFrameworkData[Player].Data
	else
		return table:WaitForIndex(PlayerFrameworkData, Player)
	end
end

Finalize()
return Bank