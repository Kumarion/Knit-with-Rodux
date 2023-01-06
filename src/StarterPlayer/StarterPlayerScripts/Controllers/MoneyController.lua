local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local State = require(script.Parent.Parent.Modules.ClientState)
local RoduxWatcher = require(Knit.Util.RoduxWatcher)

local MoneyController = Knit.CreateController{
	Name = "MoneyController",
}
local Watcher = RoduxWatcher(State)

function MoneyController:KnitInit()
	Watcher(function(state) return state.playerData end, 
		function(playerData)
			print("Client player data:", playerData) 
		end
	);
end

function MoneyController:KnitStart()
	
end

return MoneyController
