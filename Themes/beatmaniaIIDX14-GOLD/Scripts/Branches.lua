-- If the player(s) have passed AT LEAST one song, take them to the Summary screen if they back out.
-- Otherwise, return them to the main menu.
function TitleMusicRedirect()
	if GAMESTATE:StageIndex() >= 1 then 
		return "ScreenEvaluationSummaryTitle"
	else
		return "ScreenTitleMenu"
	end
end

function SongSelectionScreen()
    local mus = "ScreenSelectMusic"
    if GAMESTATE:IsCourseMode() then
        mus = "ScreenSelectCourse"
    end
    if not Profile().IIDXGoldCommonBGM or Profile().IIDXGoldCommonBGM == 'DEFAULT' then
        return mus
    elseif Profile().IIDXGoldCommonBGM == 'RANDOM' then
        local RandomBGM = CommonBGMList[math.random(#CommonBGMList-1)]
        if RandomBGM == 'DEFAULT' then
            return mus
        else            
            return mus..string.sub(RandomBGM, 1, 1) .. string.lower(string.sub(RandomBGM, 2))
        end
    else
        return mus..string.sub(Profile().IIDXGoldCommonBGM, 1, 1) .. string.lower(string.sub(Profile().IIDXGoldCommonBGM, 2))
    end
    
    return mus
end

-- Set the next screen for Evaluation.
function SetEvaluationNextScreen()
	Trace( "GetGameplayNextScreen: " )
	-- If all failed the song
	Trace( " AllFailed = "..tostring(AllFailed()) )
	-- If the game is in Event Mode.
	Trace( " IsEventMode = "..tostring(GAMESTATE:IsEventMode()) )
	-- If it's the Final Stage.
	Trace( " IsFinalStage = "..tostring(IsFinalStage()) )

	if GAMESTATE:IsEventMode() then return SongSelectionScreen() end
	if AllFailed() or IsFinalStage() and not AbleToEnterExtraStage() then return "ScreenEvaluationSummary" end
	if IsFinalStage() and AbleToEnterExtraStage() then return SongSelectionScreen() end
	return SongSelectionScreen();
end

function GetGameplayNextScreen()
	Trace( "GetGameplayNextScreen: " )
	Trace( " AllFailed = "..tostring(AllFailed()) )
	Trace( " IsEventMode = "..tostring(GAMESTATE:IsEventMode()) )
	Trace( " IsSyncDataChanged = "..tostring(GAMESTATE:IsSyncDataChanged()) )

	if GAMESTATE:IsSyncDataChanged() then 
		return "ScreenSaveSync"
	end
		
	-- Never show evaluation for training.
	-- Since it's not really neccesary.
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
			return "ScreenEvaluationStage"
		end
	else
		return SelectEvaluationScreen() 
	end
	
	return "GetGameplayNextScreen: YOU SHOULD NEVER GET HERE"
end

function OptionsMenuAvailable()
	-- Determines if players can use the Mod Menu (the usual one).
    -- In this theme you can always use it, even in Survival.
	return true
end