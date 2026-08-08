local SpeedModList = {}
SpeedModList['C'] = {}
SpeedModList['x'] = {}
SpeedModList['m'] = {}
local DFSpeedInd = 1
local DFSpeedType = 'x'
local DFSpeed = '1x'

local PerspList = {'Overhead','Hallway','Distant','Incoming','Space'}
local DFPersp = 'Overhead'

local ScrollList = {'Normal', 'Reverse'}
local DFScroll = 'Normal'

DFMini = '0% mini'
local MiniList = {}
for i = -500, 500, 1 do
    table.insert(MiniList, i .. "%")
end

function InitDefaultModOptions()
    --grab the speed mod straight from GamePrefs.ini
    local ModStr = string.lower(PREFSMAN:GetPreference('DefaultModifiers'))
    local DFSpeed = '1x'
    DFPersp = 'Overhead'
    DFScroll = 'Normal'
    
    for part in string.gfind(ModStr, "[^,]+") do
    
        part = string.gsub(part, "^%s+", "") -- Remove leading whitespace
        part = string.gsub(part, "%s+$", "") -- Remove trailing whitespace

        if string.find(part, "^%d+%.?%d*[x]$") -- 2x, 2.5x
        or string.find(part, "^[x]%d+%.?%d*$") -- x2, x5.25
        or string.find(part, "^[c]%d+$") -- C640
        or string.find(part, "^[m]%d+$") then -- M255
            DFSpeed = part
        end
        
        for ind, modName in ipairs(PerspList) do
            if part == string.lower(modName) then
                DFPersp = modName
            end
        end
        
        if string.find(part, "reverse") then
            DFScroll = "Reverse"
        end
        
        if string.find(part, "% mini") then
            DFMini = part
        end
    end

    --these 3 variables are defined in Mods.lua, we use them again to check every single speed mod this theme can use
    local ListInd = 1
    for i=speedMin,speedMax,speedSpread do
        SpeedModList['C'][ListInd] = 'C' .. i
        SpeedModList['x'][ListInd] = i/100 .. 'x'
        SpeedModList['m'][ListInd] = 'm' .. i
        if 'C' .. i == DFSpeed then
            DFSpeedType = 'C';
            DFSpeedInd = ListInd
        elseif i/100 .. 'x' == DFSpeed or 'x' .. i/100 == DFSpeed then
            DFSpeedType = 'x';
            DFSpeedInd = ListInd
        elseif 'm' .. i == DFSpeed then
            DFSpeedType = 'm';
            DFSpeedInd = ListInd
        end
        ListInd = ListInd+1
    end
end


function ListWithWarnings(list, exception)
    local newList = {}
    for i=1,table.getn(list) do
        if list[i] == exception then
            table.insert(newList,list[i])
        else
            table.insert(newList,list[i]..' (!)')
        end
    end
    return newList
end


function SaveDefaultModToPrefs()
    --so normally SetPreference'DefaultModifiers' will not affect GamePrefs.ini
    --it will only save via the built-in default modifier options like DefaultNoteSkin and DefaultFailType
    --and those will save whenever stepmania detects that the default noteskin or default fail type has been changed
    --so while setting the new 'DefaultModifiers', we leave the noteskin and fail type blank
    --and since DefaultNoteSkin and DefaultFailType are placed below these custom options,
    --stepmania will always have to add back the noteskin and fail type and save our changes
    --(and also format it for us too)
    local ScrollText = ''
    if DFScroll == 'Reverse' then
        ScrollText = ', reverse'
    end
    PREFSMAN:SetPreference('DefaultModifiers', SpeedModList[DFSpeedType][DFSpeedInd] .. ', ' .. DFPersp .. ', ' .. DFMini .. ScrollText )
end


function DefaultSpeedType()	
	local Names = {'X','C','M'}
    local TypeList = {'x', 'C', 'm'}
	
	local function Load(self, list, pn)
		for i=1,table.getn(TypeList) do
			if DFSpeedType == TypeList[i] then
                list[i] = true
                return
            end
		end
	
		list[1] = true;	-- default to x
	end

	local function Save(self, list, pn)
        
		for i=1,table.getn(TypeList) do
			if list[i] then
				DFSpeedType = TypeList[i]
                DFSpeedInd = i
                
				SaveDefaultModToPrefs()
                
                DFSpeed = SpeedModList[DFSpeedType][i]
                MESSAGEMAN:Broadcast( "DefaultSpeedTypeChanged" )
                return
			end
		end
	end

	local Params =
	{
		Name = "Speed Mod Type",
		LayoutType = "ShowOneInRow",
		ExportOnChange = true,
	}

	return CreateOptionRow( Params, Names, Load, Save )
