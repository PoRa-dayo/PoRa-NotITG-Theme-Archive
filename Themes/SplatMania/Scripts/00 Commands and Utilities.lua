function RadarValue(pn,n)
	--RADAR_CATEGORY_STREAM		0
	--RADAR_CATEGORY_VOLTAGE		1
	--RADAR_CATEGORY_AIR			2
	--RADAR_CATEGORY_FREEZE		3
	--RADAR_CATEGORY_CHAOS		4
	--RADAR_CATEGORY_TAPS		5
	--RADAR_CATEGORY_JUMPS		6
	--RADAR_CATEGORY_HOLDS		7
	--RADAR_CATEGORY_MINES		8
	--RADAR_CATEGORY_HANDS		9
	--RADAR_CATEGORY_ROLLS		10
	if GAMESTATE:IsPlayerEnabled(pn) and GAMESTATE:IsHumanPlayer(pn) then
		return GAMESTATE:GetCurrentSteps(pn):GetRadarValues(pn):GetValue(n)
	else
		return 0
	end
end

function XboxController()
	local InputDevices = INPUTMAN:GetDescriptions()
	for i=1,table.getn(InputDevices) do
		if InputDevices[i] == "Xbox One Wired Controller" then
			return true
		else
			return false
		end
	end
end

-- Noteskin reader system.
Nskin = {};

function Nskin.Load(sButton,sElement)
	LoadNoteskinlua = assert(loadfile(string.sub(NOTESKIN:GetPath("Note","skin"), 2)));
	LoadNoteskinlua();
	Button, Element = NoteLoad(sButton, sElement);
	return NOTESKIN:GetPath(Button,Element);
end;

function Nskin.Command(self)
	return NoteCommand(self);
end;

function GetGameplayNextScreen()
	Trace( "GetGameplayNextScreen: " )
	Trace( " AllFailed = "..tostring(AllFailed()) )
	Trace( " IsEventMode = "..tostring(GAMESTATE:IsEventMode()) )
	Trace( " IsSyncDataChanged = "..tostring(GAMESTATE:IsSyncDataChanged()) )

	if GAMESTATE:IsSyncDataChanged() then 
		return "ScreenSaveSync"
	end
		
	-- Never show evaluation for training.
	if GAMESTATE:GetCurrentSong():GetSongDir() == "Songs/In The Groove/Training1/" then 
		if GAMESTATE:IsEventMode() then 
			return SongSelectionScreen()
		else
			return EvaluationNextScreen()
		end
	elseif AllFailed() and not GAMESTATE:IsCourseMode() then 
		if GAMESTATE:IsEventMode() then 
			return "ScreenEvaluationStageFailed"
		else
			return "ScreenNameEntryTraditional"
		end
	else 
		return SelectEvaluationScreen() 
	end
	
	return "GetGameplayNextScreen: YOU SHOULD NEVER GET HERE"
end

function SelectEvaluationScreen()
	if IsNetConnected() then return "ScreenNetEvaluation" end
	Mode = PlayModeName()
	if( Mode == "Regular" ) then
		return "ScreenEvaluationStage"

	end
	if( Mode == "Nonstop" ) then return "ScreenEvaluationNonstop" end
	if( Mode == "Oni" ) then return "ScreenEvaluationOni" end
	if( Mode == "Endless" ) then return "ScreenEvaluationEndless" end
	if( Mode == "Rave" ) then return "ScreenEvaluationRave" end
	if( Mode == "Battle" ) then return "ScreenEvaluationBattle" end
end

-- Had to make some comands to make the number actually round
-- Because lua doesn't have it exactly.
function math.sign(v)
	return (v >= 0 and 1) or -1
end

function math.round(v, bracket)
	bracket = bracket or 1
	return math.floor(v/bracket + math.sign(v) * 0.5) * bracket
end

function PlrDiff(pn)
	return GAMESTATE:GetCurrentSteps(pn):GetDifficulty()
end

function ReturnTestingText()
	text = ''

	text = text.."Welcome back to this testing build of SplatMania."
	text = text.."\n"
	text = text.."\n"
	text = text.."I hope you have enjoyed playing the earlier versions of the game.\n"
	text = text.."I seriously can't thank you enough for the support that the people who are helping out and also mentioning about this game. Seriously, thank you!\n\n"
	text = text.."It's been almost a month since I started this project back from the ground up. And well, there's been a lot of progress. I've worked non-stop on this all day, everyday, and I don't plan on stopping.\n\n"
	text = text.."This is like... the first project where people actually wanted to help me with it, and I just can't believe it. I've always worked alone, with no-one else. And it's been like for 2 years since I started being on the OITG theming scene.\n\n"
	text = text.."I specially want to thank Mr. Squidball, GreenJelly, Jared MS and anonymous for sticking around and also helping with the game! Thanks so much guys!\n\n"
	text = text.."And as for you, the player currently testing, I would like to say, have fun with the game. If you find any bugs, please, let us know!\n\n"
	text = text.."If you want to help or be more updated on the game's progress, check out our development Discord!\n\n"
	text = text.."https://discord.gg/v6wHdbb"

	return text
