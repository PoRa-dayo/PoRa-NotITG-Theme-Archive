This archive only hosts NotITG-compatible themes that do not already have a NotITG fork maintained by anyone else, with the exception being Simply ITG because idk how to contact the creator.
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

All themes here are ensured to have: modern noteskin customization, modern judgment font customization, proper difficulty number, step artist, song length indicator and result indicator (can be grades or percentage score) on song selection screen, Stitch.lua stuff (FailOverlay, in-game console, whatever extra overlays you want, etc.), a "Play Mods" button (takes you to 2P Regular immediately), Course (Marathon) Mode being accessible, a Select Theme option, and a Display Resolution option.\
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
-Made noteskins use the entire NoteSkins folder, judgment fonts use the _Judgments folder, and swapped the positions of Turn and Judgment Font in Options\
-Mods now affect players 1-8\
-Added NotITG MetaMods\
-Added M speedmod\
-Added fullscreen/windowed and resolution options\
-Removed the duplicated text in Options menu\
-Added some files in Graphics/_Bandages to prevent errors when restarting a song\
-_missing font now redirects to Common title font as the Meat font is too big for the debug menu\
-Common normal font is now an edited version of Common title (instead of an edited version of Meat) so that the UI that use it fit the game\
-Edited a bunch of UI in Edit Mode to fit NotITG's Editor.\
Since the detailed scores it uses is already similar to the 17-tier one, I also changed the score threshold in metrics.ini to a 17-tier one for consistency across themes.\
-Stitch.lua is implemented, alongside FailOverlays and the in-game console.\
-Added step artist display in song selection screen.

<img width="200" height="150" alt="NotITG-v4 9 1_N1zP0GNTDo" src="https://github.com/user-attachments/assets/5864a2e9-8bf0-4821-9ba5-ba2db0a5f711" />
<img width="200" height="150" alt="NotITG-v4 9 1_ydQ8VCPOex" src="https://github.com/user-attachments/assets/0f8bc8c2-9e2a-4ae8-aabc-0c3b48679eea" />
<img width="200" height="150" alt="NotITG-v4 9 1_13CBcIFn30" src="https://github.com/user-attachments/assets/7767509a-61a6-48d3-a398-cc5428121afe" />
<img width="200" height="150" alt="NotITG-v4 9 1_3LoP7zfpwd" src="https://github.com/user-attachments/assets/d8575bbb-d00c-4c00-af22-ed18defb8526" />
<img width="200" height="150" alt="NotITG-v4 9 1_IV6PgA7Zjo" src="https://github.com/user-attachments/assets/7b6fd3a0-f78b-448d-acda-8401e8c622c3" />
<img width="200" height="150" alt="NotITG-v4 9 1_5IrQY1r7ci" src="https://github.com/user-attachments/assets/a41efbde-30bb-485b-91d0-395f90f3eb4e" />


# SIMPLY ITG
The default In The Groove 2 theme, with certain features from NotITG Simply Love ported over.
## Credits:
-Original theme by Connormgs, still maintained? (not sure) Optimized for NotITG 4.9.1 by PoRa

## Changelogs:
-Added "Play Mods" (takes you to 2P Dance immediately)\
-Fixed the issue that made the speedmod set at setdefault in modfiles get overwritten by player's speedmod.\
-Made noteskins use the entire NoteSkins folder, and judgment fonts use the _Judgments folder\
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
-Stitch.lua is implemented, alongside FailOverlays and the in-game console.\
-Added step artist display in song selection screen.

<img width="200" height="150" alt="NotITG-v4 9 1_aSZEkP7Qqw" src="https://github.com/user-attachments/assets/cafa07e5-a603-408a-b327-56bc7472d54b" />
<img width="200" height="150" alt="NotITG-v4 9 1_WEXP4fVbKx" src="https://github.com/user-attachments/assets/be3345b4-037c-4ee0-9865-b69f5daab26f" />
<img width="200" height="150" alt="NotITG-v4 9 1_jUI7JOitBB" src="https://github.com/user-attachments/assets/6f34b1b8-bf6c-40a4-8e95-53eee088e152" />
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
-Added the song title in the evaluation screen to account for charts with no banners.\
-Stitch.lua is implemented, alongside FailOverlays and the in-game console.\
-Added step artist display in song selection screen.

