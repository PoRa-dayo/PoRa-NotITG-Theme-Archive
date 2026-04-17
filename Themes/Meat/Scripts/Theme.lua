maxFeet = 1
minFeet = 1
feetBaseZoom = .24
blankMeter = ''

lvlSpd = SCREEN_WIDTH/650

lifeBarSizeAdd = { Width = 0, Height = -70, OffsetX = 0, OffsetY = 35 }

screenList = { Gameplay = 'ScreenStage' , SelectMusic = SongSelectionScreen , PlayerOptions = SelectFirstOptionsScreen , Summary = function() banner = 9 return 'Summary' end , TitleMenu = ScreenTitleBranch ,  Ending = 'ScreenIntro' }

if not FUCK_EXE then judgmentFontList = { 'Meat' , 'Love' , 'Tactics', 'Chromatic', 'Deco', 'GrooveNights', 'FP', 'ITG2' } end


function FixWidth() if SCREEN_WIDTH == 767 or SCREEN_WIDTH == 853 then SCREEN_WIDTH = SCREEN_WIDTH + 1; SCREEN_CENTER_X = SCREEN_CENTER_X + 1; SCREEN_RIGHT = SCREEN_RIGHT + 1 end lvlSpd = SCREEN_WIDTH/640 end

function HoldTween(self) self:diffuse(1,1,1,1) self:zoom(.8); self:sleep(0.5) self:zoom(0) end

function AspectScale(self) FixWidth() z = SCREEN_WIDTH/640 self:zoom(z) self:x((SCREEN_CENTER_X)*(1-z)) self:y(SCREEN_CENTER_Y*(1-z)) end
function MusicAspectScale(self) FixWidth() z = math.min(SCREEN_WIDTH/640,1.2) self:zoom(z) self:x((SCREEN_CENTER_X)*(1-z)) self:y(SCREEN_CENTER_Y*(1-z)) self:addy(120*(1-z)) end
function TransitionAspectScale(self) FixWidth() z = SCREEN_WIDTH/640/Screen():GetZoom() self:zoom(z) self:x((SCREEN_CENTER_X)*(1-z)) self:y(SCREEN_CENTER_Y*(1-z)) end
function MusicTransitionAspectScale(self) FixWidth() z = math.max(1,SCREEN_WIDTH/768) self:zoom(z) self:x((SCREEN_CENTER_X)*(1-z)) self:y(SCREEN_CENTER_Y*(1-z)) z = math.min(SCREEN_WIDTH/640,1.2); self:addy(-120*(1-z)/z) end
function ReverseAspectScale(self) z = 640/SCREEN_WIDTH self:zoom(z) self:x((SCREEN_CENTER_X)*(1-z)) self:y(SCREEN_CENTER_Y*(1-z)) end

function DifficultyListCommand(self,t) i = self:getaux() self:x((i-1)*(40)) self:shadowlength(0) DifficultyListRow(self,i,t) if t == 'meter' then self:horizalign('left') self:addx(-9) self:y(2) self:zoom(.3) self:diffuse(0,0,0,1) end end
function DifficultyChangingIsAvailable() return GAMESTATE:GetSortOrder() ~= SORT_MODE_MENU end
function ModeMenuAvailable() if GAMESTATE:IsCourseMode() then return false end return DifficultyChangingIsAvailable() end

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

function ItemsLongRowP2() if GAMESTATE:IsPlayerEnabled(PLAYER_1) then return SCREEN_CENTER_X+170 end return SCREEN_CENTER_X+10 end
function GetPaneX( player ) if player == PLAYER_1 then return SCREEN_CENTER_X-230 else return SCREEN_CENTER_X+230 end end

function DoublesPosition()
	if not GAMESTATE:PlayersCanJoin() then return "0" end
	if GAMESTATE:GetCoinMode()==COIN_MODE_FREE then return "0" end
	if GAMESTATE:GetCoinMode()==COIN_MODE_HOME then return "0" end
	if GAMESTATE:GetPremium() ~= PREMIUM_DOUBLE then return "0" end	
	local credits = GAMESTATE:GetCoins() - 2 * PREFSMAN:GetPreference("CoinsPerCredit");
	if credits >= 0 then return "0" end
	return "-21"
