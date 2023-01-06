local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Signal = require(Knit.Util.Signal)
local Promise = require(Knit.Util.Promise)

local config = {}
local configSignals = {}
local configAllDone = false

local promiseResolutions = {}
local PlayerConfig = Knit.CreateController { Name = "PlayerConfig" }

function PlayerConfig:GetConfig()
	return config;
end

function PlayerConfig:Wait()
	if (configAllDone) then
		return Promise.resolve();
	else
		return Promise.new(function(resolve)
			table.insert(promiseResolutions, resolve);
		end);
	end;
end

function PlayerConfig:Get(key)
	return config[key];
end

function PlayerConfig:GetChangedSignal(key)
	return configSignals[key];
end

function PlayerConfig:KnitInit()
	local DataController = Knit.GetController("DataController");
	
	DataController:Await():andThen(function(profileReplica)
		for k, v in pairs(profileReplica.Data.Config) do
			config[k] = v;
			configSignals[k] = Signal.new();

			profileReplica:ListenToChange({"Config", k}, function(newValue, oldValue)
				config[k] = newValue;
				configSignals[k]:Fire(newValue, oldValue);
			end);
		end;

		configAllDone = true;
		for _, resolve in ipairs(promiseResolutions) do
			resolve();
		end;
		table.clear(promiseResolutions);
	end);
end

return PlayerConfig