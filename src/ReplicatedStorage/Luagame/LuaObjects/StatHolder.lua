-- BY CARROTOPLIA

----------------------------->> Modules and Services <<---------------------------------

local Get = require(game:GetService("ReplicatedStorage").Get)
local Object = require(Get("Object"))
local QuickSignal = require(Get("QuickSignal"))
local table = require(Get("table"))

----------------------------->> Object <<---------------------------------

local Object = {}

function Object.new(StartValue, LockedType)
    assert(StartValue, "Missing Property: StartValue")

    local VHolder, Finalize = Object "Value Holder"
    VHolder.Class = "StatHolder"
    VHolder.Value = StartValue
    VHolder.Changed = table:GetChangedEvent(VHolder)

    VHolder:SetChangable("Value", true)
    VHolder:SetDatatype("Value", LockedType or if type(StartValue) == "table" then 
        StartValue.__type or typeof(StartValue) 
    else 
        typeof(StartValue))

    Finalize()
    return VHolder
end
Object.New = Object.new

return Object