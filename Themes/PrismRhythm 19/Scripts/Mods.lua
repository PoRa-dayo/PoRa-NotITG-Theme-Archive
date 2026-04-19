
function number(n) return tonumber(tostring(n)) end
function SM(str) SCREENMAN:SystemMessage(str) end
function Screen() return SCREENMAN:GetTopScreen() end
function Child(str) return GetChild(str) end
function Sound(str) SOUND:PlayOnce( Path("sounds",str )) end
function Path(ec,str) return THEME:GetPath( _G['EC_'..string.upper(ec)] , '' , str ) end
function TableToString(t) local s = '' for i,v in ipairs(t) do s = s .. v end return s end

modJudgmentFont = {1,1}

-- BGAnimation Screen Functions

-- SCREEN SELECT MUSIC
--<ActorFrame InitCommand="%SelectMusicInit" FirstUpdateCommand="%SelectMusic" CaptureCommand="%SongInfo" CurrentSongChangedMessageCommand="queuecommand,Capture" CurrentStepsP1ChangedMessageCommand="queuecommand,Capture" CurrentStepsP2ChangedMessageCommand="queuecommand,Capture" />
function SelectMusicInit(self) InitializeMods() ApplyRateAdjust() self:queuecommand('FirstUpdate') end
function SelectMusic(self) self:queuecommand('Capture') end

-- SCREEN EVALUATION
--<ActorFrame InitCommand="%EvaluationInit" FirstUpdateCommand="%Evaluation" />
function EvaluationInit(self) RevertHideBG() RevertRateAdjust() self:queuecommand('FirstUpdate') end
function Evaluation() ApplyHideBG() end

-- SCREEN GAMEPLAY
-- <ActorFrame Command="%GameplayInit" FirstUpdateCommand="%Gameplay" UnknwonHoldMessageCommand="%HoldCheck" AssignHoldsCommand="%AssignHold"/>
function GameplayInit(self)	Combo = {} self:queuecommand('FirstUpdate') end
function Gameplay() JudgmentInit() end

-- Mod Changing functions

function InitializeMods()
	if GAMESTATE:GetEnv('Mods') then return end
	modRate = 1
	modJudgmentFont = {1,1}
	CalculateSpeedMod()
	GAMESTATE:SetEnv('Mods',1)
end

function ModPulse(self,mod)
	for pn=0,1 do if GAMESTATE:PlayerIsUsingModifier(pn,mod) then GAMESTATE:ApplyGameCommand('mod,no '..mod,pn+1); self:queuecommand('Mod') end end
	self:sleep(.1)
	self:queuecommand('Pulse')
end

function ApplyRateAdjust()
	for pn=1, 2 do
		if GAMESTATE:IsPlayerEnabled( pn - 1 ) then
			speed = string.gsub(modSpeed[pn],modType[pn],"")
			if modType[pn] == "x" then speed = math.ceil(100*speed/modRate)/100 .. "x" end
			if modType[pn] == "C" then speed = "C" .. math.ceil(speed/modRate) end
			GAMESTATE:ApplyGameCommand('mod,' .. speed,pn)
		end
	end
end

function RevertRateAdjust()
	for pn=1, 2 do
		if modSpeed and modSpeed[pn] then GAMESTATE:ApplyGameCommand('mod,' .. modSpeed[pn],pn) end
	end
end

-- Removes Cover on ScreenEvaluation InitCommand to prevent disqualification, reapplies it immediately after.
function RevertHideBG() modCover = {} for pn=1, 2 do if GAMESTATE:IsPlayerEnabled( pn - 1 ) then if GAMESTATE:PlayerIsUsingModifier(pn-1,'cover') then modCover[pn] = true end GAMESTATE:ApplyGameCommand('mod,no cover',pn) end end end   
function ApplyHideBG() for pn=1, 2 do if modCover[pn] then GAMESTATE:ApplyGameCommand('mod,cover',pn) end end end

-- Judgment Tracking

