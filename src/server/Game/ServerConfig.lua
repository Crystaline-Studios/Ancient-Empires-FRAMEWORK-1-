local Config = {}

Config.ModerationService = {

	--------- Basic Exploits
	MagnitudeCheck = true, -- Should it track the players magnitude and see if it goes over a threshold (walkspeed + threshold)
	MagnitudeThreshold = 2, -- The threshold for magnitude checking

	NoclipCheck = true, -- Should it track if the player travels through parts that they should not be able to

	FlightCheck = true, -- Should it check if the player is flying
	FlightThreshold = 2, -- The threshold for flying falling speed

	------- Non Movement Explois
	GodmodeCheck = true, -- Should it try preventing godmode? (Triggered by humanoid of player being destroyed)
	AllowRootDestruction = false, -- Should it prevent deletion of rootpart

	ProximityPromptDistanceCheck = true, -- Should it track if a exploiter triggers a proximity prompt from a far distance
	ProximityPromptDistanceThreshold = 2, -- The threshold for proximity prompt triggering from a distance above the normal

	ProximityPromptInstantFireCheck = true, -- Should it track if a proximity prompt is triggered instantly
	ProximityPromptInstantFireThreshold = 0.5, -- The threshold for proximity prompt instant triggering

	------ Player Anticheat Settings
	Whitelisted = {
		-- Input any usernames of users you want to make the anticheat not apply to.
	},

	Blacklisted = {
		-- Input any usernames of users you want to make UNABLE to play.
	},
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
	SpawnDelay = 5
}

return Config