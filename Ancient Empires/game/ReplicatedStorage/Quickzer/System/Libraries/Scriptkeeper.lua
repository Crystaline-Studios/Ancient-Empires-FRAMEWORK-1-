--Created By Carrotoplia on Tue Oct 11 14:18:21 2022
-- For cleaning up shit like like the thing!

----------------------------->> Services and Modules <<---------------------------------

local Get = require(game:GetService("ReplicatedStorage").Get)
local Objectify = require(Get("Objectify"))

----------------------------->> Variables <<---------------------------------

local Bins = {}
local CleanupMethods = {
	"Disconnect", "disconnect", -- Signals
	"Destroy", "destroy", -- Instances / LuaInstances
	"Remove","remove", -- general stuff
	"Unwrap", "unwrap", -- QuickSignal
	"Clear", "clear", -- maybe scriptkeepr bins
	"Clean", "clean", -- I think its Objectstore
	"Wipe","wipe", -- possibly objectstore
	"DisconnectAll", "disconnectall", -- quicksignal
	"Unbind", "Unattach" -- lua object(attachment)
}

----------------------------->> Library <<---------------------------------

local ScriptKeeper = {}
ScriptKeeper.Class = "ScriptkeeperLibrary"
ScriptKeeper.class = ScriptKeeper.Class

function Cleanup(Object)
	local ObjectType = typeof(Object)
	if ObjectType == "table" or ObjectType == "userdata" then
		for _,Method in pairs(CleanupMethods) do
			local A,B = pcall(function()
				Object[Method]()
			end)
		end
		local SortThrough = Object
		pcall(function()
			if Object.IsFromQuick then
				SortThrough = Object.__Core
			end
		end)
		
		for Key,MicroObject in pairs(SortThrough) do
			if typeof(MicroObject) == "Instance" or typeof(MicroObject) == "table" or typeof(MicroObject) == "userdata" or typeof(MicroObject) == "thread" then
				Cleanup(MicroObject)
			else
				rawset(SortThrough, Key, nil)
			end
		end
		if getmetatable(Object) then
			Cleanup(getmetatable(Object))
		end
		Object = nil
	elseif ObjectType == "Instance" then
		Object:Destroy()
	elseif ObjectType == "thread" then
		coroutine.close(ObjectType)
	else
		warn("Attempted to clean up unknown value type")
	end
end

function ScriptKeeper:GetBin(ID)
	if Bins[ID] == nil then
		local Bin = {}
		Bin.Class = "ScriptkeeperBin"
		Bin.class = Bin.Class
		Bin.Trash = {}
		
		
		
		
		function Bin:Clear()
			Cleanup(Bin.Trash)
		end
		Bin.clear = Bin.Clear
		
		
		
		function Bin:ClearTagged(Tag)
			assert(Tag, "Missing Tag in ClearTagged")
			for Key,Trash in pairs(Bin.Trash) do
				if Trash.Tags then
					if table.find(Trash.Tags, Tag) then
						Cleanup(Trash)
						Bin[Key] = nil
					end
				end
			end
		end
		Bin.cleartagged = Bin.ClearTagged
		Bin.clearTagged = Bin.ClearTagged
		
		
		
		function Bin:Store(Value, Tags)
			local ID = nil
			if not Tags then
				Bin.Trash[#Bin.Trash + 1] = {Value = Value}
				ID = #Bin.Trash + 1
			else
				Bin.Trash[#Bin.Trash + 1] = {Tags = Tags,Value = Value}
				ID = #Bin.Trash + 1
			end
			
			local Section = {}
			Section.Class = "ScriptkeeperBinSection"
			Section.class = Section.Class
			
			function Section:Remove()
				Bin.Trash[ID] = nil
			end
			Section.remove = Section.Remove
			
			function Section:SetTags(Tags)
				Bin.Trash[ID].Tags = Tags
			end
			Section.settags = Section.SetTags
			Section.setTags = Section.SetTags
			
			function Section:Clean()
				Cleanup(Bin.Trash[ID])
				Bin.Trash[ID] = nil
			end
			Section.clean = Section.Clean
			
			local Holder = Objectify(Section)
			return Section
		end
		Bin.store = Bin.Store
		
		
		local Holder = Objectify(Bin)
		Holder:SetUnreadable("Trash")
		Bins[ID] = Bin
		return Bin
	else
		return Bins[ID]
	end
end


local Holder = Objectify(ScriptKeeper)
return ScriptKeeper