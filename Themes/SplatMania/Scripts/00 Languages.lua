-- This is theme information.
-- It contains the information about who worked on the game.
-- And also all the people who contributed. Even if it was small or huge!

SplatoonInfo = {
	Name = "SplatMania";
	Version = "0.3.3.0";
	VersionDate = {13,5,2018};
	Author = "Jose_Varela";
	Programming = "Jose_Varela";
	SoundManager = "Pixel Squid";
	GraphicRipping = "Ploaj\n Ink_Larry\n larsenv";
	FontCreator = "JapanYoshi\nJose_Varela";
	StoryBoardCreator = "Squibble Bauble";
}

function Credits_Name(self)
	self:horizalign('right');
	self:zoom(0.5);
	self:ztest(1);
	self:x(70);
	self:diffuse(0.8,0.8,1,1);
end

function Credits_Info(self)
	self:horizalign('right');
	self:wrapwidthpixels(900);
	self:vertalign('top');
	self:zoom(0.4);
	self:ztest(1);
	self:x(70);
end

function Credits_Legal(self)
	self:horizalign('right');
	self:wrapwidthpixels(900);
	self:vertalign('top');
	self:diffuse(1,1,1,0.7);
	self:zoom(0.35);
	self:ztest(1);
	self:x(70);
end

function CImg( file ) return "../Credits/"..file end

Credits = {
	
	Devel = {
		{"Programming", "Jose_Varela"},
		{"Sound Management", "Pixel Squid\nJose_Varela"},
		{"Graphics", "GreenJelly\nJose_Varela\nilSoulsli"},
		{"Font Design/Programming", "JapanYoshi\nJose_Varela"},
		{"Story/Writing", "Squibble Bauble"},
	},

	ChatP = {"People in Amino Dev Chat", "TealAdrien\nInkro\nemmanu888\nGreenJelly\nCallie\nanymous/kersplat\nSquibble Bauble\nMango Garcia" },

	SPThk = {
		{ "Jousway", "Providing help with lua functions and commands.\nLua based noteskin system." },
		{ "MadKat", "Help and feedback on graphics." },
		{ "dbk2", "Feedback." },
		{ "willycel123", "Suggestions and QA testing on graphics." },
		{ "Moru Zerinho6", "Small suggestions." },
	},

	MPThk = {
		{ "Galaxy Squids", "Being a cool clan and making me more happy that I ever expected in my life." },
		{ "UKSRT Discord", "Providing a HUGE ammount of help towards the project in terms of troubleshooting and suggestions." },
		{ "JaredGaming Discord", "Feedback. although quite small, I still apreciate it." },
		{ "SplatMania Development Discord", "For keeping along for the ride. I can't thank you guys enough! Thanks for staying with me, helping me with my medical conditions during the development, keeping me afloat while working on new features, suggestions, sound bits, graphical help. Just, thank you so much." },
		{ "Splatoon Amino", "Massive interest in the project, and also where I met awesome people who helped with the project!" },
		{ "The Spriters Resource", "For ripping the Splatoon sprites that inspired the graphics for this game." },
	},

	LegalInfo = {
		"SplatMania is a FanGame taking inspiration from Splatoon, a game by Nintendo.\nJose_Varela, and the rest of the development team do not want to hurt the IP. This was just a FanGame, made with heart for the community.",
		"This game runs on NotITG.\nNotITG is made by TaroNuke and Team Proof of Concept. NotITG is based on the OpenITG engine, by the OpenITG team.",
		"All graphics made for the game were made in Affinity Photo and Affinity Designer.\nProgramming was done in Sublime Text 3 and Microsoft Visual Studio Code.\nSound Mixing and Creation was done in Audacity and GarageBand. (With a lot of effects)\n"
	},
}

