local shared_settings = { };

for _, module in pairs(script:GetChildren()) do
	if not shared_settings[module.Name] then
		shared_settings[module.Name] = require(module);
	end;
end;

return shared_settings;