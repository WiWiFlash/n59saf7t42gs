local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local camera = workspace.CurrentCamera
local flying = false
local speed = 50 

local function Fly()
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, speed, 0)
    bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
    bodyVelocity.Parent = character.HumanoidRootPart
    return bodyVelocity
end

local function ToggleFlight()
    if flying then
        flying = false
        character.HumanoidRootPart:FindFirstChildOfClass("BodyVelocity"):Destroy()
        humanoid.PlatformStand = false
    else
        flying = true
        humanoid.PlatformStand = true
        local bodyVelocity = Fly()

        game:GetService("RunService").RenderStepped:Connect(function()
            if flying then
                local cameraDirection = camera.CFrame.LookVector
                bodyVelocity.Velocity = Vector3.new(cameraDirection.X, 0, cameraDirection.Z).unit * speed
            end
        end)
    end
end

local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.E then
        ToggleFlight()
    elseif input.KeyCode == Enum.KeyCode.Q then
        flying = false
        character.HumanoidRootPart:FindFirstChildOfClass("BodyVelocity"):Destroy()
        humanoid.PlatformStand = false
    end
end)
