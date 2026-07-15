ToHoSokuGlob = {}


function Sound(str) SOUND:PlayOnce( Path("sounds",str )) end
function Path(ec,str) return THEME:GetPath( _G['EC_'..string.upper(ec)] , '' , str ) end


---------------------------------------------
-- NOTESKIN AND JUDGMENT LIST INITIALIZATION
---------------------------------------------

-- Judgment Font List
judgmentFontList = { 'Bebas2', 'Chromatic', 'Code2', 'Comic Sans2', 'Deco', 'DDR A', 'DDR Extreme', 'ECFA', 'ECFA No Quotes', 'Emoji', 'FP', 'GrooveNights', 'ITG2', 'Japanese', 'Lobster2', 'Love', 'Love Chroma', 'Miso2', 'mute', 'Optimus Dark', 'Rainbowmatic', 'Roboto', 'Roboto ITG', 'Tactics', 'VHS', 'Vision', 'Vision Dark', 'Wendy2' }
if FUCK_EXE then -- Auto load on NotITG
    local list = { 'Default' }
    
    local dir = string.sub(THEME:GetPath(2,'','_blank.png'),9)
    dir = string.sub(dir,1,string.find(dir,'/')-1)
    for _,v in pairs({ GAMESTATE:GetFileStructure('Themes/'.. dir ..'/Graphics/_Judgments/') }) do
        local t, _, name = string.find(v, "(.+) %dx%d")
        if t then table.insert( list, name )
        else print('[Judgment] Error in loading ' .. v)
        end
    end

    judgmentFontList = list
end

-- Hold Judgment List
holdJudgmentList = { 'Bebas', 'Code', 'Love', 'mute', 'None', 'Wendy' }
if FUCK_EXE then -- Auto load on NotITG
    local list = { 'Default' }
    
    local dir = string.sub(THEME:GetPath(2,'','_blank.png'),9)
    dir = string.sub(dir,1,string.find(dir,'/')-1)
    for _,v in pairs({ GAMESTATE:GetFileStructure('Themes/'.. dir ..'/Graphics/_HoldJudgments/') }) do
        local t, _, name = string.find(v, "(.+) %dx%d")
        if t then table.insert( list, name )
        else print('[Hold Judgment] Error in loading ' .. v)
        end
    end

    holdJudgmentList = list
end

--NoteSkin list
local noteskins = NOTESKIN:GetNoteSkinNames()
NoteSkinList = {}
local ind = 1
local blacklist = {'arrowkun', 'arrowkun-notweens', 'cel2d', 'cel-cmd', 'cel-cmd-notweens', 'cel-glow2', 'cel-yuno', 'coin', 'controlcel', 'controlmetal', 'controlmetal2', 'couples-cmd', 'couplescontrol', 'de-default', 'divinentity', 'dunno', 'dunno2', 'justholds', 'metal2_dpad', 'metal-cmd', 'metal-cmdholds', 'metal-cmd-notweens', 'mindcode', 'minderror', 'mindgalaxykiss', 'mindkickmetal', 'mindnoshow', 'mindpressure', 'mindrockstarmetal', 'mindstarsmetal', 'mindtechmetal', 'pixel', 'proxynotes', 'shape', 'slow', 'solid_black', 'spikes2', 'splitter', 'spt'}

for i, noteskin in ipairs(noteskins) do
    local name = string.lower(noteskin)
    local blacklisted = false
    for _, blackName in ipairs(blacklist) do
        if name == blackName then
            blacklisted = true
        end
    end
    if not blacklisted then
        NoteSkinList[ind] = name
        ind = ind+1
    end
end

-- find a noteskin listed in the DefaultModifiers string located in Data/GamePrefs.ini
function GetDefaultNoteSkinFromGamePrefsIni()
    -- if this function is called too early: as in there is no game style set (dance, pump, etc)
    -- the game will return the names of the directories of each noteskin, rather than a map of noteskin names
    -- there aren't many differences between the two, but the latter returns a list where all names are lowercased, and the former returns names capitalized as-is in the NoteSkins directory
    -- while these differences are small, it's enough to cause problems when looking through DefaultModifiers, since the casing might not match, and we cannot guarantee to receive a list of names lowercased by the game either
    -- which means we now need to take matters in our own hands and string.lower everything
    local noteskins = NOTESKIN:GetNoteSkinNames()
    for i, noteskin in ipairs(noteskins) do
        noteskins[i] = string.lower(noteskin)
    end
    local defaults = string.lower(PREFSMAN:GetPreference'DefaultModifiers')
    for str in string.gfind(defaults, '[^,]+') do
        local mod = string.gsub(str, " ", "")
        for i, noteskin in ipairs(noteskins) do
            if mod == noteskin then
                return noteskin
            end
        end
    end
    -- no noteskins present within DefaultModifiers, fall back onto a common noteskin
    return 'scalable'
