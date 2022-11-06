
----------------------------->> Services and Modules <<---------------------------------
local TweenService = game:GetService("TweenService")

local Get = require(game:GetService("ReplicatedStorage").Get)
local QuickSignal = require(Get("QuickSignal"))
local Table = require(Get("Table"))

local UIHolders = {}

----------------------------->> Service <<---------------------------------

local Service = {}
Service.Class = "UIService"

function Service:New(Name, Parent)
    assert(Name, "Missing Parameter: Name")

    local ScreenGui; if not Parent then
        ScreenGui = Instance.new("ScreenGui")
    end
    
    local Frame = Instance.new("Frame")
    Frame.Parent = Parent or ScreenGui
    Frame.BorderSizePixel = 0

    local UI = {}
    UIHolders[Name] = UI

    UI.Position = {X = 0, Y = 0}
    UI.Size = {X = 0, Y = 0}
    UI.Padding = {X = 0, Y = 0}
    UI.CellSize = {X = 0, Y = 0}
    UI.Roundness = 0
    UI.HorizontalGridPosition = "Center"
    UI.Visible = true

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



        elseif Index == "GridEnabled" then
            local Grid = Frame:FindFirstChild("Grid")
            if NewValue then
                if not Grid then
                    local Grid = Instance.new("UI" .. UI.GridType .. "Layout")
                    Grid.Name = "Grid"

                    Grid.FillDirection = Enum.FillDirection[UI.FillDirection]
                    Grid.SortOrder = Enum.SortOrder.LayoutOrder
                    Grid.HorizontalAlignment = Enum.HorizontalAlignment[UI.HorizontalGridPosition]
                    Grid.VerticalAlignment = Enum.VerticalAlignment[UI.VerticalGridPosition]

                    if Grid:IsA("UITableLayout") then
                        Grid.Padding = UDim2.new(0, UI.Padding.X, 0, UI.Padding.Y)
                    elseif Grid:IsA("UIListLayout") then
                        Grid.Padding = UDim.new(0, UI.Padding.X)
                    elseif Grid:IsA("UIGridLayout") then
                        Grid.CellPadding = UDim2.new(0, UI.Padding.X, 0, UI.Padding.Y)
                        Grid.CellSize = UDim2.new(0, UI.CellSize.X, 0, UI.CellSize.Y)
                    end

                end
            else
                if Grid then
                    Grid:Destroy()
                end
            end




        elseif Index == "FillDirection" then
            local Grid = Frame:FindFirstChild("Grid")
            if Grid then
                Grid.FillDirection = Enum.FillDirection[UI.FillDirection]
            end



        elseif Index == "HorizontalGridPosition" then
            local Grid = Frame:FindFirstChild("Grid")
            if Grid then
                Grid.HorizontalAlignment = Enum.HorizontalAlignment[UI.HorizontalGridPosition]
            end


        elseif Index == "VerticalGridPosition" then
            local Grid = Frame:FindFirstChild("Grid")
            if Grid then
                Grid.VerticalGridPosition = Enum.VerticalAlignment[UI.VerticalGridPosition]
            end

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
        UI:Fade(true, 0, 0)
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
        local Button = {}
        Button.Position = {X = 0, Y = 0}
        Button.Size = {X = 0, Y = 0}

        local ButtonInstance = Instance.new("TextButton")
        ButtonInstance.BorderSizePixel = 0 
        ButtonInstance.Name = Name or "Button"

        local ImageLabel = Instance.new("ImageLabel")
        ImageLabel.Size = UDim2.new(1,0,1,0)
        ImageLabel.BackgroundTransparency = 1
        

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
        return Button
    end

    function UI:Textbox()
        
    end

    function UI:Label()
        
    end

    function UI:Frame(Name)
        return Service:New(Name, Frame)
    end

    return UI, ScreenGui
end

function Service:GetUI(Name)
    return UIHolders[Name]
end

return Service
