-- Created By Carrotoplia on Sat Oct 15 20:13:51 2022

----------------------------->> Services and Modules <<---------------------------------

local Players = game:GetService("Players")
local MessagingService = game:GetService("MessagingService")
local ServerScriptService = game:GetService("ServerScriptService")

local DataBank = require(script.Parent.Parent.Databank)
local SConfig = require(ServerScriptService.ServerConfig)

----------------------------->> All of the Variables! <<---------------------------------

local ServerBans = {}
Players.PlayerAdded:Connect(function(Player)
	local Data = DataBank:GetPlayerSystemDataTable(Player.UserId)

	if Data.Ban == true then
		Player:Kick(Data.BanReason)
	elseif Data.Ban and Data.Ban > os.Time() then
		Player:Kick(Data.BanReason)
	end

	if ServerBans[Player.UserId] then
		local BanData = ServerBans[Player.UserId]
		if BanData.Time > os.time() then
			Player:Kick(BanData.Time.Reason)
		end
	end
end)

----------------------------->> The Service The Best One!!! <<---------------------------------

local Service = {}

function Service:Ban(UserID, Reason, Time)
	assert(UserID, "Missing Parameter: UserID")

	local Player = Players:GetPlayerByUserId(UserID)
	local Data = DataBank:GetPlayerSystemDataTable(UserID)
	Data.Banned = if Time then os.time + Time else true
	table.insert(Data.ModerationLogs, {Type = "Ban", Time = os.time(), Reason = Reason, BanTime = Time})

	if Player then
		Player:Kick(Data.BanReason)
	end
end

function Service:ServerBan(UserID, Reason, Time)
	assert(UserID, "Missing Parameter: UserID")
	local Player = Players:GetPlayerByUserId(UserID)
	local Data = DataBank:GetPlayerSystemDataTable(UserID)

	table.insert(Data.ModerationLogs, {Type = "ServerBan", Time = os.time(), Reason = Reason, BanTime = Time})

	if Player then
		Player:Kick(Reason)
	end
	ServerBans[UserID] = {
		Time = os.time() + Time,
		Reason = Reason
	}
end

function Service:Kick(UserID, Reason)
	assert(UserID, "Missing Parameter: UserID")
	local Player = Players:GetPlayerByUserId(UserID)
	local Data = DataBank:GetPlayerSystemDataTable(UserID)

	table.insert(Data.ModerationLogs, {Type = "Kick", Time = os.time(), Reason = Reason})

	if Player then
		Player:Kick(Reason)
	end
end

function Service:Warn(UserID, Reason)
	assert(UserID, "Missing Parameter: UserID")
	warn("Warn is not implemented UIService Implementation is Required")
end

function Service:IsBanned(UserID)
	assert(UserID, "Missing Parameter: UserID")
	local Data = DataBank:GetPlayerSystemDataTable(UserID)
	return Data.Banned
end

function Service:GetBanReason(UserID)
	assert(UserID, "Missing Parameter: UserID")
	local Data = DataBank:GetPlayerSystemDataTable(UserID)
	return Data.BanReason
end

function Service:IsServerBanned(UserID)
	assert(UserID, "Missing Parameter: UserID")
	if ServerBans[UserID] then
		return true
	else
		return false 
	end
end

function Service:GetServerBanReason(UserID)
	assert(UserID, "Missing Parameter: UserID")
	if ServerBans[UserID] then
		return ServerBans[UserID].Reason 
	end
end

function Service:GetModerationHistory(UserID)
	assert(UserID, "Missing Parameter: UserID")
	local Data = DataBank:GetPlayerSystemDataTable(UserID)
	return Data.ModerationLogs
end

return Service