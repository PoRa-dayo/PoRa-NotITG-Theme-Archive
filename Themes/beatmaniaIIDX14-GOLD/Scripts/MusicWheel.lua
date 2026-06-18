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
SongTitles={}
GroupTitles={}
RouletteTitles={}
GroupSongNum={}
SongDiffs={}
MusicWheelList={}
StartIndex=nil
Rand=1
AllSongs = SONGMAN:GetAllSongs()
TotalSongNum = #AllSongs
CurDiff = 7

for index, songg in ipairs(AllSongs) do
    --calculate all the song amounts each song folder (group) has
    --obviously this is sometimes wrong because of all those hidden songs but whatever
    local GroupName = songg:GetGroupName()
    if not GroupSongNum[GroupName] then
        GroupSongNum[GroupName] = 1
    else
        GroupSongNum[GroupName] = GroupSongNum[GroupName] + 1
    end
    
    --GetStepsByStepsType only shows unlocked difficulties, and that's what we want.
    --Create a DiffList that stores all the difficulties of each song by MainTitle, Subtitle, and the Artist
    --Which is obviously flawed because some songs have the exact same MainTitle and SubTitle and Artist,
    --but the MusicWheel only contains those. Ass.
    local StepsList = songg:GetStepsByStepsType(0)
    local DiffList = {}
    for index, steps in ipairs(StepsList) do
        DiffList[steps:GetDifficulty()] = steps:GetMeter()
    end
    --make sure DiffList is not an empty table
    if next(DiffList) ~= nil then
        --fun
        local titl = {}
        titl[1] = songg:GetDisplayMainTitle().." "..songg:GetDisplaySubTitle().." "..songg:GetTranslitArtist()
        titl[2] = songg:GetDisplayMainTitle().." "..songg:GetDisplaySubTitle().." "..songg:GetDisplayArtist()
        titl[3] = songg:GetTranslitMainTitle().." "..songg:GetDisplaySubTitle().." "..songg:GetDisplayArtist()
        titl[4] = songg:GetTranslitMainTitle().." "..songg:GetDisplaySubTitle().." "..songg:GetTranslitArtist()
        titl[5] = GroupName..' '..songg:GetDisplayMainTitle().." "..songg:GetDisplaySubTitle().." "..songg:GetDisplayArtist()
        titl[6] = GroupName..' '..songg:GetDisplayMainTitle().." "..songg:GetDisplaySubTitle().." "..songg:GetTranslitArtist()
        titl[7] = GroupName..' '..songg:GetTranslitMainTitle().." "..songg:GetDisplaySubTitle().." "..songg:GetTranslitArtist()
        titl[8] = GroupName..' '..songg:GetTranslitMainTitle().." "..songg:GetDisplaySubTitle().." "..songg:GetDisplayArtist()
        --So currently I implemented two shitty ways to differentiate duplicates.
        --One is to add a number behind the name of the duplicate songs, then when called just list the duplicates in order.
        --This will solve it when both the duplicates appear in one folder, like with the Title sort.
        --Though the order of MusicWheel is also really ass with all the looping back to 1 thing, so the StartPoint thing has to be implemented.
        --Two is if the sort mode is Group, then add the GroupName at the start for more accuracy.
        for ind=1,8 do
            --make sure to skip the fully duplicate titles
            if not (
                (ind >= 2 and ind <= 4 and titl[ind] == titl[1]) or
                (ind >= 6 and ind <= 8 and titl[ind] == titl[5])
            ) then
                local keytitl = titl[ind]
                if SongDiffs[keytitl] then
                    local n = 2
                    while SongDiffs[titl[ind] .. n] do
                        n = n + 1
                    end
                    keytitl = titl[ind] .. n
                end
                SongDiffs[keytitl] = DiffList
            end
        end
    end
end

function GetSubtitle(ind)
    if not MusicWheelList[ind] then
        return ''
    end
    return MusicWheelList[ind]:GetChildAt(8):GetChild('Subtitle'):GetText()
end

function GetLongTitle(index)
    if not (SongTitles and ArtistTitles) then
        return ''
    end
    return (SongTitles[index] or '').." "..GetSubtitle(index).." "..(ArtistTitles[index] or '')
end

