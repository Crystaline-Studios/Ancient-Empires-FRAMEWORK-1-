-- Created By Carrotoplia on Sat Oct 15 20:13:51 2022

----------------------------->> Services and Modules <<---------------------------------

local Players = game:GetService("Players")
local MessagingService = game:GetService("MessagingService")
local ServerScriptService = game:GetService("ServerScriptService")

local DataBank = require(script.Parent.Parent.Databank)
local SConfig = require(ServerScriptService.ServerConfig)

----------------------------->> All of the Variables! <<---------------------------------

local ServerBans = {}

----------------------------->> The Service The Best One!!! <<---------------------------------

local Service = {}

function Service:Ban(UserID, Reason, Time)
	assert(UserID, "Missing Parameter: UserID")

	local Player = Players:GetPlayerByUserId(UserID)
	local Data = DataBank:GetPlayerSystemDataTable(UserID)
	if Time then
		Data.Banned = os.time + Time
	else
		Data.Banned = true
	end
	if Reason then
		Data.BanReason = Reason
	end
	if Player then
		table.insert(Data.ModerationLogs, {
			Time = Time

		})
		Player:Kick(Data.BanReason)
	end
end

function Service:ServerBan(UserID, Reason, Time)
	assert(UserID, "Missing Parameter: UserID")
	local Player = Players:GetPlayerByUserId(UserID)
	if Player then
		Player:Kick()
	end
	ServerBans[UserID] = {
		Time = Time,
		Reason = Reason
	}
end

function Service:Kick(UserID, Reason, Warning)
	assert(UserID, "Missing Parameter: UserID")
end

function Service:Warn(UserID, Reason, Warning)
	assert(UserID, "Missing Parameter: UserID")
end

function Service:IsBanned(UserID)
	assert(UserID, "Missing Parameter: UserID")
end

function Service:GetBanReason(UserID)
	assert(UserID, "Missing Parameter: UserID")
end

function Service:IsServerBanned(UserID)
	assert(UserID, "Missing Parameter: UserID")
end

function Service:GetServerBanReason(UserID)
	assert(UserID, "Missing Parameter: UserID")
end

function Service:GetModerationHistory(UserID)
	assert(UserID, "Missing Parameter: UserID")
end

return Service