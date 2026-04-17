
world = 1
level = 1
warp = 0
goal = 0
dark = ''
lvlMax = {4,3,2,3,4,1,4,3}
lvlCount = {1,1,1,1,1,1,1,math.random(1,lvlMax[8])}
lvlCountD = {1,1,1,1,1,1,1}

function SetLevel()
	local k = 0
	if GAMESTATE:IsEventMode() and world < 7 then k = 1 end
	if _G['lvlCount'..dark][world] > lvlMax[world] + k then _G['lvlCount'..dark][world] = 1 end
	level = _G['lvlCount'..dark][world]
	if warp == 0 and (level > lvlMax[world] or IsFinalStage()) then warp = 1 end
	if warp > 0 and warp ~= 10 then level = 1 end
	rnd = math.random(1,40); goal = 0
	if warp == 0 and not IsFinalStage() and world < 6 and rnd > 33 then goal = 2 end
	if warp == 0 and not IsFinalStage() and world < 7 and rnd > 37 then goal = 3 end
end

function Meatboy(num)
	if num then k = num else k = world end
	local path = THEME:GetPath( EC_GRAPHICS, '', '_Meatboy' )
		if k == 7 then path = path .. '/Bandage'
	elseif k == 9 then path = path .. '/Brownie'
	else path = path .. '/Meatboy'
	end
	return path .. Pallette()
end

function Bandage()
	local path = THEME:GetPath( EC_GRAPHICS, '', '_Bandage' )
	if world == 7 then path = path .. '/Meatboy'
	else path = path .. '/Bandage' end
	return path .. Pallette()
end

function Pallette()
	if Silhouette() then return 'W'
	elseif warp == 12 and world == 2 then return 'G'
	elseif warp == 12 and world == 3 then return '4'
	elseif warp > 11 then return 'R' end
	return ''
end

function LevelType()
	if warp == 11 then return 'Boss'
	elseif warp == 12 then return 'Warp'
	elseif warp == 13 then return 'Glitch'
	elseif dark == 'D' then return 'Dark'
	else return 'Light' end
end

function Silhouette()
	if warp > 10 then return false end
	if world == 1 and level == 3 and dark == 'D' then return 0,0,0,1 end
	if world == 1 and level == 4 and dark == 'D' then return 1,1,1,1 end
	if world == 2 and level == 3 and dark == '' then return 0,0,0,1 end
	if world == 2 and level == 2 and dark == 'D' then return .4,0,.4,1 end
	if world == 2 and level == 3 and dark == 'D' then return .24,0,.55,1 end
	if world == 4 and level == 2 and dark == 'D' then return .39,0,0,1 end
	if world == 5 and level == 1 and dark == 'D' then return .18,.51,.31,1 end
	if world == 5 and level == 4 and dark == 'D' then return 0,0,0,1 end
	return false
end

function ColorSilhouette(self) if Silhouette() then self:diffuse(Silhouette()) end end

function Obstacle(name)
	local path = THEME:GetPath( EC_GRAPHICS, '', '_Obstacle/'..name..'.xml' )
	return path
end

function GetWorldTitle(n)
	list = {'CH1: The Forest','CH2: The Hospital','CH3: The Salt Factory','CH4: Hell','CH5: Rapture','CH6: The End','The Cotton Alley','Super Marathon World'}
	if n then return list[n] end
	return list[world]
end
   
function SelectMusicFirstIn()
	if world == 6 then return '_block side white.xml' end
	return '_block side.xml'
end

function Increase()
	world = world + 1
	if world >= 9 then world = 1 end
	if world == 8 and GAMESTATE:StageIndex() > 0 and not GAMESTATE:IsEventMode() then world = 1 end
	update = 0
	MESSAGEMAN:Broadcast('Update')
	MESSAGEMAN:Broadcast('Right')
end

function Decrease()
	world = world - 1
	if world <= 0 then world = 8 end
	if world == 8 and GAMESTATE:StageIndex() > 0 and not GAMESTATE:IsEventMode() then world = 7 end
	update = 0
	MESSAGEMAN:Broadcast('Update')
	MESSAGEMAN:Broadcast('Left')
