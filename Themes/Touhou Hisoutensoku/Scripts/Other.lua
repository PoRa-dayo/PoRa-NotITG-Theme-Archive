-- Override these in other themes.
function Platform() return "generic" end
function IsHomeMode() return false end

function SelectButtonAvailable()
   return true
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

--
-- Options
--

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


function SetFromCourseTitleOnly( actor )
   Trace ( "SetFromCourseTitleOnly" )
   local course = GAMESTATE:GetCurrentCourse();
   local text = ""
   if course then
      text = course:GetDisplayFullTitle()
   end

   actor:settext( text )
end


function SongTitle(self)
    self:settext(' ')
    if GAMESTATE:IsCourseMode() then
        local course = GAMESTATE:GetCurrentCourse()
        if course then
            self:settext( course:GetDisplayFullTitle() )
        end
    else
        local songg = GAMESTATE:GetCurrentSong()
        if songg then
            self:settext( songg:GetDisplayMainTitle() )
        end
    end
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

function GetPaneX( player )
   if GAMESTATE:PlayerUsingBothSides() then
      return SCREEN_CENTER_X-160-80
   end
   
   if player == PLAYER_1 then
      return SCREEN_CENTER_X-160-80
   else
      return SCREEN_CENTER_X-160+66
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

function GameState:PlayerDifficulty( pn )
   if GAMESTATE:IsCourseMode() then
      local trail = GAMESTATE:GetCurrentTrail(pn)
      return trail:GetDifficulty()
   else
      local steps = GAMESTATE:GetCurrentSteps(pn)
      return steps:GetDifficulty()
   end
end

function GameState:PlayerMeter( pn )
   if GAMESTATE:IsCourseMode() then
      local trail = GAMESTATE:GetCurrentTrail(pn)
      return trail:GetMeter()
   else
      local steps = GAMESTATE:GetCurrentSteps(pn)
      return steps:GetMeter()
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
	if string.lower(text) == 'blank' then text = '[Not Signed]' end
	return text
end

function Radar(pn,cat)
    local GetRadar = GAMESTATE:GetCurrentSteps(pn):GetRadarValues(pn);
    return GetRadar:GetValue(cat);
end

