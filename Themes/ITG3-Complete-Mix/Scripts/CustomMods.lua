-- Global table in which to store custom mods
ITG3GlobVar = {}
ITG3GlobVar.CustomMods = {}

-- Reset mods.  This should be called at the start of each game
-- Since tables can only be assigned by reference in Lua, we must explicitly
-- define defaults for each player.
function ResetCustomMods()
	ITG3GlobVar.CustomMods[PLAYER_1] = { hidescore = false, hidecombo = false, hidelife = false, showstats = false, showmods = false, judgmentposition = false, normal = true, left = false, right = false, upsidedown = false, solo = false, vibrate = false, spin = false, spinreverse = false, bob = false, pulse = false, wag = false, dark = 0, judgment = "ITG3" }
	ITG3GlobVar.CustomMods[PLAYER_2] = { hidescore = false, hidecombo = false, hidelife = false, showstats = false, showmods = false, judgmentposition = false, normal = true, left = false, right = false, upsidedown = false, solo = false, vibrate = false, spin = false, spinreverse = false, bob = false, pulse = false, wag = false, dark = 0, judgment = "ITG3" }
end

-- Do initial reset
ResetCustomMods()


function OptionTournamentOptions()
	local t = {
		Name = "TournamentOptions",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectMultiple",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = { "Hide Score", "Hide Combo", "Hide Lifebar" },
		
		LoadSelections = function(self, list, pn)
			--if GAMESTATE:StageIndex() == 0 then ResetCustomMods() end -- Reset if we're on the first stage
			list[1] = ITG3GlobVar.CustomMods[pn].hidescore -- Hide score mod
			list[2] = ITG3GlobVar.CustomMods[pn].hidecombo -- Hide combo mod
			list[3] = ITG3GlobVar.CustomMods[pn].hidelife  -- Hide life mod
		end,
		
		SaveSelections = function(self, list, pn)
			ITG3GlobVar.CustomMods[pn].hidescore = list[1] -- Hide score mod
			ITG3GlobVar.CustomMods[pn].hidecombo = list[2] -- Hide combo mod
			ITG3GlobVar.CustomMods[pn].hidelife = list[3]  -- Hide life mod
		end
		
	}
	setmetatable(t, t)
	return t
end


function OptionShowStats()
	local t = {
		Name = "InGameStats",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectMultiple",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = { "Show In-Game Statistics" },
		
		LoadSelections = function(self, list, pn)
			--if GAMESTATE:StageIndex() == 0 then ResetCustomMods() end -- Reset if we're on the first stage
			list[1] = ITG3GlobVar.CustomMods[pn].showstats -- Resets the in-game bargraph to be off
		end,
		
		SaveSelections = function(self, list, pn)
			ITG3GlobVar.CustomMods[pn].showstats = list[1] -- in-game bargraph
		end
		
	}
	setmetatable(t, t)
	return t
end


function OptionShowModifiers()
	local t = {
		Name = "ShowModifiers",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectMultiple",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = { "Show Active Modifiers" },
		
		LoadSelections = function(self, list, pn)
			--if GAMESTATE:StageIndex() == 0 then ResetCustomMods() end -- Reset if we're on the first stage
			list[1] = ITG3GlobVar.CustomMods[pn].showmods -- Resets the live course mods to be off
		end,
		
		SaveSelections = function(self, list, pn)
			ITG3GlobVar.CustomMods[pn].showmods = list[1] -- show active attack list
		end
		
	}
	setmetatable(t, t)
	return t
end


function OptionJudgmentPosition()
	local t = {
		Name = "JudgmentPosition",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectMultiple",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = { "Judgments Behind Arrows" },
		
		LoadSelections = function(self, list, pn)
			--if GAMESTATE:StageIndex() == 0 then ResetCustomMods() end -- Reset if we're on the first stage
			list[1] = ITG3GlobVar.CustomMods[pn].judgmentposition -- Resets the judgements in front of arrows
		end,
		
		SaveSelections = function(self, list, pn)
			ITG3GlobVar.CustomMods[pn].judgmentposition = list[1] -- judgments behind arrows
		end
		
	}
	setmetatable(t, t)
	return t
end


