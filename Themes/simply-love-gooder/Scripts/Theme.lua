
feetBaseZoom = .275
JudgeY = 20

lifeBarSizeAdd.Height = lifeBarSizeAdd.Height - 80
lifeBarSizeAdd.OffsetY = lifeBarSizeAdd.OffsetY + 40

voiceOption = true

rateModsPay = { "1.0x", "1.1x", "1.2x", "1.3x", "1.4x", "1.5x", "1.6x", "1.7x", "1.8x", "1.9x", "2.0x" }
rateModsFree = { "1.0x", "1.1x", "1.2x", "1.3x", "1.4x", "1.5x", "1.6x", "1.7x", "1.8x", "1.9x", "2.0x", "0.5x", "0.6x", "0.7x" , "0.8x", "0.9x" }

screenList = { Gameplay = 'ScreenStage' , SelectMusic = 'ScreenSelectMusic' , PlayerOptions = 'ScreenPlayerOptions' , TitleMenu = ScreenTitleBranch  , NameEntry = 'ScreenNameEntryTraditional' , Evaluation = SelectEvaluationScreen , Summary = 'Summary' , Ending = SelectEndingScreen }

function CompareTextFormat(self,n) self:zoom(.3) end -- This is added on top of the base positioning etc.

ShowAllInRow = true

function ColorRGBCommand(self, n)
	self:diffuse(1,1,1,1)
	if ColorRGB ~= nil then
		self:diffuse(ColorRGB(n))
	end
end

function NonCombos()
	local t = OptionRowBase('NonCombos')
	t.OneChoiceForAllPlayers = true
	t.Choices = { "On", "Decents Only", "Off" }
	t.LoadSelections = function(self, list, pn) if not Decents() then list[3] = true elseif not WayOffs() then list[2] = true else list[1] = true end end
	t.SaveSelections = function(self, list, pn)
		if list[1] then SetPref('JudgeWindowSecondsGood',0.135) SetPref('JudgeWindowSecondsBoo',0.180) end
		if list[2] then SetPref('JudgeWindowSecondsGood',0.135)	SetPref('JudgeWindowSecondsBoo',0.135) end
		if list[3] then	SetPref('JudgeWindowSecondsGood',0.102)	SetPref('JudgeWindowSecondsBoo',0.102) end
	end
	return t
end

function Decents() if math.abs(PREFSMAN:GetPreference('JudgeWindowSecondsGood') - 0.135) < .001 then return true end end
function WayOffs() if math.abs(PREFSMAN:GetPreference('JudgeWindowSecondsBoo') - 0.180) < .001 then return true end end

-- not even used, but whatever.
function wrap(val,max,min)
	if not min then min = 0 end
	return math.mod(val+(max-min+1)-min,max-min+1)+min
end

