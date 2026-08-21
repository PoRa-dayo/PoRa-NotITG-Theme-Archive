-- Global table in which to store custom mods
CustomMods = {}

-- Reset mods.  This should be called at the start of each game
-- Since tables can only be assigned by reference in Lua, we must explicitly
-- define defaults for each player.
function ResetCustomMods()
	CustomMods[PLAYER_1] = { hidescore = false, hidecombo = false }
	CustomMods[PLAYER_2] = { hidescore = false, hidecombo = false }
end

-- Do initial reset
ResetCustomMods()

-- Tournament options; currently only has hidescore
function OptionTournamentOptions()
	local t = {
		Name = "TournamentOptions",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectMultiple",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = { "Hide Score", "Hide Combo" },
		
		LoadSelections = function(self, list, pn)
			if GAMESTATE:StageIndex() == 0 then ResetCustomMods() end
			list[1] = CustomMods[pn].hidescore -- Hide score mod
			list[2] = CustomMods[pn].hidecombo -- Hide combo mod
		end,
		
		SaveSelections = function(self, list, pn)
			CustomMods[pn].hidescore = list[1] -- Hide score mod
			CustomMods[pn].hidecombo = list[2] -- Hide combo mod
		end
		
	}
	setmetatable(t, t)
	return t
end

-- Returns 1 if score is hidden, 0 otherwise; for use in metrics.ini
function IsScoreHidden(pn)
	local ret = 0
	
	if CustomMods[pn].hidescore == true then ret = 1 end
	return ret
end

function GetComboXOffset(pn)
	if CustomMods[pn].hidecombo == true then
		return 800 -- This is enough to hide it on either side
	else
		return 0 -- No offset
	end
end
