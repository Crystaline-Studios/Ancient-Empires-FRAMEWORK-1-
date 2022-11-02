-- Created By Carrotoplia on Tue Oct 11 13:48:00 2022
-- For easy creation of debounces

----------------------------->> Modules and Services <<---------------------------------

local Get = require(game:GetService("ReplicatedStorage").Get)
local Object = require(Get("Object"))

----------------------------->> Object <<---------------------------------


local Object, Finalize = Object "Debounce Creator"
Object.Class = "ObjectCreator"
Object.class = Object.Class





function Object.new()
	local Debounce, Finalize = Object "Debounce"
	local DebounceCallbacks = {}
		
	Debounce.Class = "Debounce"
	Debounce.class = Debounce.Class
	Debounce.OnCooldown = false
	
	function Debounce:Wait()
		if Debounce.OnCooldown then
			local Running = coroutine.running()
			table.insert(DebounceCallbacks, function()
				coroutine.resume(Running)
			end)

			coroutine.yield()
		end
	end
	Debounce.wait = Debounce.Wait
	
	
	
	
	function Debounce:Bounce(Time)
		if Time then
			if typeof(Time) == "number" then
				if Debounce.OnCooldown == false then
					task.spawn(function()
						Debounce.OnCooldown = true
						task.wait(Time)
						Debounce.OnCooldown = false
						for Pos, F in pairs(DebounceCallbacks) do
							F()
							DebounceCallbacks[Pos] = nil
						end
					end)
				else
					warn("Attempted to debounce while its on Debounce if there is a use case of this lmk")
				end
			else
				error("Time is not a number time is a " .. typeof(Time))
			end
		else
			error("Time is missing")
		end
	end
	Debounce.bounce = Debounce.Bounce
	
	
	
	
	
	Finalize()
	return Debounce
end
Object.New = Object.new



Finalize()
return Object