function JudgmentInit()
	judgeP1 = {0,0,0,0,0,0,0,0,0}
	judgeP2 = {0,0,0,0,0,0,0,0,0}
	Holds = {}
	OK = {}
	NG = {}
	local P1 = SCREENMAN:GetTopScreen():GetChild('PlayerP1') if P1 then P1 = P1:GetChild('Judgment'):GetChild(''); k = modJudgmentFont[1]; P1:aux(1); if k ~= 1 then P1:Load( THEME:GetPath( EC_GRAPHICS, '', '_Judgments/'..judgmentFontList[k] )) end end
	local P2 = SCREENMAN:GetTopScreen():GetChild('PlayerP2') if P2 then P2 = P2:GetChild('Judgment'):GetChild(''); k = modJudgmentFont[2]; P2:aux(2); if k ~= 1 then P2:Load( THEME:GetPath( EC_GRAPHICS, '', '_Judgments/'..judgmentFontList[k] )) end end
end

function JudgmentTween(self) self:zoom(.8) self:decelerate(.1) self:zoom(.75) self:sleep(.6) self:accelerate(.2) self:zoom(0) end
function HoldTween(self) self:diffuse(1,1,1,1) self:zoom(.8); self:sleep(.5) self:zoom(0) end

function JudgmentCommand(self,n) TrackJudgment(self,n) JudgmentTween(self) end
function HoldCommand(self,n) TrackHold(self,n) HoldTween(self) end

function TrackJudgment(self,n)
	if self:getaux() == 1 then judgeP1[n] = judgeP1[n] + 1 end
	if self:getaux() == 2 then judgeP2[n] = judgeP2[n] + 1 end
end

function TrackHold(self,k)
	pn = self:getaux()
	if not GAMESTATE:IsPlayerEnabled(PLAYER_2) then self:aux(1); pn = 1; end
	if not GAMESTATE:IsPlayerEnabled(PLAYER_1) then self:aux(2); pn = 2; end
	if pn > 0 then _G['judgeP'..pn][k] = _G['judgeP'..pn][k] + 1 return end

	if self:getaux() == 0 then n = table.getn(Holds)+1; self:aux(-n); Holds[n] = self else n = self:getaux()*-1 end
	if not OK[n] then OK[n] = 0; NG[n] = 0 end
	if k == 7 then OK[n] = OK[n] + 1 else NG[n] = NG[n] + 1 end
	MESSAGEMAN:Broadcast('UnknownHold')
end   

function CheckHold(self)
	for i,v in ipairs(Holds) do	v:finishtweening() v:z(0) v:linear(.05) v:z(12) end
	SCREENMAN:GetTopScreen():GetChild('PlayerP2'):hurrytweening(1.2)
	self:stoptweening(); self:sleep(.05); self:queuecommand('AssignHolds')
end
   
function AssignHold()
	for i,v in ipairs(Holds) do   
		if v:GetZ() >= 11 then
			judgeP1[7] = judgeP1[7] + OK[i]; judgeP1[8] = judgeP1[8] + NG[i]; v:aux(1)
		else
			judgeP2[7] = judgeP2[7] + OK[i]; judgeP2[8] = judgeP2[8] + NG[i]; v:aux(2)
		end
	end
	Holds = {}; OK = {}; NG = {}
end

-- Capturing Functions
function IndexCapture(self,str) _G[str][table.getn(_G[str])+1] = self end

function CaptureCombo(self)	if Combo[1] or not GAMESTATE:IsPlayerEnabled(PLAYER_1) then Combo[2] = self; self:z(2) else Combo[1] = self; self:z(1) end end

function SongInfo()
	CapturePane()
	CaptureBPM()
	CaptureMeter()
	SongLength = SCREENMAN:GetTopScreen():GetChild('TotalTime'):GetText()
	CaptureSteps()
	MESSAGEMAN:Broadcast('SongInfo')
end

