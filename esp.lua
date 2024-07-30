local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local function createBox()
    local box = Drawing.new("Square")
    box.Color = Color3.new(1, 0, 0)  -- Red color
    box.Thickness = 2
    box.Filled = false
    box.Transparency = 1
    return box
end

local function createText()
    local text = Drawing.new("Text")
    text.Color = Color3.new(1, 1, 1)  -- White color
    text.Size = 20
    text.Center = true
    text.Outline = true
    text.OutlineColor = Color3.new(0, 0, 0)  -- Black outline
    return text
end

local function updateBoxAndText(box, text, player)
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local torso = player.Character.HumanoidRootPart
        local vector, onScreen = workspace.CurrentCamera:WorldToViewportPoint(torso.Position)
        if onScreen then
            box.Size = Vector2.new(50, 100)  -- Size of the box
            box.Position = Vector2.new(vector.X - box.Size.X / 2, vector.Y - box.Size.Y / 2)
            box.Visible = true

            text.Position = Vector2.new(box.Position.X + box.Size.X / 2, box.Position.Y - text.Size - 2)
            text.Text = player.Name
            text.Visible = true
        else
            box.Visible = false
            text.Visible = false
        end
    else
        box.Visible = false
        text.Visible = false
    end
end

local visuals = {}

for _, player in pairs(Players:GetPlayers()) do
    if player ~= Players.LocalPlayer then
        local box = createBox()
        local text = createText()
        visuals[player] = {box = box, text = text}
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= Players.LocalPlayer then
        local box = createBox()
        local text = createText()
        visuals[player] = {box = box, text = text}
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if visuals[player] then
        visuals[player].box:Remove()
        visuals[player].text:Remove()
        visuals[player] = nil
    end
end)

RunService.RenderStepped:Connect(function()
    for player, visual in pairs(visuals) do
        updateBoxAndText(visual.box, visual.text, player)
    end
end)