end
   
function BarColor()
	list = {'#688043','#542764','#333333','#990000','#666666','#393939','#FFFFFF'}
	listD = {'#990000','#990000','#990000','#990000','#990000','#990000','#FFFFFF'}
	if dark == 'D' then list = listD end
	if list[world] then return list[world] end
	return '#000000'
end

function TopBannerTextColor()
	list = {'#597344','#452052','#F5C25C','#6E1112','#FFFFFF','#393939','#FFFFFF','#000000','#FFFFFF'}
	listD = {'#6A0000','#6A0000','#6A0000','#FF6600','#6A0000','#6A0000','#FFFFFF','#000000','#FFFFFF'}
	if dark == 'D' then list = listD end
	if list[banner] then return list[banner] end
	return '#666666'
end

function BannerTextColor()
	list = {'#2F3E22','#452052','#F5C25C','#6A0000','#FFFFFF','#575757','#FFFFFF'}
	listD = {'#6A0000','#6A0000','#6A0000','#FF6600	','#6A0000','#6A0000','#FFFFFF'}
	if dark == 'D' then list = listD end
	if list[world] then return list[world] end
	return '#000000'
end

function BannerTextColor2()
	list = {'#2F3E22','#452052','#000000','#000000','#000000','#000000','#000000'}
	listD = {'#000000','#000000','#000000','#000000','#000000','#000000','#000000'}
	if dark == 'D' then list = listD end
	if list[world] then return list[world] end
	return '#000000'
end

function BannerShadow() -- find and fix.
	if banner == 9 then return '2' end
	return '0'
end

function ExtraMeatColor(self)
	self:diffuse(.38,.02,.02,1)
	if Silhouette() then self:diffuse(Silhouette()) end
end

function ObstacleLoop(self)
	self:x(576*lvlSpd)	self:queuecommand('Go') self:linear(4.5) self:x(-576*lvlSpd) self:queuecommand('Loop')
end

function ObstacleFinished(self,i)
	self:stoptweening()
	if i and (obstacle(1) == 23 or obstacle(1) == 24) then
		self:linear(1)
		self:addx(-256*lvlSpd)
	else
		if done ~= 2 then done = 1 end
		x = self:GetX()
		if x < 192 then
			if x > 0 then done = 2 end
			self:linear(1)
			self:addx(-256*lvlSpd)
		else
			self:hidden(1)
		end
	end
end

function FinishMoving(self,x1,x2,t)
	s = x2-x1
	d = x2-self:GetX()
	l = math.max(t*d/s,0)
	self:stoptweening()
	self:linear(l)
	self:x(x2)
end

-- Obstacle 1: Saw On Ground
-- Obstacle 1b: Saw On Ground With Frame
-- Obstacle 2: Small Flying Saw
-- Obstacle 3: Needle Pile
-- Obstacle 4: Crawling Thing
-- Obstacle 5: Floating Thing
-- Obstacle 5b: Floating Thing 2
-- Obstacle 6: Salt Pile
-- Obstacle 7: Missile
-- Obstacle 8: Lava
-- Obstacle 9: Laser Eye
-- Obstacle 10: Lava Ball
-- Obstacle 11: Exploding Demon
-- Obstacle 12: Maggot
-- Obstacle 13: Maggots
-- Obstacle 14: Quad Cannon
-- Obstacle 15: Chasing Thing
-- Obstacle 16: Spikes
-- Obstacle 17: Two Saws
-- Obstacle 17b: Two Saws With Frame
-- Obstacle 18: Pit
-- Obstacle 19: Fast Flying Saws
-- Obstacle 20: Two Salt Piles with Missile
-- Obstacle 21: Saw with Missile
-- Obstacle 22: Two Saws with Missile
-- Obstacle 23: Repeller
-- Obstacle 24: Falling Floor
-- Obstacle 25: Two Saws Stacked
-- Obstacle 26: Repeller with Pit
-- Obstacle 27: Repeller with Saw
-- Obstacle 28: Floating Thing with Needle Pile
-- Obstacle 28b: Floating Thing2 with Needle Pile
-- Obstacle 29: Blood Pit
-- Obstacle 30: Water Pit - Retro

