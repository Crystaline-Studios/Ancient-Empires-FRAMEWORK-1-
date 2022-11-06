-- Created By Carrotoplia on Fri Oct 14 21:02:09 2022
-- for easy moderation and exploit detection.

----------------------------->> Modules / Services / Nonchanging Assets <<---------------------------------

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local ProximityPromptService = game:GetService("ProximityPromptService")

local ModActions = require(script.ModerationActions)
local Get = require(ReplicatedStorage.Get)
local QuickSignal = require(Get("QuickSignal"))
local Config = require(Get("SConfig"))
Config = Config.ModerationService

local Frames = {}


function RunSync(F)
    task.synchronize()
    F()
    task.desynchronize()
end

----------------------------->> The Service / THE THE THE SERVICE <<---------------------------------

local Service = setmetatable({}, {__index = ModActions})

Service.OnTriggered = QuickSignal.new()
Service.OnFly = QuickSignal.new()
Service.OnNoclip = QuickSignal.new()
Service.OnMagnitude = QuickSignal.new()
Service.OnGodmode = QuickSignal.new()
Service.OnRootremoval = QuickSignal.new()
Service.OnFaketrigger = QuickSignal.new()

ProximityPromptService.PromptButtonHoldBegan:Connect(function(Prompt, Player)
    local ActionLog = ModActions:GetAnticheatLog(Player.UserId)

    if Config.ProximityPromptDistanceCheck then
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local Distance = (Player.Character.HumanoidRootPart.Position - Prompt:FindFirstAncestorOfClass("BasePart").Position).Magnitude
            if Distance > Prompt.MaxActivationDistance + Config.ProximityPromptDistanceThreshold then
                Service.OnFaketrigger:Fire(Player)
                ModActions:Kick(Player.UserId, "KickCode: 2. Report this as a bug if it happens and your not a exploiter.")
                table.insert(ActionLog, {
                    Type = "OutOfRangeProximityPromptTrigger",
                    Time = os.time(),
                    JobID = game.JobId,
                    PlaceVersion = game.PlaceVersion,
                })
            end
        end
    end

    if Config.ProximityPromptInstantFireCheck then
        local Running = coroutine.running()
        local StartDuration = Prompt.HoldDuration
        local Time = os.time()

        local Connection = ProximityPromptService.PromptButtonHoldEnded:Connect(function(TPrompt, TPlayer)
            if Prompt == TPrompt and TPlayer == Player then
                coroutine.resume(Running)
            end
        end)
        coroutine.yield()

        Connection:Disconnect()
        if StartDuration == Prompt.HoldDuration then
            if (Time + Prompt.HoldDuration) > (os.time() + Config.ProximityPromptInstantFireThreshold) then
                Service.OnFaketrigger:Fire(Player)
                ModActions:Kick(Player.UserId, "KickCode: 3. Report this as a bug if it happens and your not a exploiter.")
                table.insert(ActionLog, {
                    Type = "InstantFiringProximityPrompt",
                    Time = os.time(),
                    JobID = game.JobId,
                    PlaceVersion = game.PlaceVersion,
                })
            end
        end
    end
end)

