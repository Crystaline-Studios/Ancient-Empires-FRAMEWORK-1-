-- Created By Carrotoplia on Sun Oct 16 15:02:07 2022

----------------------------->> Object <<---------------------------------


local Object = {}
Object.Class = 'ObjectCreator'
Object.class = Object.Class



function Object.new()
	local Signal = {}
	
	Signal.Class = "QuickSignal"
	Signal.Connections = {}
	Signal.Once = {}
	Signal.SystemConnections = {}
	
	
	
	function Signal:Fire(...)
		local Args = ...
		task.spawn(function()
			for _,Connection in pairs(rawget(self, "Connections")) do
				task.spawn(function()
					Connection(Args)
				end)
			end
			for Pos,Connection in pairs(rawget(self, "Once")) do
				task.spawn(function()
					Connection(Args)
					table.remove(self.Once, Pos)
				end)
			end
			for Pos,Connection in pairs(rawget(self, "SystemConnections")) do
				task.spawn(function()
					Connection(Args)
					table.remove(self.Once, Pos)
				end)
			end
		end)
	end
	
	
	
	
	
	function Signal:Connect(f)
		table.insert(self.Connections, f)

		local Connection = {}
		Connection.Class = "QuickSignalConnection"
		
		function Connection:Disconnect()
			if table.find(self.Signal.Connections) then
				table.remove(self.Signal.Connections, table.find(self.Signal.Connections))
			end
		end
		
		function Connection:Reconnect()
			if not table.find(self.Signal.Connections) then
				table.insert(self.Signal.Connections, f)
			end
		end

		
		return Connection
	end
	
	
	function Signal:ConnectOnce(f)
		table.insert(self.Once, f)

		local Connection = {}
		Connection.Class = "QuickSignalConnection"

		function Connection:Disconnect()
			if table.find(self.Signal.Connections) then
				table.remove(self.Signal.Connections, table.find(self.Signal.Connections))
			end
		end

		function Connection:Reconnect()
			if not table.find(self.Signal.Connections) then
				table.insert(self.Signal.Connections, f)
			end
		end

		
		return Connection
	end
	
	
	
	
	function Signal:Wait()
		local Running = coroutine.running()
		local ReturnValue
		task.spawn(function()
			table.insert(Signal.SystemConnections, function(...)
				ReturnValue = ...
				coroutine.resume(Running)
			end)
		end)
		coroutine.yield()
		return ReturnValue
	end
	
	
	
	
	
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
	
	
	
	function Signal:DisconnectAll()
		table.clear(Signal.Connections)
		table.clear(Signal.Once)
	end
	
	
	

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
	
	
	function Signal:Unwrap()
		if rawget(Signal, "Wrapped") then
			rawget(Signal, "Wrapped"):Disconnect()
			rawset(Signal, "Wrapped", nil)
		end
	end
	

	return Signal
end
Object.New = Object.new

function Object:Quickify(RBXSignal)
	local Signal = self.new()
	Signal:Wrap(RBXSignal)
	return Signal
end

return Object