end

modJudgmentFont = {1,1}
modHoldJudgment = {1,1}
modNoteSkin = {1,1}
local defaultSkin = GetDefaultNoteSkinFromGamePrefsIni()
--look for the player's current noteskin
for pn=0,1 do
    for modInd, modName in ipairs(NoteSkinList) do
        if modName == defaultSkin then
            modNoteSkin[pn+1] = modInd
        end
    end
end



---------------------------------------------
-- BGANIMATION SCREEN FUNCTIONS
---------------------------------------------

-- SCREEN SELECT MUSIC (and also ScreenEditMenu)
--<ActorFrame InitCommand="%SelectMusicInit" FirstUpdateCommand="%SelectMusic" CaptureCommand="%SongInfo" CurrentSongChangedMessageCommand="queuecommand,Capture" CurrentStepsP1ChangedMessageCommand="queuecommand,Capture" CurrentStepsP2ChangedMessageCommand="queuecommand,Capture" />
function SelectMusicInit(self) InitializeMods() ApplyRateAdjust() self:queuecommand('FirstUpdate') end
function SelectMusic(self) self:queuecommand('Capture') end

-- SCREEN EVALUATION
--<ActorFrame InitCommand="%EvaluationInit" FirstUpdateCommand="%Evaluation" />
function EvaluationInit(self) RevertRateAdjust() self:queuecommand('FirstUpdate') end
function Evaluation() end

-- SCREEN GAMEPLAY
-- <ActorFrame Command="%GameplayInit" FirstUpdateCommand="%Gameplay" UnknwonHoldMessageCommand="%HoldCheck" AssignHoldsCommand="%AssignHold"/>
function GameplayInit(self)	Combo = {} self:queuecommand('FirstUpdate') end
function Gameplay() JudgmentInit() end



---------------------------------------------
-- MOD CHANGING FUNCTIONS
---------------------------------------------

modRate = 1
--in this theme i set InitializeMods to activate the first time you open ScreenSelectMusic
--InitSpeedMod is also run every time the theme is opened/reloaded (check bottom of OptionsMenu.lua)
function InitializeMods()
	if GAMESTATE:GetEnv('Mods') and modType then return end
	modRate = 1
	InitSpeedMod()
	GAMESTATE:SetEnv('Mods',1)
end

function ApplyRateAdjust()
	for pn=1, 2 do
		if GAMESTATE:IsPlayerEnabled( pn - 1 ) then
			local AdjustedSpeed = string.gsub(modSpeed[pn],modType[pn],"")
			if modType[pn] == "x" then
                AdjustedSpeed = math.ceil(100*AdjustedSpeed/modRate)/100 .. "x"
            else
                AdjustedSpeed = modType[pn] .. math.ceil(AdjustedSpeed/modRate)
            end
			ApplyMod(AdjustedSpeed,pn)
            SetOptionRow(ToHoSokuGlob.SpeedModName,pn+1,DisplaySpeedMod(pn),pn)
		end
	end
end

function RevertRateAdjust()
	for pn=1, 2 do
		if modSpeed and modSpeed[pn] then
            ApplyMod(modSpeed[pn],pn)
        end
	end
end


function JudgmentInit()
	judgeP1 = {0,0,0,0,0,0,0,0,0}
	judgeP2 = {0,0,0,0,0,0,0,0,0}
	Holds = {}
	OK = {}
	NG = {}
    
    -- Apply judgments
	for pn=1,8 do
        local PL = SCREENMAN:GetTopScreen():GetChild('PlayerP'..pn)
        local k
        if PL then
            --Judgment font
            local PJudge = PL:GetChild('Judgment'):GetChild('')
            k = modJudgmentFont[pn%2 == 1 and 1 or 2]
            PJudge:aux(pn%2 == 1 and 1 or 2)
            
            if k ~= 1 then 
                PJudge:Load( THEME:GetPath( EC_GRAPHICS, '', '_Judgments/'..judgmentFontList[k] ))
            end
            
            --Hold judgment
            if FUCK_EXE then
                for col=0,15 do
                    local PHold = PL:GetChild('HoldJudgmentCol'..col):GetChild('')
                    k = modHoldJudgment[pn%2 == 1 and 1 or 2]
                    PHold:aux(pn%2 == 1 and 1 or 2)
                    
                    if k ~= 1 then 
                        PHold:Load( THEME:GetPath( EC_GRAPHICS, '', '_HoldJudgments/'..holdJudgmentList[k] ))
                    end
                end
            end
        end
    end
end



---------------------------------------------
-- CAPTURING FUNCTIONS
---------------------------------------------

