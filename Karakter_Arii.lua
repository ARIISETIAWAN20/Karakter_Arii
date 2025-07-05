-- ✅ HWID Lock untuk Delta Executor (dengan pengecualian username tertentu)
local allowedUsers = {
    ["supa_loi"] = true,
    ["Devrenzx"] = true,
    ["Frenngk"] = true,
}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

if not allowedUsers[player.Name] then
    local hwid = identifyexecutor and identifyexecutor() or "unknown"
    if not string.find(hwid, "Delta") then
        return warn("Script hanya bisa digunakan di Delta Executor.")
    end
end

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AriiProjectGui"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
pcall(function() screenGui.Parent = game:GetService("CoreGui") end)

local function makeDraggable(frame)
    local dragToggle, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragToggle = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragToggle = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragToggle and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                       startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 210)
mainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
makeDraggable(mainFrame)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Arii Project"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame

-- Minimize Button
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0, 25, 0, 25)
minimize.Position = UDim2.new(1, -30, 0, 2)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
minimize.Parent = mainFrame

-- Content Frame
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -10, 1, -40)
content.Position = UDim2.new(0, 5, 0, 35)
content.BackgroundTransparency = 1
content.Name = "Content"
content.Parent = mainFrame

-- Speed Input Box
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 20)
speedLabel.Text = "Speed: 16"
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.BackgroundTransparency = 1
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 14
speedLabel.Parent = content

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(1, -20, 0, 20)
speedInput.Position = UDim2.new(0, 10, 0, 25)
speedInput.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
speedInput.Text = "16"
speedInput.TextColor3 = Color3.new(1, 1, 1)
speedInput.Font = Enum.Font.Gotham
speedInput.TextSize = 14
speedInput.ClearTextOnFocus = false
speedInput.Parent = content

speedInput.FocusLost:Connect(function()
    local num = tonumber(speedInput.Text)
    if num then
        num = math.clamp(num, 0, 2000)
        humanoid.WalkSpeed = num
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
        speedLabel.Text = "Speed: " .. num
    else
        speedInput.Text = tostring(humanoid.WalkSpeed)
    end
end)

-- Infinite Jump
local infJump = false
local infBtn = Instance.new("TextButton")
infBtn.Size = UDim2.new(1, 0, 0, 25)
infBtn.Position = UDim2.new(0, 0, 0, 55)
infBtn.Text = "Inf Jump: OFF"
infBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
infBtn.TextColor3 = Color3.new(1, 1, 1)
infBtn.Font = Enum.Font.Gotham
infBtn.TextSize = 14
infBtn.Parent = content

infBtn.MouseButton1Click:Connect(function()
    infJump = not infJump
    infBtn.Text = "Inf Jump: " .. (infJump and "ON" or "OFF")
end)

UserInputService.JumpRequest:Connect(function()
    if infJump then
        local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if h then
            h:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Character Clip
local clip = false
local clipBtn = Instance.new("TextButton")
clipBtn.Size = UDim2.new(1, 0, 0, 25)
clipBtn.Position = UDim2.new(0, 0, 0, 85)
clipBtn.Text = "Character Clip: OFF"
clipBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
clipBtn.TextColor3 = Color3.new(1, 1, 1)
clipBtn.Font = Enum.Font.Gotham
clipBtn.TextSize = 14
clipBtn.Parent = content

clipBtn.MouseButton1Click:Connect(function()
    clip = not clip
    clipBtn.Text = "Character Clip: " .. (clip and "ON" or "OFF")
    for _, v in pairs(character:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = not clip
        end
    end
end)

RunService.Stepped:Connect(function()
    if clip then
        for _, v in pairs(character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then
                v.CanCollide = false
            end
        end
    end
end)

-- Fly/Unfly
local flyActive = false
local BodyVelocity
local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(1, 0, 0, 25)
flyBtn.Position = UDim2.new(0, 0, 0, 115)
flyBtn.Text = "Fly: OFF"
flyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
flyBtn.TextColor3 = Color3.new(1, 1, 1)
flyBtn.Font = Enum.Font.Gotham
flyBtn.TextSize = 14
flyBtn.Parent = content

flyBtn.MouseButton1Click:Connect(function()
    flyActive = not flyActive
    flyBtn.Text = "Fly: " .. (flyActive and "ON" or "OFF")
    if flyActive then
        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.Velocity = Vector3.zero
        BodyVelocity.MaxForce = Vector3.new(1, 1, 1) * math.huge
        BodyVelocity.Parent = character:WaitForChild("HumanoidRootPart")
        RunService.RenderStepped:Connect(function()
            if flyActive and BodyVelocity then
                local moveDir = humanoid.MoveDirection
                BodyVelocity.Velocity = moveDir * 80
            end
        end)
    else
        if BodyVelocity then
            BodyVelocity:Destroy()
        end
    end
end)

-- Minimize
local minimized = false
minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    mainFrame.Size = minimized and UDim2.new(0, 300, 0, 35) or UDim2.new(0, 300, 0, 210)
    minimize.Text = minimized and "+" or "-"
end)

-- Anti AFK
local virtualUser = game:GetService("VirtualUser")
player.Idled:Connect(function()
    virtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    virtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Basic Kick Bypass
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "Kick" and not checkcaller() then
        return warn("Kick attempt blocked")
    end
    return oldNamecall(self, ...)
end)
