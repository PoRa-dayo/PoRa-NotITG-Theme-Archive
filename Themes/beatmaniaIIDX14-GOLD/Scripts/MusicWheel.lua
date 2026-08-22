--shit code warning

--The behavior of the MusicWheel is weird. In this theme it starts off as a normal ActorFrame with 21 MusicWheelItems in it.
--The names of the groups and songs go from 1 to 21 like what you see on-screen, simple.
--Let's say you start off at index 11 at the middle and your currently selected song is Mirin Template, and the song below you is Blacksphere.
--But as you move the cursor, your position index on the MusicWheel changes, but the entire wheel itself does not update to what you see on-screen.
--You just simply moved on to index 12, but 11th item in MusicWheel is still Mirin Template, and the 12th one is still Blacksphere.
--You also notice that the MusicWheelItem at index 1 has changed. Yes, only ONE item changes at a time.
--You move down to index 13, MusicWheelItem at index 2 changes. Index 14, MusicWheelItem at index 3 changes, and so on.
--Until you reach index 21, and MusicWheelItem at index 10 changes.
--You move down again, and your index has now looped back to 1. The MusicWheelItem at index 11 changes. It is no longer Mirin Template.
--Likewise, if you move up at index 1, you'll loop back to 21. The MusicWheelItem at index 11 is Mirin Template again.
--So basically, as you move, there is an 'update cursor' 10 indices away from you that also moves and updates the next item it encounters.
--When either the 'update cursor' or your own reaches index 21, it'll loop back to 1 when you move down, and vice versa.

--Oh but here comes the worst part, the BitmapText that it doesn't use DOES NOT GET CLEARED.
--So you can have a Song MusicWheelItem that has a completely unrelated group name in it because the group name did not get cleared.
--Or a Group MusicWheelItem that has freaking 'ROULETTE' in the Sort BitmapText because the ROULETTE did not get cleared.
--It does get hidden though, well except for the group name not being hidden on the roulette-type sections, so you can use GetHidden() on it.

--some of the stuff is updated in ScreenSelectMusic overlay
BMIIDX14Glob={
    SongTitles = {},
    GroupTitles = {},
    GroupSongNum = {},
    GroupSongNumDoubles = {},
    SongDiffs = {},
    MusicWheelList = {},
    CurDiff = 7,
    YouShouldChangeThatShitNOW = false
}
local StartIndex=nil
BMIIDX14Glob.AllSongs = SONGMAN:GetAllSongs()
BMIIDX14Glob.TotalSongNum = #BMIIDX14Glob.AllSongs

function GetDiffList(songg)
    --this is used as the index of the DiffList: https://craftedcart.gitlab.io/notitg_docs/lua_api/enumerations.html#difficulty
    --If a song has charts at Easy 1, Medium 3, Challenge 8, Hard (Doubles) 10, then its DiffList will be
    --{1 = 1, 2 = 3, 4 = 8, 13 = 10}
    --GetStepsByStepsType only shows unlocked difficulties, and that's what we want.
    local StepsList = songg:GetStepsByStepsType(0)
    local DoubleStepsList = songg:GetStepsByStepsType(1)
    local DiffList = {}
    for index, steps in ipairs(StepsList) do
        DiffList[steps:GetDifficulty()] = steps:GetMeter()
    end
    for index, steps in ipairs(DoubleStepsList) do
        DiffList[steps:GetDifficulty()+10] = steps:GetMeter()
    end
    return DiffList
end

--from a Song, get a string that combines its MainTitle, SubTitle and the Artist, separated by a space.
--I call this LongTitle. It will be what we use to compare with the LongTitles we grabbed from the music wheel.
--though the MainTitle, SubTitle and Artist can each be in Display (native language) form or Translit form.
--so this function will check all combinations of Display and Translit and store all possible LongTitles of the Song in a list
--we also make a version of it that also adds the Group name to the LongTitles, to compare better in Group sort mode.
function GetLongTitleList(songg)
    local MainT = {songg:GetDisplayMainTitle(), songg:GetTranslitMainTitle()}
    local SubT = {songg:GetDisplaySubTitle(), songg:GetTranslitSubTitle()}
    local ArtT = {songg:GetDisplayArtist(), songg:GetTranslitArtist()}
    local GroupName = songg:GetGroupName()
    local titlList = {}
    local titlListGroup = {}
    local seenTitls = {}
    
    --store all possible titles, and make sure there's no duplicates
    --make a version that has the group names at start as well
    for _, mT in ipairs(MainT) do
        for _, sT in ipairs(SubT) do
            for _, aT in ipairs(ArtT) do
                local LongTitl = mT .. " " .. sT .. " " .. aT
                if not seenTitls[LongTitl] then
                    table.insert(titlList, LongTitl)
                    table.insert(titlListGroup, GroupName .. " " .. LongTitl)
                    seenTitls[LongTitl] = true
                end
            end
        end
    end
    
    return {titlList, titlListGroup}