paneItemListDance = {'SongNumStepsText' , 'SongJumpsText' , 'SongHoldsText' , 'SongRollsText' , 'SongMinesText' , 'SongHandsText' , 'MachineHighScoreText' , 'ProfileHighScoreText' , 'MachineHighNameText' }
paneItemListCourse = {'CourseNumStepsText' , 'CourseJumpsText' , 'CourseHoldsText' , 'CourseRollsText' , 'CourseMinesText' , 'CourseHandsText' , 'CourseMachineHighNameText' , 'CourseMachineHighScoreText' , 'CourseProfileHighScoreText' }
judgmentList = { 'MarvelousNumber' , 'PerfectNumber' , 'GreatNumber' , 'GoodNumber' , 'BooNumber' , 'MissNumber' , 'HoldsText' , 'RollsText' , 'MinesText' , 'JumpsText' , 'HandsText' }
Difficulty = {}
Meter = {}
MaxDP = {}

for i,v in ipairs(paneItemListDance) do _G[v] = {} end
for i,v in ipairs(paneItemListCourse) do _G[v] = {} end
for i,v in ipairs(judgmentList) do _G[v] = {} end

function CapturePane()
	if GAMESTATE:IsCourseMode() then paneItemList = paneItemListCourse else paneItemList = paneItemListDance end
	for pn = 1, 2 do
		if GAMESTATE:IsPlayerEnabled(pn-1) then

			for i,v in ipairs(paneItemList) do
				_G[v][pn] = SCREENMAN:GetTopScreen():GetChild('PaneDisplayP'..pn):GetChild(''):GetChild(v):GetText()
				if i == 7 or i == 8 then _G[v][pn] = string.gsub(_G[v][pn],'%%','') end
			end

			if _G[paneItemList[1]][pn] ~= '?' then
				MaxDP[pn] = (_G[paneItemList[1]][pn] + _G[paneItemList[3]][pn] + _G[paneItemList[4]][pn])*5
			else
				MaxDP[pn] = nil
			end
		end
	end
end

function JudgmentCapture()
	for pn = 1, 2 do
		if GAMESTATE:IsPlayerEnabled(pn-1) then
			for i,v in ipairs(judgmentList) do
				_G[v][pn] = SCREENMAN:GetTopScreen():GetChild(v .. 'P' .. pn):GetText()
			end
		end
	end
end
   
function CaptureMeter()
	for pn = 1, 2 do
		if GAMESTATE:IsPlayerEnabled(pn-1) then
			s = GAMESTATE:GetCurrentSteps(pn-1)
			if s then Difficulty[pn] = s:GetDifficulty() else Difficulty[pn] = SCREENMAN:GetTopScreen():GetChild('MeterP'.. pn):GetChild('Difficulty'):GetText() end
			for i=0,5 do if DifficultyToThemedString(i) == Difficulty[pn] or string.upper(DifficultyToThemedString(i)) == Difficulty[pn] then Difficulty[pn] = i break end end
			Meter[pn] = SCREENMAN:GetTopScreen():GetChild('MeterP'.. pn):GetChild('Meter'):GetText()
		end
	end
end

function CaptureSteps()
	for pn = 1, 2 do if GAMESTATE:GetCurrentSteps(pn-1) then st = GAMESTATE:GetCurrentSteps(pn-1):GetStepsType() break end end
	steps = {}
	if GAMESTATE:GetCurrentSong() then
		steps = GAMESTATE:GetCurrentSong():GetStepsByStepsType( st )
		t = {} -- I am using this instead of table.sort because for whatever reason, it was returning true for a:GetMeter() == b:GetMeter() on some edits when that was NOT true. Maybe the function was too long? but the length was required.
		for n=1,table.getn(steps) do
			m = 1
			for i,a in ipairs(steps) do
				b = steps[m]
				if a:GetDifficulty()< b:GetDifficulty() or (a:GetDifficulty() == b:GetDifficulty() and (a:GetMeter() < b:GetMeter() or (a:GetMeter() == b:GetMeter() and a:GetDescription()<b:GetDescription()))) then m = i end
			end
			t[table.getn(t)+1] = steps[m]
			table.remove(steps,m)
		end
		steps = t
	end
