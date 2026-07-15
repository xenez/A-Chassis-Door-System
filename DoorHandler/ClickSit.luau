local seat = script.Parent
local clickDetector = seat:WaitForChild("ClickDetector")

clickDetector.MaxActivationDistance = 32 

clickDetector.MouseClick:Connect(function(player)
  if seat.Occupant then return end

	local character = player.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")

      if humanoid and humanoid.Health > 0 and humanoid.Sit == false then
			seat:Sit(humanoid)
		end
	end
end)
