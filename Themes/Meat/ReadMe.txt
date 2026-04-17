

		 ___ _____ ____   __  __			_	  ____			 
		|_ _|_   _/ ___| |  \/  | ___  __ _| |_  | __ )  ___  _   _
		 | |  | || |  _  | |\/| |/ _ \/ _` | __| |  _ \ / _ \| | | |
		 | |  | || |_| | | |  | |  __/ (_| | |_  | |_) | (_) | |_| |
		|___| |_| \____| |_|  |_|\___|\__,_|\__| |____/ \___/ \__, |
															  |___/
_______________________________________________________________________________

	Part 1:		Introduction
				1.1:	Author's Note
				1.2:	TL;DR
				1.3:	Compatibility
				1.4:	Acknowledgments
   
	Part 2:		Stepmania Features
				2.1:	Operator Menu
				2.2:	Multi-line Speed Mods
				2.3:	Scroll Rate Display
				2.4:	BPM display with Rate Mods
				2.5:	Automatic Speed Mod adjustment for Rate Mods
				2.6:	DQ for Hide Background
				2.7:	"Static" Difficulty List
   
	Part 3:		Meat Boy Features
				3.1:	Select Your World
				3.2:	Dark Worlds
				3.3:	Levels
				3.4:	Warp Zones and Glitch Levels
				3.5:	Progress Bar
				3.6:	Evaluation
				3.7:	Letter Grades

_______________________________________________________________________________
		 ___	   _				 _			  _   _			
		|_ _|_ __ | |_ _ __ ___   __| |_   _  ___| |_(_) ___  _ __ 
		 | || '_ \| __| '__/ _ \ / _` | | | |/ __| __| |/ _ \| '_ \
		 | || | | | |_| | | (_) | (_| | |_| | (__| |_| | (_) | | | |
		|___|_| |_|\__|_|  \___/ \__,_|\__,_|\___|\__|_|\___/|_| |_|
		
[Part 1]_______________________________________________________________________

[1.1] ----------------------------- Author's Note -----------------------------

		I started making this theme with that idea that it would be cool if you
	could pick your world and it would 'recolor' the theme. As I progressed,
	I kept coming up with more and more ideas, and it ballooned into something
	much larger than I had anticipated. I've spent well over 1000 hours of my
	free time on this theme, which is WAY too much, but in the process I
	learned an incredible amount about Stepmania(3.95) and Lua. Luckily that
	will speed up the process of making themes in the future, which I plan to
	do(although probably no more themes based on other video games like Meatboy
	and FFT).

		If you have not played Super Meat Boy, you will not be able to fully
	appreciate this theme.

		If you have not player Super Meat Bot, what are you doing with your
	life??? You're missing out on one of the best games in the past decade.
	Super Meat Boy can be purchased through Steam, Xbox Live Arcade, WiiWare,
	and more. Seriously, go play this game.
   
[1.2] --------------------------------- TL;DR ---------------------------------

		- Made for SM 3.95, probably works in oITG.
		- The progress bar is Meatboy running across the top of the screen.
		- Choose Super Marathon World if you want marathons.
		- Theme switching is in Gameplay Options.
		- If you want to know what does what in this theme, read this FAQ.
		- This FAQ does not explain how any of the lua functions work.
	   
[1.3] ----------------------------- Compatability -----------------------------

		This theme was made specifically for Stepmania 3.95, to work on stock
	ITG2 dedicated cabinets. The majority of the tested was done on my own ITG
	machine. Some testing was done with OpenITG but not nearly as much. It
	should work but there may still be undiscovered problems with it. It was
	made specifically for the 4:3 aspect ratio used by arcade cabinets. I made
	adjustments to fit 16:10 and 16:9, but I won't guarantee they are prefect.
	It was has never been tested with PIU or any other game mode. It might
	work, I have no idea.

		Stepmania Versions:
			- STEPMANIA 3.95 PC
			- STEPMANIA 3.95 Arcade Cabinet
			- OPENITG (probably)

		Aspect Ratios:
			- 4:3
			- 16:10
			- 16:9

