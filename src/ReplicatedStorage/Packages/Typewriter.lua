--// Services
local localization_service = game:GetService("LocalizationService");
local players = game:GetService("Players");
local sound_service = game:GetService("SoundService");

--// Folders

--// Requirements

--// Constants
local SOURCE_LOCALE = "en";
local CANCEL = false;

--// Variables
local player = players.LocalPlayer
local translator = nil
local typewriter = { }

--// Get the translating
pcall(function()
	translator = localization_service:GetTranslatorForPlayerAsync(player);
end)

--// CHeck if the translator is valid
if not translator then
	pcall(function()
		translator = localization_service:GetTranslatorForLocaleAsync(SOURCE_LOCALE);
	end);
end
 
local default_config = {
	delay_time = 0.02,
	extra_delay_on_space = false
};
 
function typewriter.configure(configurations)
	for key, value in pairs(default_config) do
		local new_value = configurations[key];
		
		if new_value ~= nil then
			default_config[key] = new_value;
		else
			warn(key .. " is not a valid configuration for TypeWriter module");
		end;
	end;
end
 
function typewriter.typeWrite(guiObject, text, delayBetweenChars)
	guiObject.Visible = true;
	guiObject.AutoLocalize = false;
	
	local display_text = text;

	if translator then
		display_text = translator:Translate(guiObject, text);
	end;

	display_text = display_text:gsub("<br%s*/>", "\n");
	display_text:gsub("<[^<>]->", "");

	guiObject.Text = display_text;

	local index = 0;
	
	sound_service["type"]:Play();
	for first, last in utf8.graphemes(display_text) do
		index = index + 1;
		guiObject.MaxVisibleGraphemes = index;
		
		task.wait(delayBetweenChars);
	end;
	sound_service["type"]:Stop();
end

function typewriter.cancel()
	CANCEL = true;
end
 
return typewriter