end

function CaptureBPM()
	bpm = {}
	s = SCREENMAN:GetTopScreen():GetChild('BPMDisplay')
	if s then
		s = s:GetChild('Text'):GetText()
		bpm[1] = string.gsub(s,'-%d+','')
		bpm[2] = string.gsub(s,'%d+-','-')
		if bpm[2] == bpm[1] then bpm[2] = '' end
	end
end

function GetSongName()
	if GAMESTATE:GetCurrentCourse() then return GAMESTATE:GetCurrentCourse():GetDisplayFullTitle() end
	if GAMESTATE:GetCurrentSong() then return GAMESTATE:GetCurrentSong():GetDisplayMainTitle() end
	return ""
end

-- BPM format and display functions

function BPMlabelRate(self)	s = AdjustedBPM() .. ' BPM ' .. RateModAppend() if self then self:settext(s) else return s end end
function BPMandRate(self) s = AdjustedBPM() .. ' ' .. RateModAppend() if self then self:settext(s) else return s end end
function RateBPMlabel(self) s = RateModText() if s ~= '' then s = s .. ' (' .. AdjustedBPM() .. ' BPM)' end	if self then self:settext(s) else return s end end   

function RateModText(self) s = '' if modRate ~= 1 then s = modRate .. 'x Music Rate' end if self then self:settext(s) else return s end end
function RateModAppend(self) s = RateModText() if s ~= '' then s = '(' .. s .. ')' end if self then self:settext(s) else return s end end

function AdjustedBPM(self)
	s = bpm[1]
	if s ~= 'Various' and s ~= '...'  then
		s = math.floor(bpm[1] * modRate + 0.5)
		if bpm[2] ~= '' then s = s .. math.floor(bpm[2] * modRate + 0.5) end
	end
	if self then self:settext(s) else return s end
end   

function DisplaySpeedMod(pn)
	speed = string.gsub(modSpeed[pn],modType[pn],"")
	s = ''
	if modType[pn] == "x" and bpm and bpm[1] ~= 'Various' and bpm[1] ~= '...'  then
		s = math.floor(speed * bpm[1] + 0.5)
		if bpm[2] ~= '' then s = s .. math.floor(speed * bpm[2] + 0.5) end
		s = ' (' .. s .. ')'
	end   
	s = modSpeed[pn] .. s
	return s
end

function GameplayBPM(self)
	bpm[3] = SCREENMAN:GetTopScreen():GetChild('BPMDisplay'):GetChild('Text'):GetText()
	-- if not OPENITG then bpm[3] = math.floor(bpm[3] * modRate + 0.5) end
	bpm[3] = math.floor(bpm[3] * modRate + 0.5)
	self:settext(bpm[3])
	self:sleep(.05)
	self:queuecommand('Update')
end


-- Lua Option Rows