end

function GetSongSubTitle()
	if GAMESTATE:GetCurrentSong() then s = string.sub(GAMESTATE:GetCurrentSong():GetDisplayFullTitle(),string.len(GAMESTATE:GetCurrentSong():GetDisplayMainTitle())+2) else s = '' end
	return s
end

function SetFromSongTitleAndCourseTitle( self )
	local text = ""
	if GAMESTATE:GetCurrentSong() then text = GAMESTATE:GetCurrentSong():GetDisplayFullTitle() end
	if GAMESTATE:GetCurrentCourse() then text = GAMESTATE:GetCurrentCourse():GetDisplayFullTitle() .. " - " .. text end
	self:settext( text )
end
	   
-- Unit Tests:
	-- SelectMusic & PlayerOptionsEdit
		-- Negative BPMs in display
		-- Same BPMs in display
		-- X mod with variable BPMS
	-- Edit
		-- PlayerOptions general
		-- SongOptions general
	-- Course ..?
	-- Gameplay
		-- BGChanges
		-- FGChanges
		-- Reverse
		-- Doubles
			-- Surround Life
			-- Compare Score

-- Change GameplayBPM to a luaeffect.

-- rename Measure to Duration, make room for graph.

-- Ghost Data:
	-- Some kind of score-stop upon failure?

-- Improve Clock function

-- General Clean-up


-- Changed UpdateGhostData to keep tap number constant between judge and ghost
-- Changed functions to track failing step, and stop updating Ghost DP afterwards.

