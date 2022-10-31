
----------------------------->> Services and Modules <<---------------------------------
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local Get = require(game:GetService("ReplicatedStorage").Get)
local Objectify = require(Get("Objectify"))
local QuickSignal = require(Get("QuickSignal"))
local Table = require(Get("Table"))

----------------------------->> Variables <<---------------------------------

local UIHolder = Instance.new("ScreenGui")

----------------------------->> Service <<---------------------------------

local Service = {}

function Service:New()
    local Frame = Instance.new("Frame", UIHolder)
    local UI = {}
    UI.Position = {X = 0, Y = 0}
    UI.Size = {X = 0, Y = 0}
    UI.Visible = true

    local FadeToggles = {}


    function UI:GlideOut(Side, Speed)
        assert(Side, "Missing Parameter: Side")
        assert(Speed, "Missing Parameter: Speed")

        local Direction
        if Side == "Top" then
            Direction = UDim2.new(Frame.X.Scale, 0, 0, 0)
            
        elseif Side == "Bottom" then
            Direction = UDim2.new(Frame.X.Scale, 0, 1, 0)

        elseif Side == "Left" then
            Direction = UDim2.new(0, 0, Frame.Y.Scale, 0)

        elseif Side == "Right" then
            Direction = UDim2.new(1, 0, Frame.Y.Scale, 0)
        else
            error("Unknown direction")
        end

        local TInfo = TweenInfo.new(
            Speed,
            Enum.EasingStyle.Exponential,
            Enum.EasingDirection.In,
            0,
            false,
            0
        )

        local Tween = TweenService:Create(Frame, TInfo, Direction)
        Tween:Play()
        UI:Fade(false, 0, 0)
    end

    function UI:GlideIn(Side, Speed)
        assert(Side, "Missing Parameter: Side")
        assert(Speed, "Missing Parameter: Speed")

        UI:Fade(false, 0, 0)

        local Direction
        if Side == "Top" then
            Direction = UDim2.new(Frame.X.Scale, 0, 0, 0)
            
        elseif Side == "Bottom" then
            Direction = UDim2.new(Frame.X.Scale, 0, 1, 0)

        elseif Side == "Left" then
            Direction = UDim2.new(0, 0, Frame.Y.Scale, 0)

        elseif Side == "Right" then
            Direction = UDim2.new(1, 0, Frame.Y.Scale, 0)

        else
            error("Unknown direction")
        end

        local TInfo = TweenInfo.new(
            Speed,
            Enum.EasingStyle.Exponential,
            Enum.EasingDirection.In,
            0,
            false,
            0
        )

        Frame.Position = Direction
        local Tween = TweenService:Create(Frame, TInfo, Direction)
        Tween:Play()
    end

    function UI:Fade(IsFading, Speed, FadeSize)
        assert(IsFading, "Missing Parameter: IsFading")

        if IsFading then
            UI.Visible = false
            while Frame.BackgroundTransparency ~= 1 do
               Frame.BackgroundTransparency += FadeSize
               task.wait(Speed) 
            end

            for _,Descendant in pairs(Frame:GetDescendants()) do
                if Descendant:GetPropertyChangedSignal("Visible") then
                    FadeToggles[Descendant] = Descendant.Visible
                    Descendant.Visible = false
                end
            end

        else
            UI.Visible = true
            while Frame.BackgroundTransparency ~= 0 do
                Frame.BackgroundTransparency -= FadeSize
                task.wait(Speed) 
            end

            for _,Descendant in pairs(Frame:GetDescendants()) do
                if Descendant:GetPropertyChangedSignal("Visible") then
                    Descendant.Visible = FadeToggles[Descendant] or true
                end
            end
        end
    end

    function UI:Button()
        local Button = {}
        Button.Position = {X = 0, Y = 0}
        Button.Size = {X = 0, Y = 0}
        Button.Bold = false

        local ButtonInstance = Instance.new("TextButton")

        Button.OnLeftClick = QuickSignal:Quickify(ButtonInstance.MouseButton1Click)
        Button.OnRightClick = QuickSignal:Quickify(ButtonInstance.MouseButton2Click)

        ----- Position and Size ------
        Table:GetChangedEvent(Button.Position):Connect(function()
            local UPos = UDim2.new(Button.Size.X,0,Button.Size.Y,0)
            ButtonInstance.Position = UPos
            ButtonInstance.AnchorPoint = UPos
        end)
        Table:GetChangedEvent(Button.Size):Connect(function()
            ButtonInstance.Size = UDim2.new(Button.Size.X,0,Button.Size.Y,0)
        end)

        ------- UserInterface Button ---------

        Table:GetChangedEvent(Button):Connect(function()
            
        end)


        local Holder = Objectify(Button)
        Holder:BindToProperty(ButtonInstance, "BackgroundTransparency", "Transparency")
        Holder:BindToProperty(ButtonInstance, "Text")
        Holder:BindToProperty(ButtonInstance, "BackgroundColor3", "Color3")
        return Button
    end

    function UI:Textbox()
        
    end

    function UI:Label()
        
    end

    local Holder = Objectify(UI)
    Holder:BindToProperty(Frame, "Transparency")
    return UI
end

local Holder = Objectify(Service)
return Service