end


function DefaultSpeedMod( speedType )
	-- Fill in with the values of the appropriate speed type
	local Names = {}
    local SModList = SpeedModList[speedType]
	for i=1,table.getn(SModList) do
        table.insert(Names, SModList[i])
    end
    
	local function Load(self, list, pn)
		list[DFSpeedInd] = true
	end

	local function Save(self, list, pn)
		for i=1,table.getn(Names) do
			if list[i] and DFSpeedType == speedType then
				SaveDefaultModToPrefs()
                DFSpeed = Names[i]
                DFSpeedInd = i
			end
		end
	end

	local Params =
	{
		Name = "DefaultSpeed",
		LayoutType = "ShowOneInRow",

		-- disable this line if it isn't used for the current speed type
		EnabledForPlayers = DFSpeedType == speedType and {PLAYER_1,PLAYER_2} or {},
		ReloadRowMessages = { "DefaultSpeedTypeChanged" },
	};

	return CreateOptionRow( Params, Names, Load, Save )
end


function DefaultPerspectiveOption()
	local modList = PerspList
    
	local Params = {
		Name = "Perspective",
		LayoutType = "ShowOneInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true
    }
	   
    local loadFunc = function(self, list, pn)
        for i=1,table.getn(modList) do
            if modList[i] == DFPersp then
                list[i] = true
            end
        end
    end

    local saveFunc = function(self, list, pn)
        for i=1,table.getn(modList) do
			if list[i] then
                DFPersp = modList[i]
				SaveDefaultModToPrefs()
			end
		end
    end
    
	return CreateOptionRow(Params, ListWithWarnings(modList,'Overhead'), loadFunc, saveFunc)
end


function DefaultScrollOption()
	local modList = ScrollList
    
	local Params = {
		Name = "Scroll",
		LayoutType = "ShowOneInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true
    }
	   
    local loadFunc = function(self, list, pn)
        for i=1,table.getn(modList) do
            if modList[i] == DFScroll then
                list[i] = true
            end
        end
    end

    local saveFunc = function(self, list, pn)
        for i=1,table.getn(modList) do
			if list[i] then
                DFScroll = modList[i]
				SaveDefaultModToPrefs()
			end
		end
    end
    
	return CreateOptionRow(Params, ListWithWarnings(modList,'Normal'), loadFunc, saveFunc)
end


function DefaultMiniOption()
	local modList = MiniList
    
	local Params = {
		Name = "Mini",
		LayoutType = "ShowOneInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true
    }
	   
    local loadFunc = function(self, list, pn)
        for i=1,table.getn(modList) do
            if modList[i] .. " mini" == DFMini then
                list[i] = true
            end
        end
    end

    local saveFunc = function(self, list, pn)
        for i=1,table.getn(modList) do
			if list[i] then
                DFMini = modList[i] .. " mini"
				SaveDefaultModToPrefs()
			end
		end
    end
    
	return CreateOptionRow(Params, ListWithWarnings(modList,'0%'), loadFunc, saveFunc)
end




function DefaultJudgmentOption()
	local modList = judgmentFontList
    
	local Params = {
		Name = "Judgment Font",
		LayoutType = "ShowOneInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false
    }
	   
    local loadFunc = function(self, list, pn)
        list[PROFILEMAN:GetMachineProfile():GetSaved().ITGMeatDefaultJudgment or 1] = true
    end

    local saveFunc = function(self, list, pn)
        for i=1,table.getn(modList) do
            if list[i] then
                PROFILEMAN:GetMachineProfile():GetSaved().ITGMeatDefaultJudgment = i
            end
        end
        --just one of this is enough
        --PROFILEMAN:SaveMachineProfile()
    end
    
	return CreateOptionRow(Params, modList, loadFunc, saveFunc)
end

function DefaultHoldJudgmentOption()
	local modList = holdJudgmentList
    
	local Params = {
		Name = "DefaultHoldJudgment",
		LayoutType = "ShowOneInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		ExportOnChange = false
    }
	   
    local loadFunc = function(self, list, pn)
        list[PROFILEMAN:GetMachineProfile():GetSaved().ITGMeatDefaultHoldJudgment or 1] = true
    end

    local saveFunc = function(self, list, pn)
        for i=1,table.getn(modList) do
            if list[i] then
                PROFILEMAN:GetMachineProfile():GetSaved().ITGMeatDefaultHoldJudgment = i
            end
        end
        PROFILEMAN:SaveMachineProfile()
    end
    
	return CreateOptionRow(Params, modList, loadFunc, saveFunc)
end