end

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

DiffColorTable = {
	{ THEME:GetMetric('Difficulties', 'Beginner'), {0.5,1,1,1} },
	{ THEME:GetMetric('Difficulties', 'Easy'), {0.5,1,0.5,1} },
	{ THEME:GetMetric('Difficulties', 'Medium'), {1,1,0.5,1} },
	{ THEME:GetMetric('Difficulties', 'Hard'), {1,0.5,0.5,1} },
	{ THEME:GetMetric('Difficulties', 'Expert'), {0.5,0.5,1,1} },
	{ THEME:GetMetric('Difficulties', 'Edit'), {1,1,1,1} },
}

SPCommand = {}

function SPCommand:GetDisplaySubtitle()
	if GAMESTATE:GetCurrentSong() then
		local song = GAMESTATE:GetCurrentSong();
		return string.sub(song:GetDisplayFullTitle(), string.len(song:GetDisplayMainTitle()) + 1);
	else
		return ""
	end
end

-- Function for neccesary profile request calls.
function Profile() return PROFILEMAN:GetMachineProfile():GetSaved() end
function SaveProfiles() return PROFILEMAN:SaveMachineProfile() end

function CoinGenerator(pn)
	local function StatsCombined(pn, n1, n2, n3, n4)
		return math.round( ( GetPSStageStats(pn):GetTapNoteScores(n1) * 2 ) +  ( GetPSStageStats(pn):GetTapNoteScores(n2) ) + ( GetPSStageStats(pn):GetTapNoteScores(n3) / 2 ) + ( GetPSStageStats(pn):GetTapNoteScores(n4) / 4 ) )
	end

	return StatsCombined(pn, 8, 7, 6, 5)
end

function UpdateSortName(self)
	self:finishtweening()
      	local GetSort = GAMESTATE:GetSortOrder()
      	local SetSort = {
          	{ THEME:GetMetric("Sort Ordering", "All")      },
          	{ THEME:GetMetric("Sort Ordering", "Title")    },
          	{ THEME:GetMetric("Sort Ordering", "BPM")      },
          	{ THEME:GetMetric("Sort Ordering", "PlayerBe") },
          	{ THEME:GetMetric("Sort Ordering", "Best")     },
          	{ THEME:GetMetric("Sort Ordering", "Artist")   },
          	{ THEME:GetMetric("Sort Ordering", "Genre")    },
          	{ THEME:GetMetric("Sort Ordering", "SongLeng") },
          	{ THEME:GetMetric("Sort Ordering", "DiffEasy") },
          	{ THEME:GetMetric("Sort Ordering", "DiffMedi") },
          	{ THEME:GetMetric("Sort Ordering", "DiffHard") },
          	{ THEME:GetMetric("Sort Ordering", "DiffChal") },
          	{'Selecting...'},
      	}

	-- SORT_PREFERRED		0
	-- SORT_GROUP			1
	-- SORT_TITLE			2
	-- SORT_BPM				3
	-- SORT_POPULARITY		4
	-- SORT_TOP_GRADES		5
	-- SORT_ARTIST			6
	-- SORT_GENRE			7
	-- SORT_SONG_LENGTH		8
	-- SORT_EASY_METER		9
	-- SORT_MEDIUM_METER	10
	-- SORT_HARD_METER		11
	-- SORT_CHALLENGE_METER	12
	-- SORT_MODE_MENU		13
	-- SORT_ALL_COURSES		14
	-- SORT_NONSTOP			15
	-- SORT_ONI				16
	-- SORT_ENDLESS			17
	-- SORT_ROULETTE			18

    -- Because ROULETTE is sort number 18, we need to do a check for this.
    -- Also we don't use this on course mode stuff, so those aren't added.
    if not GAMESTATE:IsCourseMode() then
        if GetSort ~= 18 then
            self:settext( THEME:GetMetric("Sort Ordering", "Main")..SetSort[GetSort][1] or ' ' )
        else
            self:settext( THEME:GetMetric("Sort Ordering", "Main")..'ROULETTE!' )
            self:rainbow()
        end
    end
end

function InitalBootUpScreen()
	HoursForNews = {0,2,4,6,8,10,12,14,16,18,20,22}

	for i=1,table.getn(HoursForNews) do
		if Hour() == HoursForNews[i] then
			return "SplatSaveWarning"
		else
			return "SplatBootUp"
		end
	end
end

