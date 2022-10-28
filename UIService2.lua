-- Created by Cubee

------------------------------>> Services and Modules <<---------------------------------

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Get = require(ReplicatedStorage.Get)
local Objectify = require(Get('Objectify'))
local QuickSignal = require(Get('QuickSignal'))

----------------------------->> Service <<---------------------------------

local Service = {
    -- Gui related functions. 
    NewGUI = function(name)
        local ui = Instance.new("ScreenGui",game.Players.LocalPlayer.PlayerGui)
        ui.Name = name
        return ui
    end;
    FindGUI = function(name)
        local ui = game.Players.LocalPlayer.PlayerGui:FindFirstChild(name)
        if ui then
            return ui
        else
            return false -- yes i knew it would happen
        end
    end;
    CleanScreen = function()
        game.Players.LocalPlayer.PlayerGui:ClearAllChildren()
    end;
    CreateHoverUI = function(text, bold)
        local ui = Instance.new("TextLabel",NewGUI("Hover"))
        local text2 = game:GetService("TextService")
        local mouse = game:GetService("UserInputService")
        ui.Size = UDim2.new(0,text2:GetTextSize(text,14,Enum.Font.Legacy,Vector2.new(50,15)),0,15) -- man
        if bold then
            ui.FontFace = Font.new("Legacy",Enum.FontWeight.Bold)
        else
            ui.FontFace = Font.new("Legacy",Enum.FontWeight.Regular)
        end
        ui.Position = mouse:GetMouseLocation()
        return ui
    end;
    -- Object related functions.
    Button = function(name, text, image, parent)
        local button = Instance.new("ImageButton", parent)
        button.Image = image
        button.Name = name
        if text then
            local extra = Instance.new("TextLabel",button)
            extra.Size = UDim2.new(1,0,1,0)
            extra.BackgroundTransparency = 1

        end
        return button
    end;
    Textbox = function(name, image, parent)
        local textbox = Instance.new("TextBox")
        if image ~= nil then
            local image = Instance.new("ImageLabel")
            textbox.Parent = image
            image.Parent = textbox

        else
            textbox.Parent = parent
        end
        textbox.Name = name
    end;
    Label = function(name, image, text, parent)
        local textbox = Instance.new("TextLabel")
        if image ~= nil then
            local image = Instance.new("ImageLabel")
            textbox.Parent = image
            image.Parent = textbox

        else
            textbox.Parent = parent
        end
        textbox.Name = name
        textbox.Text = text
    end;
    SubUI = function(name, parent)
        local frame = Instance.new("Frame")
        frame.BackgroundTransparency = 1
        frame.Name = name
        frame.Parent = parent
    end;
    -- UI Manipulation functions.
    GlideIn = function(dir, name, thing)
        local tween = game:GetService("TweenService")
        if dir == "Up" then
            local inst = game.Players.LocalPlayer:FindFirstChild(name)
            local dir = inst.Position
            local dir2 = dir + UDim2.new(0,0,1,0)
            inst.Position = dir2
            tween:Create(inst,thing,{Position = dir})
        elseif dir == "Left" then
            tween:Create(game.Players.LocalPlayer:FindFirstChild(name),thing)
            local inst = game.Players.LocalPlayer:FindFirstChild(name)
            local dir = inst.Position
            local dir2 = dir + UDim2.new(-1,0,0,0)
            inst.Position = dir2
            tween:Create(inst,thing,{Position = dir})
        elseif dir == "Right" then
            tween:Create(game.Players.LocalPlayer:FindFirstChild(name),thing)
            local inst = game.Players.LocalPlayer:FindFirstChild(name)
            local dir = inst.Position
            local dir2 = dir + UDim2.new(1,0,0,0)
            inst.Position = dir2
            tween:Create(inst,thing,{Position = dir})
        else
            tween:Create(game.Players.LocalPlayer:FindFirstChild(name),thing)
            local inst = game.Players.LocalPlayer:FindFirstChild(name)
            local dir = inst.Position
            local dir2 = dir + UDim2.new(0,0,-1,0)
            inst.Position = dir2
            tween:Create(inst,thing,{Position = dir})
        end

    end;
    GlideOut = function(dir, name, thing)
        local tween = game:GetService("TweenService")
        if dir == "Up" then
            local inst = game.Players.LocalPlayer:FindFirstChild(name)
            local dir = inst.Position
            local dir2 = dir + UDim2.new(0,0,1,0)
            tween:Create(inst,thing,{Position = dir2})
        elseif dir == "Left" then
            tween:Create(game.Players.LocalPlayer:FindFirstChild(name),thing)
            local inst = game.Players.LocalPlayer:FindFirstChild(name)
            local dir = inst.Position
            local dir2 = dir + UDim2.new(-1,0,0,0)
            tween:Create(inst,thing,{Position = dir2})
        elseif dir == "Right" then
            tween:Create(game.Players.LocalPlayer:FindFirstChild(name),thing)
            local inst = game.Players.LocalPlayer:FindFirstChild(name)
            local dir = inst.Position
            local dir2 = dir + UDim2.new(1,0,0,0)
            tween:Create(inst,thing,{Position = dir2})
        else
            tween:Create(game.Players.LocalPlayer:FindFirstChild(name),thing)
            local inst = game.Players.LocalPlayer:FindFirstChild(name)
            local dir = inst.Position
            local dir2 = dir + UDim2.new(0,0,-1,0)
            tween:Create(inst,thing,{Position = dir2})
        end

    end;
}
local Holder = Objectify(Service)
return Service