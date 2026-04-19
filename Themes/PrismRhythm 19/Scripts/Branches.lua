function HubIsConnected()
	-- This is a Home build, so we never have a USB card hub, so it should always
	-- say you don't have one.
	return false
end

function ScreenTitleBranch()
	-- We always re-set Awesome Mode to Off when we go back to the title screen,
	-- so that it isn't always active.
	AwesomeModeSet(0)
	-- If we're in Home mode, we give players the menu.  Otherwise, they just
	-- get the title screen.
	if GAMESTATE:GetCoinMode() == COIN_MODE_HOME then return "ScreenTitleMenu" end
	return "ScreenTitleJoin"
end

function EvaluationNextScreen()
	-- If we're playing in Event Mode, NextScreen from here is always Song Select.
	if GAMESTATE:IsEventMode() then return SongSelectionScreen() end
	-- [Old] if AllFailed() or IsFinalStage() then return "ScreenNameEntryTraditional" end
	-- If Awesome Mode is off, and either everyone failed or the set is over,
	-- the NextScreen is name entry, since they're done playing.
	if (AwesomeMode == 0 and AllFailed()) or IsFinalStage() then return "ScreenNameEntryTraditional" end
	return SongSelectionScreen();
end

function ScreenTitleBranch()
	if GAMESTATE:GetCoinMode() == COIN_MODE_HOME then return "ScreenTitleMenu" end
	if GAMESTATE:IsEventMode() then return "ScreenEventMenu" end
	return "ScreenTitleJoin"
end


function EvaluationNextScreen()
	-- More stuff regarding what the next screen should be after Eval.
	Trace( "GetGameplayNextScreen: " )
	Trace( " AllFailed = "..tostring(AllFailed()) )
	Trace( " IsEventMode = "..tostring(GAMESTATE:IsEventMode()) )
	Trace( " IsFinalStage = "..tostring(IsFinalStage()) )

	if GAMESTATE:IsEventMode() then return SongSelectionScreen() end
	if AllFailed() or IsFinalStage() then return "ScreenNameEntryTraditional" end
	return SongSelectionScreen();
end


function GetGameplayNextScreen()
	-- Where we go after a stage is cleared or failed.  Also cares about resyncs.
	Trace( "GetGameplayNextScreen: " )
	Trace( " AllFailed = "..tostring(AllFailed()) )
	Trace( " IsEventMode = "..tostring(GAMESTATE:IsEventMode()) )
	Trace( " IsSyncDataChanged = "..tostring(GAMESTATE:IsSyncDataChanged()) )

	if GAMESTATE:IsSyncDataChanged() then 
		return "ScreenSaveSync"
	end
		
	-- Never show evaluation for training.
	if GAMESTATE:GetCurrentSong():GetSongDir() == "Songs/In The Groove/Training1/" then 
		if GAMESTATE:IsEventMode() then 
			return SongSelectionScreen()
		else
			return EvaluationNextScreen()
		end
	elseif AllFailed() and not GAMESTATE:IsCourseMode() then 
		if GAMESTATE:IsEventMode() then 
			return SelectEvaluationScreen()
		else
			return "ScreenNameEntryTraditional"
		end
	else 
		return SelectEvaluationScreen() 
	end
	
	return "GetGameplayNextScreen: YOU SHOULD NEVER GET HERE"
end


function SelectEndingScreen()
	-- We generally require players to score at least a Star to get the good ending.
	-- If they score less than that, they see the normal ending.
	if GAMESTATE:GetEnv("ForceGoodEnding") == "1" or GetBestFinalGrade() <= GRADE_TIER05 then return "ScreenEndingGood" end
	return "ScreenEndingNormal"
end


function ScreenAfterGameplayWorkout()
	if GAMESTATE:GetPlayMode() == PLAY_MODE_NONSTOP then return "ScreenEvaluationNonstopWorkout" end
	if GAMESTATE:GetPlayMode() == PLAY_MODE_ENDLESS then return "ScreenEvaluationNonstopWorkout" end
	return "ScreenEvaluationStageWorkout"
end


function GetScreenEvaluationNonstopWorkoutNextScreen()
	if GAMESTATE:GetPlayMode() == PLAY_MODE_ENDLESS then return "ScreenWorkoutMenu" end
	return "ScreenSelectMusicCourse"
end


function GetGameplayScreen()
	-- Fetches training stuff if needed, otherwise just tells the game to go ahead
	-- and use the normal gameplay screen.
	local Song = GAMESTATE:GetCurrentSong();
	if Song and Song:GetSongDir() == "Songs/In The Groove/Training1/" then
		return "ScreenGameplayTraining"
	end

	return "ScreenGameplay"
end


function SongSelectionScreen()
	local s = "ScreenSelectMusic";
	if GAMESTATE:IsCourseMode() then s = s.."Course" end
	return s
end


function ScreenSelectMusicPrevScreen()
	if GAMESTATE:GetEnv("Workout") then return "ScreenWorkoutMenu" end
	return ScreenTitleBranch()
end


function OptionsMenuAvailable()
	-- Determines if players can use the Mod Menu (the usual one).
	-- They usually can; in DDR, they can't if they're going into Extra stages,
	-- and in ITG, they can't for Survivals (which use the DDR Oni designation).
	if GAMESTATE:IsExtraStage() or GAMESTATE:IsExtraStage2() then return false end
	if GAMESTATE:GetPlayMode()==PLAY_MODE_ONI then return false end
	return true
end


function GetSetTimeNextScreen()
	-- This is called only when we move to the next screen, so we only mark the time set
	-- when the screen is cleared.  That way, if the game is started by the operator and
	-- powered down before setting the screen, we still go to ScreenSetTime on the next boot.
	PROFILEMAN:GetMachineProfile():GetSaved().TimeIsSet = true
	PROFILEMAN:SaveMachineProfile()

	return "ScreenOptionsMenu"
end


function GetDiagnosticsScreen()
	return "ScreenOptionsMenu"
end


function GetUpdateScreen()
	return "ScreenOptionsMenu"
end

function GetSerialNumber()
	return "ITG2-PR-19"
end
