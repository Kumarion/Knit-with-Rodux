local Players = game:GetService("Players");
local RunService = game:GetService("RunService");

local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit);
local Promise = require(Knit.Util.Promise);
local SaveStructure = require(script.SaveStructure);
local ProfileService = require(Knit.Util.ProfileService);
local ReplicaService = require(Knit.Util.ReplicaService);
local Key = require(script.Key);
local Thread = require(Knit.Util.Thread);

local Profiles = {};
local Replicas = {};
local PlayerProfileClassToken = ReplicaService.NewClassToken("PlayerData");
local ProfileStore = ProfileService.GetProfileStore("PlayerData_" .. Key, SaveStructure);

if (RunService:IsStudio() == true) then
	--// because we like to test in studio :)
	ProfileStore = ProfileStore.Mock;
end

local DataService = Knit.CreateService{
	Name = "DataService",
	Client = {}
}

function DoExtraLoading(Player, Profile)	
	local LeaderstatsFolder = Instance.new("Folder");
	LeaderstatsFolder.Name = "leaderstats";
	LeaderstatsFolder.Parent = Player;
	
	local Data = Profile.Data.Config;
	local Money = Instance.new("NumberValue");
	Money.Name = "Money";
	Money.Value = Data.Money;
	Money.Parent = LeaderstatsFolder;
end

function DataService:GetProfileStore()
	return ProfileStore;
end

function DataService:GetReplica(Player)	
	return Promise.new(function(Resolve, Reject)
		assert(typeof(Player) == "Instance" and Player:IsDescendantOf(Players), "Value passed is not a valid player")

		if not Profiles[Player] and not Replicas[Player] then
			repeat 
				if Player then
					task.wait()
				else
					Reject("Player left the game")
				end
			until Profiles[Player] and Replicas[Player]
		end

		local Profile = Profiles[Player]
		local Replica = Replicas[Player]
		
		if Profile and Profile:IsActive() then
			if Replica and Replica:IsActive() then
				Resolve(Replica)
			else
				Reject("Replica did not exist or wasn't active")
			end
		else
			Reject("Profile did not exist or wasn't active")
		end
	end)
end

function DataService:Update(Player, Data)
	local LeaderstatsFolder = Player:FindFirstChild("leaderstats");
	for i,v in pairs(LeaderstatsFolder:GetChildren()) do
		if Data[tostring(v.Name)] then
			v.Value = Data[tostring(v.Name)];
		end;
	end;
end

function DataService:GetProfile(Player)
	if Profiles[Player] == nil then
		return;
	end;
	
	return Profiles[Player];
end

function DataService:GetPlayerData(Player)
	local Profile = self:WaitForProfile(Player);
	
	if Profile then
		return Profile.Data.Config;
	end;
end

function DataService:SetReplicaData(Player, DataName, Data)
	local ReplicaFound = Replicas[Player];

	if (ReplicaFound ~= nil) then
		ReplicaFound:SetValue({"Config", DataName}, Data);
	end;
end

function DataService:Change(Player, Stat, Action, Value)
	--// Finally get the data and set it
	if not Player:IsDescendantOf(Players) then
		return;
	end;

	local Profile = Profiles[Player];

	if not Profile then
		return;
	end;

	local ConfigData = Profile.Data.Config;

	if (Profile) and (Profile:IsActive() == false) then
		return;
	end;

	if Profile then
		if Action == "Change" then
			ConfigData[Stat] = Value;
		elseif Action == "Add" then
			ConfigData[Stat] = ConfigData[Stat] + Value;
		elseif Action == "Subtract" then
			ConfigData[Stat] = ConfigData[Stat] - Value;
		end;

		Replicas[Player]:SetValue({"Config", Stat}, ConfigData[Stat]);
		self:Update(Player, Profile.Data.Config);
	end;
end

local function PlayerAdded(Player)
	local StartTime = tick()
	local Profile = ProfileStore:LoadProfileAsync("Player_" .. Player.UserId)

	if Profile then
		Profile:AddUserId(Player.UserId)
		Profile:Reconcile()
		
		Profile:ListenToRelease(function()
			Profiles[Player] = nil
			Replicas[Player]:Destroy()
			Replicas[Player]= nil
			Player:Kick("Profile was released")
		end)

		if Player:IsDescendantOf(Players) == true then
			Profiles[Player] = Profile
			local Replica = ReplicaService.NewReplica({
				ClassToken = PlayerProfileClassToken,
				Tags = {["Player"] = Player},
				Data = Profile.Data,
				Replication = "All"
			});

			Replicas[Player] = Replica;
			DoExtraLoading(Player, Profile);
			warn(Player.Name .. "'s profile has been loaded. " .. "("..string.sub(tostring(tick() - StartTime), 1, 5) .. ")");
		else
			Profile:Release()
		end
	else
		Player:Kick("Profile == nil") 
	end
end

function DataService:WaitForProfile(Player)
	while Profiles[Player] == nil do
		task.wait();
	end;
	
	return Profiles[Player];
end

function DataService:KnitInit()
	for _, player in ipairs(Players:GetPlayers()) do
		Thread.SpawnNow(PlayerAdded, player)
	end

	Players.PlayerAdded:Connect(PlayerAdded)

	Players.PlayerRemoving:Connect(function(Player)
		if Profiles[Player] then
			Profiles[Player]:Release()
		end
	end)
end

function DataService:KnitStart()

end

return DataService