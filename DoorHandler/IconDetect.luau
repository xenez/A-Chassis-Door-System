local seat = script.Parent
local clickDetector = seat:WaitForChild("ClickDetector")

local CUSTOM_TEXT = "Sit"
local ICON_ID = "rbxassetid://6031225818"

clickDetector:SetAttribute("IsVehicle", true)
clickDetector:SetAttribute("CustomText", CUSTOM_TEXT)
clickDetector:SetAttribute("CustomIcon", ICON_ID)

clickDetector.MaxActivationDistance = 9

clickDetector.MouseClick:Connect(function(player)
	if seat.Occupant then return end

	local character = player.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid and humanoid.Health > 0 and not humanoid.Sit then
			seat:Sit(humanoid)
		end
	end
end)