function GetSongName()
	if GAMESTATE:GetCurrentCourse() then return GAMESTATE:GetCurrentCourse():GetDisplayFullTitle() end
	if GAMESTATE:GetCurrentSong() then return GAMESTATE:GetCurrentSong():GetDisplayMainTitle() end
	return ""
end

function IsType(a,t) return string.find(tostring(a),t) end

--capture BPM in the song select screen, or if it's NotITG just grab it from the BPM get functions
function CaptureBPM()
	bpm = {}
    local songg = GAMESTATE:GetCurrentSong()
    if FUCK_EXE and songg then
        bpm[1] = songg:GetMinBPM()
        local maxbpm = songg:GetMaxBPM()
        bpm[2] = maxbpm ~= bpm[1] and maxbpm or ''
    else
        local s = SCREENMAN:GetTopScreen():GetChild('BPMDisplay')
        if s then
            s = s:GetChild('Text'):GetText()
            bpm[1] = string.gsub(s,'^(-?%d+)-?[-%d]*$','%1')
            bpm[2] = string.gsub(s,'^'..bpm[1]..'%-?','')
        end
    end
end

--activated in ScreenPlayerOptions overlay and ScreenPlayerOptionsEdit overlay because it has to call AFTER all the elements have been rendered
--gives a OptionTextEle table that contains the BitmapText elements of all the option rows on the options screen
--and an OptionCursorEle that has the ActorFrames of the cursors
--and an OptionUnderlineEle that has the Underline sprites
--it's basically the same thing as Simply Love's Frame Capture
--this theme also uses a custom line highlight so no need to capture that here