function OptionNextScreen()
	local t = {
		Name = "NextScreen",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectMultiple",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false,
		Choices = { 'Music Selection', 'More Options' },
		
		LoadSelections = function(self, list, pn)
		end,
		
		SaveSelections = function(self, list, pn)
			if ( PREFSMAN:GetPreference('MenuTimer') and ( list[1] or list[2] ) and ScreenPlayerOptionsTimer < 5 ) then
                SCREENMAN:SystemMessage('Not Enough Time Left!')
			elseif list[1] then
                SCREENMAN:SetNewScreen('ScreenSelectMusic2')
			elseif list[2] then
                GetMoreOptionsScreen()
			end
		end
	}
	setmetatable(t, t)
	return t
end

function GetMoreOptionsScreen()
	--Give players a bit of buffer when switching between More Options.
	ScreenPlayerOptionsTimer = (ScreenPlayerOptionsTimer + 5)
	if ModsScreen == 'PlayerOptions' then
        return SCREENMAN:SetNewScreen('ScreenSongOptions')
    else
        return SCREENMAN:SetNewScreen('ScreenPlayerOptions')
	end
end

function AvailableArrowDirections()

if GAMESTATE:GetNumPlayersEnabled() == 1 then return "Normal", "Left", "Right", "Upside-Down", "Solo-Centered"
else return "Normal", "Left", "Right", "Upside-Down" end
end

function OptionOrientation()
	local t = {
		Name = "Orientation",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = { AvailableArrowDirections() },		
		LoadSelections = function(self, list, pn)
			--if GAMESTATE:StageIndex() == 0 then ResetCustomMods() end -- Reset if we're on the first stage
			list[1] = ITG3GlobVar.CustomMods[pn].normal -- Default scrolling
			list[2] = ITG3GlobVar.CustomMods[pn].left -- Turns field left
			list[3] = ITG3GlobVar.CustomMods[pn].right -- Turns field right
			list[4] = ITG3GlobVar.CustomMods[pn].upsidedown  -- Flips field upside down
			if GAMESTATE:GetNumPlayersEnabled() == 1 then list[5] = ITG3GlobVar.CustomMods[pn].solo end -- Centers the targets
		end,
		
		SaveSelections = function(self, list, pn)
			ITG3GlobVar.CustomMods[pn].normal = list[1] -- Default scrolling
			ITG3GlobVar.CustomMods[pn].left = list[2] -- Turns field left
			ITG3GlobVar.CustomMods[pn].right = list[3] -- Turns field right
			ITG3GlobVar.CustomMods[pn].upsidedown = list[4]  -- Flips field upside down
			if GAMESTATE:GetNumPlayersEnabled() == 1 then ITG3GlobVar.CustomMods[pn].solo = list[5] end -- Centers the targets
		end
		
	}
	setmetatable(t, t)
	return t
end


function OptionPlayfield()
	local t = {
		Name = "PlayfieldMods",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectMultiple",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = { "Vibrate", "Spin Right", "Spin Left", "Bob", "Pulse", "Wag" },
		
		LoadSelections = function(self, list, pn)
			--if GAMESTATE:StageIndex() == 0 then ResetCustomMods() end -- Reset if we're on the first stage
			list[1] = ITG3GlobVar.CustomMods[pn].vibrate -- Makes the plaing field shake
			list[2] = ITG3GlobVar.CustomMods[pn].spin -- Makes the playing field spin clockwise
			list[3] = ITG3GlobVar.CustomMods[pn].spinreverse -- Makes the playing field spin counter-clockwise
			list[4] = ITG3GlobVar.CustomMods[pn].bob -- Makes the playing field bob up and down
			list[5] = ITG3GlobVar.CustomMods[pn].pulse -- Makes the playing field pulse in and out
			list[6] = ITG3GlobVar.CustomMods[pn].wag -- Makes the playing field wag left and right
		end,
		
		SaveSelections = function(self, list, pn)
			ITG3GlobVar.CustomMods[pn].vibrate = list[1] -- Makes the plaing field shake
			ITG3GlobVar.CustomMods[pn].spin = list[2] -- Makes the playing field spin clockwise
			ITG3GlobVar.CustomMods[pn].spinreverse = list[3] -- Makes the playing field spin counter-clockwise
			ITG3GlobVar.CustomMods[pn].bob = list[4] -- Makes the playing field bob up and down
			ITG3GlobVar.CustomMods[pn].pulse = list[5] -- Makes the playing field pulse in and out
			ITG3GlobVar.CustomMods[pn].wag = list[6] -- Makes the playing field wag left and right
		end
		
	}
	setmetatable(t, t)
	return t
