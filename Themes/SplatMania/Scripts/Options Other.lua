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


-- BGAnimation Screen Functions

-- SCREEN SELECT MUSIC
--<ActorFrame InitCommand="%SelectMusicInit" FirstUpdateCommand="%SelectMusic" CaptureCommand="%SongInfo" CurrentSongChangedMessageCommand="queuecommand,Capture" CurrentStepsP1ChangedMessageCommand="queuecommand,Capture" CurrentStepsP2ChangedMessageCommand="queuecommand,Capture" />
function SelectMusicInit(self) InitializeMods() self:queuecommand('FirstUpdate') end
function SelectMusic(self) self:queuecommand('Capture') end

-- SCREEN EVALUATION
--<ActorFrame InitCommand="%EvaluationInit" FirstUpdateCommand="%Evaluation" />
function EvaluationInit(self) self:queuecommand('FirstUpdate') end
function Evaluation(self) end

-- SCREEN GAMEPLAY
-- <ActorFrame Command="%GameplayInit" FirstUpdateCommand="%Gameplay" UnknwonHoldMessageCommand="%HoldCheck" AssignHoldsCommand="%AssignHold"/>
function GameplayInit(self)	self:queuecommand('FirstUpdate') end
function Gameplay(self) JudgmentInit() end

-- Apply judgments

function JudgmentInit()
    local Jud_Normal = THEME:GetPath( EC_GRAPHICS, '', 'Judge/'..THEME:GetCurLanguage() )
    local Jud_CPUPlr = THEME:GetPath( EC_GRAPHICS, '', 'Judge/CPU/'..THEME:GetCurLanguage() )
    for pn=1,8 do
        local PL = SCREENMAN:GetTopScreen():GetChild('PlayerP'..pn)
        local k
        if PL then
            --Judgment font
            local PJudge = PL:GetChild('Judgment'):GetChild('')
            k = modJudgmentFont[pn%2 == 1 and 1 or 2]
            PJudge:aux(pn%2 == 1 and 1 or 2)
            
            if (pn == 1 and not GAMESTATE:IsHumanPlayer(PLAYER_1)) or (pn == 2 and not GAMESTATE:IsHumanPlayer(PLAYER_2)) then
                PJudge:Load( Jud_CPUPlr )
            else
                if PJudge and k ~= 1 then 
                    PJudge:Load( THEME:GetPath( EC_GRAPHICS, '', '_Judgments/'..judgmentFontList[k] ))
                else
                    PJudge:Load( Jud_Normal )
                end   
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


--Apply noteskin to all players
function ApplyNoteskin()
    --ApplyModifiers for noteskins only work before ScreenGameplay, so activating this function at ScreenStage would do
    local sk = {NoteSkinList[modNoteSkin[1]],NoteSkinList[modNoteSkin[2]]}
    if FUCK_EXE then
        for pn=1,7,2 do
            GAMESTATE:ApplyModifiers(sk[1],pn)
        end
        for pn=2,8,2 do
            GAMESTATE:ApplyModifiers(sk[2],pn)
        end
    else 
        for pn=1,2 do
            GAMESTATE:ApplyGameCommand('mod,'..sk[pn],pn)
        end
    end
end


-- Lua Option Rows

function JudgmentOption()
	local modList = judgmentFontList
    
	local Params = {
		Name = "Judgment Font",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false
    }
	   
    local loadFunc = function(self, list, pn)
        list[modJudgmentFont[pn+1]] = true
    end

    local saveFunc = function(self, list, pn)
        for i=1,table.getn(modList) do if list[i] then modJudgmentFont[pn+1] = i end end
    end
    
	return CreateOptionRow(Params, modList, loadFunc, saveFunc)
end


function HoldJudgmentOption()
	local modList = holdJudgmentList
    
	local Params = {
		Name = "Hold Judgment",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false
    }
	   
    local loadFunc = function(self, list, pn)
        list[modHoldJudgment[pn+1]] = true
    end

    local saveFunc = function(self, list, pn)
        for i=1,table.getn(modList) do if list[i] then modHoldJudgment[pn+1] = i end end
    end
    
	return CreateOptionRow(Params, modList, loadFunc, saveFunc)
end


function NoteSkinOption()
	local modList = NoteSkinList
    
	local Params = {
		Name = "Noteskin",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false
	}
    
    local loadFunc = function(self, list, pn)
        list[modNoteSkin[pn+1]] = true
    end

    local saveFunc = function(self, list, pn)
        for i=1,table.getn(modList) do if list[i] then modNoteSkin[pn+1] = i end end
    end
    
	return CreateOptionRow(Params, modList, loadFunc, saveFunc)
end


function CoinSystemOption()
	local modList = {"ON", "OFF"}
    
	local Params = {
		Name = "Coin System",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true
	}
    
    local loadFunc = function(self, list, pn)
        if not Profile().SplatManiaCoinDisabled then list[1] = true
        elseif Profile().SplatManiaCoinDisabled then list[2] = true
        else list[1] = true
        end
    end

    local saveFunc = function(self, list, pn)
        if list[1] then Profile().SplatManiaCoinDisabled = false; end
		if list[2] then Profile().SplatManiaCoinDisabled = true; end
        --you only need a couple of these on the same screen
        --PROFILEMAN:SaveMachineProfile()
    end
    
	return CreateOptionRow(Params, modList, loadFunc, saveFunc)
end


function CountdownOption()
	local modList = {"ON", "OFF"}
    
	local Params = {
		Name = "Countdown",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true
	}
    
    local loadFunc = function(self, list, pn)
        if not Profile().SplatManiaCountdownDisabled then list[1] = true
        elseif Profile().SplatManiaCountdownDisabled then list[2] = true
        else list[1] = true
        end
    end

    local saveFunc = function(self, list, pn)
        if list[1] then Profile().SplatManiaCountdownDisabled = false; end
		if list[2] then Profile().SplatManiaCountdownDisabled = true; end
        PROFILEMAN:SaveMachineProfile()
    end
    
	return CreateOptionRow(Params, modList, loadFunc, saveFunc)
end