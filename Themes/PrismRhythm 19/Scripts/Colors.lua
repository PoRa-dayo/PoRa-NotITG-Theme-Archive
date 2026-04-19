-- Main Player Colors
function PlayerColor( pn )
	if pn == PLAYER_1 then return "#99BBFF" end	-- (Blue)
	if pn == PLAYER_2 then return "#66FFFF" end	-- (Turquoise)
	return "1,1,1,1"
end

-- Main Difficulty Colors
function DifficultyColor( dc )
	if dc == DIFFICULTY_BEGINNER		then return "#D05CF6" end
	if dc == DIFFICULTY_EASY		then return "#09FF10" end
	if dc == DIFFICULTY_MEDIUM		then return "#F3F312" end
	if dc == DIFFICULTY_HARD		then return "#EA3548" end
	if dc == DIFFICULTY_CHALLENGE		then return "#16AFF3" end
	if dc == DIFFICULTY_EDIT		then return "#F7F7F7" end
	return "1,1,1,1"
end


-- Difficulty Pane Text Colors
function ContrastingDifficultyColor( dc )
	if dc == DIFFICULTY_BEGINNER		then return "#FFFFFF" end
	if dc == DIFFICULTY_EASY		then return "#FFFFFF" end
	if dc == DIFFICULTY_MEDIUM		then return "#FFFFFF" end
	if dc == DIFFICULTY_HARD		then return "#FFFFFF" end
	if dc == DIFFICULTY_CHALLENGE		then return "#FFFFFF" end
	if dc == DIFFICULTY_EDIT		then return "#FFFFFF" end
	return "1,1,1,1"
end

