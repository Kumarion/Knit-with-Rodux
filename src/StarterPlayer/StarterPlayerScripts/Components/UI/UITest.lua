local Players = game:GetService("Players");

local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit);
local Component = require(Knit.Util.Component);

local UITest = Component.new({
	Tag = "UITest",
	Ancestors = {Players},
	Extensions = {}, -- See Logger example within the example for the Extension type
})

-- Optional if UpdateRenderStepped should use BindToRenderStep:
--MyComponent.RenderPriority = Enum.RenderPriority.Camera.Value

function UITest:Construct()
	
end

function UITest:Start()
	
end

function UITest:Stop()
	
end

--function MyComponent:HeartbeatUpdate(dt) end
--function MyComponent:SteppedUpdate(dt) end
--function MyComponent:RenderSteppedUpdate(dt) end

return UITest