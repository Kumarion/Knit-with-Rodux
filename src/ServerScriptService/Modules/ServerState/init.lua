local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Rodux = require(ReplicatedStorage.Packages.Rodux)

local reducer = Rodux.combineReducers({
	test = require(script.Reducers.Test),
})

local store = Rodux.Store.new(reducer, {}, {
	Rodux.thunkMiddleware, --Rodux.loggerMiddleware,
})

return store