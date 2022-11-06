-- Created By Carrotoplia on Tue Oct 11 13:48:00 2022
-- For easy creation of debounces

----------------------------->> Object <<---------------------------------


local Object = {}
Object.Class = "ObjectCreator"
Object.class = Object.Class





function Object.new()
	local Debounce = {}
	local DebounceCallbacks = {}
		
	Debounce.Class = "Debounce"
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
	
	
	return Debounce
end
Object.New = Object.new


return Object