function ScreenSelectMusicUpdate(self)
	local song = GAMESTATE:GetCurrentSong();
    local trail = GAMESTATE:GetCurrentTrail(PLAYER_1);
    local course = GAMESTATE:GetCurrentCourse();
    local songmil, songsec, songmin, length, title
		
	if song then
		
		songmil = "00"
		
        local lenSec = song:MusicLengthSeconds()
		songsec = lenSec%60;
		songmin = math.floor(lenSec/60);
		for c in string.gfind(songsec,"%d+%p(%d%d)") do
			songmil = c;
		end;
		
		length = string.format("%02d:%02d",  songmin, songsec).."."..songmil;
		
		title = song:GetDisplayMainTitle();
	elseif trail then
        songmil = "00"
		
        local lenSec = trail:GetLengthSeconds()
		songsec = lenSec%60;
		songmin = math.floor(lenSec/60);
		for c in string.gfind(songsec,"%d+%p(%d%d)") do
			songmil = c;
		end;
		
		length = string.format("%02d:%02d",  songmin, songsec).."."..songmil;
		
        if course then
            title = course:GetDisplayFullTitle();
        else
            title = ""
        end
    else
		title = "";
		length = "00:00.00";
	end;
		
	self:GetChild("Container"):GetChild("title"):settext(title);
	self:GetChild("Container"):GetChild("length"):settext(length);
	--nps
    local P1NPS = self:GetChild("Container"):GetChild("P1NPS");
    local P2NPS = self:GetChild("Container"):GetChild("P2NPS");

	
	local difloc = {
		Novice = 32*0.40,
		Easy = 32*1.46,
		Normal = 32*2.52,
		Hard = 32*3.58,
		Lunatic = 32*4.64,
		Extra = 32*5.70,
	};
	
	
	local p1curB = self:GetChild("Container"):GetChild("p1curB");
	local p2curB = self:GetChild("Container"):GetChild("p2curB");
	local p1curA = self:GetChild("Container"):GetChild("p1curA");
	local p2curA = self:GetChild("Container"):GetChild("p2curA");
	
		
	--all this just to do difficulty
	if GAMESTATE:IsHumanPlayer(PLAYER_1) then
		if FUCK_EXE and song then
			local ChartLenghtInSec = song:StepsLengthSeconds()
			local P1Taps = Radar(PLAYER_1,RADAR_CATEGORY_TAPS)+Radar(PLAYER_1,RADAR_CATEGORY_HOLDS)+Radar(PLAYER_1,RADAR_CATEGORY_ROLLS);
			P1NPS:settext(string.format("%0.0f",P1Taps/ChartLenghtInSec));
		else
            if GAMESTATE:IsCourseMode() then
                P1NPS:settext("");
            else
                P1NPS:settext("0");
            end
		end;		
		if GAMESTATE:GetCurrentSteps(PLAYER_1) then
			local p1d = DifficultyToThemedString(GAMESTATE:GetCurrentSteps(PLAYER_1):GetDifficulty());
			if song then
				p1curB:visible(1);
				p1curA:visible(1);
			else
				p1curB:visible(0);
				p1curA:visible(0);
			end;
			if movep1 ~= difloc[p1d] or (not ToHoSokuGlob.SelectMusicHasFirstLoaded) then
                p1curB:finishtweening();
                p1curA:finishtweening();
                movep1 = difloc[p1d];
                p1curB:decelerate(0.25);
                p1curA:decelerate(0.25);
                p1curB:x(-142+difloc[p1d]);
                p1curA:x(-137.7+difloc[p1d]);
                p1curB:rotationz(difloc[p1d]*5);
			end;
		else 
			p1curB:visible(0);
			p1curA:visible(0);
		end;
		P2NPS:x(130);
	else
		P2NPS:x(115);
		p1curB:visible(0);
		p1curA:visible(0);
	end;
	
	if GAMESTATE:IsHumanPlayer(PLAYER_2) then
		if FUCK_EXE and song then
			local ChartLenghtInSec = song:StepsLengthSeconds()
			local P2Taps = Radar(PLAYER_2,RADAR_CATEGORY_TAPS)+Radar(PLAYER_2,RADAR_CATEGORY_HOLDS)+Radar(PLAYER_2,RADAR_CATEGORY_ROLLS);
			P2NPS:settext(string.format("%0.0f",P2Taps/ChartLenghtInSec));
		else
            if GAMESTATE:IsCourseMode() then
                P2NPS:settext("")
            else
                P2NPS:settext("0")
            end
		end;
		if GAMESTATE:GetCurrentSteps(PLAYER_2) then
			local p2d = DifficultyToThemedString(GAMESTATE:GetCurrentSteps(PLAYER_2):GetDifficulty());
			if song then
				p2curB:visible(1);
				p2curA:visible(1);
			else
				p2curB:visible(0);
				p2curA:visible(0);
			end;
			if movep2 ~= difloc[p2d] or (not ToHoSokuGlob.SelectMusicHasFirstLoaded) then
                p2curB:finishtweening();
                p2curA:finishtweening();
                movep2 = difloc[p2d];
                p2curB:decelerate(0.25);
                p2curA:decelerate(0.25);
                p2curB:x(-142+difloc[p2d]);
                p2curA:x(-146.2+difloc[p2d]);
                p2curB:rotationz(-difloc[p2d]*5);
			end;
		else 
			p2curB:visible(0);
			p2curA:visible(0);
		end;
		P1NPS:x(105);
	else
		P1NPS:x(115);
		p2curB:visible(0);
		p2curA:visible(0);
	end;
    ToHoSokuGlob.SelectMusicHasFirstLoaded = true
end

function ReplaceSpaceWithLineBreaks(str, WordLimit)
    local words = {}
    for word in string.gfind(str,"%S+") do
        table.insert(words, word)
    end

    if #words == 0 then
        return str
    end

    local result = words[1]

    for i = 2, #words do
        local _, last = string.find(result, ".*\n")

        local lastGroup
        if last then
            lastGroup = string.sub(result, last + 1)
        else
            lastGroup = result
        end

        if #lastGroup + 1 + #words[i] > WordLimit then
            result = result .. "\n" .. words[i]
        else
            result = result .. " " .. words[i]
        end
    end

    return result
end