function SpeedMods(name)
	local modList = baseSpeed; s = "Speed"
	if name == "Extra" then modList = extraSpeed; s = "Extra " .. s end
	local t = {
		Name = s,
		LayoutType = "ShowOneInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = modList,
	   
		LoadSelections = function(self, list, pn)
			list[1] = true
			for n = 2, table.getn(modList) do
				if name == "Base" then
					if modList[n] == modType[pn+1]..modBase[pn+1] or modList[n] == modBase[pn+1]..modType[pn+1] then list[n] = true; list[1] = false else list[n] = false end
				end
				if name == "Extra" then
					s = modList[n]; s = string.gsub(s,'C',''); s = string.gsub(s,'x',''); s = string.gsub(s,'+',''); s = string.gsub(s,'%.','') s = tonumber(s)
					if s == modExtra[pn+1] or modList[n] == modExtra[pn+1]/100 then list[n] = true; list[1] = false else list[n] = false end
					if modType[pn+1] == 'x' and modList[n] == '+C50' then list[n] = false end   
					if modType[pn+1] == 'C' and modList[n] == '+.50x' then list[n] = false end
				end
			end
		end,

		SaveSelections = function(self, list, pn)
			for n = 1, table.getn(modList) do
				if list[n] then s = modList[n] end
			end
			p = pn+1
			if name == "Base" then if s == string.gsub(s,'x','') then modType[p] = 'C' else modType[p] = 'x' end end
			s = string.gsub(s,'C',''); s = string.gsub(s,'x',''); s = string.gsub(s,'+',''); s = string.gsub(s,'%.','') s = tonumber(s)
			if name == "Base" then modBase[p] = s end
			if name == "Extra" then modExtra[p] = s end
			if modType[p] == 'x' then modSpeed[p] = modBase[p] + modExtra[p]/100 .. 'x' else modSpeed[p] = 'C' .. modBase[p] + modExtra[p] end
			GAMESTATE:ApplyGameCommand('mod,1x',p)
			ApplyRateAdjust()
			MESSAGEMAN:Broadcast('SpeedModChanged')
		end
	   
	}
	setmetatable(t, t)
	return t
end

rateMods = { "1.0x", "1.1x", "1.2x", "1.3x", "1.4x", "1.5x", "1.6x", "1.7x", "1.8x", "1.9x", "2.0x" }
rateModsEdit = { "1.0x", "1.1x", "1.2x", "1.3x", "1.4x", "1.5x", "1.6x", "1.7x", "1.8x", "1.9x", "2.0x", "0.3x", "0.4x", "0.5x", "0.6x", "0.7x", "0.8x", "0.9x" }

function RateMods( s )
	local modList = rateMods
	if s then modList = rateModsEdit end
	local t = {
		Name = "Music Rate",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = modList,
	   
		LoadSelections = function(self, list, pn)
			for n = 1, table.getn(modList) do
				if GAMESTATE:PlayerIsUsingModifier(pn,modList[n]..'music') then list[n] = true; s = string.gsub(modList[n],'x','') modRate = tonumber(s) else list[n] = false end
			end
		end,

		SaveSelections = function(self, list, pn)
			for n = 1, table.getn(modList) do
				if list[n] then s = modList[n] end
			end
			s = string.gsub(s,'x','')
			modRate = tonumber(s)
			GAMESTATE:ApplyGameCommand('mod,'..s..'xmusic',pn+1)
			ApplyRateAdjust()
			MESSAGEMAN:Broadcast('RateModChanged')
		end
	   
	}
	setmetatable(t, t)
	return t
end

function NonCombos()
	local t = {
		Name = "NonCombos",
		LayoutType = "ShowOneInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { "On", "Decents Only", "Off" },
	   
		LoadSelections = function(self, list, pn)
			if Decents() then
				if WayOffs() then list[1] = true
				else list[2] = true
				end
			else list[3] = true
			end
		end,

		SaveSelections = function(self, list, pn)
			if list[1] then
				PREFSMAN:SetPreference('JudgeWindowSecondsGood',0.135)
				PREFSMAN:SetPreference('JudgeWindowSecondsBoo',0.180)
			end
			if list[2] then
				PREFSMAN:SetPreference('JudgeWindowSecondsGood',0.135)
				PREFSMAN:SetPreference('JudgeWindowSecondsBoo',0.135)
			end
			if list[3] then
				PREFSMAN:SetPreference('JudgeWindowSecondsGood',0.102)
				PREFSMAN:SetPreference('JudgeWindowSecondsBoo',0.102)
			end
		end
	   
	}
	setmetatable(t, t)
	return t
end

function DQ()
	local t = {
		Name = "DQ",
		LayoutType = "ShowOneInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { "On", "Off" },
	   
		LoadSelections = function(self, list, pn)
			if PREFSMAN:GetPreference('Disqualification') then
				list[1] = true
			else
				list[2] = true
			end
		end,

		SaveSelections = function(self, list, pn)
			if list[1] then	PREFSMAN:SetPreference('Disqualification',true) end
			if list[2] then	PREFSMAN:SetPreference('Disqualification',false) end
		end
	   
	}
	setmetatable(t, t)
	return t
