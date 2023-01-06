local TotalPixelsPerRow = 120;
local TotalPixelsPerColumn = 60;
local Step = 2;

local function GeneratePixels()
	local PartPositionInLoop = 0;
	
	for X = 1, TotalPixelsPerRow * Step, Step do
		for Y = 1, TotalPixelsPerColumn * Step, Step do
			PartPositionInLoop += 1;

			local Part = Instance.new("Part");
			Part.Size = Vector3.new(Step, Step, Step);
			Part.Position = Vector3.new((workspace.Start.Position.X + 1) - X, (workspace.Start.Position.Y - 1) + Y, workspace.Start.Position.Z - Part.Position.Z);
			Part.Anchored = true;
			Part.BrickColor = BrickColor.Random();
			Part.Name = PartPositionInLoop
			Part.Parent = workspace.Pixels;
		end;
	end;
end

GeneratePixels();