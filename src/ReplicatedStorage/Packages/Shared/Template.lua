local template = {
	--// Gamepass Indexing
	--// Here we can iterate the gamepass settings and load them accordingly.
	--// Index being the Gamepass ID and Value.PassName being the name of the pass.
	
	["Products"] = {
		["product1"] = 0,
	},
	
	["Gamepasses"] = {
		0, -- product1
	},
	
	["GamepassNameMap"] = {
		["gamepass1"] = 0,
	},
};

return template;