end


function OptionScreenFilter()
	local t = {
		Name = "ScreenFilter",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = { "Disabled", "Dark", "Darker", "Darkest"},
		LoadSelections = function(self, list, pn)
			--if GAMESTATE:StageIndex() == 0 then ResetCustomMods() end -- Reset if we're on the first stage
			if ITG3GlobVar.CustomMods[pn].dark == 0 then list[1] = true 
			elseif ITG3GlobVar.CustomMods[pn].dark == 0.5 then list[2] = true 
			elseif ITG3GlobVar.CustomMods[pn].dark == 0.75 then list[3] = true 
			elseif ITG3GlobVar.CustomMods[pn].dark == 0.95 then list[4] = true 
			else list[1] = true end
		end,
		SaveSelections = function(self, list, pn)
				if list [1] then ITG3GlobVar.CustomMods[pn].dark = 0 
				elseif list [2] then ITG3GlobVar.CustomMods[pn].dark = 0.5 
				elseif list [3] then ITG3GlobVar.CustomMods[pn].dark = 0.75
				elseif list [4] then ITG3GlobVar.CustomMods[pn].dark = 0.95 
				else ITG3GlobVar.CustomMods[pn].dark = 0 end
		end
	}
	setmetatable(t, t)
	return t
end

function GetJudgmentPosition()
	if (GAMESTATE:IsPlayerEnabled(PLAYER_1) and ITG3GlobVar.CustomMods[PLAYER_1].judgmentposition == true) or (GAMESTATE:IsPlayerEnabled(PLAYER_2) and ITG3GlobVar.CustomMods[PLAYER_2].judgmentposition == true) then return 1
	else return 0 end
end
	
-- Returns a players selected judgment font
function GetJudgmentFont(pn)
	return ITG3GlobVar.CustomMods[pn].judgment
end

-- Returns the screen darken mod
function DarkenPercent(pn)
	return ITG3GlobVar.CustomMods[pn].dark
end

-- Returns 1 if score is hidden, 0 otherwise; for use in metrics.ini.
function IsScoreHidden(pn)
	if ITG3GlobVar.CustomMods[pn].hidescore == true then return 1 
	else return 0 end
end

-- Returns 1 if life is hidden, 0 otherwise; for use in metrics.ini.
function IsLifeHidden(pn)
	if ITG3GlobVar.CustomMods[pn].hidelife == true then return 1
	else return 0 end
end

-- We can't use the 'hidden' command on a per-player basis for combo, so
-- instead take advantage of the X combo offset.
function GetComboXOffset(pn)
	-- Hide the Lifebar off to the side.
	if ITG3GlobVar.CustomMods[pn].hidecombo == true then return "-SCREEN_WIDTH*2"
	else return 0 end
end

function GetJudgeXOffset(pn)
	return 0
end

function ShowStats(pn)
	if ITG3GlobVar.CustomMods[pn].showstats == true then return 1
	else return 0 end
end

function ShowCourseModifiers(pn)
	if ITG3GlobVar.CustomMods[pn].showmods == true then return 0
	else return 1 end
end

function ResetBeginnerDisplay()
	if GAMESTATE:GetPlayMode() == PLAY_MODE_REGULAR  then
		if GAMESTATE:IsPlayerEnabled(PLAYER_1) then 
			if GAMESTATE:GetCurrentSteps(PLAYER_1):GetDifficulty()==DIFFICULTY_BEGINNER then 
				ITG3GlobVar.CustomMods[PLAYER_1] = { hidescore = false, hidecombo = false, hidelife = false, showstats = false, showmods = false, normal = true, left = false, right = false, upsidedown = false, solo = false, vibrate = false, spin = false, spinreverse = false, bob = false, pulse = false, wag = false, dark = 0 } end end
		if GAMESTATE:IsPlayerEnabled(PLAYER_2) then 
			if GAMESTATE:GetCurrentSteps(PLAYER_2):GetDifficulty()==DIFFICULTY_BEGINNER then 
				ITG3GlobVar.CustomMods[PLAYER_2] = { hidescore = false, hidecombo = false, hidelife = false, showstats = false, showmods = false, normal = true, left = false, right = false, upsidedown = false, solo = false, vibrate = false, spin = false, spinreverse = false, bob = false, pulse = false, wag = false, dark = 0 } end end
	end
			
end

function BPMDisplayOffsets()