WindowTitles = {
	"F-CUK", 																                                      -- Requested by NumLk
	"Simply Windowed", 													                                          -- Requested by Akita
	"luv ♥",																                                      -- Requested by Mr.ThatKid
	"Don't fuck the bed", 													                                      -- Hal.dll
	"I β'd all over your iPad", 											                                      -- Ky_Dash
	"Laer wins mods by doing absolutely nothing", 							                                      -- Ky_Dash
	"-|-|-|-|- TANG PONGING INTENSIFIES -|-|-|-|-", 						                                      -- Laer
	"the frigonometric fuctions: FUCK, SHIT, SHUCK, FICK, KCUF, TIHS", 	                                          -- Requested
	"Gonna invent a new genre called TouretteCore", 						                                      -- TaroNuke
	"instructions unclear, aft'd my face", 								                                          -- Gezoda
	"There will be consequences.", 											                                      -- Requested by Akita
	"I can't believe it's not ITG!", 										                                      -- Requested by Mr.ThatKid
	"Have you ever came accross dollar store Shrek?", 						                                      -- Mars
	"What's with the sudden surge of shitting down?", 						                                      -- BrightXeno
	"I could write pages on how Shakunetsu tastes bad", 					                                      -- Mars
	"If the ass doesn't show up, you know you've broke the lua", 			                                      -- WinDEU
	"New modifier: tween the clothes of the players", 						                                      -- Ky_Dash
	"How many percent of drunk are you on right now? - 500 percent tony", 	                                      -- TaroNuke & Ky_Dash
	"ky, ky, He's our guy, if he can't do it, no man's sky",				                                      -- Akita
	"how'd you get ▓▓▓▓ ▒▒s on a ▒░▓▒░▒▒▓▓", 								                                      -- Telperion
	"Try not to break it again",											                                      -- Requested by Melody
	"I think one of the effects is broken, it just made the song silent",  	                                      -- WinDEU
	"The effect made the song better",										                                      -- TaroNuke
	"GetBaby('Background'):zoomy(1337)",									                                      -- Kirby5464
	"TEAM DRAGONFORCE",														                                      -- Zetorux
	"THIS ISN'T TEAM TOW-HOW",												                                      -- Zetorux
	"Todokete",																                                      -- Requested by BrightXeno
	"Simply Love Goodest",													                                      -- Requested by BrightXeno
	"Driftin' Donuts",														                                      -- Requested by Kirby5464
	"table.insert(drugs,{*100 drunk})",										                                      -- Requested by Kirby5464
	"The Game where you Frantically step metal pads to the music",			                                      -- Requested by BrightXeno
	"NotDDR v6.9.6.9.6.9.6.9",												                                      -- Requested by Kirby5464
	"Exotic Butters",														                                      -- Kirby5464
	"Don't let your dreams be dreams",										                                      -- Requested by RenBowe
	"BEATMANIA IIDX24 SINOBUZ",												                                      -- Requested by Rhythm Lunatic
	"SOUND VOLTEX IV HEAVENLY HEAVEN",										                                      -- Requested by Rhythm Lunatic
	"Dance Dance Revolution A",												                                      -- Requested by Rhythm Lunatic
	"i injected "..math.random(2,12).." marijuana input listeners directly into my noteskin and now I'm KICKASS", -- Telperion
	"FUCK YOU SNACKS I AM THE MOD BITCH",													                      -- Laer
	"I got the window to fuck off the screen",												                      -- TaroNuke
	"just set a function that literally throws their pc out a window",						                      -- SMSnacks
	"That hold is stealing someones lunch money",											                      -- TaroNuke
	"my state is gamestate",																                      -- Laer
	"There's like no arrows because the bpm is minus four",									                      -- TaroNuke
	"What do you mean? It's ａｒｔ",															                      -- Frums
	"Mawaru 9: Randomly Generated Tang-10-MatoiPongs",										                      -- Jose_Varela
	"can I do a zoomz(0) on my pc",															                      -- Melody
	"Renbowe is a basic Bitch.",															                      -- SMO Bot
	"Bro. Relax.",																			                      -- Requested by Kirby5464
	"nullXP",																				                      -- Requested by Kirby5464
	""..math.random(0,9000000).." XP",														                      -- Jose_Varela
	"I LIKE RHYTHM GAMES",								                                                          -- Kirby5464
	"h",																										  -- not a popular meme
	"heck",																										  -- Jose_Varela & willycel123
	"We Are The Loss",																						      -- CondorTalon, TaroNuke, Daikyi, Exschwasion, Ky_Dash, Halcyoniix
	
}

function GetRandomWindowTitle()
	return "SIMPLY LOVE GOODER (Jose\'s Unofficial Visual Modification) - "..WindowTitles[math.random(1,table.getn(WindowTitles))]
end

