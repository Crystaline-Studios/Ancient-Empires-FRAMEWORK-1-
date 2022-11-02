
----------------------------->> Services and Modules <<---------------------------------
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local Get = require(game:GetService("ReplicatedStorage").Get)
local Object = require(Get("Object"))
local QuickSignal = require(Get("QuickSignal"))
local Table = require(Get("Table"))

local UIHolders = {}

----------------------------->> Service <<---------------------------------

local Service, Finalize = Object "UIService"

function Service:New(Name)
    assert(Name, "Missing Parameter: Name")

    local ScreenGui = Instance.new("ScreenGui")
    local Frame = Instance.new("Frame", ScreenGui)
    Frame.BorderSizePixel = 0

    local UI, Finalize = Object(Name)
    UIHolders[Name] = UI

    UI.Position = Object {X = 0, Y = 0}
    UI.Size = Object {X = 0, Y = 0}

    UI.Visible = true
    UI:BindProperty(Frame, "Transparency")
    UI:BindProperty(Frame, "Enabled", "Visible")

    UI:SetChangable("Position", true)
    UI:SetChangable("Size", true)
    UI:SetChangable("Roundness", true)
    UI:SetDatatype("Roundness", "Number")


    Table:GetChangedEvent(UI.Position):Connect(function()
        local UPos = UDim2.new(UI.Size.X,0,UI.Size.Y,0)
        Frame.Position = UPos
        Frame.AnchorPoint = UPos
    end)
    Table:GetChangedEvent(UI.Size):Connect(function()
        UI.Size = UDim2.new(UI.Size.X,0,UI.Size.Y,0)
    end)
    
    Table:GetChangedEvent(UI):Connect(function(Index, NewValue)
        if Index == "Roundness" then
            if not Frame:FindFirstChild("UICorner") then
                Instance.new("UICorner", Frame)
            end

            Frame.UICorner.CornerRadius = UDim.new(0, NewValue)
        end
    end)

    ------------ Functions --------------

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
            while Frame.BackgroundTransparency ~= 1 do
               Frame.BackgroundTransparency += FadeSize
               task.wait(Speed) 
            end

            UI.Visible = false
        else
            while Frame.BackgroundTransparency ~= 0 do
                Frame.BackgroundTransparency -= FadeSize
                task.wait(Speed) 
            end

            UI.Visible = true
        end
    end

    function UI:Button(Name)
        local Button, Finalize = Object(Name)
        Button.Position = {X = 0, Y = 0}
        Button.Size = {X = 0, Y = 0}

        UI:SetChangable("Position", true)
        UI:SetChangable("Size", true)
        UI:SetChangable("Roundness", true)
        UI:SetDatatype("Roundness", "number")

        local ButtonInstance = Instance.new("TextButton")
        ButtonInstance.BorderSizePixel = 0 
        ButtonInstance.Name = Name or "Button"

        UI:BindProperty(ButtonInstance, "BackgroundTransparency", "Transparency")
        UI:BindProperty(ButtonInstance, "Text")
        UI:BindProperty(ButtonInstance, "BackgroundColor3", "Color")

        local ImageLabel = Instance.new("ImageLabel")
        ImageLabel.Size = UDim2.new(1,0,1,0)
        ImageLabel.BackgroundTransparency = 1

        UI:BindProperty(ImageLabel, "Image")
        

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


        ----- Button Table Connection --------
        Table:GetChangedEvent(Button):Connect(function(Index, NewValue)
            if Index == "Roundness" then
                if not ButtonInstance:FindFirstChild("UICorner") then
                    Instance.new("UICorner", ButtonInstance)
                end

                ButtonInstance.UICorner.CornerRadius = UDim.new(0, NewValue)
            end
        end)


        ImageLabel.Parent = ButtonInstance
        ButtonInstance.Parent = Frame

        Finalize()
        return Button
    end

    function UI:Textbox()
        
    end

    function UI:Label()
        
    end

    Finalize()
    return UI, ScreenGui
end

function Service:GetUI(Name)
    return UIHolders[Name]
end

Finalize()
return Service