function obstacle(obstacleNumber)
	listLight ={{{'1b',0,0,0},				{18,0,0,0},					{'1b',0,0,0},			{2,0,2,0}},
				{{5,0,'5b',0},				{3,0,4,0},					{3,0,4,0}},
				{{6,2,0,2},					{7,0,7,0}},
				{{8,8,10,0},				{10,0,10,10},				{11,8,0,8}},
				{{26,0,27,0},				{13,12,12,12},				{14,7,7,0},				{13,14,13,26}},
				{{17,1,17,0}},
				{{19,19,19,19},				{24,1,17,25},				{20,21,22,7},			{23,0,0,0}},
				{{'17b',2,7,5},				{12,9,'5b',14},				{15,19,4,6}}}

	listDark = {{{18,'1b',18,'17b'},		{'17b','1b','17b','1b'},	{2,2,2,2},				{1,17,1,17}},
				{{5,4,5,4},					{2,2,2,2},					{3,4,3,4}},
				{{6,'1b',7,'17b'},			{7,6,6,7}},
				{{9,8,9,8},					{8,10,17,10},				{'17b',8,10,8}},
				{{17,17,17,17},				{25,15,17,15},				{13,2,13,'17b'},		{14,14,14,14}},
				{{16,18,16,'17b'}},
				{{28,'28b',28,'28b'},		{9,9,9,9},					{11,11,11,11},			{24,15,15,15}}}

	listWarp = {{{1,0,18,0}},
				{{1,0,1,2}},
				{{18,18,18,18}},
				{{8,10,10,10}},
				{{1,16,2,30}}}

	listGlitch ={{{30,2,16,2}},
				{{29,2,29,16}},
				{{18,16,7,16}},
				{{8,10,18,16}},
				{{1,7,16,7}},
				{{1,2,16,2}}}

	listBoss = {{{17,25,1,17}},
				{{29,29,29,29}},
				{{6,6,6,6}},
				{{8,8,8,8}},
				{{25,12,25,12}},
				{{17,25,17,25}}}

	list = _G['list'..LevelType()]
	return list[world][level][obstacleNumber]
end

function Test(self,a)
	self:playcommand('Set') self:sleep(a) self:queuecommand('Check')
end

function FailMove(self)
	List = {0,0,5,0,0,5,0,10,0,0,0,0,5,0,0,0,0,25,0,10,0,0,25,25,0,25,0,0,10,10}
	s = string.gsub(obstacle(1),'b','')
	y = List[tonumber(s)]
	if y < 15 then
		self:sleep(.2)
		self:accelerate(.1)
	else
		self:sleep(.1)
		self:accelerate(.2)
	end
	self:y(y)
end

function MeatboyObstacle(self)
	Remove(self)
	self:queuecommand('Splode')
end

function MeatboyGo(self,i,j)
	n = self:GetZ()
	stop[n] = 1
	Restore(self)
	self:queuecommand('Reset')
	sleep = math.random()*i+j;
	self:sleep(sleep)
	self:queuecommand('Move1')
end

function MeatboyGoal(self)
	n = self:GetZ()
	stop[n] = 1
	if math.abs(state[n]) < 4 then self:queuecommand('Fetus') end
end

blockSize = 50

function SetEvalBlocks()
	blockSizeEval = 26
	blockXOffsetEval = SCREEN_CENTER_X-320-18
	blockYOffsetEval = SCREEN_CENTER_Y-240+67
end

function SetGameplayBlocks()
	blockSizeGameplay = 16
	blockXOffsetGameplay = SCREEN_CENTER_X-320+168
	blockYOffsetGameplay = SCREEN_CENTER_Y-240+49
end