Protips = {
	"Pressing Scroll Lock immediately allows you to go to options.",
    "Holding F3 brings up the debug menu.",
    "Hold down Tab to make things go fast, ~ for making things slow, and both to make things stop. You can use Shift to double the effect.",
	"Pressing PrintScr/SysRq takes a screenshot of the game, pressing Shift+PrintScr/SysRq will do so in a .png format and in original size.",
	"You can map keys/inputs by going into Options -> Config Key/Joy Mappings.",
	"Pressing F8 Enables the AutoPlay. Pressing it again enables the AutoPlay CPU.",
	"You can control both players by using BothAtOnce. [ F3+5 ]. This is only available for Builds from March 5th onwards.",
	"Poke Jousway in the forums/Discord for anything noteskin related.",
	"Go to [zettbou.co.uk] or [jose.heysora.net/NITG/NoteSkins] for noteskins.",
	"Check http://www.flashflashrevolution.com/vbz/showthread.php?t=133223 for a huge list of simfile packs.",
	"Check the UKSRT Discord for more frequent updates of SLG(JUVM). [https://discord.gg/rGDpXWR]",
	"If you want to make a Mod File, check the pinned messages on #troubleshooting from the UKSRT Server. [https://discord.gg/rGDpXWR]",
	"The theme works best in NotITG V2.",
	"NOW YOU DON'T NEED TO EDIT NOTESKINS.LUA TO ADD NOTESKINS. It will do it for you.",
	"You can check detailed information about your "..GetProductName().." on Options -> Detailed System Info.",
	"New player to Modded files? Check the Mod ReRate project! [https://goo.gl/f9Ls9k]",
}

function RandomTip()
	return "Tip: "..Protips[math.random(1,table.getn(Protips))]
end

FailedQuotes = {
	"Stage Failed",
	"Ya fucked up",
	"gg t 2 re",
	"Reset.", 								            -- Mr.Kid
	"FOUND RAILED",							            -- Telperion
	"You were doing good until halfway!",	            -- Telperion
	"TRACK CRASH",							            -- ArbitraryRage
	"can't do it.",							            -- Telperion
	"there was an attempt",					            -- Mr.Kid
	"misses are bad",						            -- Kirby5464
	"STAFE GAILED",							            -- Ky_Dash
	"GAS FEET LAID",						            -- Telperion
	"So close, and yet so far",				            -- ArbitraryRage
	"That was not the run",					            -- Mr.Kid
	"Alt+F4",								            -- Ky_Dash

	-- Kirby just fucking why
	"Play along at home:\n djskdjksdjskdjksdjskdksjdksdjksjdksdjkjsdjkskkksksksdjjsdjksdjksdjkssdjksjdkjksdjksdjksdjksdjkskdjjskdjksdjkjksjdksjdksjkdjksdjkjsdkjsjdskdjksjdksjdskdjksjjdjsddssjssdjkkkkkkkkkkkkkkkkkkkdjksjkdsjksdkjskdjksksdjjsdsksjdkkjksjjksjksd",

	"Stages die when they are killed!",		            -- Telperion
	"Step arrows better",					            -- Mr.Kid
	"You failed that?!?",					            -- ArbitraryRage
	"STEPMANIA BROKEN",						            -- Kirby5464
	"go back to ddr",						            -- Akita
	"git gud",								            -- ArbitraryRage
	"You had to try.",						            -- Its TheNewGuy
	"This wasn't a triumph",				            -- Mr.Kid
	"you tried",										-- Melody
	"a noodle soup a day and your skills won't decay",  -- Kirby5464
	"insert your quad star here ★",						-- Kirby5464 & Akita
	"At least make an effort",							-- ArbitraryRage
	"Good, now do it non-suckily",						-- Its TheNewGuy
	"Snaaaaaaaake!",									-- Its TheNewGuy
	"failing? apply more 1000% beat",					-- Melody
	"*-1 100000% fail",									-- Melody
	"I didn't hear you over the sound of your failure.", -- ArbitraryRage
	"play it with assist tick",							-- Kirby5464
	"what a great attempt to start the day",			-- Melody
	"That was just a warm up...right?",					-- ArbitraryRage
	"Go play pump instead.",							-- Mr.Kid
	"THIS WIN IS MINE",									-- Melody
	"You are not number one.",							-- ArbitraryRage
	"i call pad",										-- Ky_Dash
	"*an incredibly long text about you failing",       -- Its TheNewGuy 
	"What a S.H.A.M.E.", 								-- Its TheNewGuy
	"shutdown -s -t 0",									-- Melody
	"YOU DID A GOOD",									-- Kirby5464
	"reactionimage.jpeg",								-- NumLk
	"Holy shit you can't even play this fucking game right.", -- ElementTimes682
	"FAILURE.EXE",										-- ArbitraryRage
	"who failed light",									-- Kirby5464
	"delete your setup",								-- Mr.Kid
	"delet chart fass",									-- Melody
	"Everyone is typing",								-- NumLk
	"how about you play it on easy mode",				-- Melody
	"One crossover too many, hm?",						-- Mr.Kid
	"Have you tried pressing F8?",						-- ElementTimes 682
	"while true do player:rage() end",					-- ArbitraryRage		

	-- Godanmit Ky
	"UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU",

	"that's enough itg for now",						-- Melody
	"Im GoNna PASs tHiS ChARt",							-- Melody
	"Game = Over. Fail = Very Yes.",					-- Mr.Kid
	"WASTED",											-- TaroNuke, Jose_Varela
	"I bet the ITG officials did this",					-- TaroNuke
	"now do it in pad",									-- Melody
	"such bad. very fail. wow.",						-- ArbitaryRage
	":C",												-- PCBoy
}

