function PlayerColor( pn )
	if pn == PLAYER_1 then return "#FBBE03" end	-- orange
	if pn == PLAYER_2 then return "#56FF48" end	-- green
	return "1,1,1,1"
end

function DifficultyColor( dc )
	if dc == DIFFICULTY_BEGINNER	then return "0.2,1,0.2,1" end
	if dc == DIFFICULTY_EASY		then return "0.4,1.0,0.8,1" end
	if dc == DIFFICULTY_MEDIUM		then return "0,0.7,1,1" end
	if dc == DIFFICULTY_HARD		then return "1,0.8,0.2,1" end
	if dc == DIFFICULTY_CHALLENGE	then return "1,0.2,0.2,1" end
	if dc == DIFFICULTY_EDIT		then return "0.5,0.5,0.5,1" end
	return "1,1,1,1"
end

-- Get a color to show text on top of difficulty frames.
function ContrastingDifficultyColor( dc )
	if dc == DIFFICULTY_BEGINNER	then return "0.2,1,0.2,1" end
	if dc == DIFFICULTY_EASY		then return "0.4,1.0,0.8,1" end
	if dc == DIFFICULTY_MEDIUM		then return "0,0.7,1,1" end
	if dc == DIFFICULTY_HARD		then return "1,0.8,0.2,1" end
	if dc == DIFFICULTY_CHALLENGE	then return "1,0.2,0.2,1" end
	if dc == DIFFICULTY_EDIT		then return "0.5,0.5,0.5,1" end
	return "1,1,1,1"
end

function DiffuseDifficultyTopGradient( self,dc )
	if dc == DIFFICULTY_BEGINNER	then self:diffusetopedge(0.1,0.8,0,1) return end
	if dc == DIFFICULTY_EASY		then self:diffusetopedge(0,0.8,0.7,1) return end
	if dc == DIFFICULTY_MEDIUM		then self:diffusetopedge(0,0.75,0.9,1) return end
	if dc == DIFFICULTY_HARD		then self:diffusetopedge(1,0.6,0.2,1) return end
	if dc == DIFFICULTY_CHALLENGE	then self:diffusetopedge(1,0.1,0,1) return end
	if dc == DIFFICULTY_EDIT		then self:diffusetopedge(0.5,0.5,0.5,1) return end
	self:diffusetopedge(1,1,1,1)
end

function DiffuseDifficultyBottomGradient( self,dc )
	if dc == DIFFICULTY_BEGINNER	then self:diffusebottomedge(0.2,1,0.2,1) return end
	if dc == DIFFICULTY_EASY		then self:diffusebottomedge(0.5,1.0,0.8,1) return end
	if dc == DIFFICULTY_MEDIUM		then self:diffusebottomedge(0.4,0.9,0.9,1) return end
	if dc == DIFFICULTY_HARD		then self:diffusebottomedge(1,0.85,0.4,1) return end
	if dc == DIFFICULTY_CHALLENGE	then self:diffusebottomedge(1,0.5,0.1,1) return end
	if dc == DIFFICULTY_EDIT		then self:diffusebottomedge(0.7,0.7,0.7,1) return end
	self:diffusebottomedge(1,1,1,1)
end

