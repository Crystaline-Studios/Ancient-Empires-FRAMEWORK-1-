-- BY CARROTOPLIA

----------------------------->> Modules and Services <<---------------------------------

local Get = require(game:GetService("ReplicatedStorage").Get)
local Objectify = require(Get("Objectify"))
local QuickSignal = require(Get("QuickSignal"))
local table = require(Get("table"))

----------------------------->> Object <<---------------------------------

local Object = {}

function Object.new(StartValue, LockedType)
    assert(StartValue, "Missing Property: StartValue")

    local VHolder = {}
    VHolder.Class = "StatHolder"
    VHolder.Value = StartValue
    VHolder.Changed = table:GetChangedEvent()

    function VHolder:Set(NValue)
        if LockedType and typeof(NValue) == typeof(VHolder.Value) or not LockedType then
           VHolder.Value = NValue
        end
    end
    VHolder.set = VHolder.Set

    function VHolder:Get()
        return VHolder.Value
    end
    VHolder.get = VHolder.Get

    local Holder = Objectify(VHolder)
    Holder:SetChangable("Value")
    return VHolder
end
Object.New = Object.new

return Object