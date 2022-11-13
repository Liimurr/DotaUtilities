-- Generated from template
local RunUnitTests = require("RunUnitTests")

if CAddonTemplateGameMode == nil then
	CAddonTemplateGameMode = class({})
end

function Precache( context )

end

-- Create the game mode when we activate
function Activate()
	print("addon_game_mode.lua:Activate")
	GameRules.AddonTemplate = CAddonTemplateGameMode()

	print("AddonTemplate:InitGameMode")
	GameRules.AddonTemplate:InitGameMode()

	RunUnitTests()
end

function CAddonTemplateGameMode:InitGameMode()
	print( "Template addon is loaded." )
	 
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
end

-- Evaluate the state of the game
function CAddonTemplateGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end