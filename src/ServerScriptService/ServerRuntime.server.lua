local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit);
local Component = require(Knit.Util.Component);
local Components = script.Parent:WaitForChild("Components");
local Cmdr = require(script.Parent.Cmdr);

local StartTime = tick();
Knit.AddServicesDeep(script.Parent.Services);

for _, ComponentModule in ipairs(Components:GetDescendants()) do
	if ComponentModule:IsA("ModuleScript") then
		local function Load()
			require(ComponentModule);
		end;

		task.spawn(Load);
	end;
end;

Knit.Start():andThen(function()
	warn("Loaded server. " .. (string.sub(tostring(tick() - StartTime), 1, 5)) .. "ms.");
	Cmdr:RegisterDefaultCommands();
end):catch(function(err)
	warn("framework failure: " .. tostring(err));
end);