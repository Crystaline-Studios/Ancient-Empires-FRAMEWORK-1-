-- Created By Carrotoplia on Fri Oct 14 21:02:09 2022
-- for easy moderation and exploit detection.

----------------------------->> Modules / Services / Nonchanging Assets <<---------------------------------

local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local Workspace = game:GetService("Workspace")

----------------------------->> Assets / Variables / Everything Else <<---------------------------------

local SConfig = require(ServerScriptService.ServerConfig)
local Actions = require(script.ModerationActions)
local Config = SConfig.ModerationService

local LastPositions = {}

----------------------------->> The Service / THE THE THE SERVICE <<---------------------------------

local Service = setmetatable({}, {__index = require(script.ModerationActions)})


Players.PlayerAdded:Connect(function(Player)
    Player.CharacterAdded:Connect(function(Character)
        local Root = Character:WaitForChild("HumanoidRootPart")
        local Humanoid = Character:WaitForChild("Humanoid")
        
        local ActionLogs = Actions:GetAnticheatLog(Player.UserId)

        LastPositions[Player] = {LastPositions[Player], {
            IsGrounded = Humanoid.FloorMaterial ~= Enum.Material.Air,
            Position = Root.Position
        }}
        local PositionData = LastPositions[Player]

        while Root and Humanoid do
            task.wait(0.25)
            local LastData = PositionData[#PositionData]

            ---------- Location 
            local Distance = (LastData.Position - Root.Position).Magnitude
            local MaxDistance = Humanoid.WalkSpeed + Config.DistanceThreshold; MaxDistance /= 4
            if Distance > MaxDistance then
                local LatestFrame
                for Count = 1, #PositionData do
                    if PositionData[Count].IsGrounded then
                        LatestFrame = PositionData[Count]
                    end
                end
                if not LatestFrame then
                    Root.Position = PositionData[#PositionData - 1].Position
                    table.insert(ActionLogs, {
                        Type = "Distance",
                        Time = os.time()
                    })
                else
                    Root.Position = LatestFrame.Position
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

            if CastA.Instance and CastB.Instance then
                local Distance = (CastA.Position - CastB.Position).Magnitude
                if Distance > Config.NoclipThreshold then
                    Root.Position = LastData.Position
                    Humanoid.Health -= 5
                end
            elseif CastA.Instance and not CastB.Instance then
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
        Player.Character:WaitForChild("HumanoidRootPart").Position = Location
        table.insert(Player, {
            IsGrounded = true,
            Position = Location
        })
    end
end

return Service