-- LUA OPTION ROWS (BASE)

--change the text of a BitmapText element on the OptionRow with ModName, and change the x coordinate of the cursor accordingly
function SetOptionRow(ModName,id,text,pn)
    if not GAMESTATE:IsPlayerEnabled(pn-1) then return end
    --in Simply Love this function is called Size, placed inside SetOptionRow
    local function CursorXBasedOnTextSize(cursor,txt)
        local z = txt:GetWidth()*txt:GetZoom()
        cursor[pn][2]:zoomtowidth(z)
        cursor[pn][3]:x(-(z + cursor[pn][2]:GetWidth())/2)
        cursor[pn][4]:x((z + cursor[pn][2]:GetWidth())/2)
    end
    
    if not ToHoSokuGlob.OptionTextEle then return end
    if ToHoSokuGlob.OptionTextEle[ModName] and ToHoSokuGlob.OptionTextEle[ModName][id] then
        local ModValEle = ToHoSokuGlob.OptionTextEle[ModName][id]
        ModValEle:settext(text)
        
        --this Y coordinate magic number has to be changed according to what's set in metrics.ini
        local MagicY = SCREEN_CENTER_Y-103+32*(ToHoSokuGlob.OptionNumIndex[ModName]-1)
        if ToHoSokuGlob.OptionCursorEle and ToHoSokuGlob.OptionCursorEle[pn][1]:GetY() == math.floor(MagicY) then
            CursorXBasedOnTextSize(ToHoSokuGlob.OptionCursorEle, ModValEle)
        end
        
    end
end

--needs GlobalClock defined in ScreenSystemLayer MessageFrame for it to work
function Clock(val) 
    if not GlobalClock then return 999999 end
    local t = GlobalClock:GetSecsIntoEffect()
    if val then t = t - val end return t
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

-- LUA OPTION ROWS


--the SpeedModOption option row goes from 5 to 2000, increasing 5 for each option (so 5, 10, 15, 20, 25, etc.)
local speedMin = 5
local speedMax = 2000
local speedSpread = 5

--it's just a SliderOption from Simply Love,
--the thing that has 3 options as a base, just to know which direction the player is moving
--and the option text will be updated accordingly based on the direction
function SpeedModOption(name)
	local modList = {"   ","   ","   "}
    local slider = {{1,1,0},{1,1,0}} -- {position, counts, clock}
    --(counts is for the cnt that will be used in the move function and AddSnap function, it increases when saveFunc is triggered too often)
    local function move(pn,dir,cnt)
        modBase[pn+1] = clamp( AddSnap(modBase[pn+1] , dir , cnt , { 5 , 25 , 100 } ) , speedMin , speedMax );
        ModTypeAndBaseToModSpeed(pn+1)
        SetSpeedMod(pn+1)
    end
    local Params = {
		Name = "Speed",
		LayoutType = "ShowOneInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		--ExportOnChange true makes it save immediately after the player changes the value
		ExportOnChange = true
    }
        
    local loadFunc = function(self, list, pn)
        list[1] = true
        --InitSpeedMod will set the initial modType, modBase and modSpeed
        slider[pn+1][1] = 1
        --and then PostModCaptureInit will change the initial option text
    end

	local saveFunc = function(self, list, pn)
        -- Clock tracks how often this function is triggered
        if Clock(slider[pn+1][3]) < 0.1 then
            slider[pn+1][2] = slider[pn+1][2]+1
        else
            slider[pn+1][2] = 1
        end
        slider[pn+1][3] = Clock()
        for i=1,3 do 
            if list[i] then
                --every time any player changes option, BOTH players' option texts get updated, so SetOptionRow has to be done on both
                if slider[pn+1][1] == math.mod(i+2,3) then
                    move(pn, 1,slider[pn+1][2])
                    SetOptionRow(ToHoSokuGlob.SpeedModName,2,DisplaySpeedMod(1),1)
                    SetOptionRow(ToHoSokuGlob.SpeedModName,3,DisplaySpeedMod(2),2)
                end
                if slider[pn+1][1] == math.mod(i+1,3) then
                    move(pn,-1,slider[pn+1][2])
                    SetOptionRow(ToHoSokuGlob.SpeedModName,2,DisplaySpeedMod(1),1)
                    SetOptionRow(ToHoSokuGlob.SpeedModName,3,DisplaySpeedMod(2),2)
                end
                slider[pn+1][1] = math.mod(i,3)
            end
        end
    end
    
	return CreateOptionRow(Params, modList, loadFunc, saveFunc)
end

function SpeedTypeOption()
	local modList = {'X','C','M'}
    
	local Params = {
		Name = "Speed Type",
		LayoutType = "ShowOneInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = false,
		ExportOnChange = true
    }
	   
    local loadFunc = function(self, list, pn)
        --InitSpeedMod will set the initial modType, modBase and modSpeed
        for modInd,modOption in ipairs(modList) do
            if modOption == string.upper(modType[pn+1]) then
                list[modInd] = true
            end
        end
    end

    local saveFunc = function(self, list, pn)
        local TypeList = {'x', 'C', 'm'}
        for modInd,modOption in ipairs(modList) do
            if list[modInd] == true then
                modType[pn+1] = TypeList[modInd]
                ModTypeAndBaseToModSpeed(pn+1)
                SetSpeedMod(pn+1)
                SetOptionRow(ToHoSokuGlob.SpeedModName,pn+2,DisplaySpeedMod(pn+1),pn+1)
            end
        end
    end
    
	return CreateOptionRow(Params, modList, loadFunc, saveFunc)
end