local SoloOffset = 0

	if GAMESTATE:PlayerUsingBothSides() then return "hidden,1" end

	if GAMESTATE:IsPlayerEnabled(PLAYER_1) and not GAMESTATE:IsPlayerEnabled(PLAYER_2) and ShowStats(PLAYER_1) == 1 then 
		if ITG3GlobVar.CustomMods[PLAYER_1].solo then SoloOffset = 46 end
	return "HorizAlign,Center;x,SCREEN_CENTER_X+SCREEN_WIDTH/4+100;addx,SCREEN_WIDTH/2+" .. SoloOffset .. ";decelerate,1;addx,-SCREEN_WIDTH/2" end
	if GAMESTATE:IsPlayerEnabled(PLAYER_2) and not GAMESTATE:IsPlayerEnabled(PLAYER_1) and ShowStats(PLAYER_2) == 1 then
		if ITG3GlobVar.CustomMods[PLAYER_2].solo then SoloOffset = 80 end
	return "HorizAlign,Center;x,SCREEN_CENTER_X-SCREEN_WIDTH/4+100;addx,-SCREEN_WIDTH/2-" .. SoloOffset .. ";decelerate,1;addx,SCREEN_WIDTH/2" end
	
	return "hidden,1"
end

function DrawDistances()
	-- Use Full Screen If There is Only 1 Player, and Cut the Render Positions if 1 or Both use Left/Right.
	local rend = "448"
	
	-- Player 1 Active Only
	if GAMESTATE:IsPlayerEnabled(PLAYER_1) and not GAMESTATE:IsPlayerEnabled(PLAYER_2) then
		if ITG3GlobVar.CustomMods[PLAYER_1].left == true or ITG3GlobVar.CustomMods[PLAYER_1].right == true then
			if GAMESTATE:PlayerIsUsingModifier(PLAYER_1, 'hallway') then rend = SCREEN_WIDTH+100
			else rend = SCREEN_WIDTH+20 end end end

	-- Player 2 Active Only
	if GAMESTATE:IsPlayerEnabled(PLAYER_2) and not GAMESTATE:IsPlayerEnabled(PLAYER_1) then
		if ITG3GlobVar.CustomMods[PLAYER_2].left == true or ITG3GlobVar.CustomMods[PLAYER_2].right == true then
			if GAMESTATE:PlayerIsUsingModifier(PLAYER_2, 'hallway') then rend = SCREEN_WIDTH+100
			else rend = SCREEN_WIDTH+20 end end end

	-- Player 1 AND Player 2 Active
	if GAMESTATE:IsPlayerEnabled(PLAYER_1) and GAMESTATE:IsPlayerEnabled(PLAYER_2) then
		if ITG3GlobVar.CustomMods[PLAYER_1].left == true or ITG3GlobVar.CustomMods[PLAYER_1].right == true or ITG3GlobVar.CustomMods[PLAYER_2].left == true or ITG3GlobVar.CustomMods[PLAYER_2].right == true then
			rend = SCREEN_WIDTH*0.4 end end

	return rend
end

