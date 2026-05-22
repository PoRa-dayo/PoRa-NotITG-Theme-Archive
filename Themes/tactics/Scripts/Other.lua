-- Override these in other themes.
function Platform() return "arcade" end
function IsHomeMode() return false end


function SelectButtonAvailable()
	return true
end

function GetWorkoutMenuCommand()
	GAMESTATE:SetTemporaryEventMode(true)
	return "difficulty," .. GetInitialDifficulty() .. ";screen,ScreenWorkoutMenu;PlayMode,regular;SetEnv,Workout,1"
end

function ScreenEndingGetDisplayName( pn )
	if PROFILEMAN:IsPersistentProfile(pn) then return GAMESTATE:GetPlayerDisplayName(pn) end
	return "No Card"
end

function GetCreditsText()
	local song = GAMESTATE:GetCurrentSong()
	if not song then return "" end

	return 
		song:GetDisplayFullTitle() .. "\n" ..
		song:GetDisplayArtist()
end

function StopCourseEarly()
	-- Stop gameplay between songs in Fitess: Random Endless if all players have 
	-- completed their goals.
	if not GAMESTATE:GetEnv("Workout") then return "0" end
	if GAMESTATE:GetPlayMode() ~= PLAY_MODE_ENDLESS then return "0" end
	for pn = PLAYER_1,NUM_PLAYERS-1 do
		if GAMESTATE:IsPlayerEnabled(pn) and not GAMESTATE:IsGoalComplete(pn) then return "0" end
	end
	return "1"
end

--
-- Workout
--
function WorkoutResetStageStats()
	STATSMAN:Reset()
end

function WorkoutGetProfileGoalType( pn )
	return PROFILEMAN:GetProfile(pn):GetGoalType()
end

function WorkoutGetStageCalories( pn )
	return STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetCaloriesBurned()
end

function WorkoutGetTotalCalories( pn )
	return STATSMAN:GetAccumStageStats():GetPlayerStageStats(pn):GetCaloriesBurned()
end

function WorkoutGetTotalSeconds( pn )
	return STATSMAN:GetAccumStageStats():GetGameplaySeconds()
end

function WorkoutGetGoalCalories( pn )
	return PROFILEMAN:GetProfile(pn):GetGoalCalories()
end

function WorkoutGetGoalSeconds( pn )
	return PROFILEMAN:GetProfile(pn):GetGoalSeconds()
end

function WorkoutGetPercentCompleteCalories( pn )
	return WorkoutGetTotalCalories(pn) / WorkoutGetGoalCalories(pn)
end

function WorkoutGetPercentCompleteSeconds( pn )
	return WorkoutGetTotalSeconds(pn) / WorkoutGetGoalSeconds(pn)
end

--
-- Options
--
function RestoreDefaults( pn )
	if pn == PLAYER_2 then
		Trace( "skip RestoreDefaults" )
		return
	end

	Trace( "RestoreDefaults" )
	
	PREFSMAN:SetPreference( "ControllerMode", 0 )
	PREFSMAN:SetPreference( "TwoControllerDoubles", false )
	PREFSMAN:SetPreference( "SongsPerPlay", 3 )
	PREFSMAN:SetPreference( "EventMode", false )
	PREFSMAN:SetPreference( "LifeDifficultyScale", 1 )

	local Table = PROFILEMAN:GetMachineProfile():GetSaved()
	Table["DefaultSort"] = GetDefaultSort()
	Table["DefaultDifficulty"] = GetDefaultDifficulty()

	PREFSMAN:SetPreference( "BGBrightness", .4 )
	PREFSMAN:SetPreference( "GlobalOffsetSeconds", 0 )
	PREFSMAN:SetPreference( "Autosave", true )
end

-- Home unlock (stubs):
function GetUnlockCommand() return "playcommand,NoUnlock" end
function FinalizeUnlock() end

-- Arcade unlocks:
function Unlock( Title )
	local Code = UNLOCKMAN:FindCode( Title )
	if Code then
		UNLOCKMAN:UnlockCode( Code )
	end

	-- Set the song as preferred, even if it's no longer an unlock.
	NewHelpText = {}
	local s = SONGMAN:FindSong( Title )
	if s then
		GAMESTATE:SetPreferredSong( s )
		NewHelpText[1] = "Unlocked " .. s:GetDisplayFullTitle() .. "!"
	end

	-- Get a list of steps (not songs) we just unlocked, and send a message to display
	-- them in HelpText.
	if Code then
		local Songs, Steps = UNLOCKMAN:GetStepsUnlockedByCode( Code )
		for x in Songs do
			NewHelpText[x+1] = "Unlocked " .. Songs[x]:GetDisplayFullTitle() .. " " .. DifficultyToThemedString(Steps[x]) .. "!"
		end
	end

	-- Only set the HelpText if this is actually a locked song for this game.  Don't do
	-- it if it's an old unlock code from a previous game.  (Do show it if it was already
	-- unlocked, though, so people can re-enter a code to see which steps were unlocked.)
	if Code then
		MESSAGEMAN:Broadcast( "ChangeHelpText" )
	end
	NewHelpText = nil

	-- The ITG2 menu music is much stronger than ITG1's, drowning out the unlock
	-- sounds.  Dim the music to 20% for 3 seconds while we play the unlock sound.
	-- This will stay dimmed briefly after the unlock sound plays.  That's OK; it
	-- helps emphasize the sound and prevents the music changes from being too busy.
	SOUND:DimMusic( 0.2, 3 )

	local Path = THEME:GetPath( EC_SOUNDS, '', "Unlocked " .. Title )
	SOUND:PlayOnce( Path )
