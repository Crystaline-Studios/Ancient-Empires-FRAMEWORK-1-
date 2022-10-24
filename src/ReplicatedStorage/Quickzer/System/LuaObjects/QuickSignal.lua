-- Created By Carrotoplia on Sun Oct 16 15:02:07 2022

----------------------------->> Services and Modules <<---------------------------------

local Get = require(game:GetService("ReplicatedStorage").Get)
local Objectify = require(Get("Objectify"))

----------------------------->> Object <<---------------------------------


local Object = {}
Object.Class = 'ObjectCreator'
Object.class = Object.Class



function Object.new()
	local Signal = {}
	
	Signal.Class = "QuickSignal"
	Signal.class = Signal.Class
	Signal.Connections = {}
	Signal.Once = {}
	
	
	
	
	
	function Signal:Fire(...)
		local Args = ...
		task.spawn(function()
			for _,Connection in pairs(self.Connections) do
				task.spawn(function()
					Connection(Args)
				end)
			end
			for Pos,Connection in pairs(self.Once) do
				task.spawn(function()
					Connection(Args)
					table.remove(self.Once, Pos)
				end)
			end
		end)
	end
	Signal.fire = Signal.Fire
	
	
	
	
	
	function Signal:Connect(f)
		table.insert(self.Connections, f)
		local Connection = {}
		Connection.Class = "QuickSignalConnection"
		Connection.class = Connection.Class
		
		function Connection:Disconnect()
			if table.find(self.Signal.Connections) then
				table.remove(self.Signal.Connections, table.find(self.Signal.Connections))
			end
		end
		Connection.disconnect = Connection.Disconnect
		
		function Connection:Reconnect()
			if not table.find(self.Signal.Connections) then
				table.insert(self.Signal.Connections, f)
			end
		end
		Connection.reconnect = Connection.Reconnect
		
		local Holder = Objectify(Connection)
		return Connection
	end
	Signal.connect = Signal.Connect
	
	
	function Signal:ConnectOnce(f)
		table.insert(self.Once, f)
		local Connection = {}
		Connection.Class = "QuickSignalConnection"
		Connection.class = Connection.Class

		function Connection:Disconnect()
			if table.find(self.Signal.Connections) then
				table.remove(self.Signal.Connections, table.find(self.Signal.Connections))
			end
		end
		Connection.disconnect = Connection.Disconnect

		function Connection:Reconnect()
			if not table.find(self.Signal.Connections) then
				table.insert(self.Signal.Connections, f)
			end
		end
		Connection.reconnect = Connection.Reconnect
		
		local Holder = Objectify(Connection)
		return Connection
	end
	Signal.connectonce = Signal.ConnectOnce
	Signal.connectOnce = Signal.ConnectOnce
	
	
	
	
	
	function Signal:Wait()
		local Running = coroutine.running()
		local ReturnValue
		task.spawn(function()
			Signal:Connect(function(...)
				ReturnValue = ...
				coroutine.resume(Running)
			end)
		end)
		coroutine.yield()
		return ReturnValue
	end
	Signal.wait = Signal.Wait
	
	
	
	
	
	
	function Signal:WaitWithCheck(f)
		local Running = coroutine.running()
		local ReturnValue
		task.spawn(function()
			Signal:Connect(function(...)
				if f(...) then
					ReturnValue = ...
					coroutine.resume(Running)
				end
			end)
		end)
		coroutine.yield()
		return ReturnValue
	end
	Signal.waitWithCheck = Signal.WaitWithCheck
	Signal.waitwithcheck = Signal.WaitWithCheck
	
	
	
	
	function Signal:DisconnectAll()
		table.clear(Signal.Connections)
		table.clone(Signal.Once)
	end
	Signal.disconnectall = Signal.DisconnectAll
	Signal.disconnectAll = Signal.DisconnectAll
	
	
	

	function Signal:Wrap(RBXSignalT)
		local Signals = if type(RBXSignalT) ~= "table" then {RBXSignalT} else RBXSignalT
		local Connections = {}
		for _,Signal in pairs(Signals) do 
			local Connection = Signal:Connect(function(...)
				self:Fire(...)
			end)
			table.insert(Connections, Connection)
		end
		
	end
	Signal.wrap = Signal.Wrap
	
	
	function Signal:Unwrap()
		if rawget(Signal, "Wrapped") then
			rawget(Signal, "Wrapped"):Disconnect()
			rawset(Signal, "Wrapped", nil)
		end
	end
	Signal.unwrap = Signal.Unwrap
	
	
	
	
	local Holder = Objectify(Signal)
	Holder:SetHidden("Connections")
	Holder:SetHidden("Once")
	return Signal
end
Object.New = Object.new

function Object:Quickify(RBXSignal)
	local Signal = self.new()
	Signal:Wrap(RBXSignal)
	return Signal
end

local Holder = Objectify(Object)
return Object