----------------------------->> Assets <<---------------------------------

local Get = require(game:GetService("ReplicatedStorage").Get)
local Objectify = require(Get("Objectify"))
local OSignal = require(Get("QuickSignal"))

----------------------------->>  <<---------------------------------
local Object = {}
Object.Class = "ObjectCreator"
Object.class = Object.Class

function Object.new()
	local Switch = {}
	Switch.Class = "Switch"
	Switch.class = Switch.Class
	local Signal = OSignal.new()

	Switch.Toggled = false
	function Switch:Wait()
		if not Switch.Toggled then
			Signal:Wait()
		end
	end
	Switch.wait = Switch.Wait
	
	function Switch:Toggle()
		Switch.Toggled = not Switch.Toggled
		Signal:Fire()
	end
	Switch.toggle = Switch.Toggle
	
	local Holder = Objectify(Switch)
	return Switch
end
Object.New = Object.new

local Holder = Objectify(Object)
return Object