function GetFailedStageQuote()
	return FailedQuotes[math.random(1,table.getn(FailedQuotes))]
end

function SLGBuildVersion()
	if OpenITG then
		return "OpenITG - "..GAMESTATE:GetVersionDate()
	elseif FUCK_EXE then
		return "NotITG - "..GAMESTATE:GetVersionDate()
	else
		return "Weird build you have there"
	end
end

LogCommands = {
	"------------------\n------------------\n------------------\n".."Detailed System Info Display - SLG(JUVM)".."\n\n",
	"Hard Disk\n Free Space: "..GetDiskSpaceFree().."\n".." Total Size: "..GetDiskSpaceTotal().."\n\n",
	"Total Session Time (Including Menu times):\n "..GetUptime().."\n\n",
	"Video Driver:\n "..PREFSMAN:GetPreference("LastSeenVideoDriver").."\n\n",
	"\n------------------\n------------------\n------------------"
};

function OutputToLog()
	Trace(LogCommands[1]..LogCommands[2]..LogCommands[3]..LogCommands[4]..LogCommands[5])
	SCREENMAN:SystemMessage("A summary of the information has been sent to the Log.")
end

function ThemeFile( file ) return THEME:GetPath( EC_GRAPHICS, '' , file ) end

function LoadFromSongBackground(self, song)
	local Path = song:GetBackgroundPath()
	if not Path then
		Path = THEME:GetPath(EC_GRAPHICS,"Common","fallback background")
	end

	self:LoadBackground( Path )
end

-- Checks for Background songs and load their backgrounds.
function SongBGLoad(self)
	if GAMESTATE:GetCurrentSong() then
		local BGSong = GAMESTATE:GetCurrentSong()
		-- Did you found the directory of the song?
		-- Great, now get the background image.
		LoadFromSongBackground(self, BGSong)
		self:sleep(0.25)
    	self:zoom(1.2)
    	self:decelerate(0.5)
    	self:scaletocover(0,SCREEN_TOP,SCREEN_WIDTH,SCREEN_BOTTOM);
    	self:diffusealpha(0.8)
    end
end

SLGJUVMInfo = {
	Version = "7";
	VersionDate = "April 2nd, 2018";
	VersionName = "FIXES AND FIXES";
};