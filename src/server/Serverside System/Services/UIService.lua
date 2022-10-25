module = {
    NewUI = function(player, name) -- Creates a new UI
        local ui = Instance.new("ScreenGui")
        ui.Parent = player.PlayerGui
        ui.Name = name
        return ui
    end;
    GetUI = function(player, name) -- Returns the specified UI
        local ui = player.PlayerGui:FindFirstChild(name)
        if ui then
            return ui
        else
            return false
        end
    end;
    ClearScreen = function(player)
        for x, y in pairs(player.PlayerGui:GetChildren()) do
        y:Destroy()
        end
    end;
    SubUI = function(player, name)
        local ui = Instance.new("ScreenGui")
        ui.Parent = player.PlayerGui:FindFirstChild(name)
    end;
    Button = function(position, size, image, ui, player) -- Generates a generic image button
        local button = Instance.new("ImageButton")
        button.Parent = player.PlayerGui:FindFirstChild(ui)
        button.Position = position
        button.Size =  size
        button.Image = image
    end;
    TextBox = function(position, size, image, ui, player) -- Generates a generic text box
        local button = Instance.new("TextBox")
        if not image == nil then
            local image = Instance.new("ImageLabel")
            image.Parent = player.PlayerGui:FindFirstChild(ui)
            image.Position = position
            image.Size = size
            button.Parent = image
            button.Size = UDim2.new(1,0,1,0)
        else
            button.Parent = player.PlayerGui:FindFirstChild(ui)
            button.Position = position
            button.Size =  size
        end
    end;
    Label = function(position, size, image, ui, player, text, font, fontSize) -- Generates a generic text label
        local button = Instance.new("TextLabel")
        if not image == nil then
            local image = Instance.new("ImageLabel")
            image.Parent = player.PlayerGui:FindFirstChild(ui)
            image.Position = position
            image.Size = size
            button.Parent = image
            button.Size = UDim2.new(1,0,1,0)
        else
            button.Parent = player.PlayerGui:FindFirstChild(ui)
            button.Position = position
            button.Size =  size
        end
        button.Text = text
        button.FontFace = font
        button.TextSize = fontSize
    end;
    Hover = function(position,text,font,fontSize) -- Generatates a bubble for when a player hovers over a UI element
        local textlabel = Instance.new("TextLabel")
        local textadd = game:GetService("TextService")
        local length = textadd:GetTextSize(text,fontSize,font)
        textlabel.Size = UDim2.new(0,length,0,fontSize)
        textlabel.Position = position
    end
}

return module