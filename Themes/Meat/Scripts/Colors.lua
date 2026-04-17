function DifficultyColor( dc )
	if dc == DIFFICULTY_BEGINNER	then return "#D05CF6" end
	if dc == DIFFICULTY_EASY		then return "#09FF10" end
	if dc == DIFFICULTY_MEDIUM		then return "#F3F312" end
	if dc == DIFFICULTY_HARD		then return "#EA3548" end
	if dc == DIFFICULTY_CHALLENGE	then return "#16AFF3" end
	if dc == DIFFICULTY_EDIT		then return "#F7F7F7" end
	return "1,1,1,1"
end

function DifficultyColorRGB( dc )
	if dc == DIFFICULTY_BEGINNER	then return .82,.36,.96,1 end
	if dc == DIFFICULTY_EASY		then return .04,1.0,.06,1 end
	if dc == DIFFICULTY_MEDIUM		then return .95,.95,.07,1 end
	if dc == DIFFICULTY_HARD		then return .92,.21,.28,1 end
	if dc == DIFFICULTY_CHALLENGE	then return .08,.69,.92,1 end
	if dc == DIFFICULTY_EDIT		then return .97,.97,.97,1 end
	return 1,1,1,1
end

function EditMenuColor(diff)
	dc = nil
	if diff == "Novice" 	then dc = DIFFICULTY_BEGINNER end
	if diff == "Easy" 		then dc = DIFFICULTY_EASY end
	if diff == "Medium" 	then dc = DIFFICULTY_MEDIUM end
	if diff == "Hard" 		then dc = DIFFICULTY_HARD end
	if diff == "Expert"		then dc = DIFFICULTY_CHALLENGE end
	if diff == "Edit"		then dc = DIFFICULTY_EDIT end
	return DifficultyColorRGB( dc )
end

function JudgmentColorBase( n )
	local c = {}
	if n == 1 then c={0,.86,1} end
	if n == 2 then c={1,.60,0} end
	if n == 3 then c={.04,1,0} end
	if n == 4 then c={.62,0,.97} end
	if n == 5 then c={1,.42,0} end
	if n == 6 then c={1,0,0} end
	return c
end

function JudgmentColorLight( n , a )
	local c = JudgmentColorBase( n )
	for i,k in ipairs(c) do c[i] = k+(1-k)*a end
	return c[1],c[2],c[3],1
end

function JudgmentColorDark( n , a )
	local c = JudgmentColorBase( n )
	for i,k in ipairs(c) do c[i] = k+(.8-k)*a end
	return c[1],c[2],c[3],1
end	