end

for index, songg in ipairs(BMIIDX14Glob.AllSongs) do
    --calculate all the song amounts each song folder (group) has
    --check if the song is locked or not with the new NotITG 4.9.0 feature as well
    --it can't detect songs being unlocked mid-session but whatever
    local GroupName = songg:GetGroupName()
    local StepsList = songg:GetStepsByStepsType(0)
    local DoubleStepsList = songg:GetStepsByStepsType(1)
    local IsSongUnlocked = (not FUCK_EXE) or (not UNLOCKMAN:SongIsLocked(songg))
    if IsSongUnlocked and StepsList and #StepsList > 0 then
        if not BMIIDX14Glob.GroupSongNum[GroupName] then
            BMIIDX14Glob.GroupSongNum[GroupName] = 1
        else
            BMIIDX14Glob.GroupSongNum[GroupName] = BMIIDX14Glob.GroupSongNum[GroupName] + 1
        end
    end
    if IsSongUnlocked and DoubleStepsList and #DoubleStepsList > 0 then
        if not BMIIDX14Glob.GroupSongNumDoubles[GroupName] then
            BMIIDX14Glob.GroupSongNumDoubles[GroupName] = 1
        else
            BMIIDX14Glob.GroupSongNumDoubles[GroupName] = BMIIDX14Glob.GroupSongNumDoubles[GroupName] + 1
        end
    end
    
    --Create a SongDiffs table that stores the DiffList of each song by MainTitle, Subtitle, and the Artist
    --Which is obviously flawed because some songs have the exact same MainTitle and SubTitle and Artist,
    --but the MusicWheel only contains those. Ass.
    local DiffList = GetDiffList(songg)
    
    --make sure DiffList is not an empty table
    if next(DiffList) ~= nil then
    
        local TitlList = GetLongTitleList(songg)
        --So currently I implemented two shitty ways to differentiate duplicates.
        --One is to add a number behind the name of the duplicate songs, then when called just list the duplicates in order.
        --This will solve it when both the duplicates appear in one folder, like with the Title sort.
        --Though the order of MusicWheel is also really ass with all the looping back to 1 thing, so the StartPoint thing has to be implemented.
        --Two is if the sort mode is Group, then add the GroupName at the start for more accuracy (TitlType 2).
        for TitlType=1,#TitlList do
            for ind=1,#TitlList[TitlType] do
                local keytitl = TitlList[TitlType][ind]
                if BMIIDX14Glob.SongDiffs[keytitl] then
                    local n = 2
                    while BMIIDX14Glob.SongDiffs[TitlList[TitlType][ind] .. n] do
                        n = n + 1
                    end
                    keytitl = TitlList[TitlType][ind] .. n
                end
                BMIIDX14Glob.SongDiffs[keytitl] = DiffList
            end
        end
    end
end

--these are only for getting stuff from the music wheel
--this one gives the Subtitle of the MusicWheelItem at the specified index
function GetWheelSubtitle(ind)
    if not BMIIDX14Glob.MusicWheelList[ind] then
        return ''
    end
    return BMIIDX14Glob.MusicWheelList[ind]:GetChildAt(8):GetChild('Subtitle'):GetText()
end

--gives the LongTitle of the MusicWheelItem at the specified index
--e.g. GetWheelLongTitle(CurWheelIndex()) in console gives you the LongTitle of the current selected song on the wheel
--BMIIDX14Glob.SongDiffs[GetWheelLongTitle(CurWheelIndex())] gives you the DiffList of that song
function GetWheelLongTitle(index)
    if not (BMIIDX14Glob.SongTitles and BMIIDX14Glob.ArtistTitles) then
        return ''
    end
    return (BMIIDX14Glob.SongTitles[index] or '').." "..GetWheelSubtitle(index).." "..(BMIIDX14Glob.ArtistTitles[index] or '')
end

