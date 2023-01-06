local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local PropertyTestController = Knit.CreateController{
	Name = "PropertyTestController",
}
local PropertyTestService

function PropertyTestController:KnitInit()
	PropertyTestService = Knit.GetService("PropertyTestService");
	PropertyTestService.SomeData:Observe(function(data)
		print("**Observed the property on the server:")
		
		for i,v in pairs(data) do
			print(i, v)
		end
	end)
end

function PropertyTestController:KnitStart()
	
end

return PropertyTestController