end


function SetDifficultyFrameFromSteps( Actor, pn )
	Trace( "SetDifficultyFrameFromSteps" )
	local steps = GAMESTATE:GetCurrentSteps( pn );
	if steps then 
		Actor:setstate(steps:GetDifficulty()) 
	end
end

function SetDifficultyFrameFromGameState( Actor, pn )
	Trace( "SetDifficultyFrameFromGameState" )
	local trail = GAMESTATE:GetCurrentTrail( pn );
	if trail then 
		Actor:setstate(trail:GetDifficulty()) 
	else
		SetDifficultyFrameFromSteps( Actor, pn )
	end
end

function SetFromSongTitleAndCourseTitle( actor )
	Trace( "SetFromSongTitleAndCourseTitle" )
	local song = GAMESTATE:GetCurrentSong();
	local course = GAMESTATE:GetCurrentCourse();
	local text = ""
	if song then
		text = song:GetDisplayFullTitle()
	end
	if course then
		text = course:GetDisplayFullTitle() .. " - " .. text;
	end

	actor:settext( text )
end

function SetRemovedText(self, port)
	local CurrentSong = GAMESTATE:GetCurrentSong()
	if CurrentSong and string.find( CurrentSong:GetDisplayFullTitle(), "Disconnected" ) then
		self:settext( "The controller in controller port " .. port .. " has been disconnected." )
		return
	end

	self:settext( "The controller in controller port " .. port .. " has been removed." )
end


function GetActual( stepsType )
	return 
		PROFILEMAN:GetMachineProfile():GetSongsActual(stepsType,DIFFICULTY_EASY)+
		PROFILEMAN:GetMachineProfile():GetSongsActual(stepsType,DIFFICULTY_MEDIUM)+
		PROFILEMAN:GetMachineProfile():GetSongsActual(stepsType,DIFFICULTY_HARD)+
		PROFILEMAN:GetMachineProfile():GetSongsActual(stepsType,DIFFICULTY_CHALLENGE)+
		PROFILEMAN:GetMachineProfile():GetCoursesActual(stepsType,COURSE_DIFFICULTY_REGULAR)+
		PROFILEMAN:GetMachineProfile():GetCoursesActual(stepsType,COURSE_DIFFICULTY_DIFFICULT)
end

function GetPossible( stepsType )
	return 
		PROFILEMAN:GetMachineProfile():GetSongsPossible(stepsType,DIFFICULTY_EASY)+
		PROFILEMAN:GetMachineProfile():GetSongsPossible(stepsType,DIFFICULTY_MEDIUM)+
		PROFILEMAN:GetMachineProfile():GetSongsPossible(stepsType,DIFFICULTY_HARD)+
		PROFILEMAN:GetMachineProfile():GetSongsPossible(stepsType,DIFFICULTY_CHALLENGE)+
		PROFILEMAN:GetMachineProfile():GetCoursesPossible(stepsType,COURSE_DIFFICULTY_REGULAR)+
		PROFILEMAN:GetMachineProfile():GetCoursesPossible(stepsType,COURSE_DIFFICULTY_DIFFICULT)
end

function GetTotalPercentComplete( stepsType )
	return GetActual(stepsType) / (0.96*GetPossible(stepsType))
end

function GetSongsPercentComplete( stepsType, difficulty )
	return PROFILEMAN:GetMachineProfile():GetSongsPercentComplete(stepsType,difficulty)/0.96
end

function GetCoursesPercentComplete( stepsType, difficulty )
	return PROFILEMAN:GetMachineProfile():GetCoursesPercentComplete(stepsType,difficulty)/0.96
end

function GetExtraCredit( stepsType )
	return GetActual(stepsType) - (0.96*GetPossible(stepsType))
end

function GetMaxPercentCompelte( stepsType )
	return 1/0.96;
end

-- This is overridden in the PS2 theme to set the options difficulty.
function GetInitialDifficulty()
	return "beginner"
