local GET = require(game:GetService('ReplicatedStorage').Get)
local table = require(GET("Table"))


local Object = {}


--[=[
	@class Debounce

	Quickly make debounces!
]=]
function Object.new()
	local DebounceTime = os.time()
	local WaitTime = 0

	--[=[
		@within Debounce
		Used to quickly make debounces

		@param Time number -- Number of seconds to wait before it can be used again.
	]=]
	local function MyFunction(Time)
		if os.time() > DebounceTime + WaitTime then
			DebounceTime = os.time() 
			WaitTime = Time
			return true
		end
	end

	return MyFunction
end

return Object