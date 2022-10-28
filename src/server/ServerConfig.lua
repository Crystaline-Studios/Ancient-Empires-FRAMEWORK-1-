-- Created By Carrotoplia on Fri Oct 14 00:27:37 2022
-- For easy config creation
local Config = {}

Config.ModerationService = {
	DistanceThreshold = 5, -- Extra Distance threshold for Laggy players. (walkspeed is equal to studs per second from player)
	NoclipThreshold = 0.5, -- Distance threshold For laggy players.
	AllowVoidStanding = false, -- If the player can be above void at all it.

	DoMaxActionDetection = true, -- Enables player being attacked by anticheat when it triggers it too often
	ActionsPerMinuteCap = 5 -- How many times can the player trigger the anticheat before being kicked per minute.
}

Config.Databank = {
	DefaultPlayerProfile = {}
}

Config.Embody = {
	---------------- SPAWNING STUFF -----------------------
	RespawnLocations = {
		Vector3.new(-65, 0.5, -58),
		Vector3.new(-12, 0.5, 13)
	}, -- put vector3's here

	-- Options: "Random" for random spot
	-- "Far" for farthest from players
	-- "Team" For spawning people near there teams if they aint in one random
	-- "Friends" to spawn players near there roblox friends if no friends are there it tries there team then random.
	RespawnMethod = "Random",
	AutoRespawn = true,
	SpawnDelay = 5,

	---------------------- LIMB DESTRUCTION AUTORESPAWN -------------------------
	-- If a limb is not allowed to be destroyed it will kill the players character opon destruction
	AllowRootDestroying = false,
	AllowTorsoDestroying = false,
	AllowHeadDestroying = false,
	AllowLimbDestruction = false
}

return Config