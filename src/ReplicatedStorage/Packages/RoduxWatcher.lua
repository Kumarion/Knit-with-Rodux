--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Rodux = require(ReplicatedStorage.Packages.Rodux)

return function(store)
	return function(selector, onChange)
		local value = selector(store:getState())

		local connection = store.changed:connect(function(newState, _oldState)
			local newValue = selector(newState)
			
			if newValue == value then
				return
			end
			
			value = newValue
			onChange(value)
		end)

		onChange(value)
		return connection.disconnect
	end
end