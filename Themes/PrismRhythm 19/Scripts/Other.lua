-- Override these in other themes.
function Platform() return "generic" end
function IsHomeMode() return false end

-- Judgment Font List
judgmentFontList = { 'Default', 'DDR 1st', 'DDR 2nd', 'DDR 3rd & 4th', 'DDR 5th', 'DDR Max 1 & 2', 'DDR Extreme 1', 'DDR Extreme 2', 'DDR Supernova 1', 'DDR Supernova 2', 'DDR X1', 'DDR X2', 'DDR X3', 'DDR A1', 'DDR A2', 'DDR A3', 'DDR World', 'ITG1', 'Chroma ITG1', 'ITG2', 'Chroma ITG2', 'ITG3', 'Chroma ITG3', 'ITG Simply Love', 'ITG GrooveNights', 'ITG Velocity', 'ITG Deco', 'ITG Empress', 'ITG Gold', 'ITG Tactics SD', 'ITG Tactics HD', 'PrismRhythm Ver1', 'PrismRhythm Ver2', 'PrismRhythm Ver3', 'CyberiaStyle', 'Focus', 'Sliced', 'Reptilian', 'Glowstone', 'Obsidian', 'Tron', 'Powerpuff', 'VHS', 'StepMania 4', 'StepMania 5' }
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
   -- Stop gameplay between songs in Fitness: Random Endless if all players have 
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

function SetFromSongTitleOnly( actor )
   Trace ( "SetFromSongTitleOnly" )
   local song = GAMESTATE:GetCurrentSong();
   local text = ""
   if song then
      text = song:GetDisplayFullTitle()
   end

   actor:settext( text )
end

function GetGroup(str)

local tokens = {}

local fieldstart = 1
repeat
local nexti = string.find(str, '/', fieldstart)
table.insert(tokens, string.sub(str, fieldstart, nexti-1))
fieldstart = nexti + 1
until fieldstart > string.len(str)

if tokens[table.getn(tokens)-1] then
return tokens[table.getn(tokens)-1]
end

return nil
end

function SetFromCourseTitleOnly( actor )
   Trace ( "SetFromCourseTitleOnly" )
   local course = GAMESTATE:GetCurrentCourse();
   local text = ""
   if course then
      text = course:GetDisplayFullTitle()
   end

   actor:settext( text )
end

function SetCourseLabelAndName( actor )
   Trace ( "SetCourseLabelAndName" )
   local course = GAMESTATE:GetCurrentCourse();
   local mode = ""
   if GAMESTATE:GetPlayMode() == PLAY_MODE_ONI then
      mode = "Survival Course:"
   elseif GAMESTATE:GetPlayMode() == PLAY_MODE_NONSTOP then
      mode = "Marathon Course:"
   end
   local text = ""
   if course then
      text = mode .. " " .. course:GetDisplayFullTitle()
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
   if GAMESTATE:PlayerUsingBothSides() then
      return SCREEN_CENTER_X
   end
   
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

function Zomg_Sound()
   local Path = THEME:GetPath( EC_SOUNDS, '', "girl_moan" )
   SOUND:DimMusic( 0.3, 7 )
   SOUND:PlayOnce( Path )
end

function Zomg_Sound2()
   local Path = THEME:GetPath( EC_SOUNDS, '', "holdingitdown" )
   SOUND:DimMusic( 0.3, 3 )
   SOUND:PlayOnce( Path )
end

function Zomg_Sound3()
   local Path = THEME:GetPath( EC_SOUNDS, '', "specialed" )
   SOUND:DimMusic( 0.3, 5 )
   SOUND:PlayOnce( Path )
end

function Zomg_Sound4()
   local Path = THEME:GetPath( EC_SOUNDS, '', "puppets" )
   SOUND:DimMusic( 0.3, 5 )
   SOUND:PlayOnce( Path )
end

function Zomg_Sound5()
   local Path = THEME:GetPath( EC_SOUNDS, '', "i_got_crabs" )
   SOUND:DimMusic( 0.3, 2 )
   SOUND:PlayOnce( Path )
end

function Zomg_Sound6()
   local Path = THEME:GetPath( EC_SOUNDS, '', "ureahahaha" )
   SOUND:DimMusic( 0.3, 9 )
   SOUND:PlayOnce( Path )
end

function GetStartScreen() PREFSMAN:SetPreference("DelayedScreenLoad",false) if PREFSMAN:GetPreference('BreakComboToGetItem') and GetInputType and GetInputType() == "" then return "ScreenArcadeStart" end return THEME:GetMetric('Common','FirstAttractScreen') end
function GetStepsDescriptionText(n)
	local steps = GAMESTATE:GetCurrentSteps(n)
	if not steps then
		text = ''
	else
		text = steps:GetDescription()
	end
	if string.lower(text) == 'blank' then text = '[Not Signed]' end
	return text
end

function AwesomeModeSet(n)
	if n == 0 then
		AwesomeMode = 0
	else
		AwesomeMode = 1
		SCREENMAN:SystemMessage("Cannot fail.")
	end
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


