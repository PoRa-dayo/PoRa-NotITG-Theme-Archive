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
function SelectMusicInit(self) InitializeMods() ApplyRateAdjust() self:queuecommand('FirstUpdate') end
function SelectMusic(self) self:queuecommand('Capture') end

-- SCREEN EVALUATION
--<ActorFrame InitCommand="%EvaluationInit" FirstUpdateCommand="%Evaluation" />
function EvaluationInit(self) RevertHideBG() RevertRateAdjust() self:queuecommand('FirstUpdate') end
function Evaluation(self) ApplyHideBG() end

-- SCREEN GAMEPLAY
-- <ActorFrame Command="%GameplayInit" FirstUpdateCommand="%Gameplay" UnknwonHoldMessageCommand="%HoldCheck" AssignHoldsCommand="%AssignHold"/>
function GameplayInit(self)	Combo = {} self:queuecommand('FirstUpdate') end
function Gameplay(self) JudgmentInit() end

-- Mod Changing functions

function InitializeMods()
	if GAMESTATE:GetEnv('Mods') then return end
	modRate = 1
	modJudgmentFont = {1,1}
    modNoteSkin = {1,1}
	CalculateSpeedMod()
	GAMESTATE:SetEnv('Mods',1)
end


-- Apply judgments

function JudgmentInit()
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

function CreateOptionRow( Params, Names, LoadFctn, SaveFctn )
	if not Params.Name then return nil end

	-- this needs to be used because Lua evaluates 'false' as 'nil', so
	-- we can't use an OR operator to assign the value properly.
	local function setbool( value, default )
		if value ~= nil then return value else return default end
	end

	-- fill in with passed params or default values. only Name is required.
	local t =
	{
		Name = Params.Name,

		LayoutType = Params.LayoutType or "ShowAllInRow",
		SelectType = Params.SelectType or "SelectOne",

		OneChoiceForAllPlayers = setbool(Params.OneChoiceForAllPlayers, true),
		EnabledForPlayers = Params.EnabledForPlayers or {PLAYER_1, PLAYER_2},

		ExportOnChange = setbool(Params.ExportOnChange, false),
		ReloadRowMessages= Params.ReloadRowMessages or {},

		Choices = Names,
		LoadSelections = LoadFctn,
		SaveSelections = SaveFctn,
	}

	setmetatable( t, t )
	return t
end


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

