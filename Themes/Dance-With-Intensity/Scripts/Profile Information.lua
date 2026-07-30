local ProfileNames = {
	-- Profile Names that will appear in Select Music and the Options Menu
	-- The names won't update until you restart the game or use F3+R

	-- Player 1
	"Player 1",

	-- Player 2
	"Player 2",
}

function GetProfileName(n)
    --prioritize stepmania's built-in local profile names
    if PROFILEMAN:IsPersistentProfile(n-1) then
        local Naem = GAMESTATE:GetPlayerDisplayName(n-1)
        if Naem ~= '' then
            return GAMESTATE:GetPlayerDisplayName(n-1)
        end
    end
	return ProfileNames[n]
end