Players.PlayerAdded:Connect(function(Player)
    Frames[Player] = {{}} -- For stupid embody reasons
    local ActionLog = ModActions:GetAnticheatLog(Player.UserId)
    local IsBanned = ModActions:IsBanned(Player.UserId) 

    ----- Ban Detection ------
    if IsBanned == true or IsBanned and os.time() < IsBanned then
        Player:Kick(ModActions:GetBanReason(Player.UserId))
    end

    Player.CharacterAdded:Connect(function(Character)
        local Root = Character:WaitForChild("HumanoidRootPart")
        local Humanoid = Character:WaitForChild("Humanoid")

        Frames[Player] = {}
        local PositionFrames = Frames[Player]

        table.insert(PositionFrames, {
            Position = Root.Position, -- Roots Position
            CFrame = Root.CFrame, -- Roots CFrame data
            IsGrounded = Enum.Material.Grass, -- Placeholder
            DoMagnitudeCheck = true, -- Disabled when teleported
            FlightRay = Workspace:Raycast(Root.Position, Vector3.new(0, 180, 0), RaycastParams.new())
        })



        if Config.GodmodeCheck then
            Humanoid.AncestryChanged:Connect(function(_, NewParent)
                -- Checks if the players character still exists
                if Character:IsDescendantOf(game) then
                    if not NewParent or not game:IsAncestorOf(NewParent) then
                        Service.OnGodmode:Fire(Player)
                        table.insert(ActionLog, {
                            Type = "Godmode",
                            Time = os.time(),
                            JobID = game.JobId,
                            PlaceVersion = game.PlaceVersion,
                        })
                        ModActions:Kick(Player, "KickCode: 1. Report this as a bug if it happens and your not a exploiter.")
                    end
                end
            end)
        end

        if not Config.AllowRootDestruction then
            Root.AncestryChanged:Connect(function(_, NewParent) 
                -- Checks if the players character still exists
                if Character:IsDescendantOf(game) then
                    if not NewParent or not game:IsAncestorOf(NewParent) then
                        Service.OnRootremoval:Fire(Player)
                    end
                end
            end)
        end
        

        while Root and Character and Humanoid do
            local FrameData = PositionFrames[#PositionFrames]
            local WaitTime = math.random(5, 10) -- Inconsistant so exploiters cant move exactly before it runs the checks 

            local WalkSpeed = Humanoid.WalkSpeed
            local JumpPower = Humanoid.JumpPower
            local RootPosition = Root.Position
            local FloorMaterial = Humanoid.FloorMaterial
            local Gravity = workspace.Gravity


            task.desynchronize()
            -------------------- Magnitude Check ----------------------
            if Config.MagnitudeCheck and FrameData.DoMagnitudeCheck then
                if (FrameData.Position - RootPosition).Magnitude > (WalkSpeed + Config.MagnitudeThreshold) / WaitTime then
                    RunSync(function()
                        Root.CFrame = FrameData.CFrame
                        Service.OnMagnitude:Fire(Player)
                        table.insert(ActionLog, {
                            Type = "Magnitude",
                            Time = os.time(),
                            JobID = game.JobId,
                            PlaceVersion = game.PlaceVersion,
                        })
                    end)
                end
            end

            
            ---------------- Noclip Check ---------------------------
            if Config.NoclipCheck then
                local RayParams = RaycastParams.new()
                RayParams.IgnoreWater = true

                local RayA = Workspace:Raycast(FrameData.Position, CFrame.lookAt(FrameData.Position, RootPosition), RayParams)
                local RayB = Workspace:Raycast(RootPosition, CFrame.lookAt(RootPosition, FrameData.Position), RayParams)

                if RayA.Position or RayB.Position then 
                    RunSync(function()
                        Root.CFrame = FrameData.CFrame
                        Service.OnNoclip:Fire(Player)
                        table.insert(ActionLog, {
                            Type = "Noclip",
                            Time = os.time(),
                            JobID = game.JobId,
                            PlaceVersion = game.PlaceVersion,
                        })
                    end)
                end
            end


            ---------------- Flight Check ---------------------------
            local RayParams = RaycastParams.new()
            RayParams.IgnoreWater = false

            local FlightRay = Workspace:Raycast(FrameData.Position, Vector3.new(0, 180, 0) , RayParams)

            if Config.FlightCheck and FloorMaterial == Enum.Material.Air then
                if not FlightRay.Instance or FlightRay.Distance > JumpPower^2 / (2*Gravity) + Config.FlightThreshold then-- Player is not jumping
                    if FrameData.FlightRay.Distance > FlightRay.Distance then
                        -- Player has not moved down in air 
                        RunSync(function()
                            Humanoid.Sit = false
                            Root.CFrame = CFrame.new(FlightRay.Position + Vector3.new(0, Humanoid.HipHeight, 0))
                                table.insert(ActionLog, {
                                Type = "Flight",
                                Time = os.time(),
                                JobID = game.JobId,
                                PlaceVersion = game.PlaceVersion,
                            })
                            Service.OnFly:Fire(Player)
                        end)
                    end
                end
            end

            task.synchronize()
            table.insert(PositionFrames, {
                Position = Root.Position, -- Roots Position
                CFrame = Root.CFrame, -- Roots CFrame data
                IsGrounded = Humanoid.FloorMaterial, -- Placeholder
                DoMagnitudeCheck = true, -- Disabled when teleported
                FlightRay = FlightRay
            })
            task.wait(.1)
        end
    end)
end)


function Service:TP(Player)
    local PlayerFrames = Frames[Player]
    PlayerFrames[#PlayerFrames].DoMagnitudeCheck = false
end


return Service