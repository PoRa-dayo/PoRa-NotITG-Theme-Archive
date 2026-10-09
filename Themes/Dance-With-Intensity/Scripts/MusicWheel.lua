--So this is simpler than the MusicWheel.lua over at the Beatmania IIDX Gold theme
--because I only need to check for amount of songs in a group.
--The difference is the song amount has to be attached to the MusicWheelItem itself.
--Once again the music wheel is first captured in metrics.ini
--And then UpdateWheelTitles is controlled via metrics.ini and ScreenSelectMusic overlay.
DWIGlobVar={
    SongTitles = {},
    GroupTitles = {},
    GroupSongNum = {},
    GroupSongNumDoubles = {},
    MusicWheelList = {},
    YouShouldChangeThatShitNOW = false
}
DWIGlobVar.AllSongs = SONGMAN:GetAllSongs()
DWIGlobVar.TotalSongNum = #DWIGlobVar.AllSongs

for index, songg in ipairs(DWIGlobVar.AllSongs) do
    --calculate all the song amounts each song folder (group) has
    --check if the song is locked or not with the new NotITG 4.9.0 feature as well
    --it can't detect songs being unlocked mid-session but whatever
    local GroupName = songg:GetGroupName()
    local StepsList = songg:GetStepsByStepsType(0)
    local DoubleStepsList = songg:GetStepsByStepsType(1)
    local IsSongUnlocked = (not FUCK_EXE) or (not UNLOCKMAN:SongIsLocked(songg))
    if IsSongUnlocked and StepsList and #StepsList > 0 then
        if not DWIGlobVar.GroupSongNum[GroupName] then
            DWIGlobVar.GroupSongNum[GroupName] = 1
        else
            DWIGlobVar.GroupSongNum[GroupName] = DWIGlobVar.GroupSongNum[GroupName] + 1
        end
    end
    if IsSongUnlocked and DoubleStepsList and #DoubleStepsList > 0 then
        if not DWIGlobVar.GroupSongNumDoubles[GroupName] then
            DWIGlobVar.GroupSongNumDoubles[GroupName] = 1
        else
            DWIGlobVar.GroupSongNumDoubles[GroupName] = DWIGlobVar.GroupSongNumDoubles[GroupName] + 1
        end
    end
    
end

--where the song amount on wheel magic begins
function UpdateWheelTitles()
    if not FUCK_EXE then return end
    if GAMESTATE:IsCourseMode() or (not SCREENMAN:GetTopScreen():GetChild('MusicWheel')) then
        DWIGlobVar.MusicWheelList = {}
        return
    end
    DWIGlobVar.GroupTitles={}
    
    local Count = #DWIGlobVar.MusicWheelList
    for i = 1, Count do
        local item = DWIGlobVar.MusicWheelList[i]
        
        DWIGlobVar.GroupTitles[i] = item:GetChildAt(9):GetText()
        local TitlStr = DWIGlobVar.GroupTitles[i];
        --SongNameEle contains Title, Subtitle and Artist. A section also has these, it's just hidden.
        --So to display the song amount in a section, we just unhide its SongNameEle and change the text of the Artist.
        --We'll also use the Title from SongNameEle to display the section name instead, and hide the original section name element.
        --The original section name element will now just be used to grab the color for the MusicWheelItem section/expanded to use.
        local SongNameEle = item:GetChildAt(8)
        local SectionNameEle = item:GetChildAt(9)
        local RouletteNameEle = item:GetChildAt(10)
        local ArtistEle = SongNameEle:GetChild('Artist')
        local TitleEle = SongNameEle:GetChild('Title')
        local SongNum = GAMESTATE:PlayerUsingBothSides() and DWIGlobVar.GroupSongNumDoubles[TitlStr] or DWIGlobVar.GroupSongNum[TitlStr]
        local SectionR,SectionG,SectionB,SectionA = 1,1,1,1
        
        --check if the WheelItem at i is a normal section
        if TitlStr and TitlStr ~= '' and (not SectionNameEle:GetHidden()) then
            --the section field will now only be used to grab the color
            SectionR,SectionG,SectionB,SectionA = SectionNameEle:getdiffuse()
            if SongNum then
                --if song amount exists, add the song amount at the Artist field
                ArtistEle:settext('('..SongNum.. (SongNum == 1 and ' song)' or ' songs)') )
                ArtistEle:zoom(0.6)
                ArtistEle:y(10)
                --change the song amount's color, because by default it will follow the colors in [SongManager] over at metrics.ini
                ArtistEle:diffuse(1,1,0.5,1)
                
                TitleEle:y(-8)
            else
                ArtistEle:settext('')
                TitleEle:y(0)
            end
            SongNameEle:GetChild('Subtitle'):settext('')
            
            --move the section name to the Title field
            TitleEle:settext(TitlStr)
            TitleEle:zoom(0.9)
            TitleEle:maxwidth(350)
            TitleEle:horizalign('left')
            --change the section name's color, because by default it will follow the colors in [SongManager] over at metrics.ini
            TitleEle:diffuse(1,1,0.5,1)
            
            --remove the section name from the old section field
            SectionNameEle:settext('')
            
            SongNameEle:hidden(0)
            --use the color of the old section that follows [SongManager] to diffuse the MusicWheelItem section
            item:GetChildAt(3):diffuse(SectionR,SectionG,SectionB,SectionA)
            --and the MusicWheelItem expanded
            item:GetChildAt(4):diffuse(SectionR,SectionG,SectionB,SectionA)
            
        elseif SectionNameEle:GetHidden() and (not RouletteNameEle:GetHidden()) then
            --don't diffuse the Roulette section
            item:GetChildAt(3):diffuse(1,1,1,1)
        end
        
        --MusicWheelItem song must be visible for all MusicWheelItems
        item:GetChildAt(2):hidden(0)
    end
    --CurrentSongChanged is not activated when the player opens a group, and this stupid program offers no way to detect that
    --So I have to keep repeating UpdateWheelTitles in the case GetCurrentSong is not found
    if not GAMESTATE:GetCurrentSong() then
        return 'Repeat'
    end
end

--not actually used here but I keep it because it's helpful for debugging via console
function CurWheelIndex()
    --so as far as I can tell there's no way to tell which MusicWheelItem is the selected one, other than it being the one with Y = 0
    --but lo and behold, scrolling animations exist which mess up all the Y coordinates grrrrr
    --so this will just be returning the index with the smallest absolute Y position, aka smallest abs
    --which means, avoid detecting with this immediately when switching songs
    local smallestAbs = 999
    local returnInd = 1
    for index, item in ipairs(DWIGlobVar.MusicWheelList) do
        local ypos = item:GetY()
        if math.abs(ypos) < smallestAbs then
            returnInd = index
            smallestAbs = math.abs(ypos)
        end
    end
    return returnInd
end