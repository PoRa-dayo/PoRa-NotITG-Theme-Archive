modJudgmentFont = {1,1}

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
	CalculateSpeedMod()
	GAMESTATE:SetEnv('Mods',1)
end


-- Judgment Tracking

function JudgmentInit()
	judgeP1 = {0,0,0,0,0,0,0,0,0}
	judgeP2 = {0,0,0,0,0,0,0,0,0}
	Holds = {}
	OK = {}
	NG = {}
	local P1 = SCREENMAN:GetTopScreen():GetChild('PlayerP1') if P1 then P1 = P1:GetChild('Judgment'):GetChild(''); k = modJudgmentFont[1]; P1:aux(1); if k ~= 1 then P1:Load( THEME:GetPath( EC_GRAPHICS, '', '_Judgments/'..judgmentFontList[k] )) end end
	local P2 = SCREENMAN:GetTopScreen():GetChild('PlayerP2') if P2 then P2 = P2:GetChild('Judgment'):GetChild(''); k = modJudgmentFont[2]; P2:aux(2); if k ~= 1 then P2:Load( THEME:GetPath( EC_GRAPHICS, '', '_Judgments/'..judgmentFontList[k] )) end end
end


function ApplyNoteskin()
    --both GetCurrentNoteSkins and ApplyModifiers for noteskins only work before ScreenGameplay, so activating this function at ScreenStage would do
    local sk = GAMESTATE:GetCurrentNoteSkins()
    if FUCK_EXE then
        for pn=1,7,2 do
            if GAMESTATE:IsPlayerEnabled(pn) then
                GAMESTATE:ApplyModifiers(sk[1],pn)
            end
        end
        for pn=2,8,2 do
            if GAMESTATE:IsPlayerEnabled(pn) then
                GAMESTATE:ApplyModifiers(sk[2],pn)
            end
        end
    else 
        for pn=1,2 do
            if GAMESTATE:IsPlayerEnabled(pn) then
                GAMESTATE:ApplyGameCommand('mod,'..sk[pn],pn)
            end
        end
    end
end


-- Lua Option Rows

function JudgmentOption()
	local modList = judgmentFontList
	local t = {
		Name = "Judgment Font",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = false,
		Choices = modList,
	   
		LoadSelections = function(self, list, pn)
			list[modJudgmentFont[pn+1]] = true
		end,

		SaveSelections = function(self, list, pn)
			for i=1,table.getn(modList) do if list[i] then modJudgmentFont[pn+1] = i end end
		end
	   
	}
	setmetatable(t, t)
	return t
end


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

				GAMESTATE:DelayedGameCommand( "reloadtheme" )
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