function CheckCustomMods(pn)
local s = "y,SCREEN_TOP+240;"
	local left = "rotationz,270;"
	local right = "rotationz,90;"
	local upsidedown = "rotationz,180;addy,20;"
	local solo = "x,SCREEN_CENTER_X;"
	local vibrate = "vibrate;effectmagnitude,20,20,20;"
	local spin = "spin;EffectClock,beat;effectmagnitude,0,0,45;"
	local bob = "bob;EffectClock,beat;effectmagnitude,0,-30,0"
	local pulse = "pulse;EffectClock,beat;"
	local wag = "wag;EffectClock,beat;"
	local spinreverse = "spin;EffectClock,beat;effectmagnitude,0,0,-45;"
	local leftsideoffset = "x,SCREEN_LEFT+190+" .. GetLifebarAdjustment() ..";"
	local rightsideoffset = "x,SCREEN_RIGHT-190-" .. GetLifebarAdjustment() ..";"
	local player1centeroffset = "x,SCREEN_CENTER_X-160-".. GetLifebarAdjustment() .. ";"
	local player2centeroffset = "x,SCREEN_CENTER_X+160+" .. GetLifebarAdjustment() ..";"
	local right1poffset = "addx,SCREEN_WIDTH/2;"
	local left1poffset = "addx,-SCREEN_WIDTH/2;"

	if ITG3GlobVar.CustomMods[pn].left == true then 
		s = left
			if pn == PLAYER_1 then
				s = s .. leftsideoffset
			else
				s = s .. player2centeroffset
			end		
		if GAMESTATE:IsPlayerEnabled(PLAYER_2) and not GAMESTATE:IsPlayerEnabled(PLAYER_1) then
			s = s .. left1poffset end
	elseif ITG3GlobVar.CustomMods[pn].right == true then 
		s = right
			if pn == PLAYER_2 then
				s = s .. rightsideoffset
			else
				s = s .. player1centeroffset
			end	
		if GAMESTATE:IsPlayerEnabled(PLAYER_1) and not GAMESTATE:IsPlayerEnabled(PLAYER_2) then
			s = s .. right1poffset end
	elseif ITG3GlobVar.CustomMods[pn].upsidedown == true then
		s = upsidedown
	elseif ITG3GlobVar.CustomMods[pn].solo == true then
		s = solo
	else
		s = s
	end
	
	if ITG3GlobVar.CustomMods[pn].spin == true then
		s = s .. spin end
		
	if ITG3GlobVar.CustomMods[pn].spinreverse == true then
		s = s .. spinreverse end
	
	if ITG3GlobVar.CustomMods[pn].vibrate == true then
		s = s .. vibrate end
		
	if ITG3GlobVar.CustomMods[pn].bob == true then
		s = s .. bob end
		
	if ITG3GlobVar.CustomMods[pn].pulse == true then
		s = s .. pulse end
		
	if ITG3GlobVar.CustomMods[pn].wag == true then
		s = s .. wag end

	return s
end

-- [LifeP1OnCommand] --
function GetLifeBarEffectsP1()
	s = 'rotationz,-90;addx,-100;sleep,0.5;decelerate,0.8;addx,100;DrawOrder,-1';
	
	if IsLifeHidden(PLAYER_1) == 1 then 
	s = 'hidden,1' return s end

	return s
end

-- [ScoreP1OnCommand] --
function GetScoreEffectsP1()
	s = 'shadowlength,0;addy,-100;' .. DoublesScoreCenterP1() .. 'sleep,0.5;decelerate,0.8;addy,100';
	
	if IsScoreHidden(PLAYER_1) == 1 then 
	s = 'hidden,1' return s end

	return s
end

-- [PlayerP1OnCommand] --
function GetPlayerEffectsP1(pn)
	return CheckCustomMods(PLAYER_1)
end

-- [LifeP2OnCommand] --
function GetLifeBarEffectsP2()
	s = 'draworder,-1;rotationz,-90;addx,100;sleep,0.5;decelerate,0.8;addx,-100';

	if IsLifeHidden(PLAYER_2) == 1 then 
	s = 'hidden,1' return s end
	
	return s
end

-- [ScoreP2OnCommand] --
function GetScoreEffectsP2()
	s = 'shadowlength,0;addy,-100;' .. DoublesScoreCenterP2() ..'sleep,0.5;decelerate,0.8;addy,100'

	if IsScoreHidden(PLAYER_2) == 1 then 
	s = 'hidden,1' return s end	

	return s
end

-- [PlayerP2OnCommand] --
function GetPlayerEffectsP2(pn)
	return CheckCustomMods(PLAYER_2)
end



-- NotITG 4.9.1 SECTION --


-- Judgment Font List
judgmentFontList = { 'Bebas2', 'Chromatic', 'Code2', 'Comic Sans2', 'Deco', 'DDR A', 'DDR Extreme', 'ECFA', 'ECFA No Quotes', 'Emoji', 'FP', 'GrooveNights', 'ITG2', 'Japanese', 'Lobster2', 'Love', 'Love Chroma', 'Miso2', 'mute', 'Optimus Dark', 'Rainbowmatic', 'Roboto', 'Roboto ITG', 'Tactics', 'VHS', 'Vision', 'Vision Dark', 'Wendy2' }
if FUCK_EXE then -- Auto load on NotITG
    local list = { 'Default' }
    
    local dir = string.sub(THEME:GetPath(2,'','_blank.png'),9)
    dir = string.sub(dir,1,string.find(dir,'/')-1)
    for _,v in pairs({ GAMESTATE:GetFileStructure('Themes/'.. dir ..'/Graphics/_Judgments/') }) do
        local t, _, name = string.find(v, "(.+) %dx%d")
        if t then table.insert( list, name )
        else print('[Judgment] Error in loading ' .. v)
        end
    end

    judgmentFontList = list
