local ProfileNames = {
	-- Profile Names that will appear in Select Music and the Options Menu
	-- The names won't update until you restart the game or use F3+R

	-- Player 1
	"Player 1",

	-- Player 2
	"Player 2",
}

function GetProfileName(n)
	return ProfileNames[n]
end
