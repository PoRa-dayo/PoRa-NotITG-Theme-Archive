function ScrAddSuffix(ScreenName)
    local suffix = ""
    if PopCandyIsOriginal() then
        suffix = "Original"
    end
    return ScreenName..suffix
end

function ScrGameplayAddSuffix(ScreenName)
    local suffix = ""
    if PopCandyGameplayIsOriginal() then
        suffix = "Original"
    end
    return ScreenName..suffix
end

function ScreenTitleBranch()
	if GAMESTATE:GetCoinMode() == COIN_MODE_HOME then return ScrAddSuffix("ScreenTitleMenu") end
	return ScrAddSuffix("ScreenTitleJoin")
end

function ScreenCautionBranch()
	return ScrAddSuffix("ScreenCaution")
end

function SongSelectionScreen()
	if PlayModeName() == "Nonstop" then return ScrAddSuffix("ScreenSelectCourseNonstop") end
	if PlayModeName() == "Oni" then return ScrAddSuffix("ScreenSelectCourseOni") end
	if PlayModeName() == "Endless" then return ScrAddSuffix("ScreenSelectCourseEndless") end
	return ScrAddSuffix("ScreenSelectMusic")
end

function SelectFirstOptionsScreen()
	if PlayModeName() == "Rave" then return "ScreenRaveOptions" end
	return "ScreenPlayerOptions"
end

function GetGameplayScreen()
	if IsExtraStage() or IsExtraStage2() or IsFinalStage() then return ScrGameplayAddSuffix("ScreenGameplayExtra") end
    if GAMESTATE:IsCourseMode() then return ScrGameplayAddSuffix("ScreenGameplayCourse") end
	return ScrGameplayAddSuffix("ScreenGameplay")
end

function SelectEvaluationScreen()
	Mode = PlayModeName()
	if( Mode == "Regular" ) then return ScrAddSuffix("ScreenEvaluationStage") end
	if( Mode == "Nonstop" ) then return ScrAddSuffix("ScreenEvaluationNonstop") end
	if( Mode == "Oni" ) then return ScrAddSuffix("ScreenEvaluationOni") end
	if( Mode == "Endless" ) then return ScrAddSuffix("ScreenEvaluationEndless") end
	if( Mode == "Rave" ) then return ScrAddSuffix("ScreenEvaluationRave") end
	if( Mode == "Battle" ) then return ScrAddSuffix("ScreenEvaluationBattle") end
end

function IsEventMode()
	return PREFSMAN:GetPreference( "EventMode" )
end

-- Checks if the player is available to access the extra stage.
-- Current System works like this:
-- To obtain the Extra Stage, all players must have an accumulated score of 93% or higher.
-- Failing to obtain these will result just sending you back to the final evaluation screen.
--NOT USED (Extra stages seem to be broken in NotITG)
function AbleToEnterExtraStage()

	local ValueToPass = 0.93
	local function PEnabled(pn)
		return GAMESTATE:IsPlayerEnabled(pn)
	end

	local function StatsCombined(pn, n1, n2, n3)
		return GetPSStageStats(pn):GetTapNoteScores(n1) + GetPSStageStats(pn):GetTapNoteScores(n2) + GetPSStageStats(pn):GetTapNoteScores(n3)
	end

	if IsFinalStage() then
		
		if PEnabled(PLAYER_1) and not PEnabled(PLAYER_2) then
			if ( AccumScoreActual(PLAYER_1) / AccumScorePossible(PLAYER_1) ) >= ValueToPass then
				return true
			else
				return false
			end
		end

		if PEnabled(PLAYER_2) and not PEnabled(PLAYER_1) then
			if ( AccumScoreActual(PLAYER_2) / AccumScorePossible(PLAYER_2) ) >= ValueToPass then
				return true
			else
				return false
			end
		end

		if PEnabled(PLAYER_1) and PEnabled(PLAYER_2) then
			if ( AccumScoreActual(PLAYER_1) / AccumScorePossible(PLAYER_1) ) >= ValueToPass and ( AccumScoreActual(PLAYER_2) / AccumScorePossible(PLAYER_2) ) >= ValueToPass then
				return true
			else
				return false
			end
		end

	end

end

-- For "EvalOnFail", do:
-- function GetGameplayNextScreen() return SelectEvaluationScreen() end

function GetGameplayNextScreen()
	Trace( "GetGameplayNextScreen: " )
	local Passed = not AllFailed()
	Trace( " Passed = "..tostring(Passed) )
	Trace( " IsSyncDataChanged = "..tostring(GAMESTATE:IsSyncDataChanged()) )
	Trace( " IsCourseMode = "..tostring(GAMESTATE:IsCourseMode()) )
	Trace( " IsExtraStage = "..tostring(IsExtraStage()) )
	Trace( " IsExtraStage2 = "..tostring(IsExtraStage2()) )
	Trace( " Event mode = "..tostring(IsEventMode()) )
	
	if GAMESTATE:IsSyncDataChanged() then 
		return "ScreenSaveSync"
	end

	if Passed or GAMESTATE:IsCourseMode() or
		IsExtraStage() or IsExtraStage2()
	then
		Trace( "Go to evaluation screen" )
		return SelectEvaluationScreen()
	end

	if IsEventMode() then
		Trace( "Go to song selection screen" )
		-- DeletePreparedScreens()
		return SongSelectionScreen()
	end

	Trace( "ScreenGameOver" )
	return "ScreenGameOver"
end

local function ShowScreenInstructions()
	if not PREFSMAN:GetPreference("ShowInstructions") then
		return false
	end

	if GAMESTATE:GetPlayMode() == PLAY_MODE_INVALID then
		Trace( "ShowScreenInstructions: called without PlayMode set" )
		return true
	end

	if GAMESTATE:GetPlayMode() ~= PLAY_MODE_REGULAR then
		return true
	end

	for pn = PLAYER_1,NUM_PLAYERS-1 do
		if GAMESTATE:GetPreferredDifficulty(pn) <= DIFFICULTY_EASY then
			return true
		end
	end

	return false
end

function GetScreenInstructions()
	if not ShowScreenInstructions() then
		return THEME:GetMetric("ScreenInstructions","NextScreen")
	else
		return ScrAddSuffix("ScreenInstructions")
	end
end

function OptionsMenuAvailable()
	if GAMESTATE:IsExtraStage() or GAMESTATE:IsExtraStage2() then return false end
	return true
end

function ModeMenuAvailable()
	local PickExtraStage = PREFSMAN:GetPreference( "PickExtraStage" )
	if (GAMESTATE:IsExtraStage() and not PickExtraStage) or GAMESTATE:IsExtraStage2() then
		return false
	end
	return true
end

-- (c) 2005 Glenn Maynard, Chris Danford
-- All rights reserved.
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a
-- copy of this software and associated documentation files (the
-- "Software"), to deal in the Software without restriction, including
-- without limitation the rights to use, copy, modify, merge, publish,
-- distribute, and/or sell copies of the Software, and to permit persons to
-- whom the Software is furnished to do so, provided that the above
-- copyright notice(s) and this permission notice appear in all copies of
-- the Software and that both the above copyright notice(s) and this
-- permission notice appear in supporting documentation.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
-- OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
-- THIRD PARTY RIGHTS. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
-- INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
-- OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS
-- OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
-- OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
-- PERFORMANCE OF THIS SOFTWARE.

