This archive only hosts NotITG-compatible themes that do not already have a NotITG fork maintained by anyone else, with the exception being Simply ITG because idk how to contact the creator.
So here's a list of themes that do have NotITG fork and are still currently maintained by other people:

Simply Love - Oat vs. Rya's Fork: https://github.com/oatmealine/simply-love-oat-fork \
GrooveNights - Star's Fork: https://github.com/StarUndrscre/GrooveNights-StarFork

# Welcome to my NotITG theme archive!

**NOTE: The game might give errors if you try to play files immediately after switching themes. Restarting the game fixes the problem.**

An archive by PoRa that hosts old NotITG-compatible themes, slightly edited to ensure a smooth experience on NotITG v4.9.1. Hopefully this will allow for more long-term usage with these themes.

These were only tested on NotITG v4.9.1 Coin Mode Home + Event Mode.

All themes here are ensured to have: modern noteskin customization, modern judgment font customization, proper difficulty number, song length indicator and result indicator (can be grades or percentage score) on song selection screen, a "Play Mods" button (takes you to 2P Regular immediately), Course (Marathon) Mode being accessible, a Select Theme option, and a Display Resolution option.\
Other modern features are not necessarily added, mainly for either the sake of keeping it true to the original, or because of UI issues.

I'm still new to theming so I actually don't know for sure how this all works, I just copy pasted stuff from other themes until I figure out what works haha. I just want there to be a bunch of working themes to make theming easier in the future. Maybe I'll try making my own theme some day? But until then, back to noteskin hole I go.

# IN THE GROOVE: MEAT
A very animated theme based on the game Super Meat Boy by Team Meat, with world selection and a whole auto platformer for some visuals!\
Pretty insane how functional this theme still is even on NotITG current version
## Credits:
-Original theme by Mad Matt, no longer maintained. Optimized for NotITG 4.9.1 by PoRa

## Changelogs:
-Added "Play Mods" (takes you to 2P Regular immediately, also note that this will always pick The Forest since this theme doesn't save the world you picked last session)\
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
-Since the detailed scores it uses is already similar to the 17-tier one, I also changed the score threshold in metrics.ini to a 17-tier one for consistency across themes.

# SIMPLY ITG
The default In The Groove 2 theme, with certain features from NotITG Simply Love ported over.
## Credits:
-Original theme by Connormgs, still maintained? (not sure) Optimized for NotITG 4.9.1 by PoRa

## Changelogs:
-Added "Play Mods" (takes you to 2P Regular immediately)\
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
-Removed Reset Menu button in Options as it screws up the game real badly. (not so surprising isn't it)

# DANCE WITH INTENSITY
A minimal theme based on the game Dance With Intensity by SimWolf and DJ DraftHorse.
## Credits:
-Original theme by Jose Varela, no longer maintained (detailed credits in README). Optimized for NotITG 4.9.1 by PoRa

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
-Added the ability to set the resolution alongside the ratio. All ratios except for 4:3, 16:10, 16:9, 3:2 and 5:4 are removed.


# IN THE GROOVE: TACTICS
A minimal theme based on the game Final Fantasy Tactics by Square, featuring a whole... class system?
## Credits:
-Original theme by Mad Matt, no longer maintained. Optimized for NotITG 4.9.1 by PoRa

## Changelogs:
-Added "Continue" (takes you to 2P Regular and selects Squire immediately since this theme doesn't save your class once you exit)\
-Fixed duplicated/overlapping text in the Options menu.\
-Added Display Mode, Resolution, Select Theme option.\
-_missing font now redirects to FFT2 white font for better readability in the UI that uses it.\
-Made noteskins option (Note) use the entire NoteSkins folder, noteskins now affect players 1-8, added Judgment Font (Judge) customization option.\
-Changed the layering of the BPM number so that it stays hidden during modfiles.\
-Edited a bunch of UI in Edit Mode to fit NotITG's Editor.\
-Fixed some of the UI in Marathon Mode, fixed the bug where the course title is updated one course late when switching courses.\
-NOTE: I did NOT change this one to the 17-tier scoring threshold, so the saved grades will be messed up when you check out other themes. (Will automatically fix itself when it's fixed in the next NotITG release)


# A.O.I.
***NOTE: This theme requires you to have the theme OITGThemerFallback for it to work!!! And just like any other fallback theme, do not actually use OITGThemerFallback.***

The accelerated operational interface for Stepmania 3.95 ported to NotITG!
## Credits:
-Original theme by k//eternal. Original NotITG port by Jose Varela, no longer maintained. Optimized for NotITG 4.9.1 by Nhan and PoRa.

## Changelogs:
-Added "Play Mods" (takes you to 2P Regular Hard difficulty immediately)\
-Edit Courses changed to Courses. Finished the UI of Courses.\
-Default sort option is set to Group.\
-Changed all the .gif files into .png files.\
-Redirected more fonts into using the _shared1 font.\
-Made noteskins use the entire NoteSkins folder, noteskins now affect players 1-8, added Judgment Font (Judge Skin) customization option, added Music Rate customization option\
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
-Finished the UI in Edit Mode.