end

-- Hold Judgment List
holdJudgmentList = { 'Bebas', 'Code', 'Love', 'mute', 'None', 'Wendy' }
if FUCK_EXE then -- Auto load on NotITG
    local list = { 'Default' }
    
    local dir = string.sub(THEME:GetPath(2,'','_blank.png'),9)
    dir = string.sub(dir,1,string.find(dir,'/')-1)
    for _,v in pairs({ GAMESTATE:GetFileStructure('Themes/'.. dir ..'/Graphics/_HoldJudgments/') }) do
        local t, _, name = string.find(v, "(.+) %dx%d")
        if t then table.insert( list, name )
        else print('[Hold Judgment] Error in loading ' .. v)
        end
    end

    holdJudgmentList = list
end

--NoteSkin list
local noteskins = NOTESKIN:GetNoteSkinNames()
NoteSkinList = {}
local ind = 1
local blacklist = {'arrowkun', 'arrowkun-notweens', 'cel2d', 'cel-cmd', 'cel-cmd-notweens', 'cel-glow2', 'cel-yuno', 'coin', 'controlcel', 'controlmetal', 'controlmetal2', 'couples-cmd', 'couplescontrol', 'de-default', 'divinentity', 'dunno', 'dunno2', 'justholds', 'metal2_dpad', 'metal-cmd', 'metal-cmdholds', 'metal-cmd-notweens', 'mindcode', 'minderror', 'mindgalaxykiss', 'mindkickmetal', 'mindnoshow', 'mindpressure', 'mindrockstarmetal', 'mindstarsmetal', 'mindtechmetal', 'pixel', 'proxynotes', 'shape', 'slow', 'solid_black', 'spikes2', 'splitter', 'spt'}

for i, noteskin in ipairs(noteskins) do
    local name = string.lower(noteskin)
    local blacklisted = false
    for _, blackName in ipairs(blacklist) do
        if name == blackName then
            blacklisted = true
        end
    end
    if not blacklisted then
        NoteSkinList[ind] = name
        ind = ind+1
    end
end

-- find a noteskin listed in the DefaultModifiers string located in Data/GamePrefs.ini
function GetDefaultNoteSkinFromGamePrefsIni()
    -- if this function is called too early: as in there is no game style set (dance, pump, etc)
    -- the game will return the names of the directories of each noteskin, rather than a map of noteskin names
    -- there aren't many differences between the two, but the latter returns a list where all names are lowercased, and the former returns names capitalized as-is in the NoteSkins directory
    -- while these differences are small, it's enough to cause problems when looking through DefaultModifiers, since the casing might not match, and we cannot guarantee to receive a list of names lowercased by the game either
    -- which means we now need to take matters in our own hands and string.lower everything
    local noteskins = NOTESKIN:GetNoteSkinNames()
    for i, noteskin in ipairs(noteskins) do
        noteskins[i] = string.lower(noteskin)
    end
    local defaults = string.lower(PREFSMAN:GetPreference'DefaultModifiers')
    for str in string.gfind(defaults, '[^,]+') do
        local mod = string.gsub(str, " ", "")
        for i, noteskin in ipairs(noteskins) do
            if mod == noteskin then
                return noteskin
            end
        end
    end
    -- no noteskins present within DefaultModifiers, fall back onto a common noteskin
    return 'scalable'
end

modJudgmentFont = {1,1}
modHoldJudgment = {1,1}
modNoteSkin = {1,1}
local defaultSkin = GetDefaultNoteSkinFromGamePrefsIni()
--look for the player's current noteskin
for pn=0,1 do
    for modInd, modName in ipairs(NoteSkinList) do
        if modName == defaultSkin then
            modNoteSkin[pn+1] = modInd
        end
    end
end


-- BGAnimation Screen Functions

-- SCREEN SELECT MUSIC
--<ActorFrame InitCommand="%SelectMusicInit" FirstUpdateCommand="%SelectMusic" CaptureCommand="%SongInfo" CurrentSongChangedMessageCommand="queuecommand,Capture" CurrentStepsP1ChangedMessageCommand="queuecommand,Capture" CurrentStepsP2ChangedMessageCommand="queuecommand,Capture" />
function SelectMusicInit(self) InitializeMods() ApplyRateAdjust() self:queuecommand('FirstUpdate') end
function SelectMusic(self) self:queuecommand('Capture') end