function Splat_LoadBanner(self)
	if GAMESTATE:GetCurrentSong() then
        if GAMESTATE:GetCurrentSong():GetBannerPath() then
            self:hidden(0)
            self:scaletoclipped(229,90);
            self:LoadBanner(GAMESTATE:GetCurrentSong():GetBannerPath());
        else
            self:LoadBanner(ThemeFile('Common fallback banner'))
        end
    else
        self:LoadBanner(ThemeFile('Common fallback banner'))
    end
end

function Splat_LoadBackground(self)
	if GAMESTATE:GetCurrentSong() then
        if GAMESTATE:GetCurrentSong():GetBackgroundPath() then
            self:hidden(0)
            self:scaletoclipped(250,150);
            self:LoadBackground(GAMESTATE:GetCurrentSong():GetBackgroundPath());
        else
            self:LoadBackground(ThemeFile('Common fallback background'))
        end
    else
        self:LoadBackground(ThemeFile('Common fallback background'))
    end
end

function ThemeFile( file )
	return THEME:GetPath(EC_GRAPHICS,'', file )
end

function JudgmentTween(self)
	self:y(20);
	self:diffusealpha(1);
	self:zoom(0.6);
	self:decelerate(0.1);
	self:zoom(0.5);
	self:sleep(0.5);
	self:accelerate(0.2);
	self:diffusealpha(0);
end

function ColCon(n1, n2, n3)
	return (n1/255),(n2/255),(n3/255),1
end

function ThemeName() local str = string.sub(THEME:GetPath(2,'','_blank.png'),9) return string.sub(str,1,string.find(str,'/')-1) end

function LOAD_GLOBAL( file ) return "../GLOBAL/"..file end

function Center(self)
	self:x(SCREEN_CENTER_X)
	self:y(SCREEN_CENTER_Y)
end

SplatManiaSongNames = {
		{'15', 'HOME' },
		-- The following are for testing, and are not in the actual game.
		{'NEONアーキテクチャ (パート2)', 'death\'s dynamic shroud.wmv' },
	}

function TwoLinesTitleTween(self)
	self:zoom(0.9); 
	self:maxwidth(570); 
	self:y(-30);
	for i=1,table.getn(SplatManiaSongNames) do
		if self:GetText() == SplatManiaSongNames[i][1] then
			self:settext('\n  -- [EXTRA] Octoling\'s Mix 1 --')
		end
	end
end

function TwoLinesArtistTween(self)
	self:zoom(0.9); 
	self:maxwidth(570); 
	self:y(-30);
	for i=1,table.getn(SplatManiaSongNames) do
		if self:GetText() == 'by: '..SplatManiaSongNames[i][2] then
			self:settext(' ')
		end
	end
end

function ThreeLinesTitleTween(self)
	self:zoom(0.7); 
	self:maxwidth(380); 
	self:y(-25); 
	self:x(-200)
	for i=1,table.getn(SplatManiaSongNames) do
		if self:GetText() == SplatManiaSongNames[i][1] then
			self:settext('\n  -- [EXTRA] Octoling\'s Mix 1 --')
		end
	end
end

function ThreeLinesSubtitleTween(self)
	self:hidden(0); 
	self:zoom(.5); 
	self:maxwidth(500); 
	self:x(-200)
	for i=1,table.getn(SplatManiaSongNames) do
		if self:GetText() == SplatManiaSongNames[i][1] then
			self:settext(' ')
		end
	end
end

function ThreeLinesArtistTween(self)
	self:zoom(0.6); 
	self:maxwidth(400); 
	self:y(0); 
	self:horizalign('right'); 
	self:x(240)
	for i=1,table.getn(SplatManiaSongNames) do
		if self:GetText() == 'by: '..SplatManiaSongNames[i][2] then
			self:settext(' ')
		end
	end
end

function AudioPlay( file )
	return SOUND:PlayOnce( THEME:GetPath( EC_SOUNDS, '', file ) )
end

function PercentageNumber(pn, name)
	local CalcPerNames = {
    	["Cur"] = STATSMAN:GetCurStageStats(),
    	["Accum"] = STATSMAN:GetAccumStageStats(),
	}

	-- TODO: Change Internal name lol
	-- To: SPLMANIA
	-- The old one stuck here lmao.
    if (SPLMANIA or FUCK_EXE or OPENITG) and CalcPerNames[name] and GAMESTATE:IsPlayerEnabled(pn) then
        local GPSS = CalcPerNames[name]:GetPlayerStageStats(pn);
        return tonumber( string.sub( FormatPercentScore( GPSS:GetActualDancePoints()/GPSS:GetPossibleDancePoints() ), -1 ) )
    else
        return ""
    end
end