rateMods = {}
rateModsEdit = {}
--from 0.5x to 2x in Edit, 1x to 2x outside Edit
for i = 50, 200, 5 do
    if i >= 100 then
        table.insert(rateMods, (i / 100) .. "x")
    end
    table.insert(rateModsEdit, (i / 100) .. "x")
end

function MusicRateOption( s )
	local modList = rateMods
	if s then modList = rateModsEdit end
	local t = {
		Name = "Music Rate",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = true,
		Choices = modList,
	   
		LoadSelections = function(self, list, pn)
			for n = 1, table.getn(modList) do
				if GAMESTATE:PlayerIsUsingModifier(pn,modList[n]..'music') then
                    list[n] = true;
                    s = string.gsub(modList[n],'x','')
                    modRate = tonumber(s)
                else
                    list[n] = false
                end
			end
		end,

		SaveSelections = function(self, list, pn)
			for n = 1, table.getn(modList) do
				if list[n] then s = modList[n] end
			end
			s = string.gsub(s,'x','')
			modRate = tonumber(s)
			GAMESTATE:ApplyGameCommand('mod,'..s..'xmusic',pn+1)
			ApplyRateAdjust()
			MESSAGEMAN:Broadcast('RateModChanged')
		end
	   
	}
	setmetatable(t, t)
	return t
end

function BackButton()
	local modList = {'More Options', 'Song Select'}
	local t = {
		Name = "BackButton",
		LayoutType = "ShowAllInRow",
		SelectType = "SelectMultiple",
		OneChoiceForAllPlayers = GAMESTATE:IsPlayerEnabled(PLAYER_1),
		ExportOnChange = true,
		Choices = modList,
		LoadSelections = function(self, list, pn) end,
		SaveSelections = function(self, list, pn)
            --otherwise if anything tries to access ToHoSokuGlob.OptionTextEle it will cause AV because the elements are no longer there
            ToHoSokuGlob.OptionTextEle = nil
            ToHoSokuGlob.OptionCursorEle = nil
            ToHoSokuGlob.OptionRows = nil
            if list[1] then
                if (not ToHoSokuGlob.OptionsScreen) or ToHoSokuGlob.OptionsScreen == 'PlayerOptions' then
                    SCREENMAN:SetNewScreen('ScreenSongOptions')
                elseif ToHoSokuGlob.OptionsScreen == 'SongOptions' then
                    SCREENMAN:SetNewScreen('ScreenPlayerOptions')
                end
            end
            if list[2] then
                SCREENMAN:SetNewScreen('ScreenSelectMusic')
            end
        end
	}
	setmetatable(t, t)
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


-- Lua Option Row support functions
	   
function InitSpeedMod()
    --define these tables, examples of their format are also shown here (DIFFERENT FROM SIMPLY LOVE)
	modType = {'x','x'}
	modSpeed = {'3.5x','3.5x'}
    modBase = {350,350}
	for pn=1,2 do
        if GAMESTATE:IsPlayerEnabled(pn-1) then
            for i=speedMin,speedMax,speedSpread do
                if GAMESTATE:PlayerIsUsingModifier(pn-1,'C'..i) then
                    modType[pn] = 'C';
                    modBase[pn] = i
                    modSpeed[pn] = 'C' .. modBase[pn]
                elseif GAMESTATE:PlayerIsUsingModifier(pn-1,(i/100)..'x') then
                    modType[pn] = 'x';
                    modBase[pn] = i
                    modSpeed[pn] = i/100 .. 'x'
                elseif GAMESTATE:PlayerIsUsingModifier(pn - 1, 'm' .. i) then
                    modType[pn] = 'm';
                    modBase[pn] = i
                    modSpeed[pn] = 'm' .. modBase[pn]
                end
            end
        end
    end
end

modRate = 1

function ApplyMod(mod,pn)
    if FUCK_EXE then
        GAMESTATE:ApplyModifiers(mod,pn)
    else
        GAMESTATE:ApplyGameCommand('mod,'..mod,pn)
    end
end

function SetSpeedMod(pn)
    ApplyMod('1x',pn)
    ApplyRateAdjust()
    --ApplyMod(modSpeed[pn],pn)
    --there is an extra Disqualification Message in ScreenOptions overlay for speed mod changes
    MESSAGEMAN:Broadcast('SpeedModChanged')
end

function DisplaySpeedMod(pn)
    local s = ''
    local finalSpeedStr = modSpeed[pn]
	if modType[pn] == 'x' then
        if bpm and tonumber(bpm[1]) then
            s = math.floor(modBase[pn] / 100 * bpm[1] * modRate + 0.5)
            if tonumber(bpm[2]) then s = s ..  '-' .. math.floor(modBase[pn] / 100 * bpm[2] * modRate + 0.5) end
            s = ' (' .. s .. ')'
        end
        finalSpeedStr = math.ceil(modBase[pn]/modRate)/100 .. 'x'
	end
	s = finalSpeedStr .. s
	return s
end

--cnt increases when SaveSelections is activated too often
--speed contains different increments, here it's 5, 25 and 100
--n will be higher based on how high cnt is, which will then be used as speed[n] to consider which increment to use
function AddSnap( val , dir , cnt , speed )
	local n = clamp( math.floor( cnt / 5 ) + 1 , 1 , table.getn( speed ) )
	local add = dir * speed[n]
	local ret = val + add
	return ret - math.mod( ret , add )
end

function ModTypeAndBaseToModSpeed(pn)
    if modType[pn] == 'x' then
        modSpeed[pn] = (modBase[pn]/100) .. modType[pn]
    else
        modSpeed[pn] = modType[pn] .. modBase[pn]
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

InitSpeedMod()