function IsRoulette(ind)
    if not MusicWheelList[ind] then
        return false
    end
    return (not MusicWheelList[ind]:GetChildAt(10):GetHidden()) and (not MusicWheelList[(ind % #MusicWheelList)+1]:GetChildAt(10):GetHidden())
end

--so since the TextBanner only lets you use one font, I had to resort to... this
--it successfully splits up here so
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

function UpdateWheelTitles()
    if not FUCK_EXE then return end
    if GAMESTATE:IsCourseMode() then return end
    --some of the stuff is defined in ScreenSelectMusic overlay, depending on when I want it to reset
    SongTitles={}
    GroupTitles={}
    UsedTitles={}
    RouletteTitles={}
    --modulo loops my beloved
    --go from StartIndex to #MusicWheelList, then go back to 1 to StartIndex-1
    local CSong = GAMESTATE:GetCurrentSong()
    if not CSong then StartIndex = nil end
    local Count = #MusicWheelList
    local StartIndex = FindStartPoint()
    for i = 0, Count - 1 do
        if Count == 0 then return end
        local index = ((StartIndex - 1 + i) % Count) + 1
        local item = MusicWheelList[index]
        
        --grab the titles and subtitles and store them in their corresponding tables
        SongTitles[index] = item:GetChildAt(8):GetChild('Title'):GetText()
        GroupTitles[index] = item:GetChildAt(9):GetText()
        RouletteTitles[index] = item:GetChildAt(10):GetText()

        -- if the Artist has not been changed to a diff number (corrupted), put it in ArtistTitles
        local ArtistDisp = item:GetChildAt(8):GetChild('Artist')
        if not ArtistCorrupted(ArtistDisp:GetText()) then
            ArtistTitles[index] = ArtistDisp:GetText()
        end
        
        if ArtistTitles[index] then
            --assemble the full title
            local FullTitl = GetLongTitle(index)
            if CSong and GAMESTATE:GetSortOrder() == 1 then
                FullTitl = CSong:GetGroupName().." "..GetLongTitle(index)
            end
            
            --if the title was used before, add a number behind the title
            local KeyTitl = FullTitl
            if UsedTitles[KeyTitl] then
                local n = 2
                while UsedTitles[FullTitl .. n] and SongDiffs[FullTitl .. n] do
                    n = n + 1
                end
                if SongDiffs[FullTitl .. n] then
                    KeyTitl = FullTitl .. n
                else
                    KeyTitl = FullTitl
                end
            end

            --grab the song's diff table
            local SonggDiff = SongDiffs[KeyTitl]
            UsedTitles[KeyTitl] = true

            
            -- change the Artist to a diff number
            if SonggDiff and item:GetChildAt(8):GetChild('Artist') ~= '' then
                local ClosestDiff = GetClosestDiff(SonggDiff, CurDiff)
                DiffNumTitles[index] = DiffMeterConvert(SonggDiff[ClosestDiff])
                ArtistDisp:settext( DiffNumTitles[index] )
                local ColorStr = DifficultyColor(ClosestDiff)
                local tb = {}
                for v in string.gfind(ColorStr, "[^,]+") do
                    tb[#tb + 1] = tonumber(v)
                end
                ArtistDisp:diffuse(unpack(tb))
                ArtistDisp:zoom(1)
            end
        end
    end
end

function CurWheelIndex()
    --so as far as I can tell there's no way to tell which MusicWheelItem is the selected one, other than it being the one with Y = 0
    --but lo and behold, scrolling animations exist which mess up all the Y coordinates grrrrr
    --so this will just be returning the one with the smallest absolute Y position, aka smallest abs
    local smallestAbs = 999
    local returnInd = 1
    for index, item in ipairs(MusicWheelList) do
        local ypos = item:GetY()
        if math.abs(ypos) < smallestAbs then
            returnInd = index
            smallestAbs = math.abs(ypos)
        end
    end
    return returnInd
end

--get the difficulty slot closest to CurDiff if SonggDiff[CurDiff] doesn't exist
function GetClosestDiff(SonggDiff, CurDiff)
    if SonggDiff[CurDiff] == nil then
        local BestDiff = nil
        local BestDistance = 999

        for i = 0, 5 do
            if SonggDiff[i] ~= nil then
                local Distance = math.abs(i - CurDiff)

                if Distance < BestDistance then
                    BestDistance = Distance
                    BestDiff = i
                end
            end
        end

        return BestDiff
    end
    return CurDiff
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
    local FirstTitl = GetLongTitle(1)
    local LastTitl = GetLongTitle(#MusicWheelList)
    if FirstTitl ~= LastTitl then
        return 1
    end
    
    local StartPt = #MusicWheelList
    while StartPt > 1 and GetLongTitle(StartPt-1) == FirstTitl do
        StartPt = StartPt - 1
    end
    return StartPt
end