function CalculatePercentage(self, pn, name)
	local CalcPerNames = {
    	["Cur"] = STATSMAN:GetCurStageStats(),
    	["Accum"] = STATSMAN:GetAccumStageStats(),
	}

    if (SPLMANIA or FUCK_EXE or OPENITG) and CalcPerNames[name] and GAMESTATE:IsPlayerEnabled(pn) then
        local GPSS = CalcPerNames[name]:GetPlayerStageStats(pn);
        self:settext( FormatPercentScore( GPSS:GetActualDancePoints()/GPSS:GetPossibleDancePoints() ) )
    else
        self:settext(' ')
    end
end

function PlayerColor( pn )
	if pn == PLAYER_1 then return "#FBBE03" end	-- orange
	if pn == PLAYER_2 then return "#56FF48" end	-- green
	return "1,1,1,1"
end

function GetScore( pn )
	return STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetScore()
end

function MissionModeScreen(name)
	return "MissionMode/"..name
end

-- function MMNextScreen()
-- 	if MissionModeNextScreen then
-- 		return "../MissionMode/"..MissionModeNextScreen
-- 	else
-- 		return ""
-- 		SCREENMAN:SystemMessage("There's no screen inserted!")
-- 	end
-- end

function RecieveTapNoteScore(self, pn, n1, n2, n3, n4, n5, n6, name1, name2)
	local NoteType = {
    	["Stage"] = GetPSStageStats(pn),
    	["Total"] = GetPSStats(pn),
	}

	local JudgeDiffuses = {
	["Fantastic"] = {138,255,255},
	["Excellent"] = {251,255,63},
	["Great"] = {63,255,122},
	["Decent"] = {228,122,255},
	["WayOff"] = {255,145,63},
	["Miss"] = {255,63,63},
}

	self:x( n2 )
    self:shadowlength(0)
    self:y( n3 )
    self:diffusealpha(0)
    self:zoom(n6)
    self:addx(n5)
    --
    if GAMESTATE:IsPlayerEnabled(pn) then
    	if NoteType[name1] == nil then
    		self:settext( '' )
    	else
        	self:settext( string.format('% 5d',NoteType[name1]:GetTapNoteScores(n1)) )
        end
        self:sleep(0.125*n4)
        self:decelerate(0.2)
        self:diffuse( ColCon( JudgeDiffuses[name2][1], JudgeDiffuses[name2][2], JudgeDiffuses[name2][3] ) )
        self:addx(-n5)
    else
        self:settext( math.random(1,52400) )
    end
end
-- Get Total Score for Summary Screen And Normal EventMode Results
function GetTotalScore( pn ) return STATSMAN:GetAccumStageStats():GetPlayerStageStats(pn):GetScore() end
-- Get Specific Tap Note Score for Summary Screen
function GetPSStats( pn ) return STATSMAN:GetAccumStageStats():GetPlayerStageStats(pn) end
-- Get Specific Tap Note Score for Normal Evaluation
function GetPSStageStats( pn ) return STATSMAN:GetCurStageStats():GetPlayerStageStats(pn) end

function GetStartScreen() PREFSMAN:SetPreference("DelayedScreenLoad",false) if PREFSMAN:GetPreference('BreakComboToGetItem') and GetInputType and GetInputType() == "" then return "ScreenArcadeStart" end return THEME:GetMetric('Common','FirstAttractScreen') end

function IsEasierDifficulty( pn ) 
    if not GAMESTATE:GetCurrentSong() or not GAMESTATE:GetCurrentSteps(pn) then return false end
    -- Apparently GetStepsByStepsType only returns the UNLOCKED steps that match the stepsType, like, WOW DID YOU KNOW THAT?????
    local stype = GAMESTATE:GetCurrentSteps(pn):GetStepsType()
    local DiffList = GAMESTATE:GetCurrentSong():GetStepsByStepsType(stype)
    local EasiestDiff = 5
    for _, steps in pairs(DiffList) do
        if steps:GetDifficulty() < EasiestDiff then
            EasiestDiff = steps:GetDifficulty()
        end
    end
    local CurrentDiff = GAMESTATE:PlayerDifficulty(pn)
    local IsEasierDiff = EasiestDiff < CurrentDiff
    return IsEasierDiff
end

function IsHarderDifficulty( pn ) 
    if not GAMESTATE:GetCurrentSong() or not GAMESTATE:GetCurrentSteps(pn) then return false end
    local stype = GAMESTATE:GetCurrentSteps(pn):GetStepsType()
    local DiffList = GAMESTATE:GetCurrentSong():GetStepsByStepsType(stype)
    local HardestDiff = 0
    for _, steps in pairs(DiffList) do
        if steps:GetDifficulty() > HardestDiff then
            HardestDiff = steps:GetDifficulty()
        end
    end
    local CurrentDiff = GAMESTATE:PlayerDifficulty(pn)
    local IsHarderDiff = HardestDiff > CurrentDiff
    return IsHarderDiff
end