--btw everything here except for OptionNumIndex absolutely needs to be cleared once you exit the corresponding option menu
--else the game will crash when accessing those tables as it contains elements that no longer exist,
--and will either give a "A BitmapText needs a font" error or an AV
function CaptureOptionRows()
    ToHoSokuGlob.OptionRows = {}
    ToHoSokuGlob.OptionTextEle = {}
    ToHoSokuGlob.OptionNumIndex = {}
    ToHoSokuGlob.OptionCursorEle = {{},{}}
    ToHoSokuGlob.OptionUnderlineEle = {}
    local optionInd = 0
    
    local cursorInd = 0
    local cursorFramePn = 1
    local cursorPn = 1
    
    local underlineInd = 0
    local underlineFramePn = 1
    local underlinePn = 1
    local FrameEle = SCREENMAN:GetTopScreen():GetChild('Frame')
    --holy shit propagate is confusing
    --so FrameEle here has like twenty something children,
    --the first ones each have like 3 grandchildren of their own, while the rest only have 1 grandchild each
    --all of FrameEle's children will call GiveChildren, IN ORDER BASED ON THEIR ACTORFRAME INDEX
    FrameEle:propagate(1)
    FrameEle:addcommand('FrameGiveChildren',function(self)
        --pick the children with 1 grandchild cuz those are the option rows
        if IsType(self,'ActorFrame') and self:GetNumChildren() == 1 then
            local OptionRow = self
            --grab that 1 grandchild
            local OptionRowEle = self:GetChild('')
            if IsType(OptionRowEle,'ActorFrame') then
                OptionRowEle:propagate(1)
                
                --and make that grandchild give its components as well.
                local ModName
                OptionRowEle:addcommand('RowGiveChildren',function(self)
                    if IsType(self,'BitmapText') then
                        --first bitmaptext found in each OptionRowEle is the mod name, I want to use that as the index
                        --(so it's easier to view in console lol)
                        if not ModName then
                            ModName = self:GetText()
                            ToHoSokuGlob.OptionTextEle[ModName] = {}
                            ToHoSokuGlob.OptionRows[ModName] = OptionRow
                            
                            --and so i store the number index in another table
                            optionInd = optionInd +1
                            ToHoSokuGlob.OptionNumIndex[ModName] = optionInd
                            
                            --save stuff related to the speed mod in variables that we can use later
                            if string.find(ModName, "^(Speed %()") then
                                ToHoSokuGlob.SpeedModName = ModName
                                
                                local s = ModName
                                bpm = {}
                                s = string.sub(s,8,string.len(s)-1)
                                bpm[1] = string.gsub(s,'^(-?%d+)-?[-%d]*$','%1')
                                bpm[2] = string.gsub(s,'^'..bpm[1]..'%-?','')
                            elseif ModName == 'Speed' then
                                ToHoSokuGlob.SpeedModName = ModName
                                bpm[1] = ''
                                bpm[2] = ''
                            end
                        end
                        --now for each index we have a bunch of BitmapText we can mess with
                        --note that the bitmaptext of the mod name itself is at index 1
                        table.insert(ToHoSokuGlob.OptionTextEle[ModName],self)
                        
                    elseif IsType(self,'ActorFrame') and self:GetNumChildren() == 3 then
                        underlineInd = 0
                        underlinePn = 1
                        --inside each OptionRowEle, the ActorFrames with 3 children are the underlines
                        --here the mod name is also used as the index
                        --and inside each mod name, the player number is the index
                        local UnderlineFrame = self
                        if not ToHoSokuGlob.OptionUnderlineEle[ModName] then
                            ToHoSokuGlob.OptionUnderlineEle[ModName] = {{},{}}
                        end
                        --for each player, the ActorFrame itself is placed at index 1
                        table.insert(ToHoSokuGlob.OptionUnderlineEle[ModName][underlineFramePn],UnderlineFrame)
                        underlineFramePn = underlineFramePn == 1 and 2 or 1
                        UnderlineFrame:propagate(1)
                        
                        --for index 2 onwards we place the ActorFrame's children
                        UnderlineFrame:addcommand('UnderlineGiveChildren',function(self)
                            underlineInd = underlineInd +1
                            table.insert(ToHoSokuGlob.OptionUnderlineEle[ModName][underlinePn],self)
                            if underlineInd >= 3 then underlinePn = 2 end
                        end)
                        UnderlineFrame:queuecommand('UnderlineGiveChildren')
                    end
                    
                end)
                
                OptionRowEle:queuecommand('RowGiveChildren')
            end
            
        --also grab the ones with 3 grandchildren cuz those are the cursors
        --here the index will be the player number
        elseif IsType(self,'ActorFrame') and self:GetNumChildren() == 3 then
            --for each player, the ActorFrame itself is placed at index 1
            table.insert(ToHoSokuGlob.OptionCursorEle[cursorFramePn],self)
            cursorFramePn = cursorFramePn == 1 and 2 or 1
            self:propagate(1)
            
            --for index 2 onwards we place the ActorFrame's children
            self:addcommand('CursorGiveChildren',function(self)
                cursorInd = cursorInd +1
                table.insert(ToHoSokuGlob.OptionCursorEle[cursorPn],self)
                if cursorInd >= 3 then cursorPn = 2 end
            end)
            
            self:queuecommand('CursorGiveChildren')
        end
    end)
    FrameEle:queuecommand('FrameGiveChildren')
end

function ClearOptionCaptures()
    ToHoSokuGlob.OptionTextEle = nil
    ToHoSokuGlob.OptionCursorEle = nil
    ToHoSokuGlob.OptionRows = nil
    ToHoSokuGlob.OptionUnderlineEle = nil
end

--what to do right after the capturing above
function PostModCaptureInit()
    SetOptionRow(ToHoSokuGlob.SpeedModName,2,DisplaySpeedMod(1),1)
    SetOptionRow(ToHoSokuGlob.SpeedModName,3,DisplaySpeedMod(2),2)
end



---------------------------------------------
-- BPM FORMAT AND DISPLAY FUNCTIONS
---------------------------------------------

function BPMlabelRate(self)
    if not bpm then return RateModText() end
    local s = AdjustedBPM() .. ' BPM ' .. RateModAppend()
    if self then self:settext(s) else return s end
end
function BPMandRate(self)
    if not bpm then return RateModText() end
    local s = AdjustedBPM() .. ' ' .. RateModAppend()
    if self then self:settext(s) else return s end
end
function RateBPMlabel(self)
    if not bpm then return RateModText() end
    local s = RateModText()
    if s ~= '' then s = s .. ' (' .. AdjustedBPM() .. ' BPM)' end
    if self then self:settext(s) else return s end
end   


function RateModText(self)
    local s = ''
    if modRate ~= 1 then s = modRate .. 'x Music Rate' end
    if self then self:settext(s) else return s end
end
function RateModAppend(self)
    local s = RateModText()
    if s ~= '' then s = '(' .. s .. ')' end
    if self then self:settext(s) else return s end
end


function AdjustedBPM(self)
	local s = bpm[1]
	if tonumber(s) then
		s = math.floor(bpm[1] * modRate + 0.5)
		if tonumber(bpm[2]) then s = s .. '-' .. math.floor(bpm[2] * modRate + 0.5) end
	end
	if self then self:settext(s) else return s end
end   

--update the BPM counter during gameplay
function GameplayBPM(self)
	local GameBpm = SCREENMAN:GetTopScreen():GetChild('BPMDisplay'):GetChild('Text'):GetText()
	-- if not OPENITG then GameBpm[3] = math.floor(GameBpm[3] * modRate + 0.5) end
	GameBpm = math.floor(GameBpm * modRate + 0.5)
	self:settext(GameBpm)
	self:sleep(.05)
	self:queuecommand('Update')
end

