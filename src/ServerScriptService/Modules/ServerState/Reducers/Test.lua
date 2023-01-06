local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.Packages.Rodux)
local Sift = require(ReplicatedStorage.Packages.sift)

local initialState = {
	selected = ""
}

local reducer = Rodux.createReducer(initialState, {
	SetSelected = function(state, action)
		local newSelection = action.newSelection
		
		return Sift.Dictionary.merge(state, {
			selected = newSelection
		})
	end
})

return reducer
