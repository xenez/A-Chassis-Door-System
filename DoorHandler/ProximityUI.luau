local ProximityPromptService = game:GetService("ProximityPromptService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local function createCleanUI(prompt)
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "CleanPromptUI"
	billboard.Size = UDim2.new(0, 180, 0, 45)
	billboard.AlwaysOnTop = true

	billboard.Adornee = prompt.Parent:IsA("Model") and prompt.Parent.PrimaryPart or prompt.Parent
	billboard.StudsOffset = Vector3.new(0, 2.5, 0)
  
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 0, 1, 0)
	frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	frame.BackgroundTransparency = 0.2
	frame.ClipsDescendants = true
	frame.Parent = billboard

	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 6)
	uiCorner.Parent = frame

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, -10, 1, 0)
	textLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
	textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	textLabel.BackgroundTransparency = 1
	textLabel.TextColor3 = Color3.fromRGB(245, 245, 245)
	textLabel.Font = Enum.Font.GothamMedium
	textLabel.TextSize = 13

	local keyName = prompt.KeyboardKeyCode.Name
	textLabel.Text = string.format("[%s]  %s", keyName, prompt.ActionText)
	textLabel.Parent = frame

	local progressBar = Instance.new("Frame")
	progressBar.Size = UDim2.new(0, 0, 0, 3)
	progressBar.Position = UDim2.new(0, 0, 1, -3)
	progressBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	progressBar.BorderSizePixel = 0
	progressBar.Parent = frame

	return billboard, frame, progressBar
end

ProximityPromptService.PromptShown:Connect(function(prompt, inputType)
	if prompt.Style ~= Enum.ProximityPromptStyle.Custom then return end

	local billboard, frame, progressBar = createCleanUI(prompt)
	billboard.Parent = playerGui

	TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(1, 0, 1, 0)
	}):Play()

	local holdBeganConn, holdEndedConn
	if prompt.HoldDuration > 0 then
		holdBeganConn = prompt.PromptButtonHoldBegan:Connect(function()
			TweenService:Create(progressBar, TweenInfo.new(prompt.HoldDuration, Enum.EasingStyle.Linear), {
				Size = UDim2.new(1, 0, 0, 3)
			}):Play()
		end)

		holdEndedConn = prompt.PromptButtonHoldEnded:Connect(function()
			TweenService:Create(progressBar, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
				Size = UDim2.new(0, 0, 0, 3)
			}):Play()
		end)
	end

	local promptHiddenConn
	promptHiddenConn = ProximityPromptService.PromptHidden:Connect(function(hiddenPrompt)
		if hiddenPrompt == prompt then
			if holdBeganConn then holdBeganConn:Disconnect() end
			if holdEndedConn then holdEndedConn:Disconnect() end
			promptHiddenConn:Disconnect()

			local hideTween = TweenService:Create(frame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Size = UDim2.new(0, 0, 1, 0),
				BackgroundTransparency = 1
			})
			hideTween:Play()
			hideTween.Completed:Connect(function()
				billboard:Destroy()
			end)
		end
	end)
end)