--check whether the MusicWheelItem at the specified index is roulette-type
function IsRoulette(ind)
    if not BMIIDX14Glob.MusicWheelList[ind] then
        return false
    end
    return (not BMIIDX14Glob.MusicWheelList[ind]:GetChildAt(10):GetHidden()) and (not BMIIDX14Glob.MusicWheelList[(ind % #BMIIDX14Glob.MusicWheelList)+1]:GetChildAt(10):GetHidden())
end

--so since the TextBanner only lets you use one font, I had to resort to... this
--check the [lv] section of TextBanner text in the Fonts folder and you'll see how this converts to a diff number
--it successfully splits up here so it should recognize them as separate characters
--https://earthlingsoft.net/unicode/split-up
function DiffMeterConvert(diff)
    if not diff then return '' end
    diff = tostring(diff)
    local symbolMap = {
        ["0"] = "𓀐",
        ["1"] = "🍑",
        ["2"] = "😎",
        ["3"] = "🥵",
        ["4"] = "✊",
        ["5"] = "👉",
        ["6"] = "👌",
        ["7"] = "💦",
        ["8"] = "😩",
        ["9"] = "💥"
    }
    return string.gsub(diff, ".", function(char)
        return symbolMap[char] or char
    end)
end

--check to see if the Artist has not been changed to a diff number (corrupted)
function ArtistCorrupted(str)
    if str == '' then return true end
    local chars = {"𓀐","🍑","😎","🥵","✊","👉","👌","💦","😩","💥"}
    for i = 1, table.getn(chars) do
        if string.find(str, chars[i], 1, true) then
            return true
        end
    end
    return false
end

--where the diff numbers on wheel magic begins
function UpdateWheelTitles(FirstUpdate)
    if not FUCK_EXE then return end
    if GAMESTATE:IsCourseMode() or (not SCREENMAN:GetTopScreen():GetChild('MusicWheel')) then
        BMIIDX14Glob.MusicWheelList = {}
        return
    end
    --some of the stuff is defined in ScreenSelectMusic overlay, depending on when I want it to reset
    BMIIDX14Glob.SongTitles={}
    BMIIDX14Glob.GroupTitles={}
    local UsedTitles={}
    
    local CSong = GAMESTATE:GetCurrentSong()
    
    --modulo loops my beloved
    --go from StartIndex to #MusicWheelList, then go back to 1 to StartIndex-1
    local Count = #BMIIDX14Glob.MusicWheelList
    local StartIndex = FindStartPoint()
    for i = 0, Count - 1 do
        if Count == 0 then return end
        local index = ((StartIndex - 1 + i) % Count) + 1
        local item = BMIIDX14Glob.MusicWheelList[index]
        
        --grab the titles and subtitles on the music wheel and store them in their corresponding tables
        BMIIDX14Glob.SongTitles[index] = item:GetChildAt(8):GetChild('Title'):GetText()
        BMIIDX14Glob.GroupTitles[index] = item:GetChildAt(9):GetText()

        -- if the Artist has not been changed to a diff number (corrupted), put it in ArtistTitles
        local ArtistDisp = item:GetChildAt(8):GetChild('Artist')
        if not ArtistCorrupted(ArtistDisp:GetText()) then
            BMIIDX14Glob.ArtistTitles[index] = ArtistDisp:GetText()
        end
        
        if BMIIDX14Glob.ArtistTitles[index] then
            --assemble the full title
            local FullTitl = GetWheelLongTitle(index)
            --if the sort order is Group, add the Group name in front
            if CSong and GAMESTATE:GetSortOrder() == 1 then
                FullTitl = CSong:GetGroupName().." "..GetWheelLongTitle(index)
            end
            
            --if the title was used before, and the next duplicate of that title actually has a SongDiffs table,
            --check that next duplicate (add a number behind the title, and keep increasing that number)
            --do this until an unused title is found
            local KeyTitl = FullTitl
            local SDff = BMIIDX14Glob.SongDiffs
            if UsedTitles[KeyTitl] or (not IsHaveSongDiffOfCurrentMode(SDff[KeyTitl])) then
                local n = 2
                while UsedTitles[FullTitl .. n] and IsHaveSongDiffOfCurrentMode(SDff[FullTitl .. n+1]) do
                    n = n + 1
                end
                if IsHaveSongDiffOfCurrentMode(SDff[FullTitl .. n]) then
                    KeyTitl = FullTitl .. n
                else
                    KeyTitl = FullTitl
                end
            end
            
            if FirstUpdate and index == 11 then
                --this is ONLY activated when the ScreenSelectMusic screen is first initiated,
                --so the wheel index of the currently selected song is guaranteed to be 11, not affected by scrolling anims.
                UpdateDiffOfCSong(KeyTitl)
            end
            
            --grab the song's diff table
            local SonggDiff = BMIIDX14Glob.SongDiffs[KeyTitl]
            UsedTitles[KeyTitl] = true

            
            -- change the Artist to a diff number
            if SonggDiff and item:GetChildAt(8):GetChild('Artist') ~= '' then
                local ClosestDiff = GetClosestDiff(SonggDiff, BMIIDX14Glob.CurDiff)
                BMIIDX14Glob.DiffNumTitles[index] = DiffMeterConvert(SonggDiff[ClosestDiff])
                if not ClosestDiff then
                    ClosestDiff = BMIIDX14Glob.CurDiff
                end
                if GAMESTATE:PlayerUsingBothSides() then
                    ClosestDiff = ClosestDiff - 10
                end
                ArtistDisp:settext( BMIIDX14Glob.DiffNumTitles[index] )
                DiffuseDifficultyTopGradient(ArtistDisp, ClosestDiff)
                DiffuseDifficultyBottomGradient(ArtistDisp, ClosestDiff)
                ArtistDisp:zoom(1)
            end
        end
    end
end

function CurWheelIndex()
    --so as far as I can tell there's no way to tell which MusicWheelItem is the selected one, other than it being the one with Y = 0
    --but lo and behold, scrolling animations exist which mess up all the Y coordinates grrrrr
    --so this will just be returning the index with the smallest absolute Y position, aka smallest abs
    --which means, avoid detecting with this immediately when switching songs
    local smallestAbs = 999
    local returnInd = 1
    for index, item in ipairs(BMIIDX14Glob.MusicWheelList) do
        local ypos = item:GetY()
        if math.abs(ypos) < smallestAbs then
            returnInd = index
            smallestAbs = math.abs(ypos)
        end
    end
    return returnInd
end

--SonggDiff is the DiffList of a song.
--Get the difficulty slot closest to CDiff if SonggDiff[CDiff] doesn't exist
function GetClosestDiff(SonggDiff, CDiff)
    local doub = GAMESTATE:PlayerUsingBothSides()
    --if it's Doubles mode
    if doub then
        CDiff = CDiff + 10
    end
    if SonggDiff[CDiff] == nil then
        local BestDiff = nil
        local BestDistance = 999

        for i = (doub and 10 or 0), (doub and 15 or 5) do
            if SonggDiff[i] ~= nil then
                local Distance = math.abs(i - CDiff)

                if Distance < BestDistance then
                    BestDistance = Distance
                    BestDiff = i
                end
            end
        end

        return BestDiff
    end
    return CDiff
end

function IsHaveSongDiffOfCurrentMode(SonggDiff)
    if not SonggDiff then
        return false
    end
    local doub = GAMESTATE:PlayerUsingBothSides()
    for i = (doub and 10 or 0), (doub and 15 or 5) do
        if SonggDiff[i] ~= nil then
            return true
        end
    end
    return false
end

--So as mentioned above, all the duplicates need to be in order.
--Normally, it is already in order (alphabetical based on the directory name) in both SONGMAN:GetAllSongs() and MusicWheel,
--(Well not exactly, there's stuff like Anzu no Uta and Anzu no Uta (U.P.S.) having different order in MusicWheel compared to SONGMAN:GetAllSongs()
--but I don't want to care about that)
--except for this situation:

--1  Mirin Template
--2  Mirin Template
--3  Blacksphere
--...

--...
--18 Warriors Aboot
--19 Mirin Template
--20 Mirin Template
--21 Mirin Template

--In this situation the UpdateWheelTitles needs to start from index 19, go to 21, then loop back to 1 and go to 18.
--This function checks if the first and last titles are the same. If they aren't just return 1.
--If they are then check from the bottom for where that bunch of duplicates started.
function FindStartPoint()
    local FirstTitl = GetWheelLongTitle(1)
    local LastTitl = GetWheelLongTitle(#BMIIDX14Glob.MusicWheelList)
    if FirstTitl ~= LastTitl then
        return 1
    end
    
    local StartPt = #BMIIDX14Glob.MusicWheelList
    while StartPt > 1 and GetWheelLongTitle(StartPt-1) == FirstTitl do
        StartPt = StartPt - 1
    end
    return StartPt
end

function UpdateDiffOfCSong(KeyTitl)
    local CSong = GAMESTATE:GetCurrentSong()
    if CSong then
        --if it matches, and there's no information about one of the difficulties, then it's probably a new difficulty
        --that the player unlocked. If that's the case, update the SongDiffs.
        local SonggDiff = BMIIDX14Glob.SongDiffs[KeyTitl]
        local DList = GetDiffList(CSong)
        if next(DList) ~= nil then
            for ind,val in pairs(DList) do
                if DList[ind] and (not SonggDiff[ind]) then
                    BMIIDX14Glob.SongDiffs[KeyTitl][ind] = DList[ind]
                end
            end
        end
    end
end