end

function DifficultyChangingIsAvailable()
	return GAMESTATE:GetPlayMode() ~= PLAY_MODE_ENDLESS and GAMESTATE:GetPlayMode() ~= PLAY_MODE_ONI and GAMESTATE:GetSortOrder() ~= SORT_MODE_MENU
end

function ModeMenuAvailable()
	if GAMESTATE:IsCourseMode() then return false end
	--Trace( "here1" )
	if GAMESTATE:GetSortOrder() == SORT_MODE_MENU then return false end
	--Trace( "here2" )
	return true
end

function GetEditStepsText()
	local steps = GAMESTATE:GetCurrentSteps(PLAYER_1)
	if steps == nil then 
		return ""
	elseif steps:GetDifficulty() == DIFFICULTY_EDIT then 
		return steps:GetDescription()
	else 
		return DifficultyToThemedString(steps:GetDifficulty())
	end
end

function GetScreenSelectStyleDefaultChoice()
	if GAMESTATE:GetNumPlayersEnabled() == 1 then return "1" else return "2" end
end

-- Wag for ScreenSelectPlayMode scroll choice3.  This should use
-- EffectMagnitude, and not a hardcoded "5".
function TweenedWag(self)
	local time = self:GetSecsIntoEffect()
	local percent = time / 4
	local rx, ry, rz
	rx,ry,rz = self:getrotation()
	rz = rz + 5 * math.sin( percent * 2 * 3.141 ) * self:getaux()
	self:rotationz( rz )
end

-- For DifficultyMeterSurvival:
function SetColorFromMeterString( self )
	local meter = self:GetText()
	if meter == "?"  then return end

	local i = (meter+0);
	local cmd;
	if i <= 1 then cmd = "Beginner"
	elseif i <= 3 then cmd = "Easy"
	elseif i <= 6 then cmd = "Regular"
	elseif i <= 9 then cmd = "Difficult"
	else cmd = "Challenge"
	end
	
	self:playcommand( "Set" .. cmd .. "Course" )
end

function GetPaneX( player )
	if player == PLAYER_1 then
		return SCREEN_CENTER_X-152
	else
		return SCREEN_CENTER_X+152
	end
end

function EvalX()
	if not GAMESTATE:PlayerUsingBothSides() then return 0 end

	local Offset = 147
	if GAMESTATE:GetMasterPlayerNumber() == PLAYER_2 then Offset = Offset * -1 end
	return Offset;
end

function EvalTweenDistance()
	local Distance = SCREEN_WIDTH/2
	if GAMESTATE:PlayerUsingBothSides() then Distance = Distance * 2 end
	return Distance
end

-- used by BGA/ScreenEvaluation overlay
-- XXX: don't lowercase commands on parse
function ActorFrame:difficultyoffset()
	if not GAMESTATE:PlayerUsingBothSides() then return end

	local XOffset = 75
	if GAMESTATE:GetMasterPlayerNumber() == PLAYER_2 then XOffset = XOffset * -1 end
	self:addx( XOffset )
	self:addy( -55 )
end

function GameState:PlayerDifficulty( pn )
	if GAMESTATE:IsCourseMode() then
		local trail = GAMESTATE:GetCurrentTrail(pn)
		return trail:GetDifficulty()
	else
		local steps = GAMESTATE:GetCurrentSteps(pn)
		return steps:GetDifficulty()
	end
end

function Get2PlayerJoinMessage()
	if not GAMESTATE:PlayersCanJoin() then return "" end
	if GAMESTATE:GetCoinMode()==COIN_MODE_FREE then return "2 Player mode available" end
	
	local numSidesNotJoined = NUM_PLAYERS - GAMESTATE:GetNumSidesJoined()
	if GAMESTATE:GetPremium() == PREMIUM_JOINT then numSidesNotJoined = numSidesNotJoined - 1 end	
	local coinsRequiredToJoinRest = numSidesNotJoined * PREFSMAN:GetPreference("CoinsPerCredit")
	local remaining = coinsRequiredToJoinRest - GAMESTATE:GetCoins();
		
	if remaining <= 0 then return "2 Player mode available" end
	
	local s = "For 2 Players, insert " .. remaining .. " more coin"
	if remaining > 1 then s = s.."s" end
	return s
end

function GetRandomSongNames( num )
	local s = "";
	for i = 1,num do
		local song = SONGMAN:GetRandomSong();
		if song then s = s .. song:GetDisplayFullTitle() .. "\n" end
	end
	return s
end

