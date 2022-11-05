-- Created By Carrotoplia on Fri Oct 14 21:02:09 2022
-- for easy moderation and exploit detection.

----------------------------->> Modules / Services / Nonchanging Assets <<---------------------------------

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

----------------------------->> Assets / Variables / Everything Else <<---------------------------------

local SConfig = require(ServerScriptService.ServerConfig)
local Actions = require(script.ModerationActions)
local Config = SConfig.ModerationService

local LastPositions = {}

----------------------------->> The Service / THE THE THE SERVICE <<---------------------------------

local Service = setmetatable({}, {__index = require(script.ModerationActions)})


Players.PlayerAdded:Connect(function(Player)
    local ActionLogs = Actions:GetAnticheatLog(Player.UserId)
    task.spawn(function()
        local LatestCount = #ActionLogs 
        while true do
            task.wait(60)
            local HitCount = #ActionLogs - LatestCount
            if HitCount > Config.ActionsPerMinuteCap then
                Actions:Kick(Player.UserId, "Triggered Anticheat Too often if this is causing problems for you report it as a bug.")
            else
                LatestCount = #ActionLogs + Config.ActionsPerMinuteCap
            end 
        end
    end)


    Player.CharacterAdded:Connect(function(Character)
        local Root = Character:WaitForChild("HumanoidRootPart")
        local Humanoid = Character:WaitForChild("Humanoid")


        ---- ANTI GOD MODE
        Character.ChildRemoving:Connect(function(Child)
            if Child == Humanoid then
                Character:Destroy()
                warn("Humanoid Destroyed: So Character is Too.")
            end
        end)

        LastPositions[Player] = {LastPositions[Player], {
            IsGrounded = Humanoid.FloorMaterial ~= Enum.Material.Air,
            Position = Root.Position,
            FloorDistance = 1
        }}
        local PositionData = LastPositions[Player]

        while Root and Humanoid do
            task.wait(0.25)
            local LastData = PositionData[#PositionData]

            ---------- ANTI Fly
            local FloorRay = workspace:Raycast(Root.Position, Vector3.new(0, -2, 0), RaycastParams.new())
            local FloorDistance = if FloorRay.Instance then (FloorRay.Position - Root.Position).Magnitude else nil 

            if not FloorDistance then
                if not Config.AllowVoidStanding then
                    Humanoid.Sit = false

                    Root.Position = LastData.Position
                    Humanoid.Health -= 5
                    table.insert(ActionLogs, {
                        Type = "AboveVoid",
                        Time = os.time()
                    })
                end
            else
                if FloorDistance > LastData.FloorDistance - 0.1 then -- Don't think it went down at all
                    local LatestFrame
                    for Count = 1, #PositionData do
                        if PositionData[Count].IsGrounded then
                            LatestFrame = PositionData[Count]
                        end
                    end

                    Humanoid.Sit = false

                    if not LatestFrame then
                        Root.Position = PositionData[#PositionData - 1].Position
                        Humanoid.Health -= 5
                        table.insert(ActionLogs, {
                            Type = "Fly",
                            Time = os.time()
                        })
                    else
                        Root.Position = LatestFrame.Position
                        Humanoid.Health -= 5
                        table.insert(ActionLogs, {
                            Type = "Fly",
                            Time = os.time()
                        })
                    end
                end
            end

            ---------- Location 
            local Distance = (LastData.Position - Root.Position).Magnitude
            local MaxDistance = Humanoid.WalkSpeed + Config.DistanceThreshold
            MaxDistance /= 4

            if Distance > MaxDistance then
                Humanoid.Sit = false

                local LatestFrame
                for Count = 1, #PositionData do
                    if PositionData[Count].IsGrounded then
                        LatestFrame = PositionData[Count]
                    end
                end
                if not LatestFrame then
                    Root.Position = PositionData[#PositionData - 1].Position
                    Humanoid.Health -= 5
                    table.insert(ActionLogs, {
                        Type = "Distance",
                        Time = os.time()
                    })
                else
                    Root.Position = LatestFrame.Position
                    Humanoid.Health -= 5
                    table.insert(ActionLogs, {
                        Type = "Distance",
                        Time = os.time()
                    })
                end
            end

            ---------- Noclip
            local Params = RaycastParams.new()
            Params.IgnoreWater = true
            
            local CastA = workspace:Raycast(LastData.Position, CFrame.lookAt(LastData.Position, Root.Position).LookVector, Params)
            local CastB = workspace:Raycast(Root.Position, CFrame.lookAt(Root.Position, LastData.Position).LookVector, Params)

            if CastA.Material and CastB.Material then
                Distance = (CastA.Position - CastB.Position).Magnitude
                if Distance > Config.NoclipThreshold then
                    Humanoid.Sit = false

                    Root.Position = LastData.Position
                    Humanoid.Health -= 5
                end

            elseif CastA.Material and not CastB.Material  then
                Humanoid.Sit = false


                Root.Position = LastData.Position
                Humanoid.Health -= 5
                table.insert(ActionLogs, {
                    Type = "Noclip",
                    Time = os.time()
                })
            end


            table.insert(PositionData, {
                IsGrounded = Humanoid.FloorMaterial ~= Enum.Material.Air,
                Position = Root.Position
            })
        end     
    end)
end)

function Service:SafeTP(Player, Location)
    assert(Player, "Missing Parameter: Player")
    assert(Location, "Missing Parameter: Location")

    if Player.Character then
        Player.Character:WaitForChild("Humanoid").Sit = false
        Player.Character:WaitForChild("HumanoidRootPart").Position = Location
        table.insert(Player, {
            IsGrounded = true,
            FloorDistance = 0,
            Position = Location
        })
    end
end
function Service:SafeMoveTo(Player, Location)
    assert(Player, "Missing Parameter: Player")
    assert(Location, "Missing Parameter: Location")

    if Player.Character then
        Player.Character:WaitForChild("Humanoid").Sit = false
        Player.Character:WaitForChild("HumanoidRootPart")

        Player.Character:MoveTo(Location)
        table.insert(Player, {
            IsGrounded = true,
            FloorDistance = 0,
            Position = Location
        })
    end
end


return Service