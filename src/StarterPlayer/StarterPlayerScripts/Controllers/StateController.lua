local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local StateController = Knit.CreateController{
	Name = "StateController",
}
local StateClient = require(script.Parent.Parent.Modules.ClientState);
local RoduxWatcher = require(Knit.Util.RoduxWatcher);
local Watcher = RoduxWatcher(StateClient);

function StateController:KnitInit()
	-- Setup a watcher for our stats reducer
	Watcher(function(state) return state.test.selected end, 
		function(selected)
			print("Client selected:", selected) 
		end
	);
	
	Watcher(function(state) return state.test.testCash end, 
		function(cash)
			print("Client cash:", cash) 
		end
	);
end

function StateController:KnitStart()
	-- Dispatch a couple of purchases
	StateClient:dispatch({
		type = "SetSelected",
		newSelection = "ThisIsANewSelection"
	});
end

return StateController