end

function BackButton()
	local modList = {'More: Major Switches', 'Back: Song Select'}
	local t = {
		Name = "BackButton",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectMultiple",
		OneChoiceForAllPlayers = GAMESTATE:IsPlayerEnabled(PLAYER_1),
		ExportOnChange = true,
		Choices = modList,
		LoadSelections = function(self, list, pn) end,
		SaveSelections = function(self, list, pn) if list[1] then SCREENMAN:SetNewScreen('ScreenSongOptions') end if list[2] then SCREENMAN:SetNewScreen('ScreenSelectMusic') end end
	}
	setmetatable(t, t)
	return t
end


-- Must put the list "judgmentFontList" in another lua so it doesn't get overwritten whenever this file is updated from the master copy.
function JudgmentOption()
	local modList = judgmentFontList
	local t = {
		Name = "Judgment Font",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = modList,
	   
		LoadSelections = function(self, list, pn)
			list[modJudgmentFont[pn+1]] = true
		end,

		SaveSelections = function(self, list, pn)
			for i=1,table.getn(modList) do if list[i] then modJudgmentFont[pn+1] = i end end
		end
	   
	}
	setmetatable(t, t)
	return t
end

-- Lua Option Row support functions
	   
function CalculateSpeedMod()
	modBase = {}
	modExtra = {}
	modType = {}
	modSpeed = {}
	for pn=1, 2 do
		if GAMESTATE:IsPlayerEnabled( pn - 1 ) then
			modBase[pn] = 700
			modExtra[pn] = 0
			modType[pn] = 'C'
			for j=0, 90, 10 do CalculateSpeedLoop(j,pn) end
			for j=25, 75, 25 do CalculateSpeedLoop(j,pn) end
			if modType[pn] == 'C' then modSpeed[pn] = 'C' .. modBase[pn] + modExtra[pn] end
			if modType[pn] == 'x' then modSpeed[pn] = modBase[pn] + modExtra[pn]/100 ..'x' end
		end   
	end
end

function CalculateSpeedLoop(j,pn)
	for i=1, 8, 1 do
		if GAMESTATE:PlayerIsUsingModifier(pn-1,i + j/100 .. 'x') then modBase[pn] = i; modExtra[pn] = j; modType[pn] = 'x' end
	end
	for i=400, 1400, 100 do
		if GAMESTATE:PlayerIsUsingModifier(pn-1,'C' .. i + j) then modBase[pn] = i; modExtra[pn] = j; modType[pn] = 'C' end
	end
end

baseSpeed = { "1x", "2x", "3x", "4x", "5x", "6x", "7x", "C1400", "C1300", "C1200", "C1100", "C1000", "C900", "C800", "C700", "C600", "C500", "C400" }
extraSpeed = { "0", "+.25x", "+.50x", "+.75x", "+C90", "+C80", "+C70", "+C60", "+C50", "+C40", "+C30", "+C20", "+C10" }
modRate = 1

function Decents() if math.abs(PREFSMAN:GetPreference('JudgeWindowSecondsGood') - 0.135) < .001 then return true end end

function WayOffs() if math.abs(PREFSMAN:GetPreference('JudgeWindowSecondsBoo') - 0.180) < .001 then return true end end

-- Synthetic DifficultyListRow functions

listPointer = {}
listPointerY = {}

-- Decalre these variables as needed in other lua file. Do not do it here because they'd get overwritten when you update this lua from the master file. The values shown below are what will be used if nothing is declared.
-- twoDifficultyListRows = false
-- maxRows = 5
-- blankMeter = '?'
-- maxFeet = 20
-- minFeet = 0
-- feetBaseZoom = 1

