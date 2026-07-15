local seat = script.Parent
local animation = seat:WaitForChild("SitAnimation")
local sitTrack = nil

seat:GetPropertyChangedSignal("Occupant"):Connect(function()
	local humanoid = seat.Occupant

	if humanoid then
		local animator = humanoid:FindFirstChildOfClass("Animator")
		if animator then
			sitTrack = animator:LoadAnimation(animation)
			sitTrack.Priority = Enum.AnimationPriority.Action 
			sitTrack:Play()
		end
	else
		if sitTrack then
			sitTrack:Stop()
			sitTrack:Destroy()
			sitTrack = nil
		end
	end
end)
