
function ScreenSelectMusicPrev() banner = 0 return "ScreenSelectWorld" end
function SelectFirstOptionsScreen() banner = 9 return "ScreenPlayerOptions"..world .. dark end
function ScreenTitleBranch() if GAMESTATE:GetCoinMode() == COIN_MODE_HOME then return "ScreenTitleMenu" end return "ScreenTitleJoin" end
function SongSelectionScreen() banner = world return "ScreenSelectMusic" .. world .. dark end
function SongSelectionScreenNotMarathon()
    if world == 8 then
        world = 1
    end
    banner = world
    return "ScreenSelectMusic" .. world .. dark
end

function GetGameplayNextScreen()
	if GAMESTATE:IsSyncDataChanged() then return "ScreenSaveSync"
	elseif warp == 11 then return "ScreenEvaluation" .. world .. 'B'
	elseif warp == 12 then return "ScreenEvaluation" .. world .. 'W'
	elseif warp == 13 then return "ScreenEvaluation" .. world .. 'G'
	else return "ScreenEvaluation" .. world .. dark end
end	