-- NOTE: If using Feet Icons, they must be arranged in a column in the graphics file. The dimensions of the file must be powers of 2 ( 128x1024, for example).
-- Divide the column into 8ths vertically, place the "no chart" icon in the top 8th, the 'novice' icon in the 2nd 8th ... the edit icon in the 7th 8th, and leave the last one blank.
-- It must be done this way because "customtexturerect" removes your ability to "setstate".

function DifficultyList()
	difficultyList = {}
	local r = maxRows or (not maxRows and 5)
	local a = math.floor(r/4) + 1
	local b = r+1-a
	local c = math.floor(r/2) + 1
	if not GAMESTATE:GetCurrentSong() then
		for pn=1,2 do if GAMESTATE:IsPlayerEnabled(pn-1) then listPointerY[pn] = Difficulty[pn] + 1 end end
		return
	end
	if FixedDifficultyRows() then
		for i,v in ipairs(steps) do  
			q = v:GetDifficulty()+1
			if q < 6 then
				difficultyList[q] = v
			else
				for k=1,table.getn(steps) do q = 5+k if not difficultyList[q] then difficultyList[q] = v break end end
			end
		end
	else
		difficultyList = steps
		q = table.getn(steps)
	end
--  q is the index of the last entry of difficultyList. We need to save this instead of using table.getn because when you have "FixedDifficultyRow" you often have nil values in the middle of the table.
	for n=1,2 do if GAMESTATE:IsPlayerEnabled(n-1) then
		for i=1,q do if difficultyList[i] == GAMESTATE:GetCurrentSteps(n-1) then listPointer[n] = i end end
		if listPointer[n] <= c then listPointerY[n] = listPointer[n] elseif listPointer[n] >= (q+1)-(r-c) then listPointerY[n] = listPointer[n]-q+r else listPointerY[n] = c end
		if FixedDifficultyRows() then listPointerY[n] = listPointer[n] end
	end end
	if not twoDifficultyListRows and GAMESTATE:GetNumPlayersEnabled() == 2 and q > r then
		listPointerY[1] = math.max(math.min(math.ceil((r+listPointer[1]-listPointer[2])/2),b),a)
		listPointerY[2] = math.max(math.min(math.ceil((r+listPointer[2]-listPointer[1])/2),b),a)
		if listPointer[1] + listPointer[2] < r+2 and listPointer[1] <= b and listPointer[2] <= b then listPointerY[1] = listPointer[1]; listPointerY[2] = listPointer[2] end
		if listPointer[1] + listPointer[2] > 2*(q+1)-(r+2) and listPointer[1] >= (q+1)-b and listPointer[2] >= (q+1)-b then listPointerY[1] = listPointer[1]-q+r; listPointerY[2] = listPointer[2]-q+r end
		for i=1,2 do if listPointer[i] <= a then listPointerY[i] = listPointerY[i] elseif listPointer[i] >= (q+1)-a then listPointerY[i] = listPointer[i]-q+r end end
	end
end

