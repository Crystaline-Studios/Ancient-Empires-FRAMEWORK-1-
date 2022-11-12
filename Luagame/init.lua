local GoodSignal = require(script.Util.GoodSignal)

local Luagame = {}
Luagame.ServiceAdded = GoodSignal.new()
Luagame.LibraryAdded = GoodSignal.new()

local Services = {}
local Libraries = {}
local World = {}

function Luagame:GetService(Name, NoTimeout)
    assert(Name, "Missing Parameter: Name")
    assert(type(Name) == "string", "Incorrect Datatype for name string expected.")

    if not Services[Name] then
        local Running = coroutine.running()

        local Connection
        Connection = Luagame.ServiceAdded:Connect(function(ServiceName)
            if ServiceName == Name then
                Connection:Disconnect()
                Connection = nil
                coroutine.resume(Running)
            end
        end)
        if not NoTimeout then
            task.delay(10, function()
                if Connection then
                    warn("Timed out loading service. (ServiceName: " .. Name .. ") Put true as an second argument in this function to disable timing out.")
                    Connection:Disconnect()
                    coroutine.resume(Running)
                end
            end)
        end
        coroutine.yield()
    end

    return Services[Name]
end

function Luagame.AddService(Name, Service)
    assert(Name, "Missing Parameter: Name")
    assert(type(Name) == "string", "Incorrect Datatype for Name, String expected")
    assert(Service, "Missing Parameter: Service")
    assert(type(Service) == "table", "Incorrect Datatype for Service, Table expected")
    assert(Service.Class, "Missing Property: Service.Class")

    local Metatable = {}
    local OldMeta = getmetatable(Service)
    if OldMeta then
        Metatable.NewIndex = OldMeta.__newindex
    end
    
    function Metatable:__newindex(Table, Key, Value)
        local OldValue = rawget(Table, Key)
        if typeof(OldValue) ~= typeof(Value) and OldValue ~= nil and Value ~= nil then
            error("Attempted to set property '" .. Key .. "' to an different datatype on: '" .. Table.Class .. "'")
        else
            if self.NewIndex then
                self.NewIndex(Table, Key, Value)
            else
                rawset(Table, Key, Value)
            end
        end
    end
    setmetatable(Service, Metatable)
    Services[Name] = Service
    Luagame.ServiceAdded:Fire(Name, Service)
end

function Luagame:AddLibrary(Name, Library)
    assert(Name, "Missing Parameter: Name")
    assert(type(Name) == "string", "Incorrect Datatype for Name, String expected")
    assert(Library, "Missing Parameter: Library")
    assert(type(Library) == "table", "Incorrect Datatype for Library, Table expected")

    setmetatable(Library, {__newindex = function()
        warn("This is a library it shouldn't be changed")
    end})

    Libraries[Name] = Library
    Luagame.LibraryAdded:Fire(Name, Library)
    return Library
end

function Luagame.AddServices(Folder)
    assert(Folder, "Missing Parameter: Folder")

    for _, Child in pairs(Folder:GetChildren()) do
        if Child:IsA("ModuleScript") then
            Luagame.AddService(Child.Name, require(Child))
        end
    end
end
function Luagame.AddServicesDeep(Folder)
    assert(Folder, "Missing Parameter: Folder")

    for _, Child in pairs(Folder:GetDescendants()) do
        if Child:IsA("ModuleScript") then
            Luagame.AddService(Child.Name, require(Child))
        end
    end
end

function Luagame.AddLibraries(Folder)
    assert(Folder, "Missing Parameter: Folder")

    for _, Child in pairs(Folder:GetChildren()) do
        if Child:IsA("ModuleScript") then
            Luagame.AddService(Child.Name, require(Child))
        end
    end
end
function Luagame.AddLibrariesDeep(Folder)
    assert(Folder, "Missing Parameter: Folder")

    for _, Child in pairs(Folder:GetDescendants()) do
        if Child:IsA("ModuleScript") then
            Luagame.AddLibrary(Child.Name, require(Child))
        end
    end
end



return Luagame