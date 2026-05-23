--[[
------------------------------------------
				TOUCH
------------------------------------------
]]

DialogTextBank = {

	--[[
	
	Jose's Dialog System USAGE
	(If Contained)
	
	List of items:
	(Can be in any order)

		FACE NUMBER,
		CHARACTER NAME
		CHARACTER COLOR
		TEXT
		TIME VALUES
		NEXT MESSAGE
		MESSAGECOMMAND
		PLAYSOUND

	Animation Format
	Maximum 3 Text tweens per text string. No more is needed.
	If more are required, edit the values in Jose's Dialog System.lua

	If a tween is not needed on a dialog, 
	not adding the tween will work too.

		Cut1 = Value;
		Time1 = Value;
		Cut2 = Value;
		Sleep1 = Value;

		Time2 = Value;
		Cut3 = Value;
		Sleep2 = Value;
		Cut4 = Value;

		Time3 = Value;
		Cut5 = Value;
		Sleep3 = Value;
		Cut6 = Value;

		-- If the need to send to a new text string is needed,
		-- Use these three commands.

		RequestForNewText = true/false;
		SleepTimeBeforeNewText = Value;
		NewTextName = Name;

		-- If you need to Broadcast a MessageCommand, for an action,
		-- Use these two commands.
		RequestMessage = true/false;
		NewMessageName = Name;

		-- If the character needs a name displayed, use these two commands.
		CharacterName = Name;
		CharacterColor = Color in a 3 item table format;

		Note: CharacterColor will always be solid. If there's need to make it transparent, modify ColCon's 4th value. (Which is 1 by default.)
		Note: Coloring is in RGB 255 format. This lua contains a function to convert it to a format that StepMania can understand.

		Example
			CharacterColor = {116, 215, 204};

		-- If the characters needs to play an audio, use these three commands.

		PlaySound = true/false;
		SoundType = Name; -- Normally assigned for the type of character on this theme. (It is reffered via a folder)
		SoundName = Name; -- Name of the audio file.

		-----------------------------------------------------------------------------
		-----------------------------------------------------------------------------
		-----------------------------------------------------------------------------
		-----------------------------------------------------------------------------

		EXAMPLE OF A COMPLETE DIALOG:

				MarieBegin = { 	

					CharacterName = "Marie";
					CharacterColor = {116, 215, 204};
					Text = "Woah! I didn't see you there.\nWhat's up? Welcome to the test screen.";

					-- ANIMATION TWEENS
					Cut1 = 1;		Time1 = 0.3;
					Cut2 = 0.93;	Sleep1 = 1;
					Time2 = 0.5;	Cut3 = 0;

					-- SWITCH TWEENS
					RequestForNewText = false;
					SleepTimeBeforeNewText = 4;
					NewTextName = "MarieContinue1";

					PlaySound = true;
					SoundType = "Octoling";
					SoundName = "RivalAVoiceAttack01";
				},

		-----------------------------------------------------------------------------
		-----------------------------------------------------------------------------
		-----------------------------------------------------------------------------
		-----------------------------------------------------------------------------

	]]

	NotAvailable = {

		NotThere = {

					FaceID = 20;
					Text = "I'm sorry but... there's no screen in here yet. The developer hasn't completed it... I'm super sorry.";

					-- ANIMATION TWEENS
					Cut1 = 1;		Time1 = 0.3;
					Cut2 = 0.83;	Sleep1 = 1;
					Time2 = 0.6;	Cut3 = 0;

					-- SWITCH TWEENS
					RequestForNewText = true;
					SleepTimeBeforeNewText = 4;
					NewTextName = "NotThere2";
				},

		NotThere2 = {

					FaceID = 20;
					Text = "You can press ESC or BACK to return to the intro screen... Or you can just stay.";

					-- ANIMATION TWEENS
					Cut1 = 1;		Time1 = 0.9;
					Cut2 = 0.3;		Sleep1 = 1;
					Time2 = 0.6;	Cut3 = 0;

					-- SWITCH TWEENS
					RequestForNewText = true;
					SleepTimeBeforeNewText = 4;
					NewTextName = "EmptyText";
				},

		EmptyText = {

					FaceID = 0;
					Text = "";

					-- ANIMATION TWEENS
					Cut1 = 0;

					-- SWITCH TWEENS
					RequestForNewText = false;
					RequestMessage = true;
					NewMessageName = "HideTextBox";
				},
	},

	DialogTest = {
		
		VanillaBegin = { 	

					FaceID = 1;
					CharacterName = "Vanilla";
					CharacterColor = {240, 000, 075};

					Text = " "

					Cut1 = 0;
					Time1 = 0;
					Cut2 = 0;
					Sleep1 = 0;
					Time2 = 0;
					Cut3 = 0;


					-- SWITCH TWEENS
					RequestForNewText = true;
					SleepTimeBeforeNewText = 4;
					NewTextName = "VanillaContinue1";

					PlaySound = true;
					SoundType = "Octoling";
					SoundName = "RivalAVoiceAttack01";
				},

		VanillaContinue1 = { 

					FaceID = 2;
					CharacterName = "Vanilla";
					CharacterColor = {240, 000, 075};
					Text = "This screen is meant for testing purposes. Right now you\'re seeing the dialog system in action.";

					-- ANIMATION TWEENS
					Cut1 = 1;		Time1 = 0.5;
					Cut2 = 0;	Sleep1 = 0;

					-- SWITCH TWEENS
					RequestForNewText = true;
					SleepTimeBeforeNewText = 4;
					NewTextName = "VanillaContinue2";

					PlaySound = true;
					SoundType = "Octoling";
					SoundName = "RivalAVoiceFind00";
				},

		VanillaContinue2 = { 	

					FaceID = 3;
					CharacterName = "Vanilla";
					CharacterColor = {240, 000, 075};
					Text = "I wish my buddy Crystal could be here so she can see that you arrived... but what can I do? She\'s probably just \'hanging out\' with some agent or something.";

					-- ANIMATION TWEENS
					Cut1 = 1;		Time1 = 0.5;
					Cut2 = 0.53;	Sleep1 = 1.3;
					Time2 = 1.3;	Cut3 = 0;

					-- SWITCH TWEENS
					RequestForNewText = true;
					SleepTimeBeforeNewText = 5;
					NewTextName = "VanillaContinue3";

					PlaySound = true;
					SoundType = "Octoling";
					SoundName = "RivalAVoiceFind01";
				},

		VanillaContinue3 = { 	

					FaceID = 4;
					CharacterName = "Vanilla";
					CharacterColor = {240, 000, 075};
					Text = "You know, this place is kind of limited, you know? I mean, it\'s cool and all, but, there\'s no shooting gameplay. It\'s just dancing...\nWhere's the fun on that?";

					-- ANIMATION TWEENS
					Cut1 = 1;		Time1 = 2.5;
					Cut2 = 0;		Sleep1 = 0;

					-- SWITCH TWEENS
					RequestForNewText = true;
					SleepTimeBeforeNewText = 2;
					NewTextName = "VanillaContinue4";

					PlaySound = true;
					SoundType = "Octoling";
					SoundName = "RivalAVoiceSoul01";
				},

		VanillaContinue4 = { 	

					CharacterName = "Vanilla";
					CharacterColor = {240, 000, 075};
					Text = "Anyways, i'd like to welcome you to the theme. You can go back now by pressing ESC.";

					-- ANIMATION TWEENS
					Cut1 = 1;		Time1 = 2.5;
					Cut2 = 0;		Sleep1 = 0;

					-- SWITCH TWEENS
					RequestForNewText = false;
					SleepTimeBeforeNewText = 2;
					NewTextName = "VanillaContinue4";

					PlaySound = true;
					SoundType = "Octoling";
					SoundName = "RivalAVoiceJetEd01";
				},

	},

	SplatNews = {

				NewsIntro = { 
					CharacterName = "Callie"; CharacterColor = {240, 000, 075};
					Text = "Hold on your tentacles, 'cause it's Inkopolis News time!";
					Cut1 = 1; Time1 = 2.5; Cut2 = 0; Sleep1 = 0;
					RequestForNewText = true; SleepTimeBeforeNewText = 3; NewTextName = "NewsBody1";
					PlaySound = true; SoundType = "SquidSister"; SoundName = "RivalAVoiceJetEd01";
				},

				NewsBody1 = { 
					CharacterName = "Callie"; CharacterColor = {240, 000, 075};
					Text = "Today we have a huge sort of news!";
					Cut1 = 1; Time1 = 1.5; Cut2 = 0; Sleep1 = 0;
					RequestForNewText = true; SleepTimeBeforeNewText = 2; NewTextName = "NewsScores1";
					PlaySound = true; SoundType = "SquidSister"; SoundName = "RivalAVoiceJetEd01";
				},

				NewsScores1 = { 
					CharacterName = "Callie"; CharacterColor = {240, 000, 075};
					Text = "But first, let's go with the best scores of the month.";
					Cut1 = 1; Time1 = 2.5; Cut2 = 0; Sleep1 = 0;
					RequestForNewText = true; SleepTimeBeforeNewText = 2; NewTextName = "NewsScoresInfo";
					PlaySound = true; SoundType = "SquidSister"; SoundName = "RivalAVoiceJetEd01";
				},

				NewsScoresInfo = { 
					CharacterName = "Callie"; CharacterColor = {240, 000, 075};
					Text = "First we have "..NameBestScore3()..", Who came in 3rd place, with a score of "..ScoreBestScore3().." On "..SongBestScore3().."!";
					Cut1 = 1; Time1 = 2.5; Cut2 = 0; Sleep1 = 0;
					RequestForNewText = true; SleepTimeBeforeNewText = 2; NewTextName = "NewsScoresInfo2";
					PlaySound = true; SoundType = "SquidSister"; SoundName = "RivalAVoiceJetEd01";
				},

				NewsScoresInfo2 = { 
					CharacterName = "Callie"; CharacterColor = {240, 000, 075};
					Text = "Congrats, "..NameBestScore3().."!";
					Cut1 = 1; Time1 = 1.0; Cut2 = 0; Sleep1 = 0;
					RequestForNewText = true; SleepTimeBeforeNewText = 2; NewTextName = "NewsScoresInfo3";
					PlaySound = true; SoundType = "SquidSister"; SoundName = "RivalAVoiceJetEd01";
				},

				NewsScoresInfo3 = { 
					CharacterName = "Callie"; CharacterColor = {240, 000, 075};
					Text = "Then we have "..NameBestScore2()..", Who came in 2nd place, with a score of "..ScoreBestScore2().." On "..SongBestScore2().."!";
					Cut1 = 1; Time1 = 2.5; Cut2 = 0; Sleep1 = 0;
					RequestForNewText = true; SleepTimeBeforeNewText = 2; NewTextName = "NewsScoresInfo4";
					PlaySound = true; SoundType = "SquidSister"; SoundName = "RivalAVoiceJetEd01";
				},

				NewsScoresInfo4 = { 
					CharacterName = "Callie"; CharacterColor = {240, 000, 075};
					Text = "Man... "..NameBestScore2().." sure is good on "..SongBestScore2().."... I'll try my best to beat you though!";
					Cut1 = 1; Time1 = 2.5; Cut2 = 0; Sleep1 = 0;
					RequestForNewText = true; SleepTimeBeforeNewText = 2; NewTextName = "NewsScoresInfo5";
					PlaySound = true; SoundType = "SquidSister"; SoundName = "RivalAVoiceJetEd01";
				},

				NewsScoresInfo5 = { 
					CharacterName = "Callie"; CharacterColor = {240, 000, 075};
					Text = "And finally, we have "..NameBestScore1()..", Who came in 1st place, with a score of "..ScoreBestScore1().." On "..SongBestScore1().."!";
					Cut1 = 1; Time1 = 2.5; Cut2 = 0; Sleep1 = 0;
					RequestForNewText = true; SleepTimeBeforeNewText = 2; NewTextName = "NewsScoresInfo6";
					PlaySound = true; SoundType = "SquidSister"; SoundName = "RivalAVoiceJetEd01";
				},

	},



}