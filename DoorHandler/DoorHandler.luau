local TweenService = game:GetService("TweenService")
local hinge = script.Parent
local doorGroup = hinge.Parent 
local prompt = doorGroup:FindFirstChildWhichIsA("ProximityPrompt", true)
local spawnExit = doorGroup:FindFirstChild("SpawnExit", true)
local carModel = doorGroup
repeat
	carModel = carModel.Parent
until carModel:FindFirstChild("DriveSeat", true) or carModel:FindFirstChild("DriverSeat", true) or carModel == workspace

if carModel == workspace then
	warn("[ERROR]: " .. doorGroup.Name)
end

local carBody = carModel:FindFirstChild("DriveSeat", true) or carModel:FindFirstChild("DriverSeat", true)
local targetSeat = carModel:FindFirstChild(TARGET_SEAT_NAME, true)

local weld = Instance.new("Weld")
weld.Name = "HingeWeld_" .. doorGroup.Name
weld.Part0 = carBody
weld.Part1 = hinge
weld.C0 = carBody.CFrame:Inverse() * hinge.CFrame
weld.C1 = CFrame.new()
weld.Parent = hinge

local isOpen = false

local tweenInfo = TweenInfo.new(
	0.3, 
	Enum.EasingStyle.Back, 
	Enum.EasingDirection.Out
)

local openAngleOffset = CFrame.Angles(0, math.rad(-55), 0)
local closedC0 = weld.C0
local openC0 = closedC0 * openAngleOffset

local currentPassenger = nil

local function setDoorState(open)
	isOpen = open
	if prompt then
		prompt.ActionText = isOpen and "Driver Door" or "Driver Door"
		prompt.Enabled = not (targetSeat and targetSeat.Occupant)
	end

	local doorSound = hinge:FindFirstChild("DoorSound")
	if doorSound then
		doorSound:Play()
	end

	local targetC0 = isOpen and openC0 or closedC0
	local tween = TweenService:Create(weld, tweenInfo, {C0 = targetC0})
	tween:Play()
end

if prompt then
	prompt.Triggered:Connect(function()
		setDoorState(not isOpen)
	end)
end

if targetSeat then
	targetSeat:GetPropertyChangedSignal("Occupant"):Connect(function()
		local humanoid = targetSeat.Occupant

		if humanoid then
			currentPassenger = humanoid.Parent 
			if isOpen then
				setDoorState(false)
			end
		else
			if currentPassenger then
				local character = currentPassenger
				currentPassenger = nil 

				if not isOpen then
					setDoorState(true)
				end

				if spawnExit and character:FindFirstChild("HumanoidRootPart") then
					task.wait(0.05)
					character.HumanoidRootPart.CFrame = spawnExit.CFrame
				end
			end
		end
	end)
end
