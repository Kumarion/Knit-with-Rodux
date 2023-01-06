local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit);
local Component = require(Knit.Util.Component);
local ReplicaController = require(Knit.Util.ReplicaController);
local Cmdr = require(game:GetService("ReplicatedStorage"):WaitForChild("CmdrClient"));
local Thread = require(Knit.Util.Thread);

local Components = script.Parent.Components;
local StartTime = tick();
Knit.AddControllersDeep(script.Parent.Controllers);

for _, ComponentModule in ipairs(Components:GetDescendants()) do
	if ComponentModule:IsA("ModuleScript") then
		local function Load()
			require(ComponentModule);
		end;
		
		task.spawn(Load);
	end;
end;

task.spawn(ReplicaController.RequestData);

Knit.Start():andThen(function()
	warn("Loaded client. " .. (string.sub(tostring(tick() - StartTime), 1, 5)) .. "ms.");
	
	local function IsAdmin()
		local Group = 0;
		return (Knit.Player:GetRankInGroup(Group) >= 100);
	end

	if IsAdmin() then
		Cmdr:SetActivationKeys({Enum.KeyCode.Semicolon});
	else
		Cmdr:SetActivationKeys({});
	end;
end):catch(function(err)
	warn("framework failure: " .. tostring(err) .. " -- SEND THIS TO DEVELOPERS!");
end);