local adsfsafas = [[

Significant changes:
[hide=Summary of all the new stuff]
[b][u]Player Options[/u][/b]
    There are now 2 player options screens, the first contains the most important mods, the second contains additional regular and custom mods. To go to the second options screen, select 'more options' on the 'Next Screen' option.
    Speed mods are now handled differently. The first line selects the mod type, the second line changes the value. Holding left/right will make it change faster.
    Player options in general are now handled very differently, entirely through lua. It makes it 100x easier for me to copy changes from theme to theme, but makes it less straight forward for other people to edit options.
    If any part of the player options seems strange or doesn't work properly, please let me know.

[b][u]Mods saved to card[/u][/b]
    These themes will now save some additional mods to your card, including mini, hide background, and all of the new custom mods. Because of the way in which they are saved, a theme must specifically read and apply them when a game starts. They won't be applied if you switch to a theme other than the new versions of SL, Meatboy, or Tactics.
    If there are other mods that you would like to see saved, let me know.
   
[b][u]Danger flashes[/u][/b]
    When coming out of danger alive, there is now a green flash to let you now you didn't fail. When going from danger to dead, there is a red flash to let you know you failed.

[b][u]Ghost Data[/u][/b]
    These themes can now save ghost data to the machine or player profile(memory card). Ghost Data is a list of judgments and time stamps, essentially a complete recording of your score as it happened.
    The saved ghost data is used by several of the new custom mods.
    Due to numerous issues and uncertainties, Ghost data is not saved for courses.
    There is an operator menu option to turn on/off the saving of ghost data to the machine profile. By default it will not save.
    There is an player options menu option to turn on/off the saving of ghost data to the player profile. By default it will not save.
    There is a limit to much large(file size) a player profile can be(3000kb). Each saved ghost data score will take ~1.2kb per 1000 steps(normally saved scores take ~1kb each). While this will not quickly become a problem, it is something to be aware of. There is no such limit on machine profile size.
    There is currently no way built in to these themes to erase ghost data. Such a feature will be included at some point. There may some day be a way to copy ghost data to/from the machine as well.
    Do not turn on ghost data saving unless you are willing to restart your profiles. While it is unlikely, there is always the possible of unforseen problem.
   
[b][u]Compare Score[/u][/b]
    This new custom mod shows you how far off you are from the selected target score, in real time during the song. The value is displayed slightly above and to the right of the judgment. When the difference is 0, nothing is displayed.
    The selectable options are None, Personal(record), Machine(record), Subtractive, and Opponent. The opponent option is selectable only if there are two players both playing the same chart.
    The Subtractive option will show how much score you've lost. I may split subtractive into 2 options, one that shows the maximum score you can still get, and one that shows how much score you've lost.
    When there is ghost data available, the Personal and Machine options will show, step for step, the difference in your current score and the saved score. When ghost data is not available, it will show how far away from the average required to get the machine/personal record you are. If the machine/personal record is 0(no saved scores), these options will show subtractive scoring.
    The option is set to show the difference in dance points up to a difference of 10, and above that show the difference in percent. This boundry is subject to change, depending on what people would prefer.
    If you get a 'miss' tap judgment on a hold or roll, no hold/roll judgment is triggered. My judgment tracking will not know that you missed out on the points you could have gotten from the hold/roll. As such, it is not possible to be entirely accurate on subtractive scoring without the use of special noteskins, which I am not going to do. Comparing to ghost scores will still be accurate.
    If the maximum number of dance points cannot be calculated from the pane display(it shows '?' for most fields on edit charts and some course), comparative score will not be displayed. Too many uncertainties are introduced.

[b][u]Measure Count[/u][/b]
    This new custom mod shows how many measures into the song/stream you are.  The value is displayed slightly above and to the left of the judgment. It will show only streams over 2 measures.
    If 'none' is selected, nothing will be displayed.
    If 'All' is selected, it will display how many measures into the song you are.
    The other selections will display how long a stream has been going at the selected note frequency.
    If there is ghost data available, it will also display how long the stream will be.
    The stream lengths are calculated estimations. It is not possible to tell when a note was supposed to be hit, only when it was actually hit and what judgment was triggered. Whether a judgment was early or late cannot be determined theme-side, you simply have a window in time around a beat when the judgment was triggered. This mod is set to err on the side of inclusion, counting slightly more as stream than is really there, rather than missing some actual stream. Very short breaks in runs or changes in note type will not always be counted as a 'break' by this display, it will often keep counting. This happens more as bpm increases, because the timing windows cover a larger number of beats.
    The calculation functions still need some tweaking to attain more consistant results. My goal is to overcount as little as possible while never undercounting. Feel free to inform me of any inaccuracies you find in the measure count, I know there are plenty. The count seems to be less accurate on my machine than on my PC.
   
[b][u]'Surround' Life Bar[/u][/b]
    This new custom mod transforms the life bar to fill the entire background of the play field. It is still, to some degree, in its 'proof of concept' phase. The final displayed format may change, in some combination of color and blending. Feel free to give me any suggestions for how the display should look. It is possible to make 'full' life look completely different from not-full life.
       
[b][u]Screenshot-able multiple score screen[/u][/b]
    When either going back from ScreenSelectMusic or forward from ScreenNameEntry you should be taken to a screen displaying scores, banners, judgments, etc. for multiple songs at once.
    The scores are split into multiple pages with 4(meatboy) or 5(tactics, SL) scores per screen. Hitting 'start' or 'back(keyboard)' will take you to the next set of results, until all have been shown.
    If there are any problems with formatting or suggestions to improve, please let me know.
	The formatting isn't quite finished in Meatboy.
	
[/hide]   

I've tested all of this stuff in single and versus, on event mode, SM 3.95 and ITG arcade. I have not tested this stuff with courses, doubles, oITG, FG/BGAnimations, reverse, DOWNS files, menu timer on, etc. and have done very limited testing in non-event mode.

If the theme ever crashes, please try to reproduce the crash, to figure out the exact circumstances so that I can duplicate it on my own to fix the problem. If a specific simfile/course is causing the crash, please send me the simfile/course(and all simfiles it uses) when you tell me about the crash.
]]