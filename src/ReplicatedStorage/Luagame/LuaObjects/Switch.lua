----------------------------->> Assets <<---------------------------------

local Get = require(game:GetService("ReplicatedStorage").Get)
local Object = require(Get("Object"))

----------------------------->>  <<---------------------------------
local Object, Finalize = Object "Switch Creator"
Object.Class = "ObjectCreator"
Object.class = Object.Class

function Object.new()

	local Switch, Finalize = Object "Switch"
	Switch.Class = "Switch"
	Switch.Toggled = false

	local WaitFunctions = {}

	function Switch:Wait()
		if not Switch.Toggled then
			local Running = coroutine.running()
			table.insert(WaitFunctions, function()
				coroutine.resume(Running)
			end)
		end
	end
	Switch.wait = Switch.Wait
	
	function Switch:Toggle()
		Switch.Toggled = not Switch.Toggled
		if Switch.Toggled then
			for Pos,F in pairs(WaitFunctions) do
				F()
				WaitFunctions[Pos] = nil
			end
		end
	end
	Switch.toggle = Switch.Toggle

	
	Finalize()
	return Switch
end
Object.New = Object.new

Finalize()
return Object