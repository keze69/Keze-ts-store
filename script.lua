end= game.Players.LocalPlayer
local autoJump = false
local jumpDelay = 5

-- Anti AFK
player.Idled:Connect(function()
    local VirtualUser = game:GetService("VirtualUser")
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "KEZE_UI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main frame
local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0,240,0,160)
frame.Position = UDim2.new(0.5,-120,0.6,-80)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,12)
corner.Parent = frame

-- Gradient
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80,0,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,200,255))
}
gradient.Parent = frame

-- Glow
local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(120,120,255)
stroke.Parent = frame

-- KEZE Logo
local logo = Instance.new("TextLabel")
logo.Parent = frame
logo.Size = UDim2.new(1,0,0,30)
logo.BackgroundTransparency = 1
logo.Text = "KEZE"
logo.TextColor3 = Color3.new(1,1,1)
logo.TextScaled = true
logo.Font = Enum.Font.GothamBlack

-- Toggle Button
local toggle = Instance.new("TextButton")
toggle.Parent = frame
toggle.Size = UDim2.new(0.8,0,0,35)
toggle.Position = UDim2.new(0.1,0,0.3,0)
toggle.Text = "Auto Jump: OFF"
toggle.TextScaled = true
toggle.Font = Enum.Font.Gotham
toggle.BackgroundColor3 = Color3.fromRGB(60,60,60)
toggle.TextColor3 = Color3.new(1,1,1)

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0,8)
toggleCorner.Parent = toggle

toggle.MouseButton1Click:Connect(function()
    autoJump = not autoJump
    if autoJump then
        toggle.Text = "Auto Jump: ON"
        toggle.BackgroundColor3 = Color3.fromRGB(60,200,100)
    else
        toggle.Text = "Auto Jump: OFF"
        toggle.BackgroundColor3 = Color3.fromRGB(200,60,60)
    end
end)

-- Slider label
local label = Instance.new("TextLabel")
label.Parent = frame
label.Size = UDim2.new(1,0,0,20)
label.Position = UDim2.new(0,0,0.65,0)
label.BackgroundTransparency = 1
label.Text = "Jump Delay: 5s"
label.TextColor3 = Color3.new(1,1,1)
label.TextScaled = true
label.Font = Enum.Font.Gotham

-- Slider
local slider = Instance.new("Frame")
slider.Parent = frame
slider.Size = UDim2.new(0.8,0,0,10)
slider.Position = UDim2.new(0.1,0,0.82,0)
slider.BackgroundColor3 = Color3.fromRGB(50,50,50)
slider.BorderSizePixel = 0

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(1,0)
sliderCorner.Parent = slider

local knob = Instance.new("Frame")
knob.Parent = slider
knob.Size = UDim2.new(0,16,0,16)
knob.Position = UDim2.new(0.5,-8,0.5,-8)
knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
knob.BorderSizePixel = 0

local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(1,0)
knobCorner.Parent = knob

local UIS = game:GetService("UserInputService")
local dragging = false

knob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging then
        local pos = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X,0,1)
        knob.Position = UDim2.new(pos,-8,0.5,-8)

        jumpDelay = math.floor(1 + pos * 9)
        label.Text = "Jump Delay: "..jumpDelay.."s"
    end
end)

-- Auto jump Auto
task.spawn(function()
    while true do
        if autoJump then
            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoid = character:FindFirstChildOfClass("Humanoid")

            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end

        task.wait(5) -- jump every 5 seconds
    end
end)
