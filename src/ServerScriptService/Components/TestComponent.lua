local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit);
local Component = require(Knit.Util.Component);

local MyComponent = Component.new({
	Tag = "MyComponent",
	Ancestors = {workspace},
	Extensions = {}, -- See Logger example within the example for the Extension type
})

-- Optional if UpdateRenderStepped should use BindToRenderStep:
--MyComponent.RenderPriority = Enum.RenderPriority.Camera.Value

function MyComponent:Construct()
	
end

function MyComponent:Start()
	
end

function MyComponent:Stop()
	
end

--function MyComponent:HeartbeatUpdate(dt) end
--function MyComponent:SteppedUpdate(dt) end
--function MyComponent:RenderSteppedUpdate(dt) end

return MyComponent