This archive only hosts NotITG-compatible themes that do not already have a NotITG fork maintained by anyone else.

So here's a list of usable themes that do have NotITG forks and are still currently maintained by other people:

[Simply Love - Oat vs. Rya's Fork](https://github.com/oatmealine/simply-love-oat-fork) \
[GrooveNights for NotITG](https://github.com/Altracer42/GrooveNights_nitg) \
[GrooveNights - Star's Fork](https://github.com/StarUndrscre/GrooveNights-StarFork) \
[BunTheme](https://github.com/itBunHop/BunTheme)

# Welcome to my NotITG theme archive!

Head on to the [releases](https://github.com/PoRa-dayo/PoRa-NotITG-Theme-Archive/releases/tag/v1.0.0) to download!

**NOTE: The game might give errors if you try to play files immediately after switching themes. Restarting the game fixes the problem.**

An archive by PoRa that hosts old NotITG-compatible themes, slightly edited to ensure a smooth experience on NotITG v4.9.1. Hopefully this will allow for more long-term usage with these themes.

These were only tested on NotITG v4.9.1 Coin Mode Home + Event Mode.

All themes here are ensured to have: modern noteskin customization, modern judgment font customization, modern judgment hold customization (except DWI theme), proper difficulty number, step artist, song length indicator (can just be Long/Marathon indicator, but Course Mode must have the total time), available difficulties indicator (can be a difficulty list, or show whether easier/harder difficulties are available) and result indicator (percentage score and Failed grades must be visible) on song selection screen, hold (OK and NG) and mine counter as well as offset plot/spellcard viewer on results screen, Stitch.lua stuff (FailOverlay, in-game console, etc.), a "Play Mods" button (takes you to 2P Regular immediately), Course (Marathon) Mode being accessible, a Select Theme option, and a Display Resolution option.

Other modern features are not necessarily added, mainly for either the sake of keeping it true to the original, or because of UI issues. I also want to keep these themes at a 'frozen in time' state as much as possible, which means the themes' version numbers stay the same, the tips and birthdays stay the same no matter how outdated they are, and some menus remain lacking in features, to show that they're products of their time.

I'm still new to theming so there are a lot of things I have no clue about. All the fixes were done purely by copying stuff from other themes until I figure out what works. I just want there to be a bunch of working themes to make theming easier in the future. Maybe I'll try making my own theme some day? But until then, back to noteskin hole I go.

# IN THE GROOVE: MEAT
A very animated theme based on the game Super Meat Boy by Team Meat, with world selection and a whole auto platformer for some visuals!\
Pretty insane how functional this theme still is even on NotITG current version
## Credits:
-Original theme by Mad Matt, no longer maintained. Optimized for NotITG 4.9.1 by PoRa

## Changelogs:
-Added "Play Mods" (takes you to 2P Regular immediately, also note that this will always pick The Forest since this theme doesn't save the world you picked last session)\
-Fixed the issue that made the speedmod set at setdefault in modfiles get overwritten by player's speedmod.\
-Made noteskins use the entire NoteSkins folder, judgment fonts use the _Judgments folder, added Hold Judgment customizations, and moved around some options.\
-Mods now affect players 1-8\
-Added NotITG MetaMods\
-Added M speedmod\
-Added fullscreen/windowed and resolution options\
-Removed the duplicated text in Options menu\
-Added some files in Graphics/_Bandages to prevent errors when restarting a song\
-_missing font now redirects to Common title font as the Meat font is too big for the debug menu\
-Common normal font is now an edited version of Common title (instead of an edited version of Meat) so that the UI that use it fit the game\
-Edited a bunch of UI in Edit Mode to fit NotITG's Editor.\
-Since the detailed scores it uses is already similar to the 17-tier one, I also changed the score threshold in metrics.ini to a 17-tier one for consistency across themes.\
-Dr. Fetus now shows up in the song selection screen on whatever song you failed.\
-Stitch.lua is implemented, alongside FailOverlays and the in-game console.\
-Added step artist display in song selection screen.\
-Added offset plot and spellcard viewer in results screen.

<img width="200" height="150" alt="NotITG-v4 9 1_N1zP0GNTDo" src="https://github.com/user-attachments/assets/5864a2e9-8bf0-4821-9ba5-ba2db0a5f711" />
<img width="200" height="150" alt="NotITG-v4 9 1_ydQ8VCPOex" src="https://github.com/user-attachments/assets/0f8bc8c2-9e2a-4ae8-aabc-0c3b48679eea" />
<img width="200" height="150" alt="NotITG-v4 9 1_13CBcIFn30" src="https://github.com/user-attachments/assets/7767509a-61a6-48d3-a398-cc5428121afe" />
<img width="200" height="150" alt="NotITG-v4 9 1_3LoP7zfpwd" src="https://github.com/user-attachments/assets/d8575bbb-d00c-4c00-af22-ed18defb8526" />
<img width="200" height="150" alt="NotITG-v4 9 1_QnEUawLGTH" src="https://github.com/user-attachments/assets/0ecbb2f7-db8e-4a2d-aa72-329da4e08376" />
<img width="200" height="150" alt="NotITG-v4 9 1_5IrQY1r7ci" src="https://github.com/user-attachments/assets/a41efbde-30bb-485b-91d0-395f90f3eb4e" />


# SIMPLY ITG
The default In The Groove 2 theme, with certain features from NotITG Simply Love ported over, most notably the ability to choose the theme's color!
## Credits:
-Original theme by Connormgs (beaglebark), no longer maintained. Optimized for NotITG 4.9.1 by PoRa with permission.

## Changelogs:
-Added "Play Mods" (takes you to 2P Dance immediately)\
-Fixed the issue that made the speedmod set at setdefault in modfiles get overwritten by player's speedmod.\
-Made noteskins use the entire NoteSkins folder, and judgment fonts use the _Judgments folder. Added Hold Judgment customizations.\
-Mods now affect players 1-8\
-Added NotITG MetaMods\
-Removed Tutorial and Edit Courses (they don't work).\
-Removed Sound Options as it's broken and its settings are already there in the other categories\
-Added fullscreen/windowed option\
-Added the ability to set the resolution alongside the ratio. All ratios except for 4:3, 16:10, 16:9, 3:2 and 5:4 are removed.\
-Moved the Clean Screen options to Arcade Option.\
-Changed the values of the Lifebar Adjustment option, so you don't need to go to metrics.ini to change the lifebars for widescreen anymore. Lifebar Adjustment is now set to 0 by default.\
-Changed the help text in Edit Mode to reflect NotITG edit mode functions.\
-Removed Reset Menu button in Options as it screws up the game real badly. (not so surprising isn't it)\
-Replay Song? screen now takes you to evaluation screen if No is selected.\
-Removed Marathon Mode and Battle Mode buttons on title screen, select those inside Dance Mode instead.\
-F grades are now shown in song selection screen.\
-Stitch.lua is implemented, alongside FailOverlays and the in-game console.\
-Added step artist display in song selection screen.\
-Added offset plot and spellcard viewer in results screen.

<img width="200" height="150" alt="NotITG-v4 9 1_aSZEkP7Qqw" src="https://github.com/user-attachments/assets/cafa07e5-a603-408a-b327-56bc7472d54b" />
<img width="200" height="150" alt="NotITG-v4 9 1_WEXP4fVbKx" src="https://github.com/user-attachments/assets/be3345b4-037c-4ee0-9865-b69f5daab26f" />
<img width="200" height="150" alt="NotITG-v4 9 1_v6voTYf2em" src="https://github.com/user-attachments/assets/706c3bda-f26f-4f8b-adf0-24b610bd1f22" />
<img width="200" height="150" alt="NotITG-v4 9 1_8OMtk3BqCK" src="https://github.com/user-attachments/assets/2a9fb97b-316c-4e47-8764-f35eacc6d315" />
<img width="200" height="150" alt="NotITG-v4 9 1_TO6OPIpG9X" src="https://github.com/user-attachments/assets/3e73d16f-4af4-4da7-8acf-810da2296895" />


# DANCE WITH INTENSITY
A minimal theme based on the game Dance With Intensity by SimWolf and DJ DraftHorse.
## Credits:
-Original theme by Jose Varela, no longer maintained (detailed credits in README). Optimized for NotITG 4.9.1 by PoRa with permission.

## Changelogs:
-Added "Play Mods" (takes you to 2P Regular immediately)\
-Changed "Other" to "Noteskin", made noteskins use the entire NoteSkins folder, noteskins now affect players 1-8, added Judgment Font (Judge Skin) customization option, removed Freeze Arrows option since it doesn't really translate well to NotITG\
-Added grades in the song selection like the original DWI, the Failed grade will use the NO DATA sprite, changed the score threshold to a 17-tier one for the grades on song selection to work, and to keep the consistency with other themes (might change back when NotITG has better support for custom score/grade thresholds)\
-Delayed the theme reload when exiting the theme menu, required to fix the Theme Select button being broken.\
-Fixed the grade in results screen being broken\
-Removed the EVENT MODE screen (ScreenStage) that comes up after exiting song options\
-Removed the duplicate profile score info in song options screen when Show Score in Select Music is enabled\
-Fixed the error where part of the course details become transparent.\
-Changed the sort key config instruction to the name used in Stepmania (Select instead of Circle)\
-ReceptorArrowsYStandard is set back to -125 instead of -145 to prevent inconsistencies in modfiles\
-Fixed the stupid error where switching the Arrow Placement to DWI sets the playfield to ITG's position, while switching it to ITG brings the playfield downwards. (Arrow Placement - DWI is supposed to bring it upwards compared to ITG). ITG is now the default option to respect modfiles.\
-Fixed some more stupid errors in profile-related functions\
-Fixed the softlock that occurs when discarding offset changes\
-Fixed the tween overflow error that occurs when scrolling through songs too quickly\
-Added the ability to set the resolution alongside the ratio. All ratios except for 4:3, 16:10, 16:9, 3:2 and 5:4 are removed.\
-Course entries' titles are now properly left-aligned like in the original DWI.\
-Course mode's music now properly loops.\
-Little triangles are shown in song selection screen whenever there's an easier or harder difficulty available.\
-Machine Percentage High Score is now shown in song selection screen when Show Score in Select Music option is enabled.\
-Added the song title in the evaluation screen to account for charts with no text in their banners.\
-The CLEARED screen now takes 3 seconds instead of 5.\
-Stitch.lua is implemented, alongside FailOverlays and the in-game console.\
-Added step artist display in song selection screen.\
-Added back the percentage in results screen of course mode.\
-Added mod icons for custom noteskins.\
-Added offset plot and spellcard viewer in results screen.\
-Added back OK counter, as well as an N.G. counter next to it, and a mine counter next to the misses counter in results screen.

<img width="200" height="150" alt="NotITG-v4 9 1_AHPX1eOta3" src="https://github.com/user-attachments/assets/873f8787-f810-48cd-ae25-193a1293accc" />
<img width="200" height="150" alt="NotITG-v4 9 1_Odd72sXTZe" src="https://github.com/user-attachments/assets/6b90feff-2ba1-4053-b787-ab8c8ec3daad" />
<img width="200" height="150" alt="NotITG-v4 9 1_emRLmGJCsw" src="https://github.com/user-attachments/assets/509b91eb-c5d7-401d-ad51-5069370aafef" />
<img width="200" height="150" alt="NotITG-v4 9 1_jTjLyQS3jd" src="https://github.com/user-attachments/assets/1b7b3857-42e2-4062-89d1-a8b4d8c7b432" />
<img width="200" height="150" alt="NotITG-v4 9 1_FgkErb8ypD" src="https://github.com/user-attachments/assets/38283b56-7547-4437-8b7c-a4a8180158f0" />


# IN THE GROOVE: TACTICS
A minimal theme based on the game Final Fantasy Tactics by Square, featuring a whole... class system?
## Credits:
-Original theme by Mad Matt, no longer maintained. Optimized for NotITG 4.9.1 by PoRa

## Changelogs:
-Added "Continue" (takes you to 2P Dance and selects Squire immediately (or your last selected class if found))\
-Fixed duplicated/overlapping text in the Options menu.\
-Added Display Mode, Resolution, Select Theme option.\
-_missing font now redirects to FFT2 white font for better readability in the UI that uses it.\
-Made noteskins option (Note) use the entire NoteSkins folder, noteskins now affect players 1-8, added Judgment Font (Judge) and Hold Judgment (Hold Judge) customization options.\
-Changed the layering of the BPM number so that it stays hidden during modfiles.\
-Edited a bunch of UI in Edit Mode to fit NotITG's Editor.\
-Fixed some of the UI in Marathon Mode, fixed the bug where the course title is updated one course late when switching courses.\
-Added course length in Marathon Mode.\
-NOTE: I did NOT change this one to the 17-tier scoring threshold, so the saved grades will be messed up when you check out other themes. (Will automatically fix itself when it's fixed in the next NotITG release)\
-Fixed the oversight that made system messages stay hidden after showing up for the first time.\
-Added Config Key/Joy Mappings option.\
-Added Undead status icons next to songs you failed in the song selection screen.\
-Stitch.lua is implemented, alongside FailOverlays and the in-game console.\
-Added step artist display in song selection screen.\
-Added offset plot and spellcard viewer in results screen.

<img width="200" height="150" alt="NotITG-v4 9 1_1tjK7gDr5J" src="https://github.com/user-attachments/assets/89a4413f-d6ae-452e-9efa-250af917df0b" />
<img width="200" height="150" alt="NotITG-v4 9 1_PBIx9s7E0H" src="https://github.com/user-attachments/assets/0b08f8a2-4aeb-4368-a9be-4432b97c23c3" />
<img width="200" height="150" alt="NotITG-v4 9 1_KTU2h1C9RK" src="https://github.com/user-attachments/assets/66d37c6c-ad58-4360-964a-b5f81745b378" />
<img width="200" height="150" alt="NotITG-v4 9 1_YxcHjR6XMb" src="https://github.com/user-attachments/assets/c7283f67-ff9a-4792-922c-086425357e29" />
<img width="200" height="150" alt="NotITG-v4 9 1_HvAg8y7O6n" src="https://github.com/user-attachments/assets/33ebe694-cac4-4099-a76c-b90dffdc861e" />
<img width="200" height="150" alt="NotITG-v4 9 1_gNbsq0hjzg" src="https://github.com/user-attachments/assets/39bbd930-a767-47ae-a2f8-ef09cf88ae4d" />


# A.O.I.
***NOTE: This theme requires you to have the theme OITGThemerFallback for it to work!!! And just like any other fallback theme, do not actually use OITGThemerFallback.***

The accelerated operational interface for Stepmania 3.9, ported to NotITG!\
PROJEKT A.O.I. is based on the UI of Beatmania IIDX 12: Happy Sky. It is also known as the 10th installment of the PROJEKT series - a series revolving around themes based on the UI of Beatmania.

OITGThemerFallback is a fallback theme that's made to make it easier to port SM3.9 themes. It also has some documentation in the metrics that you can use as a reference to make your own theme.
## Credits:
-Original theme by k//eternal. Original NotITG port by Jose Varela, no longer maintained. Optimized for NotITG 4.9.1 by Nhan and PoRa with permission.

## Changelogs:
-Added "Play Mods" (takes you to 2P Regular Hard difficulty immediately)\
-Edit Courses changed to Courses. Finished the UI of Courses.\
-Default sort option is set to Group.\
-Changed all the .gif files into .png files.\
-Redirected more fonts into using the _shared1 font.\
-Made noteskins use the entire NoteSkins folder, noteskins now affect players 1-8, added Judgment Font and Hold Judgment customization options, added Music Rate customization option\
-Replaced the "Loading..." sprite with an original one.\
-Changed the layering of the player mods, timer bar and difficulty frame, as well as removing some duplicated elements in the song selection screen.\
-Changed the layering of the life bar, score bar and difficulty bar so they don't show up in modfiles, and slightly change their animation so that it makes sense.\
-Removed the "Player 1" during gameplay. (why is that thereee)\
-All elements on song selection screen now properly disappear when a song is selected.\
-Added an extra difficulty number on the song selection screen for difficulties more than 10.\
-Added a new window icon.\
-Bonus conditions for triggering special star effects in the ScreenStage screen.\
-Added some missing fonts for BPM/course length display.\
-Removed the leftover ITG2 frame in the result evaluation screen.\
-Revamped the entire grading system because every port of A.O.I. uses a different one and it was really inconsistent. E is now the failing grade. The spinning grades in the evaluation screen are now manually implemented as the built-in one is hardcoded to 7 tiers.\
-Fixed the error where the length indicator in music selection screen never changes.\
-Added the song title in the evaluation screen to account for charts with no banners. Also fixed the timer bar sprite in the evaluation screen.\
-Moved the Aspect Ratio/Resolution options around and replaced it with a more modern one. Removed Network Options (NotITG doesn't have that) and Profile Options (NotITG's built-in profile system is broken). Removed Show Caution, Show Song Options and Show Instructions options as it doesn't really affect anything in A.O.I., it just causes other themes to break.\
-Finished the UI in Edit Mode.\
-Changed the background of the results screen to one of the unused backgrounds when you get an E grade.\
-Little triangles are shown in song selection screen whenever there's an easier or harder difficulty available.\
-Machine Percentage High Score is now shown in song selection screen.\
-Judgment and combo positions no longer get messed up when moved in modfiles.\
-Stitch.lua is implemented, alongside FailOverlays and the in-game console.\
-Added step artist display in song selection screen.\
-Added offset plot and spellcard viewer in results screen.\
-Added a mine counter next to the misses counter, and a N.G. counter next to the freeze counter in results screen.

<img width="200" height="150" alt="NotITG-v4 9 1_fI2Rc4ccEX" src="https://github.com/user-attachments/assets/42d665a7-7956-4a56-b381-5b2600e8456e" />
<img width="200" height="150" alt="NotITG-v4 9 1_rAmhAt1GeF" src="https://github.com/user-attachments/assets/7e4efa9c-987e-486a-ba07-4e89dbb3dff8" />
<img width="200" height="150" alt="NotITG-v4 9 1_sYwGA8m7HN" src="https://github.com/user-attachments/assets/63642c71-c162-430a-8544-bdf0890b3eee" />
<img width="200" height="150" alt="NotITG-v4 9 1_isD7hniFEx" src="https://github.com/user-attachments/assets/47f72736-7eaf-45ae-bfd7-22e0a165c422" />
<img width="200" height="150" alt="NotITG-v4 9 1_nV1CXnBpCu" src="https://github.com/user-attachments/assets/96dd0d70-1574-4480-b898-58e9e1306d97" />


# PRISMRHYTHM 19

A kawaii theme based on the visual novel Prism Rhythm published by Lump of Sugar.\
This theme already has almost every feature you can ask for, so there are very few things I need to edit. It also has loads of documentation in the metrics that you can use as a reference to make your own theme.
## Credits:
-Original theme by Ace of Arrows, and unlike most other SM3.95/OITG themes, it's still being maintained! Optimized for NotITG 4.9.1 by PoRa with permission.

## Changelogs:
-Added "Play Mods" (takes you to 2P Dance immediately)\
-Placed Dance Mode, Battle Mode and Survival Mode inside Arcade Modes option.\
-Changed the layering of the BPM number and the player icons during gameplay so they stay hidden in modfiles.\
-Moved the help text in the Config Keys screen to the top.\
-Moved the Aspect Ratio/Resolution options around and replaced it with a more modern one. Removed Profile Options (broken in NotITG). Removed Show Caution and Show Instructions options, they don't do anything in this theme and break other themes.\
-Removed Reset Menu button in Options as it screws up the game real badly. (not so surprising isn't it)\
-Noteskins now affect players 1-8.\
-Added Hold Judgment and Vocalize customization.\
-F grades now show up in song selection screen.\
-Edited a bunch of UI in Edit Mode to fit NotITG's Editor.\
-Stitch.lua is implemented, alongside FailOverlays and the in-game console.\
-Added offset plot and spellcard viewer in results screen.

<img width="200" height="150" alt="NotITG-v4 9 1_fYdoivIhTT" src="https://github.com/user-attachments/assets/4eb11608-3b2b-4e31-8a99-8fa6aaaaa1a6" />
<img width="200" height="150" alt="NotITG-v4 9 1_oXfyWZ7KUg" src="https://github.com/user-attachments/assets/9957c377-345c-4fcb-8e87-a04bf5488d72" />
<img width="200" height="150" alt="NotITG-v4 9 1_g9UbaofFZq" src="https://github.com/user-attachments/assets/74586bce-9d40-4946-b980-ce41527bc132" />
<img width="200" height="150" alt="NotITG-v4 9 1_W6ivwVRoeT" src="https://github.com/user-attachments/assets/9fcada5c-edc2-4c9d-b406-a7dc334d24e6" />
<img width="200" height="150" alt="NotITG-v4 9 1_AnneehDTt7" src="https://github.com/user-attachments/assets/b8037208-3117-4324-941b-0229eee88d94" />

# SIMPLY LOVE GOODER (Jose's Unofficial Visual Modification)
A custom fork of NotITG's Simply Love, with loads of new features.

## Credits:
Original theme by Jose Varela, no longer maintained. Optimized for NotITG 4.9.1 by PoRa with permission.

## Changelogs:
-Added "Play Mods" (takes you to 2P Dance immediately)\
-Fixed the 'The actor file in '/Themes/simply-love-gooder/BGAnimations/ScreenGameplay ready/' is as a blank, invalid File attribute "Layer1"' error.\
-Fixed the issue that made the speedmod set at setdefault in modfiles get overwritten by player's speedmod.\
-Moved Advanced Graphic Options to the main options because it keeps refreshing the theme every time you select it inside Graphic Options.\
-Added the grades on the music wheel similar to the latest Simply Love themes.\
-Made noteskins use the entire NoteSkins folder, judgment fonts use the _Judgments folder. Added Hold Judgment customization. Mods now affect players 1-8.\
-Added M speedmod.\
-Added NotITG MetaMods.\
-Added SmartBlender. Everyone loves SmartBlender.\
-Not sure why the Config Key menu is shifted to the right, so I changed the Config Key menu to look like the original Simply Love.\
-Made the text in Edit Mode's UI slightly bigger because I could barely read the small text.\
-Marathon Mode no longer shows a bunch of errors when starting a course.\
-Slightly altered the UI of course contents.\
-Courses now redirect you to evaluation screen instead of back to the title screen after clearing.\
-The song progress timer now uses NotITG's StepsLengthSeconds instead of MusicLengthSeconds for more accuracy.\
-Added offset plot and spellcard viewer in results screen.\
-Stitch.lua is implemented, alongside FailOverlays and the in-game console.

<img width="200" height="150" alt="NotITG-v4 9 1_xlioNAwSXk" src="https://github.com/user-attachments/assets/20fe8442-5a88-4921-bdcb-3528798df37e" />
<img width="200" height="150" alt="NotITG-v4 9 1_gPeVZXXoP2" src="https://github.com/user-attachments/assets/35cc0244-202f-4176-9894-ad1bd0f49ed6" />
<img width="200" height="150" alt="NotITG-v4 9 1_WvZvelobqm" src="https://github.com/user-attachments/assets/23019231-2fdc-442f-b4e9-0d3ade98ff5a" />
<img width="200" height="150" alt="NotITG-v4 9 1_O7mSi1rTVj" src="https://github.com/user-attachments/assets/50e12b52-e612-4316-b23e-bb6736f156a7" />
<img width="200" height="150" alt="NotITG-v4 9 1_PuoX0zosiz" src="https://github.com/user-attachments/assets/a79d82fe-cdf8-4934-b89a-a54740262c0c" />


# SPLATMANIA 0.3.3.0
A modern animated theme based on the game Splatoon developed by Nintendo, though it was definitely more optimized for the SplatMania build rather than actual NotITG so some changes had to be made about that. There's also a newer 0.5.0.0 version for StepMania 5, but the UI there is so different that it's basically a different alternate theme, so I won't be referencing it too much.

## Credits:
Original theme by Jose Varela, no longer maintained. Optimized for NotITG 4.9.1 by PoRa with permission.

## Changelogs:
-Common normal font is now an edited version of PaintballStroke so that the UI that use it fit the game more.\
-Fixed some issues with japanese/korean text.\
-The Start button now takes you to 2P Regular immediately. The usual select mode button is now the Other modes button.\
-Slightly altered some UI so that it makes more sense and text doesn't get covered up.\
-Added some more Options for the sake of long-term usage of this theme inside NotITG rather than the SplatMania build.\
-Doubles and Marathon modes are now accessible. Marathon has new BGM and UI slightly altered for the mode.\
-Added a timeout in the title screen that leads to the detailed credits screen because that screen is just unused for some reason.\
-In my opinion the song banner and BPM being hidden in song selection screen is unacceptable for normal NotITG so I added that back.\
-Added a bunch of info in song selection screen like step artist being shown for every difficulty, your high score being shown, Failed icon shown in song selection on failed songs, little squids that indicate easier/harder difficulties available, etc.\
-Added modernized noteskin, judgment font, hold judgment, and Music Rate customization.\
-Fixed the error where the Long/Marathon pop-up in song selection screen keeps getting bigger if you switch through songs rapidly, also changed its location.\
-Added offset plot and spellcard viewer in results screen.\
-A "Success!" rank is added to the evaluation screen for when you lifebar pass the song. The song banner and player mods are also added there.\
-Added mine counter in the evaluation screen similar to SplatMania 0.5.0.\
-Fully overhauled the UI of the lifebar, difficulty counter, etc. during non-mods gameplay.\
-Resized the default judgment textures and changed the judgment tween accordingly so that it scales well with most other judgments out there.\
-Made the music wheel highlight in song selection screen clearer, and made it not disappear when entering sort mode.\
-No more long wait after pressing start to enter song options.\
-Added options to disable the Countdown near the end of the song, as well as the Coin System.\
-Removed the custom Language Settings menu as it doesn't work, so the built-in Language options is used now. I don't know if it's even possible to make it keep picking the language you last used by default every time you start the game though.\
-The song progress timer now uses NotITG's StepsLengthSeconds instead of MusicLengthSeconds for more accuracy.\
-Stitch.lua is implemented, alongside FailOverlays and the in-game console.

<img width="200" alt="NotITG-v4 9 1_69H7WSJs1d" src="https://github.com/user-attachments/assets/1846daee-f457-4cdf-8b6f-4630d29df30b" />
<img width="200" alt="NotITG-v4 9 1_D4dXsxAH9l" src="https://github.com/user-attachments/assets/1f007dd7-b83f-4529-a454-021ff5741d97" />
<img width="200" alt="xVIwFUbVN5" src="https://github.com/user-attachments/assets/f0667d9d-032f-4b25-aecc-d62dbb7fc1a4" />
<img width="200" alt="NotITG-v4 9 1_FneqyfElaC" src="https://github.com/user-attachments/assets/084a0e32-b386-401f-9402-956b66f62f1f" />
<img width="200" alt="NotITG-v4 9 1_xTsWBdgqQz" src="https://github.com/user-attachments/assets/d0c7edf9-3166-4989-b3e5-4702a0bf9412" />

# IN THE GROOVE 3: COMPLETE MIX
A futuristic-looking theme made for In The Groove 3, the "supposedly" third installment in the In The Groove series by Roxor Games, hadn't it been for the Konami acquisition.

This Complete Mix bundle allows you to switch between the interfaces of the original In The Groove 3, In The Groove 3: Encore, and the pre-release of In The Groove 3: Encore Final on the fly!

## Credits:
Original theme by LightningXCE and the ITG3 Team, no longer maintained (except for ITG3 Encore Final which they're still working on and there hasn't even been an actual release yet). The ITG3 Final interface in this theme is based on the SM5 port by AJ Kelly and DarkBahamut162. Optimized for NotITG 4.9.1 by PoRa.

## Changelogs:
-Now falls back on NotITG's fallback theme instead of ITG3's fallback3 theme, though there are barely any differences between the two anyway.\
-Added "Play Mods" (takes you to 2P Dance immediately). All the other modes except Fitness Mode are now in Arcade Modes.\
-Removed the labels in Records.\
-Moved Select Theme to the main options screen because it's too important to be in freaking "Custom Song Options".\
-Moved Map Inputs to the main options screen to make the title screen less cluttery.\
-Removed Reset To Factory Defaults because it messes up the game real badly.\
-There were a bunch of blacklisted themes in Select Theme. Now only the default and fallback themes are blacklisted.\
-Added fullscreen/windowed option.\
-Added the ability to set the resolution alongside the ratio. All ratios except for 4:3, 16:10, 16:9, 3:2 and 5:4 are removed.\
-Moved the Clean Screen options to Arcade Option.\
-Added step artist display in song selection screen.\
-Lowered the max width of the artist display, course titles and course contents in the song/course selection screen.\
-Increased the spacing between the difficulties and the course entries' titles.\
-F grades are shown in the song selection screen.\
-Added a length indicator in Marathon mode.\
-Added modernized noteskin, judgment font, and hold judgment customization.\
-Timer-related restrictions are now disabled when Menu Timer is Off.\
-Fixed the error that happens in the player options menu when the song's BPM is negative.\
-Most of the gameplay UI is fused with ITG3 Encore's because the UI of the original ITG3 is very unfinished.\
-Step information now has numbers below their icons that are permanently visible. Thanks Ace of Arrows for this idea.\
-Swapped the behavior of the stepartist, song length and step information popups by default. Now they'll normally show up and hide whenever you hold Select. There is now an option called Hide Song Details in Theme Options that swaps back this behavior.\
-ITG3 had special gameplay UI that gets triggered on certain special songs. Since this isn't ITG3, you can now switch between any UI you want in Theme Options. Do note that the special songs (e.g. any VerTex song) will still force their own respective UI. It is now also enabled in Course Mode.\
-Added the UI of ITG3 Encore and ITG3 Encore Final. You can switch between these interfaces via Theme Options.\
-Altered some of the UI of Edit mode to fit NotITG's settings.\
-Added offset plot and spellcard viewer in results screen.\
-Stitch.lua is implemented, alongside FailOverlays and the in-game console.

<img width="200" alt="NotITG-v4 9 1_CBnvbNxFh3" src="https://github.com/user-attachments/assets/8e89f0b1-f10f-49b1-8d23-2bba332ac7a8" />
<img width="200" alt="NotITG-v4 9 1_OvgLJY1wGj" src="https://github.com/user-attachments/assets/56a20cf9-d4a3-4d90-890d-7dab2044ab69" />
<img width="200" alt="NotITG-v4 9 1_ZaDX4Z6FzO" src="https://github.com/user-attachments/assets/c3fc6cb3-0ad1-4f20-a12c-e841e0ca1af3" />
<img width="200" alt="NotITG-v4 9 1_3k7t9OViez" src="https://github.com/user-attachments/assets/caebef17-fdb5-4918-bddc-1c7b0768e2cb" />
<img width="200" alt="NotITG-v4 9 1_4SbJSLvXq1" src="https://github.com/user-attachments/assets/04909583-8d27-4c31-95d5-f4f991e25ab5" />


# BEATMANIA IIDX 14: GOLD
***NOTE: This theme requires you to have the theme OITGThemerFallback for it to work!!! And just like any other fallback theme, do not actually use OITGThemerFallback.***

A very animated and flashy theme based on the game Beatmania IIDX 14: Gold, the 14th installment in Konami's Beatmania IIDX series. This is also my very first full port of a SM3.9 theme, using OITGThemerFallback and A.O.I. as a base.\
Now, it's party time! Ready to relive your hypest moments with IIDX GOOOOOOOOOOOOOOOOLD!!!!!

## Credits:
Original theme by DJ.Tony (SM3.9). Ported and optimized for NotITG 4.9.1 by PoRa.

## Changelogs: (compared to the SM3.9 ver)
-This was a big theme. The original theme had a custom .exe that came along with it that allowed you to customize some things like the Common BGM, Decide SFX, Toasties, Screen Filter, Explosions of the Beatmania skins that came along with it, the Lane Covers, and even options to make the UI become an actual Beatmania simulator.:\
-- .exe programs like those existed at the time was because the Scripts folder weren't a thing. Now that it is a thing, options like Common BGM, Decide SFX, Toasties and Screen Filter can now be customized right inside the theme via Options -> Theme Options.\
-- All the stuff related to turning the theme into a Beatmania simulator, including Lane Cover and Noteskin Explosions, is removed for obvious reasons.\
-Added "Play Mods" (takes you to 2P Versus Dance immediately)\
-No longer possible to select Solo (6K) mode (the button is replaced with Doubles mode).\
-The battery gauge in Challenge Mode is now replaced with the lifetime gauge, aka it's now Survival mode instead of Oni. No one likes Oni mode.\
-Added roll counter and steps description (step artist) to the pane display.\
-Added more sort icons.\
-Added the banner frame and total time counter in course selection screen.\
-Above the banner in the song selection screen is now the song title, song subtitle and song artist, instead of just the song artist.\
-The difficulties on the music wheel are now more like in the original IIDX.\
-Added group name display and number of songs in the group like the original IIDX.\
-Converted the grade system to a 17-tier one.\
-Noteskins now affect players 1-8, added Judgment Font and Hold Judgment customization options.\
-The Full Combo animation is no longer unused.\
-Judgment and combo positions no longer get messed up when moved in modfiles.\
-The animation for the PERFECT judgment being 3 frames caused a bunch of problems in NotITG as well as compatibility with other judgment fonts, so it is changed to just the cyan-white PERFECT with different diffuse colors. It doesn't look accurate anymore, but it still sorta works.\
-Toasties now use cropping instead of masking to avoid messing with the playfields. They will not show up in modfiles. The Toasties in 2-player modes now appear behind the playfield of the corresponding player.\
-Finished Edit Mode's UI.\
-Modern resolution settings are added. Elements are now made to *mostly* support other screen ratios that can be picked via the in-theme options.\
-Added offset plot and spellcard viewer in results screen.\
-Added a BAD counter next to the OK counter, and a mine counter next to the misses counter in results screen.\
-Stitch.lua is implemented, alongside FailOverlays and the in-game console.


<img width="200" alt="NotITG-v4 9 1_NJKWbTCH2e" src="https://github.com/user-attachments/assets/85104be9-b12b-44b3-b650-20dfa4f0c3fa" />
<img width="200" alt="NotITG-v4 9 1_GtUzV3sWtd" src="https://github.com/user-attachments/assets/f7e91440-57b8-43ae-8328-64bd20ba9cfe" />
<img width="200" alt="NotITG-v4 9 1_KgNbzFQ4b8" src="https://github.com/user-attachments/assets/52a98074-2a19-460e-9b54-1ae5277349fe" />
<img width="200" alt="NotITG-v4 9 1_UnfWajcjL7" src="https://github.com/user-attachments/assets/f04a3188-6999-4781-90ed-dc1b4c006535" />
<img width="200" alt="NotITG-v4 9 1_WynyrU45bV" src="https://github.com/user-attachments/assets/db5daea4-0fe4-41db-90b2-19d67a210ed5" />


# TOUHOU HISOUTENSOKU
A steampunk-like theme made as a love letter to the fighting game Touhou Hisoutensoku, made by Twilight Frontier and Team Shanghai Alice.


This is also my first port of a SM5 theme, and the original SM5 theme is a rather simple one. Unfortunately NotITG themes have to have a load of files, but I tried organizing them to the best of my ability.\
It was built with PrismRhythm as a base, so its metrics documentation is still there. Hope this theme can be a good base for making new ones in the future.

## Credits:
Original theme by Jousway (SM5). Ported and optimized for NotITG 4.9.1 by PoRa with permission.

Thanks to DarkOverord for posting most of the game's assets on spriters-resource.com.

## Changelogs: (compared to the SM5 ver.)
-Added Touhou Hisoutensoku's window icon.\
-Buttons in the title screen are changed to have NotITG's common game modes, including "VS Dance", acting as this theme's "Play Mods".\
-Marathon mode is now accessible. Doubles charts can now be played.\
-Added "Memory of Forgathering Dream" that plays at certain parts such as Marathon Mode, Edit menu, etc.\
-Added a bunch of sound effects from the original game that play in various places. The timeout sound however was from the mainline bullet hell Touhou games lol.\
-Option menus are revamped to be more like what SM3.95 themes usually have. Added custom option cursors and underlines.\
-Player option menus are revamped to be more like what NotITG Simply Love has. Speedmod customization is changed to be in the style of Simply Love. Added MetaMods.\
-Added judgment font and hold judgment customization.\
-Added a "Press Start to enter options menu" popup.\
-Pane contents (stepchart data on song select) changed to what ITG usually has.\
-Added a custom default judgment font and hold judgment, and custom combo font.\
-Folder names and Roulette/Random on the song select screen now have different colors to be less confusing.\
-Difficulty list now uses its own number font, and also shows the difficulty name and number as well as the stepartist of the currently selected chart.\
-Grades now use assets from the original game, with custom-made grade sprites for D and F. The grade system is similar to A.O.I's.\
-Added ScreenStage (intro before the gameplay) that shows the song title and current stage in a similar manner to the original game.\
-The default background is now picked randomly from the 7 main backgrounds that appeared in the original game's Story Mode.\
-Added custom Ready and Cleared animations based on the original game.\
-The lifebar now has an extra red part that shows up when life is lost, and is animated like in the original game.\
-Current song title, subtitle and difficulty are now displayed in the gameplay UI.\
-The top middle part of the gameplay UI now displays the current stage, as well as a countdown to the end of the song.\
-Added a small BPM counter at the bottom.\
-Added a fanfare to the results screen. (being the ending of "The Eternal Theme Engine")\
-Results screen now display stats in a similar manner to ITG, except Hands and Jumps counters are removed. BPM and Music Rate are also displayed on this screen.\
-Added a name entry screen at the end of a game session (when Event Mode is off).\
-Added Edit menu and finished its UI.\
-The prompts (pop-ups that ask a question that you have to answer) are also customized.\
-Added offset plot and spellcard viewer in results screen.\
-Stitch.lua is implemented, alongside FailOverlays and the in-game console.


<img width="200" alt="NotITG-v4 9 1_gCfGWOw5qg" src="https://github.com/user-attachments/assets/a9d96874-4b2d-4a66-a6e6-fa1b43557533" />
<img width="200" alt="NotITG-v4 9 1_bo2xtRpaIA" src="https://github.com/user-attachments/assets/56d70423-45f5-45e5-9b7a-794f0e55115e" />
<img width="200" alt="NotITG-v4 9 1_dUJ6RcpCBl" src="https://github.com/user-attachments/assets/256c4d61-7e78-4a29-88ed-840aeae849fb" />
<img width="200" alt="KFm6BinoKl" src="https://github.com/user-attachments/assets/917315a1-b0f2-4cb1-a71a-c235503c60ca" />
<img width="200" alt="NotITG-v4 9 1_I5qMfjsspj" src="https://github.com/user-attachments/assets/b55607af-4b78-4563-89cc-0581a57b9351" />


# Special thanks
[MattMayuga](https://github.com/Tiny-Foxes/JudgeFonts-by-MattMayuga/) - Judgment fonts.\
[HURG-IIDX](https://github.com/HURG-IIDX/Simply-Love-Judgefonts) - Judgment fonts.\
Maybell Eigenhart - Hold judgment fonts.