LanguagesBoard = {

	-- English Language
	-- By Jose_Varela, Squibble Bauble

	english = {
		SplatManiaOptions = {
			GraphicOptions = {
				HeaderText = "Graphic Options",
				LowLevel = "Low",
				MedLevel = "Medium",
				HigLevel = "High",
				MaxLevel = "Maximum",
			},
			MainOptions = {
				HeaderText = "Main Options",
			},
			LanguageOptions = {
				HeaderText = "Select Language",
				Warning = "When you set the language, you must restart your game to apply the changes.",
			},
			Global = {
				Move = "Move",
				Accept = "Accept",
				Return = "Return",
			},
		},

		ScreenTest = {
			Dialog = {
				VanillaBegin = {
					ContainText = "Woah! I didn't see you there.\nWhat's up? Welcome to the test screen.",
					Cut1 = 1;
					Time1 = 0.3;
					Cut2 = 0.93;
					Sleep1 = 1;
					Time2 = 0.5;
					Cut3 = 0;
				}, 
			},

			LanguageTest = {
				Text=  "This is a screen meant to test the font functionality of the theme and the other languages.",
				Text2= "Whenever you change the language, the text on this screen SHOULD change.",
				Text3= "If it doesn't, please report it to Jose, so he can check and fix it.",
			},
		},

		Tutorial = {
			HelpText = {
				Text1 = "Hello, and welcome to the tutorial.",
				Text2 = "Here you'll learn the basics to play the game.",
				Text3 = "Let's start with some notes first.::Should be simple enough to hit them.",
				Text4 = "As you play, you get a rating for each note you hit.",
				Text5 = "Fantastics will get you the highest ammount of points.::Perfects a little bit less and so on.",
				Text6 = "Sometimes, when hitting the notes,::you'll have to move. Try it!",
			},
		},

		AboutSplatMania = {
			OverlayText ={
				HeaderText = "About SplatMania",
				MadeBy = "Made by ".. SplatoonInfo["Author"] .."",
			},
		},

		TitleMenu = {
			Choices = {
				Start = "Start",
				Options = "Options",
				Exit = "Exit",
				MissionDeck = "Mission Deck",
				Stats = "Stats and Info",
				LanguageTest = "Language Test",
			},
		},

		SelectMusic = {
			MenuText = {
				SelMusic = "Select Music...",
				SongInfo = "Song Information",
				StepInfo = "Step Information",
				NeverP = "Never Played!",
				AmmPlay = "Times Played: ",
			},

			StepInfoDisplay = {
				Stream = "S",
				Voltage = "V",
				Air = "A",
				Freeze = "F",
				Chaos = "C",
			},

			SortOrder = {
				Main = "Current Sort Order: ",
				All = "All Music (Folder/Separated)",
          		Title = "Title",
          		BPM = "BPM",
          		PlayerBe = "Player\'s Best",
          		Best = "Best Grades",
          		Artist = "Artist",
          		Genre = "Genre",
          		SongLeng = "Song Length",
          		DiffEasy = "Difficulty: Easy",
          		DiffMedi = "Difficulty: Medium",
          		DiffHard = "Difficulty: Hard",
          		DiffChal = "Difficulty: Challenge",
			},

			Global = {
				Beginner = "Beginner",
				Easy = "Easy",
				Medium = "Groovy",
				Hard = "Splaty",
				Expert = "Jammin\'",
				Edit = "Octavio\'s mix",
				ToOptions = "Press START to enter options.",
				LongSong = "This song is long!",
				MaraSong = "This song is a marathon!",
			},
		},
	},

	-- Spanish Language
	-- By Jose_Varela
	
	spanish = {
		SplatManiaOptions = {
			GraphicOptions = {
				HeaderText = "Opciones Graficas",
				LowLevel = "Bajo",
				MedLevel = "Medio",
				HigLevel = "Alto",
				MaxLevel = "Máximo",
			},
			MainOptions = {
				HeaderText = "Opciones Principales",
			},
			LanguageOptions = {
				HeaderText = "Escoger Lenguaje",
				Warning = "Al cambiar el lenguaje, debes reiniciar el juego para aplicar los cambios.",
			},
			Global = {
				Move = "Mover",
				Accept = "Aceptar",
				Return = "Regresar",
			},
		},

		ScreenTest = {
			Dialog = {
				Text1 = "¡Woah, No te vi ahi! ¿Que tal? Bienvenido a la pantalla de prueba.",
			},

			LanguageTest = {
				Text=  "Ésta es una pantalla para probar la funcionalidad de las fuentes del juego y los otros lenguajes.",
				Text2= "Cuando cambies el lenguaje, el texto de esta pantalla DEBERIA cambiar.",
				Text3= "Si no sucede eso, por favor, reportelo a Jose, para que pueda analizarlo y arreglarlo.",
			},
		},

		Tutorial = {
			HelpText = {
				Text1 = "Hola, y bienvenido al tutorial.",
			},
		},

		AboutSplatMania = {
			OverlayText ={
				HeaderText = "Acerca de SplatMania",
				MadeBy = "Hecho por ".. SplatoonInfo["Author"] .."",
			},
		},

		TitleMenu = {
			Choices = {
				Start = "Iniciar",
				Options = "Opciones",
				Exit = "Salir",
				MissionDeck = "Cabina de Misiones",
				Stats = "Stats and Info",
				LanguageTest = "Prueba de Lenguaje",
			},
		},

		SelectMusic = {
			MenuText = {
				SelMusic = "Selecciona una canción...",
				SongInfo = "Info. de Canción",
				StepInfo = "Información de Pasos",
				NeverP = "¡Nunca Jugado!",
				AmmPlay = "Intentos: ",
			},

			StepInfoDisplay = {
				Stream = "C",
				Voltage = "V",
				Air = "A",
				Freeze = "S",
				Chaos = "Ch",
			},

			SortOrder = {
				Main = "Modo de Sorteado: ",
				All = "Toda la Música (En Carpetas)",
          		Title = "Titulo",
          		BPM = "BPM",
          		PlayerBe = "Mejores de la Comunidad",
          		Best = "Mejores Grados",
          		Artist = "Artista",
          		Genre = "Género",
          		SongLeng = "Duración",
          		DiffEasy = "Dificultad: Facíl",
          		DiffMedi = "Dificultad: Medio",
          		DiffHard = "Dificultad: Difícil",
          		DiffChal = "Dificultad: Desafío",
			},

			Global = {
				Beginner = "Principiante",
				Easy = "Facil",
				Medium = "Groovy",
				Hard = "Splaty",
				Expert = "Mezcla",
				Edit = "Mix de Octavio",
				ToOptions = "Presiona START para entrar a opciones.",
				LongSong = "¡Esta canción es larga!",
				MaraSong = "¡Esto es un maratón!",
			},
		},
	},

	japanese = {
		SplatManiaOptions = {
			GraphicOptions = {
				HeaderText = "グラフィックオプション",
				LowLevel = "低い",
				MedLevel = "中",
				HigLevel = "アルト",
				MaxLevel = "最大",
			},
			MainOptions = {
				HeaderText = "主なオプション",
			},
			LanguageOptions = {
				HeaderText = "言語を選択",
				Warning = "言語を設定するときは、ゲームを再起動して変更を適用する必要があります。",
			},
			Global = {
				Move = "移動",
				Accept = "受け入れる",
				Return = "前のメニューに戻る",
			},
		},

		ScreenTest = {
			Dialog = {
				Text1 = "うわー、私はそこに会いませんでした！ どうしたの？ テスト画面へようこそ。",
			},

			LanguageTest = {
				Text=  "これは、テーマと他の言語のフォント機能をテストするための画面です。",
				Text2= "言語を変更すると、この画面のテキストが変更されます。",
				Text3= "そうでない場合は、Jose_Varelaに報告してください。",
			},
		},
	},
}

function GrabTransText(name1, name2, name3, name4)
	-- If it contains 3 elements
	if LanguagesBoard[THEME:GetCurLanguage()][name1][name2][name3] == nil then
		SCREENMAN:SystemMessage("A text string was not found in the "..THEME:GetCurLanguage().." language. Using english variant instead.")
		return LanguagesBoard['english'][name1][name2][name3]
	else
		return LanguagesBoard[THEME:GetCurLanguage()][name1][name2][name3]
	end

	-- If it contains 4 elements
	if LanguagesBoard[THEME:GetCurLanguage()][name1][name2][name3][name4] == nil then
		SCREENMAN:SystemMessage("A text string was not found in the "..THEME:GetCurLanguage().." language. Using english variant instead.")
		return LanguagesBoard['english'][name1][name2][name3][name4]
	else
		return LanguagesBoard[THEME:GetCurLanguage()][name1][name2][name3][name4]
	end
	return ""
end

function LanguageSet(name)
	PREFSMAN:SetPreference("Language", name)
end