--[[
OpenITG resolution switcher, version 1.0
Licensed under Creative Commons Attribution-Share Alike 3.0 Unported
(http://creativecommons.org/licenses/by-sa/3.0/)

These probably won't work unless they're used on the same screen. You've been warned.

Written by Mark Cannon ("Vyhd") for OpenITG (http://www.boxorroxors.net/)
All I ask is that you keep this notice intact and don't redistribute in bytecode.
--]]

-- used in a few places, so we keep it here.
-- checks to see if two floats are equal, within error
local function fequ( f1, f2, error )
	if not f1 or not f2 then return nil end
	local error = error or 0.01
	local absolute_diff = math.abs(f1 - f2)
	return absolute_diff < error
end

-- Ratio is pre-declared in order to avoid drifting due to
-- saving badly-rounded floats over time. Possibly paranoia,
-- but this will save us some headaches regardless.
local Resolutions =
{
	["4:3"] = 
	{
		Ratio = 1.333333,
		Res = { "512x384", "640x480", "800x600", "1024x768", "1152x864", "1280x1024", "1400x1050", "1600x1200" },
	},

	["16:10"] =
	{
		Ratio = 1.6,
		Res = { "720x480", "1000x600", "1280x800", "1440x900", "1600x1024" },
	},

	["16:9"] =	
	{
		Ratio = 1.777777,
		Res = { "960x540", "1280x720", "1600x900", "1920x1080" },
	},
    
    ["3:2"] =	
	{
		Ratio = 1.5,
		Res = { "750x500", "1500x1000" },
	},
    
    ["5:4"] =	
	{
		Ratio = 1.25,
		Res = { "625x500", "1250x1000" },
	},
}

-- Width, then height. "640x480" -> 640, 480
local function SplitResolution( res )
	-- part before "x" is the width in pixels, part after is height in pixels
	local delim_pos = string.find( res, "x" )
	local width = tonumber( string.sub(res,1,delim_pos-1) )
	local height = tonumber( string.sub(res,delim_pos+1) )
	return width, height
end

-- returns the float value associated with the given ratio
local function RatioToFloat( ratio )
	return tonumber(Resolutions[ratio].Ratio)
end

-- returns the table key that best matches the given ratio
local function FloatToRatio( float )
	for key,tbl in pairs(Resolutions) do
		if fequ( tbl.Ratio, float ) then return key end
	end

	return nil
end

-- holds the aspect ratio that the system will have once everything's set
local temp_ratio = FloatToRatio( PREFSMAN:GetPreference("DisplayAspectRatio") )
local temp_float = RatioToFloat( temp_ratio )

-- This function only sets a temporary ratio for the other table to pick up on
function LuaSetAspectRatio()	
	-- build from all the key values of Resolutions
	local Names = {}
	for k,v in pairs(Resolutions) do table.insert(Names, k) end
	
	local function Load(self, list, pn)
		for i=1,table.getn(Names) do
			if fequ(temp_float, RatioToFloat(Names[i])) then list[i] = true return end
		end
	
		list[1] = true;	-- default to 4:3
	end

	local function Save(self, list, pn)
		for i=1,table.getn(Names) do
			if list[i] then
				if not fequ(ratio,temp_float) then
					temp_ratio = Names[i]
					temp_float = RatioToFloat( temp_ratio )
					MESSAGEMAN:Broadcast( "AspectRatioChanged" )
					return
				end
			end
		end
	end

	local Params =
	{
		Name = "AspectRatio",
		LayoutType = "ShowOneInRow",
		ExportOnChange = true,
	}

	return CreateOptionRow( Params, Names, Load, Save )
end

function LuaSetResolution( ratio )
	-- Fill in with the values names of the appropriate Resolutions table
	local Names = {}
	for i=1,table.getn(Resolutions[ratio].Res) do table.insert(Names, Resolutions[ratio].Res[i]) end
	
	local curwidth = PREFSMAN:GetPreference( "DisplayWidth" )
	local curheight = PREFSMAN:GetPreference( "DisplayHeight" )

	local function Load(self, list, pn)
		for i=1,table.getn(Names) do
			local width, height = SplitResolution( Names[i] )

			-- just find the closest match here...
			if width == curwidth or height == curheight then list[i] = true return end
		end

		-- fallback value: smallest one
		list[1] = true
	end

	local function Save(self, list, pn)
		for i=1,table.getn(Names) do
			if list[i] then
				-- make sure we're the right one being selected
				if ratio ~= temp_ratio then return end

				local width, height = SplitResolution( Names[i] )

				-- set the new preferences
				PREFSMAN:SetPreference( "DisplayWidth", width )
				PREFSMAN:SetPreference( "DisplayHeight", height )
				PREFSMAN:SetPreference( "DisplayAspectRatio", Resolutions[ratio].Ratio )
				Debug( "New resolution: " .. width .. "x" .. height .. ", ratio " .. Resolutions[ratio].Ratio )
				
				DISPLAY:SetWindowPositionAndSize(0,0,width,height)
                
                -- the ThemeSwitcher in dwiutils does this job now
				-- GAMESTATE:DelayedGameCommand( "reloadtheme" )
			end
		end
	end

	local Params =
	{
		Name = "DisplayResolution",
		LayoutType = "ShowOneInRow",

		-- disable this line if it isn't used for the current ratio
		EnabledForPlayers = fequ(RatioToFloat(ratio),temp_float) and {PLAYER_1,PLAYER_2} or {},
		ReloadRowMessages = { "AspectRatioChanged" },
	};

	return CreateOptionRow( Params, Names, Load, Save )
end