<img width="200" height="150" alt="NotITG-v4 9 1_yNGDFvPqYA" src="https://github.com/user-attachments/assets/a0337299-a99f-4f32-8a6e-25090ab40973" />
<img width="200" height="150" alt="NotITG-v4 9 1_Odd72sXTZe" src="https://github.com/user-attachments/assets/6b90feff-2ba1-4053-b787-ab8c8ec3daad" />
<img width="200" height="150" alt="NotITG-v4 9 1_emRLmGJCsw" src="https://github.com/user-attachments/assets/509b91eb-c5d7-401d-ad51-5069370aafef" />
<img width="200" height="150" alt="NotITG-v4 9 1_L5Hfu5MVmg" src="https://github.com/user-attachments/assets/67da3e71-55ee-469f-b69a-5619bf79e423" />
<img width="200" height="150" alt="NotITG-v4 9 1_FgkErb8ypD" src="https://github.com/user-attachments/assets/38283b56-7547-4437-8b7c-a4a8180158f0" />


# IN THE GROOVE: TACTICS
A minimal theme based on the game Final Fantasy Tactics by Square, featuring a whole... class system?
## Credits:
-Original theme by Mad Matt, no longer maintained. Optimized for NotITG 4.9.1 by PoRa

## Changelogs:
-Added "Continue" (takes you to 2P Dance and selects Squire immediately since this theme doesn't save your class once you exit)\
-Fixed duplicated/overlapping text in the Options menu.\
-Added Display Mode, Resolution, Select Theme option.\
-_missing font now redirects to FFT2 white font for better readability in the UI that uses it.\
-Made noteskins option (Note) use the entire NoteSkins folder, noteskins now affect players 1-8, added Judgment Font (Judge) customization option.\
-Changed the layering of the BPM number so that it stays hidden during modfiles.\
-Edited a bunch of UI in Edit Mode to fit NotITG's Editor.\
-Fixed some of the UI in Marathon Mode, fixed the bug where the course title is updated one course late when switching courses.\
-NOTE: I did NOT change this one to the 17-tier scoring threshold, so the saved grades will be messed up when you check out other themes. (Will automatically fix itself when it's fixed in the next NotITG release)\
-Fixed the oversight that made system messages stay hidden after showing up for the first time.\
-Stitch.lua is implemented, alongside FailOverlays and the in-game console.\
-Added step artist display in song selection screen.

<img width="200" height="150" alt="NotITG-v4 9 1_1tjK7gDr5J" src="https://github.com/user-attachments/assets/89a4413f-d6ae-452e-9efa-250af917df0b" />
<img width="200" height="150" alt="NotITG-v4 9 1_PBIx9s7E0H" src="https://github.com/user-attachments/assets/0b08f8a2-4aeb-4368-a9be-4432b97c23c3" />
<img width="200" height="150" alt="NotITG-v4 9 1_KTU2h1C9RK" src="https://github.com/user-attachments/assets/66d37c6c-ad58-4360-964a-b5f81745b378" />
<img width="200" height="150" alt="NotITG-v4 9 1_YxcHjR6XMb" src="https://github.com/user-attachments/assets/c7283f67-ff9a-4792-922c-086425357e29" />
<img width="200" height="150" alt="NotITG-v4 9 1_HvAg8y7O6n" src="https://github.com/user-attachments/assets/33ebe694-cac4-4099-a76c-b90dffdc861e" />
<img width="200" height="150" alt="NotITG-v4 9 1_gNbsq0hjzg" src="https://github.com/user-attachments/assets/39bbd930-a767-47ae-a2f8-ef09cf88ae4d" />


# A.O.I.
***NOTE: This theme requires you to have the theme OITGThemerFallback for it to work!!! And just like any other fallback theme, do not actually use OITGThemerFallback.***

The accelerated operational interface for Stepmania 3.9 ported to NotITG!\
OITGThemerFallback is a fallback theme that's made to be closer to the base SM3.9 theme. It also has some documentation in the metrics that you can use as a reference to make your own theme.
## Credits:
-Original theme by k//eternal. Original NotITG port by Jose Varela, no longer maintained. Optimized for NotITG 4.9.1 by Nhan and PoRa with permission.

## Changelogs:
-Added "Play Mods" (takes you to 2P Regular Hard difficulty immediately)\
-Edit Courses changed to Courses. Finished the UI of Courses.\
-Default sort option is set to Group.\
-Changed all the .gif files into .png files.\
-Redirected more fonts into using the _shared1 font.\
-Made noteskins use the entire NoteSkins folder, noteskins now affect players 1-8, added Judgment Font customization option, added Music Rate customization option\
-Replaced the "Loading..." sprite with an original one.\
-Changed the layering of the timer bar and difficulty frame, as well as removing some duplicated elements in the song selection screen.\
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
-Stitch.lua is implemented, alongside FailOverlays and the in-game console.\
-Added step artist display in song selection screen.

<img width="200" height="150" alt="NotITG-v4 9 1_fI2Rc4ccEX" src="https://github.com/user-attachments/assets/42d665a7-7956-4a56-b381-5b2600e8456e" />
<img width="200" height="150" alt="NotITG-v4 9 1_rAmhAt1GeF" src="https://github.com/user-attachments/assets/7e4efa9c-987e-486a-ba07-4e89dbb3dff8" />
<img width="200" height="150" alt="NotITG-v4 9 1_sYwGA8m7HN" src="https://github.com/user-attachments/assets/63642c71-c162-430a-8544-bdf0890b3eee" />
<img width="200" height="150" alt="NotITG-v4 9 1_0KusHFIzfG" src="https://github.com/user-attachments/assets/08fb87c8-7249-478b-b9b5-9eb321b2dadf" />
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
-Noteskins now affect players 1-8.\
-Edited a bunch of UI in Edit Mode to fit NotITG's Editor.\
-Stitch.lua is implemented, alongside FailOverlays and the in-game console.

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
-Made noteskins use the entire NoteSkins folder, judgment fonts use the _Judgments folder. Mods now affect players 1-8.\
-Added M speedmod.\
-Added NotITG MetaMods.\
-Added SmartBlender. Everyone loves SmartBlender.\
-Not sure why the Config Key menu is shifted to the right, so I changed the Config Key menu to look like the original Simply Love.\
-Marathon Mode no longer shows a bunch of errors when starting a course.\
-Slightly altered the UI of course contents.\
-Courses now redirect you to evaluation screen instead of back to the title screen after clearing.\
-Added offset plot and spellcard viewer.\
-Stitch.lua is implemented, alongside FailOverlays and the in-game console.

<img width="200" height="150" alt="NotITG-v4 9 1_xlioNAwSXk" src="https://github.com/user-attachments/assets/20fe8442-5a88-4921-bdcb-3528798df37e" />
<img width="200" height="150" alt="NotITG-v4 9 1_gPeVZXXoP2" src="https://github.com/user-attachments/assets/35cc0244-202f-4176-9894-ad1bd0f49ed6" />
<img width="200" height="150" alt="NotITG-v4 9 1_WvZvelobqm" src="https://github.com/user-attachments/assets/23019231-2fdc-442f-b4e9-0d3ade98ff5a" />
<img width="200" height="150" alt="NotITG-v4 9 1_O7mSi1rTVj" src="https://github.com/user-attachments/assets/50e12b52-e612-4316-b23e-bb6736f156a7" />
<img width="200" height="150" alt="NotITG-v4 9 1_PuoX0zosiz" src="https://github.com/user-attachments/assets/a79d82fe-cdf8-4934-b89a-a54740262c0c" />

