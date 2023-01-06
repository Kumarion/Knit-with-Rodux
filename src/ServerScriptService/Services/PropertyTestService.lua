local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local PropertyTestService = Knit.CreateService{
	Name = "PropertyTestService",
	Client = {
		SomeData = Knit.CreateProperty({}),
	}
}

function PropertyTestService:SetData()
	self.Client.SomeData:Set({ImCool = true})
end

function PropertyTestService:KnitInit()
	game.Players.PlayerAdded:Connect(function(player)
		if (player.Name == "Name") then
			self.Client.SomeData:SetFor(player, {ImCool = true})
		end
	end)
	--self:SetData();
end

function PropertyTestService:KnitStart()
	
end

return PropertyTestService