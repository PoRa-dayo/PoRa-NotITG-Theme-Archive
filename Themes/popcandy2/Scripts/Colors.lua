-- Main Player Colors
function PlayerColor( pn )
	if pn == PLAYER_1 then return "0.0,0.5,1.0,1" end
	if pn == PLAYER_2 then return "0.0,1.0,0.3,1" end
	return "1,1,1,1"
end

-- Main Difficulty Colors
function DifficultyColor( dc )
	if dc == DIFFICULTY_BEGINNER		then return "0,1,1,1" end
	if dc == DIFFICULTY_EASY		then return "#F8A800" end
	if dc == DIFFICULTY_MEDIUM		then return "#F800A0" end
	if dc == DIFFICULTY_HARD		then return "#68F800" end
	if dc == DIFFICULTY_CHALLENGE		then return "#70FFFF" end
	if dc == DIFFICULTY_EDIT		then return "#7068F8" end
    
    if dc == COURSE_DIFFICULTY_BEGINNER		then return "0,1,1,1" end
	if dc == COURSE_DIFFICULTY_EASY		then return "#F8A800" end
	if dc == COURSE_DIFFICULTY_REGULAR		then return "#F800A0" end
	if dc == COURSE_DIFFICULTY_DIFFICULT	then return "#68F800" end
	if dc == COURSE_DIFFICULTY_CHALLENGE		then return "#70FFFF" end
	if dc == COURSE_DIFFICULTY_EDIT		then return "#7068F8" end
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