--[[
OpenITG resolution switcher, version 1.0
Licensed under Creative Commons Attribution-Share Alike 3.0 Unported
(http://creativecommons.org/licenses/by-sa/3.0/)

These probably won't work unless they're used on the same screen. You've been warned.

Written by Mark Cannon ("Vyhd") for OpenITG (http://www.boxorroxors.net/)
All I ask is that you keep this notice intact and don't redistribute in bytecode.
--]]

-- used in a few places, so we keep it here.
-- checks to see if two floats are equal, within error
local function fequ( f1, f2, error )
	if not f1 or not f2 then return nil end
	local error = error or 0.01
	local absolute_diff = math.abs(f1 - f2)
	return absolute_diff < error
end

-- Ratio is pre-declared in order to avoid drifting due to
-- saving badly-rounded floats over time. Possibly paranoia,
-- but this will save us some headaches regardless.
local Resolutions =
{
	["4:3"] = 
	{
		Ratio = 1.333333,
		Res = { "512x384", "640x480", "800x600", "1024x768", "1152x864", "1280x1024", "1400x1050", "1600x1200" },
	},

	["16:10"] =
	{
		Ratio = 1.6,
		Res = { "720x480", "1000x600", "1280x800", "1440x900", "1600x1024" },
	},

	["16:9"] =	
	{
		Ratio = 1.777777,
		Res = { "960x540", "1280x720", "1600x900", "1920x1080" },
	},
    
    ["3:2"] =	
	{
		Ratio = 1.5,
		Res = { "750x500", "1500x1000" },
	},
    
    ["5:4"] =	
	{
		Ratio = 1.25,
		Res = { "625x500", "1250x1000" },
	},
}

-- Width, then height. "640x480" -> 640, 480
local function SplitResolution( res )
	-- part before "x" is the width in pixels, part after is height in pixels
	local delim_pos = string.find( res, "x" )
	local width = tonumber( string.sub(res,1,delim_pos-1) )
	local height = tonumber( string.sub(res,delim_pos+1) )
	return width, height
end

-- returns the float value associated with the given ratio
local function RatioToFloat( ratio )
	return tonumber(Resolutions[ratio].Ratio)
end

-- returns the table key that best matches the given ratio
local function FloatToRatio( float )
	for key,tbl in pairs(Resolutions) do
		if fequ( tbl.Ratio, float ) then return key end
	end

	return nil
end

-- holds the aspect ratio that the system will have once everything's set
local temp_ratio = FloatToRatio( PREFSMAN:GetPreference("DisplayAspectRatio") )
local temp_float = RatioToFloat( temp_ratio )

-- This function only sets a temporary ratio for the other table to pick up on
function LuaSetAspectRatio()	
	-- build from all the key values of Resolutions
	local Names = {}
	for k,v in pairs(Resolutions) do table.insert(Names, k) end
	
	local function Load(self, list, pn)
		for i=1,table.getn(Names) do
			if fequ(temp_float, RatioToFloat(Names[i])) then list[i] = true return end
		end
	
		list[1] = true;	-- default to 4:3
	end

	local function Save(self, list, pn)
		for i=1,table.getn(Names) do
			if list[i] then
				if not fequ(ratio,temp_float) then
					temp_ratio = Names[i]
					temp_float = RatioToFloat( temp_ratio )
					MESSAGEMAN:Broadcast( "AspectRatioChanged" )
					return
				end
			end
		end
	end

	local Params =
	{
		Name = "AspectRatio",
		LayoutType = "ShowOneInRow",
		ExportOnChange = true,
	}

	return CreateOptionRow( Params, Names, Load, Save )
end

function LuaSetResolution( ratio )
	-- Fill in with the values names of the appropriate Resolutions table
	local Names = {}
	for i=1,table.getn(Resolutions[ratio].Res) do table.insert(Names, Resolutions[ratio].Res[i]) end
	
	local curwidth = PREFSMAN:GetPreference( "DisplayWidth" )
	local curheight = PREFSMAN:GetPreference( "DisplayHeight" )

	local function Load(self, list, pn)
		for i=1,table.getn(Names) do
			local width, height = SplitResolution( Names[i] )

			-- just find the closest match here...
			if width == curwidth or height == curheight then list[i] = true return end
		end

		-- fallback value: smallest one
		list[1] = true
	end

	local function Save(self, list, pn)
		for i=1,table.getn(Names) do
			if list[i] then
				-- make sure we're the right one being selected
				if ratio ~= temp_ratio then return end

				local width, height = SplitResolution( Names[i] )

				-- set the new preferences
				PREFSMAN:SetPreference( "DisplayWidth", width )
				PREFSMAN:SetPreference( "DisplayHeight", height )
				PREFSMAN:SetPreference( "DisplayAspectRatio", Resolutions[ratio].Ratio )
				Debug( "New resolution: " .. width .. "x" .. height .. ", ratio " .. Resolutions[ratio].Ratio )
				
				DISPLAY:SetWindowPositionAndSize(0,0,width,height)

				GAMESTATE:DelayedGameCommand( "reloadtheme" )
			end
		end
	end

	local Params =
	{
		Name = "DisplayResolution",
		LayoutType = "ShowOneInRow",

		-- disable this line if it isn't used for the current ratio
		EnabledForPlayers = fequ(RatioToFloat(ratio),temp_float) and {PLAYER_1,PLAYER_2} or {},
		ReloadRowMessages = { "AspectRatioChanged" },
	};

	return CreateOptionRow( Params, Names, Load, Save )
end