function GetStepChartFacts()
	local s = "";
	s = s .. "In The Groove:\n"
	s = s .. "  71 single easy\n"
	s = s .. "  71 single medium\n"
	s = s .. "  71 single hard\n"
	s = s .. "  52 single expert\n"
	s = s .. "  71 double easy\n"
	s = s .. "  71 double medium\n"
	s = s .. "  71 double hard\n"
	s = s .. "  59 double expert\n"
	s = s .. "In The Groove 2:\n"
	s = s .. "  61 single novice\n"
	s = s .. "  61 single easy\n"
	s = s .. "  61 single medium\n"
	s = s .. "  61 single hard\n"
	s = s .. "  49 single expert\n"
	s = s .. "  61 double easy\n"
	s = s .. "  61 double medium\n"
	s = s .. "  61 double hard\n"
	s = s .. "  52 double expert"
	return s
end

function GetRandomCourseNames( num )
	local s = "";
	for i = 1,num do
		local course = SONGMAN:GetRandomCourse();
		if course then s = s .. course:GetDisplayFullTitle() .. "\n" end
	end
	return s
end

function GetModifierNames( num )
	local mods = {
		"x1","x1.5","x2","x2.5","x3","x4","x5","x6","x8","c300","c450",
		"Incoming","Overhead","Space","Hallway","Distant",
		"Standard","Reverse","Split","Alternate","Cross","Centered",
		"Accel","Decel","Wave","Expand","Boomerang","Bumpy",
		"Dizzy","Drift","Mini","Flip","Invert","Tornado","Float","Beat",
		"Fade&nbsp;In","Fade&nbsp;Out","Blink","Invisible","Beat","Bumpy",
		"Mirror","Left","Right","Random","Blender",
		"No&nbsp;Jumps","No&nbsp;Holds","No&nbsp;Rolls","No&nbsp;Hands","No&nbsp;Quads","No&nbsp;Mines",
		"Simple","Stream","Wide","Quick","Skippy","Echo","Stomp",
		"Planted","Floored","Twister","Add&nbsp;Mines","No&nbsp;Stretch&nbsp;Jumps",
		"Hide&nbsp;Targets","Hide&nbsp;Judgment","Hide&nbsp;Background",
		"Metal","Cel","Flat","Robot","Vivid"
	}
	mods = tableshuffle( mods )
	local s = "";
	for i = 1,math.min(num,table.getn(mods)) do
		s = s .. mods[i] .. "\n"
	end
	return s
end

function GetSongName()
	local course = GAMESTATE:GetCurrentCourse()
	if course then return course:GetDisplayFullTitle() end
	if not GAMESTATE:GetCurrentSong() then return "" end
	local song = GAMESTATE:GetCurrentSong()
	return song:GetDisplayFullTitle()
end

function Screen() return SCREENMAN:GetTopScreen() end

function GameplayBPM(self)
	local b = Screen():GetChild('BPMDisplay')
	if b then b = b:GetChild('Text'):GetText() end
	if b then
		self:settext(b)
		self:sleep(.05)
		self:queuecommand('Update')
	end
end

function GetStartScreen() PREFSMAN:SetPreference("DelayedScreenLoad",false) if PREFSMAN:GetPreference('BreakComboToGetItem') and GetInputType and GetInputType() == "" then return "ScreenArcadeStart" end return THEME:GetMetric('Common','FirstAttractScreen') end
function GetStepsDescriptionText(n)
	local steps = GAMESTATE:GetCurrentSteps(n)
	if not steps then
		text = ''
	else
		text = steps:GetDescription()
	end
	if string.lower(text) == 'blank' then text = '' end
	return text
end



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
holdJudgmentList = { 'PrismRhythm Ver1', 'PrismRhythm Ver2', 'PrismRhythm Ver3' }
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


-- Lua Option Rows

function CreateOptionRow( Params, Names, LoadFctn, SaveFctn )
	if not Params.Name then return nil end

	-- this needs to be used because Lua evaluates 'false' as 'nil', so
	-- we can't use an OR operator to assign the value properly.
	local function setbool( value, default )
		if value ~= nil then return value else return default end
	end

	-- fill in with passed params or default values. only Name is required.
	local t =
	{
		Name = Params.Name,

		LayoutType = Params.LayoutType or "ShowAllInRow",
		SelectType = Params.SelectType or "SelectOne",

		OneChoiceForAllPlayers = setbool(Params.OneChoiceForAllPlayers, true),
		EnabledForPlayers = Params.EnabledForPlayers or {PLAYER_1, PLAYER_2},

		ExportOnChange = setbool(Params.ExportOnChange, false),
		ReloadRowMessages= Params.ReloadRowMessages or {},

		Choices = Names,
		LoadSelections = LoadFctn,
		SaveSelections = SaveFctn,
	}

	setmetatable( t, t )
	return t
end


function JudgmentOption()
	local modList = judgmentFontList
    
	local Params = {
		Name = "Judge",
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
		Name = "Hold Judge",
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
		Name = "Note",
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