function DifficultyListRow(self,k,t,pn)
	local r = maxRows or (not maxRows and 5)
	local b = blankMeter or (not blankMeter and '?')
	local m = maxFeet or (not maxFeet and 20)
	local n = minFeet or (not minFeet and 0)
	local z = feetBaseZoom or (not feetBaseZoo and 1)
	local d = {}

	if GAMESTATE:IsPlayerEnabled(PLAYER_1) then d[1] = k+listPointer[1]-listPointerY[1] else d[1] = 0 end
	if GAMESTATE:IsPlayerEnabled(PLAYER_2) then d[2] = k+listPointer[2]-listPointerY[2] else d[2] = 0 end
	if not GAMESTATE:GetCurrentSong() then
		if t == 'difficulty' then if k - 1 < 5 then self:settext(string.upper(DifficultyToThemedString( k - 1 ))) self:diffuse(DifficultyColorRGB( k - 1 )) else self:settext('') end end
		if t == 'meter' then if k - 1 < 5 then self:settext(b) self:diffuse(DifficultyColorRGB( k - 1 )) else self:settext('') end end
		if t == 'feet' then self:zoomy(z) self:zoomx(n*z) self:customtexturerect(0,0,n,1/8) end
	elseif FixedDifficultyRows() then
		s = difficultyList[k]
		if s then
			if t == 'difficulty' then if k - 1  < 5 then self:settext(string.upper(DifficultyToThemedString( k - 1 ))) else self:settext(s:GetDescription()) end self:diffuse(DifficultyColorRGB( k - 1 )) end
			if t == 'meter' then self:settext(s:GetMeter()) self:diffuse(DifficultyColorRGB( k - 1 )) end
			if t == 'feet' then self:zoomy(z) self:zoomx(math.min(s:GetMeter(),m)*z) self:customtexturerect(0,k/8,math.min(s:GetMeter(),m),(k+1)/8) end
		else
			if t == 'difficulty' then if k - 1 < 5 then self:settext(string.upper(DifficultyToThemedString( k - 1 ))) else self:settext('') end self:diffuse(DifficultyColorRGB()) end
			if t == 'meter' then self:settext('') self:diffuse(DifficultyColorRGB( k - 1 )) end
			if t == 'feet' then self:zoomy(z) self:zoomx(n*z) self:customtexturerect(0,0,n,1/8) end
		end
	else
		if pn then s = d[pn]
		elseif not GAMESTATE:IsPlayerEnabled(PLAYER_2) then s = d[1]
		elseif not GAMESTATE:IsPlayerEnabled(PLAYER_1) then s = d[2]
		elseif k <= math.floor(r/2) then
			if listPointer[1] <= listPointer[2] then s = d[1] else s = d[2] end
		else
			if listPointer[1] >= listPointer[2] then s = d[1] else s = d[2] end
		end
		s = difficultyList[s]
		if s then
			if t == 'difficulty' then if s:GetDifficulty() < 5 then self:settext(string.upper(DifficultyToThemedString(s:GetDifficulty()))) else self:settext(s:GetDescription()) end self:diffuse(DifficultyColorRGB( s:GetDifficulty() )) end
			if t == 'meter' then self:settext(s:GetMeter()) self:diffuse(DifficultyColorRGB( s:GetDifficulty() )) end
			if t == 'feet' then self:zoomy(z) self:zoomx(math.min(s:GetMeter(),m)*z) self:customtexturerect(0,(s:GetDifficulty()+1)/8,math.min(s:GetMeter(),m),(s:GetDifficulty()+2)/8) end
		else
			if t == 'difficulty' then self:settext('') end
			if t == 'meter' then self:settext('') end
			if t == 'feet' then self:zoom(0) end
		end
	end
end

function FixedDifficultyRows()
	l = table.getn(steps)
	if l > 5 then return false end
	for i,v in ipairs(steps) do
		if v:GetDifficulty() > 4 then return false end
	end
	for i=1,l-1 do
		for j=i+1,l do
			if steps[i]:GetDifficulty() == steps[j]:GetDifficulty() then return false end
		end
	end
	return true
end

function ApplyNoteskin()
    --both GetCurrentNoteSkins and ApplyModifiers for noteskins only work before ScreenGameplay, so activating this function at ScreenStage would do
    local sk = GAMESTATE:GetCurrentNoteSkins()
    if FUCK_EXE then
        for pn=1,7,2 do
            if GAMESTATE:IsPlayerEnabled(pn) then
                GAMESTATE:ApplyModifiers(sk[1],pn)
            end
        end
        for pn=2,8,2 do
            if GAMESTATE:IsPlayerEnabled(pn) then
                GAMESTATE:ApplyModifiers(sk[2],pn)
            end
        end
    else 
        for pn=1,2 do
            if GAMESTATE:IsPlayerEnabled(pn) then
                GAMESTATE:ApplyGameCommand('mod,'..sk[pn],pn)
            end
        end
    end
end