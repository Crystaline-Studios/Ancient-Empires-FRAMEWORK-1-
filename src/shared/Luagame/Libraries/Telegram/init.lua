-- Created By Carrotoplia on Sun Oct 16 13:43:34 2022

----------------------------->> Services / Modules <<---------------------------------
local RunService = game:GetService("RunService")

local Get = require(game:GetService("ReplicatedStorage").Get)
local Objectify = require(Get("Objectify"))
local Remote = script.RemoteEvent
do
	-- Makes it much harder for exploiters to figure out what remote it is
	if RunService:IsServer() then
		local CloneA = Remote:Clone(); CloneA.Name = "Clone"
		local CloneB = Remote:Clone(); CloneB.Name = "Clone"
	else
		for _,Remote in pairs(script:GetChildren()) do
			if Remote:IsA("RemoteEvent") then
				Remote.Name = math.random(100000, 900000)
			end
		end
	end
end

----------------------------->> Variables <<---------------------------------

local IsClient = RunService:IsClient()

local ConnectionsToID = {}
local Connections = {}
local IDTypes = {}

----------------------------->> Object <<---------------------------------

local Telegram = {}
Telegram.Class = "TelegramLibrary"
Telegram.class = Telegram.Class



if IsClient then
	Remote.OnClientEvent:Connect(function(ID, ...)
		if ConnectionsToID[ID] then
			for _,Connection in pairs(ConnectionsToID[ID]) do
				Connection(...)
			end
		end
		
		for _,Connection in pairs(Connections) do
			Connection(ID, ...)
		end
	end)
else
	Remote.OnServerEvent:Connect(function(Player, ID, ...)
		if IDTypes[ID] then
			local Args = {...}
			for Key,Value in pairs(IDTypes[ID]) do
				if typeof(Args[Key]) ~= Value then
					Player:Kick("System Failure, You are ether exploiting or experiencing a bug This is just a kick tell the actions you did right before you got this kick in the discord or ask a friend.")
				end
			end
		end
		
		if ConnectionsToID[ID] then
			for _,Connection in pairs(ConnectionsToID[ID]) do
				Connection(Player, ...)
			end
		end

		for _,Connection in pairs(Connections) do
			Connection(Player, ID, ...)
		end
	end)
end


function Telegram:Send(ID, Location, ...)
	if IsClient then
		Remote:FireServer(ID, Location, ...)
	else
		local LocationType = typeof(Location)
		local IsSent = false
		
		if LocationType == "Instance" then
			if Location:IsA("Player") then
				IsSent = true
				Remote:FireClient(Location, ID, ...)
			else
				error("Location property is not a player instance")
			end
		end
		
		if LocationType == "table" then
			for _,Player in pairs(Location) do
				if Player:IsA("Player") then
					IsSent = true
					Remote:FireClient(Player, ID, ...)
				end
			end
		end
		
		if Location == "Clients" then 
			IsSent = true
			Remote:FireAllClients(ID, ...)
		end
		
		if not IsSent then
			error("What the hell have you inputted in this it aint a table(With player instances inside) player instance or 'Clients'")
		end
	end
end
Telegram.send = Telegram.Send




function Telegram:SetInputTypes(ID, ...)
	if IsClient then
		error("Attempted to setInputTypes on client theres no use for it on client as the client controls the client")
	end
	IDTypes[ID] = {...}
end
Telegram.setinputtypes = Telegram.SetInputTypes
Telegram.setInputTypes = Telegram.SetInputTypes





function Telegram:Connect(F)
	local Connection = {}
	Connection.Class = "TelegramConnection"
	Connection.class = Connection.Class
	
	function Connection:Disconnect()
		if table.find(Connections, F) then
			table.remove(Connections, table.find(Connections, F))
		end
	end
	Connection.disconnect = Connection.Disconnect
	
	function Connection:Reconnect()
		if not table.find(Connections, F) then
			table.insert(Connections, F)
		end
	end
	Connection.reconnect = Connection.Reconnect
	
	local Holder = Objectify:New(Connection)
	table.insert(Connections, F)
	return Connection
end
Telegram.connect = Telegram.Connect





function Telegram:ConnectToID(ID, F)
	local Connection = {}
	Connection.Class = "TelegramConnection"
	
	local CF = ConnectionsToID[ID]
	if not CF then
		ConnectionsToID[ID] = {}
		CF = ConnectionsToID[ID]
	end
	
	function Connection:Disconnect(F)
		if table.find(CF, F) then
			table.remove(CF, table.find(CF, F))
		end
	end
	function Connection:Reconnect()
		if not table.find(CF, F) then
			table.insert(CF, F)
		end
	end
	
	local Holder = Objectify(Connection)
	table.insert(CF, F)
	return Connection
end
Telegram.connecttoid = Telegram.ConnectToID
Telegram.connectToID = Telegram.ConnectToID



local Holder = Objectify(Telegram)
return Telegram