[1.4] ---------------------------- Acknowledgments ----------------------------
   
	Special thanks to:
		- Edmund McMillen and Tommy Refenes, co-creators of Super Meat Boy
		- Lara, my fiance
		- Paul Dirac, theoretical physicist
		- 299,792,458 m/s, the Speed of Light.

_______________________________________________________________________________
			 ____  _								   _	  
			/ ___|| |_ ___ _ __  _ __ ___   __ _ _ __ (_) __ _
			\___ \| __/ _ \ '_ \| '_ ` _ \ / _` | '_ \| |/ _` |
			 ___) | ||  __/ |_) | | | | | | (_| | | | | | (_| |
			|____/ \__\___| .__/|_| |_| |_|\__,_|_| |_|_|\__,_|
				  _____   |_|	_					  
				 |  ___|__  __ _| |_ _   _ _ __ ___  ___
				 | |_ / _ \/ _` | __| | | | '__/ _ \/ __|
				 |  _|  __/ (_| | |_| |_| | | |  __/\__ \
				 |_|  \___|\__,_|\__|\__,_|_|  \___||___/

[Part 2]_______________________________________________________________________

[2.1] ----------------------------- Operator Menu -----------------------------

		Different things are in different places in different themes. In this
	theme I was limited by my attempt to keep things looking as much like Super
	Meat Boy as possible, so certain things are in slightly different places.
	This theme also has a few extra options that have only recently been put
	into themes. 
	
		Under Arcade Options you will find an option to turn on or off 
	Disqualification, and an option to turn on or off Decents and Way Offs. 
	Theme switching is under Gameplay Options. If this is your start up theme
	it will remember whatever changes you made to the settings for Decents/Way 
	Offs, Disqualification, BGBrightness, and Volume. If your Stepmania starts 
	up with a different theme, they might not be remembered.
	   
[2.2] ------------------------- Multi-Line Speed Mods -------------------------
   
		This option was created in an attempt to remove the need to include
	huge lists of speed mods. The two lines are:
   
	Base Speed	- 1x, 2x, .. 7x, 8x, C400, C500, .. C1300, C1400
	Extra Speed	- +0, +.25x, +.5x, +.75x, +C10, +C20, .. +C80, +C90

	The base speed determines what type of mod you're using, X or C.
	If you pick +.25x with a Cmod base, it will give you +C25, and so on.
	If you pick +C10 with an Xmod base, it will give you +.1x, and so on.

		It is important to note that if your mod was 1.5x and you select C700,
	you have only changed your base mod and not the fractional part, which will
	still be set to .5x, so your scroll rate will be C750. There is a scroll
	rate display above the mods that will tell you what your current selected
	speed mod is.

		Both +.5x and +C50 do the exact same thing in all cases. The reason
	that both of those options exist is to provide better familiarity to people
	who are used to fractional x mods and don't know or care about the details
	of how the two-line thing works. If there was a more concise and clean way
	to call the mod "+c50 or +.5x" I would have done so, but I think naming
	them all "+c## or +(##/100)x" would get in the way more than having one
	redundant mod.
		   
[2.3] ------------------------- Scroll Rate Display --------------------------

		On the Player Options screen, the theme will tell you what scroll rate
	will be based on your selected mods.
   
	If you're using a Cmod, it will simply add the two speed mod lines.
	If you're using an Xmod, it will add the lines together, but it will also
	multiply that mod by the BPM to show you the actual scroll rate. Never
	again will you have to ask "What's 3 x 200?"
   
[2.4] ----------------- BPM Display adjusted for Rate Mods -------------------

		The BPM is displayed on the Player Options screen. When you select a
	rate mod, it will update the display to tell you what the new BPM will be.
   
		The BPM display during gameplay will be adjusted to account for rate
	mods as well. This should work properly in both 3.95 and OpenITG.

[2.5] ------------ Automatic Speed Mod adjustment for Rate Mods --------------

		Normally, when you play a song with a rate mod, it effectively
	multiplies with your speed mod, giving you a faster scroll rate. This
	theme automatically adjusts your speed mod to counter that effect. If you
	pick the mod C660 at 1.1x scroll rate, the theme will change your mod to
	C600 during the song so that the arrows actually scroll at a rate of 660.
   
	It applies the change to Xmods as well. If you pick 4.5x and 1.5x music
	rate it will adjust your mod to 3x during the song so that you get the
	scroll rate that was listed in the Scroll Rate Display.

[2.6] ----------------------- DQ for Hide Background -------------------------

		Selecting "Hide Background" normally disqualifies you from ranking,
	preventing your scores from saving. I've always thought that was stupid.
	In this theme, I use a very blunt work-around to avoid disqualification.
	It does the check to see if you're disqualified on the Evaluation screen.
	The theme turns off hide background right before the check, and turns it
	back on afterwards.
   
		When you select hide background on the Player Options screen it will
	say that you will be disqualified but for the reasons stated above, if
	that is the only disqualifying mod you are using you will not be
	disqualified.

[2.7] ---------------------- "Static" Difficulty List ------------------------

		The normal difficulty list on the Select Music screen puts the easiest
	chart at the top and the harder charts below it in order of difficulty. As
	you scroll over songs which have different numbers of charts, the location
	of each chart on the list will bounce around. On a song with difficulties
	from novive through expert, expert will be in the 5th spot. On a song with
	only an expert chart, it will be in the first spot.
   
		This theme uses its own difficulty list display generated with lua. As
	long as there are no edits and no more than one chart of each difficulty
	(it is possible	to have	two expert charts), it will display novice through
	expert in fixed positions, regardless of how many charts the song has.
	This makes it easier to follow the difficulty you're interested in when
	scrolling over songs with different numbers of charts. If a song has edits
	or multiple charts for any lower difficulty, it will display the songs in
	the same way the stepmania normally does.

_______________________________________________________________________________
   
					 __  __			   _	 ____			  
					|  \/  | ___  __ _| |_  | __ )  ___  _   _ 
					| |\/| |/ _ \/ _` | __| |  _ \ / _ \| | | |
					| |  | |  __/ (_| | |_  | |_) | (_) | |_| |
					|_|  |_|\___|\__,_|\__| |____/ \___/ \__, |
					  _____		     _					 |___/ 
					 |  ___|__  __ _| |_ _   _ _ __ ___  ___ 
					 | |_ / _ \/ _` | __| | | | '__/ _ \/ __|
					 |  _|  __/ (_| | |_| |_| | | |  __/\__ \
					 |_|  \___|\__,_|\__|\__,_|_|  \___||___/
																			 
[Part 3]_______________________________________________________________________

[3.1] --------------------------- Select Your World ---------------------------

		You can select which world from Super Meat Boy you would like to play
	in. The selected world will affect the graphics on the Song Selection,
	Gameplay, and Evaluation screens. 
	
		On the Song Selection screen you can enter a code to return to the
	World Selection screen. The code is displayed at the bottom of the Song
	Selection screen and can be entered at any time you're on that screen.
   
		World selection also doubles as a choice between Dance(normal) mode and
	Marathon mode. If you pick worlds 1 through 7 you get Dance mode. If you
	pick Super Marathon World you get Marathon mode. If you are not on event
	mode, and go back to the World Select screen after playing a song, you will
	no longer be able to choose	Super Marathon World. If you are on event mode
	or have not yet played a song, that option will still be available.

[3.2] ------------------------------ Dark Worlds ------------------------------

		On the Song Selection screen you can enter a code to switch to the
	dark world, or if you're already on the dark world, to go back to the light
	world. The code is displayed at the bottom of the screen and can be entered
	at any time you're on that screen.

[3.3] --------------------------------- Levels --------------------------------

		Levels have no affect on gameplay. They determine what the ground,
	background, and obstacles are like for Meat Boy to run through in the
	progress bar and on the Evaluation screen. Each world has between 1 and 4
	different levels, based on actual levels from Super Meat Boy. The worlds
	that have fewer levels are the ones where there is less graphical variable
	between levels in Super Meat Boy.
   
		When you load the theme, it will have you on level 1 for each world.
	Each time you pass a song, it will move you on to the next level in that
	world. In Event Mode, when you've completed the last level in that world,
	your next level will be a Boss level, based on the boss levels from Super
	Meat Boy. After completing the boss level you will go back to level 1. If 
	you're not on Event Mode, once you complete the last level in a world, you
	go back to level 1. Instead, Final Stage will always be the boss level(unless
	it is a warp zone or glitch level). It will remember which levels have been
	played through until you reload the theme. Each light and dark world has
	its own level counts.

		The levels in world 8 are based on player made levels. In world 8 you 
	start at a random level instead of level 1, and it will go to the next level 
	after each song you complete during the marathon.
	
[3.4] ---------------------- Warp Zones and Glitch Levels ---------------------

		Every time you play a song on a normal level in worlds 1 through 5, 
	there is a chance of reaching a warp zone instead of Bandage Girl at the 
	end. If you reach the warp zone, it will not increase the level count, but 
	your next level will be a special warp zone level instead.

		Every time you play a song on a normal level in worlds 1 through 6, 
	there is a chance of reaching a glitched Bandage Girl at the end. If you 
	reach the glitched Bandage Girl, it will not increase the level count, but 
	your next level will be a special glitch level instead.

		Only normal levels can have warp zones or glitched Bandage Girls at
	the end. If you're on a boss level, a warp zone, or glitch level, it will
	always end with Bandage Girl.
   
		If you reach a warp zone or glitched Bandage Girl and then return to
	the World Selection screen or switch to or from the dark world, your next 
	level will not be a warp zone or glitch level.
	
[3.5] ----------------------------- Progress Bar ------------------------------

		During gameplay, Meat Boy will be running across the top of the screen,
	dodging obstacles, trying to reach Bandage Girl. This is the progress bar
	which tells you how far into the song you are. Meatboy will move slowly
	across the screen as the song progresses. His suroundings and what
	obstacles he has to avoid are based on the world and level you're curring
	in.

[3.6] ------------------------------ Evaluation -------------------------------

		The Evaluation screen in this theme is based on the Replays you get to
	watch after you complete each level in Super Meat Boy. Unlike in Super Meat
	Boy, how well you did on the song has almost no impact on the "replay" Meat
	Boys that are jumping around. The only difference is whether you pass or
	fail. If you pass, one of them Meat Boys on your side will(sometimes) be
	able to reach Bandage Girl. If you fail, none of them ever will.
   
		The World and level you played will determine the look of the screen
	and what obstacles are there to kill Meat Boy.
   
		A large Dr. Fetus will show up to indicate that you failed. If all
	players fail he will be in the center. If one player passes and one player
	fails, he will be on the failed player's side behind their life graph.
   
		The life graphs are either locks or breakable blocks, depending on the
	world.

[3.7] ----------------------------- Letter Grades -----------------------------

		Letter Grades do not exist in this theme. There are 5 grade tiers but
	they show at the end of the Gameplay screen, not on the evaluation screen.
   
	Tier 1: 100%, Grade A+ and Bandage Get!
	Tier 2: 99%, Bandage Get!
	Tier 3: 96%, Grade A+
	Tier 4: Passed, nothing special
	Tier 5: Failed, Meat Boy hits an obstacle instead of reaching Bandage Girl
