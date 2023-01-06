local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.Packages.Rodux)
local Sift = require(ReplicatedStorage.Packages.sift)

local initialState = {}

local reducer = Rodux.createReducer(initialState, {
	SetPlayerData = function(state, action)
		return Sift.Dictionary.merge(state, {
			[action.key] = action.value,
		})
	end,
})

return reducer
