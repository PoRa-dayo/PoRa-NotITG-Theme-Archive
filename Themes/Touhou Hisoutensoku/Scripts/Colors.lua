-- Main Player Colors
function PlayerColor( pn )
	return "1,1,1,1"
end

-- Main Difficulty Colors
function DifficultyColor( dc )
	if dc == DIFFICULTY_BEGINNER		then return "0.04,1,0.06,1" end
	if dc == DIFFICULTY_EASY		then return "0.09,0.69,0.95,1" end
	if dc == DIFFICULTY_MEDIUM		then return "0.95,0.95,0.07,1" end
	if dc == DIFFICULTY_HARD		then return "0.82,0.36,0.96,1" end
	if dc == DIFFICULTY_CHALLENGE		then return "0.92,0.21,0.28,1" end
	if dc == DIFFICULTY_EDIT		then return "0.97,0.97,0.97,1" end
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

