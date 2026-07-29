
function ScreenSelectMusicPrev() ITGMeatGlob.banner = 0 return "ScreenSelectWorld" end
function SelectFirstOptionsScreen() ITGMeatGlob.banner = 9 return "ScreenPlayerOptions"..ITGMeatGlob.world .. ITGMeatGlob.dark end
function ScreenTitleBranch() if GAMESTATE:GetCoinMode() == COIN_MODE_HOME then return "ScreenTitleMenu" end return "ScreenTitleJoin" end
function SongSelectionScreen() ITGMeatGlob.banner = ITGMeatGlob.world return "ScreenSelectMusic" .. ITGMeatGlob.world .. ITGMeatGlob.dark end
function SongSelectionScreenNotMarathon()
    if ITGMeatGlob.world == 8 then
        ITGMeatGlob.world = 1
    end
    ITGMeatGlob.banner = ITGMeatGlob.world
    return "ScreenSelectMusic" .. ITGMeatGlob.world .. ITGMeatGlob.dark
end

function GetGameplayNextScreen()
	if GAMESTATE:IsSyncDataChanged() then return "ScreenSaveSync"
	elseif ITGMeatGlob.warp == 11 then return "ScreenEvaluation" .. ITGMeatGlob.world .. 'B'
	elseif ITGMeatGlob.warp == 12 then return "ScreenEvaluation" .. ITGMeatGlob.world .. 'W'
	elseif ITGMeatGlob.warp == 13 then return "ScreenEvaluation" .. ITGMeatGlob.world .. 'G'
	else return "ScreenEvaluation" .. ITGMeatGlob.world .. ITGMeatGlob.dark end
end	

