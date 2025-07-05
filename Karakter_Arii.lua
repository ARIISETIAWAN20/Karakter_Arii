-- ✅ Game Lock untuk "99 Nights in the Forest: STRONGHOLDS"
if game.PlaceId ~= 79546208627805 then
	return warn("Script hanya bisa digunakan di game: 99 Nights in the Forest - STRONGHOLDS.")
end

--// Arii Project Character Utility Script
--// UI + Speed Slider + Inf Jump + Character Clip
--// Compatible with Delta Executor

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AriiProjectGui"
screenGui.Parent = game:GetService("CoreGui")
screenGui.ResetOnSpawn = false

-- Drag function
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

	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragToggle then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 180)
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

-- Speed Slider
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 20)
speedLabel.Text = "Speed: 16"
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.BackgroundTransparency = 1
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 14
speedLabel.Parent = content

local slider = Instance.new("TextButton")
slider.Size = UDim2.new(1, 0, 0, 20)
slider.Position = UDim2.new(0, 0, 0, 25)
slider.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
slider.Text = ""
slider.AutoButtonColor = false
slider.Parent = content

local dragging = false
local function updateSpeedSlider(x)
	local relX = math.clamp((x - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
	local speed = math.floor(relX * 2000)
	speedLabel.Text = "Speed: " .. speed
	humanoid.WalkSpeed = speed
end

slider.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true updateSpeedSlider(input.Position.X) end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		updateSpeedSlider(input.Position.X)
	end
end)

-- Infinite Jump Toggle
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
		character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

-- Noclip Toggle
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
end)

RunService.Stepped:Connect(function()
	if clip then
		for _, v in pairs(character:GetDescendants()) do
			if v:IsA("BasePart") and v.CanCollide == true then
				v.CanCollide = false
			end
		end
	end
end)

-- Minimize Functionality
local minimized = false
minimize.MouseButton1Click:Connect(function()
	minimized = not minimized
	content.Visible = not minimized
	mainFrame.Size = minimized and UDim2.new(0, 300, 0, 35) or UDim2.new(0, 300, 0, 180)
	minimize.Text = minimized and "+" or "-"
end)