-- SCREEN EVALUATION
--<ActorFrame InitCommand="%EvaluationInit" FirstUpdateCommand="%Evaluation" />
function EvaluationInit(self) RevertHideBG() RevertRateAdjust() self:queuecommand('FirstUpdate') end
function Evaluation(self) ApplyHideBG() end

-- SCREEN GAMEPLAY
-- <ActorFrame Command="%GameplayInit" FirstUpdateCommand="%Gameplay" UnknwonHoldMessageCommand="%HoldCheck" AssignHoldsCommand="%AssignHold"/>
function GameplayInit(self)	Combo = {} self:queuecommand('FirstUpdate') end
function Gameplay(self) JudgmentInit() end

-- Mod Changing functions

function InitializeMods()
	if GAMESTATE:GetEnv('Mods') then return end
	modRate = 1
	modJudgmentFont = {1,1}
    modNoteSkin = {1,1}
	CalculateSpeedMod()
	GAMESTATE:SetEnv('Mods',1)
end


-- Apply judgments

function JudgmentInit()
    for pn=1,8 do
        local PL = SCREENMAN:GetTopScreen():GetChild('PlayerP'..pn)
        local k
        if PL then
            --Judgment font
            local PJudge = PL:GetChild('Judgment'):GetChild('')
            k = modJudgmentFont[pn%2 == 1 and 1 or 2]
            PJudge:aux(pn%2 == 1 and 1 or 2)
            
            if k ~= 1 then 
                PJudge:Load( THEME:GetPath( EC_GRAPHICS, '', '_Judgments/'..judgmentFontList[k] ))
            end
            
            --Hold judgment
            if FUCK_EXE then
                for col=0,15 do
                    local PHold = PL:GetChild('HoldJudgmentCol'..col):GetChild('')
                    k = modHoldJudgment[pn%2 == 1 and 1 or 2]
                    PHold:aux(pn%2 == 1 and 1 or 2)
                    
                    if k ~= 1 then 
                        PHold:Load( THEME:GetPath( EC_GRAPHICS, '', '_HoldJudgments/'..holdJudgmentList[k] ))
                    end
                end
            end
        end
    end
end


--Apply noteskin to all players
function ApplyNoteskin()
    --ApplyModifiers for noteskins only work before ScreenGameplay, so activating this function at ScreenStage would do
    local sk = {NoteSkinList[modNoteSkin[1]],NoteSkinList[modNoteSkin[2]]}
    if FUCK_EXE then
        for pn=1,7,2 do
            GAMESTATE:ApplyModifiers(sk[1],pn)
        end
        for pn=2,8,2 do
            GAMESTATE:ApplyModifiers(sk[2],pn)
        end
    else 
        for pn=1,2 do
            GAMESTATE:ApplyGameCommand('mod,'..sk[pn],pn)
        end
    end
end


function JudgmentOption()
	local modList = judgmentFontList
    
	local Params = {
		Name = "Judgment Font",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false
    }
	   
    local loadFunc = function(self, list, pn)
        list[modJudgmentFont[pn+1]] = true
    end

    local saveFunc = function(self, list, pn)
        for i=1,table.getn(modList) do if list[i] then modJudgmentFont[pn+1] = i end end
    end
    
	return CreateOptionRow(Params, modList, loadFunc, saveFunc)
end


function HoldJudgmentOption()
	local modList = holdJudgmentList
    
	local Params = {
		Name = "Hold Judgment",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false
    }
	   
    local loadFunc = function(self, list, pn)
        list[modHoldJudgment[pn+1]] = true
    end

    local saveFunc = function(self, list, pn)
        for i=1,table.getn(modList) do if list[i] then modHoldJudgment[pn+1] = i end end
    end
    
	return CreateOptionRow(Params, modList, loadFunc, saveFunc)
end


function NoteSkinOption()
	local modList = NoteSkinList
    
	local Params = {
		Name = "Noteskin",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false
	}
    
    local loadFunc = function(self, list, pn)
        list[modNoteSkin[pn+1]] = true
    end

    local saveFunc = function(self, list, pn)
        for i=1,table.getn(modList) do if list[i] then modNoteSkin[pn+1] = i end end
    end
    
	return CreateOptionRow(Params, modList, loadFunc, saveFunc)
end