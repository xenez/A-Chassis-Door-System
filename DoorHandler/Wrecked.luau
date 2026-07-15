local vehicle = script.Parent
local humanoid = vehicle:WaitForChild("Humanoid")
local driveSeat = vehicle:FindFirstChildWhichIsA("VehicleSeat", true)

local replicatedStorage = game:GetService("ReplicatedStorage")
local wreckedTemplate = replicatedStorage:WaitForChild("WreckedCar")

local isDestroyed = false

humanoid.HealthChanged:Connect(function(currentHealth)
	if currentHealth <= 0 and not isDestroyed then
		isDestroyed = true

		local explosionPosition = driveSeat and driveSeat.Position or vehicle.PrimaryPart.Position
		local explosionCFrame = driveSeat and driveSeat.CFrame or vehicle.PrimaryPart.CFrame

		local explosion = Instance.new("Explosion")
		explosion.Position = explosionPosition
		explosion.BlastRadius = 0
		explosion.Parent = workspace

		local wreckClone = wreckedTemplate:Clone()

		if wreckClone.PrimaryPart then
			wreckClone:SetPrimaryPartCFrame(explosionCFrame)
		else
			wreckClone:PivotTo(explosionCFrame)
		end

		wreckClone.Parent = workspace

		game:GetService("Debris"):AddItem(wreckClone, 120)

		vehicle:Destroy()
	end
end)
