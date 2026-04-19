function JUVMProfile() return PROFILEMAN:GetMachineProfile():GetSaved() end

function FailDisplay()
	local t = OptionRowBase('FailDisplay')
	t.OneChoiceForAllPlayers = true
	t.Choices = { "Enable", "Disable" }
	t.LoadSelections = function(self, list) if JUVMProfile().JUVMDisplayFailText then list[1] = true else list[2] = true end end
	t.SaveSelections = function(self, list)
		if list[1] then JUVMProfile().JUVMDisplayFailText = true;  PROFILEMAN:SaveMachineProfile() end
		if list[2] then JUVMProfile().JUVMDisplayFailText = false; PROFILEMAN:SaveMachineProfile() end
	end
	return t
end

function TipDisplay()
	local t = OptionRowBase('TipDisplay')
	t.OneChoiceForAllPlayers = true
	t.Choices = { "Show", "Hide" }
	t.LoadSelections = function(self, list) if JUVMProfile().JUVMDisplayTips then list[1] = true else list[2] = true end end
	t.SaveSelections = function(self, list)
		if list[1] then JUVMProfile().JUVMDisplayTips = true;  PROFILEMAN:SaveMachineProfile() end
		if list[2] then JUVMProfile().JUVMDisplayTips = false; PROFILEMAN:SaveMachineProfile() end
	end
	return t
end

function ShowClock()
	local t = OptionRowBase('ShowClock')
	t.OneChoiceForAllPlayers = true
	t.Choices = { "Show", "Hide" }
	t.LoadSelections = function(self, list) if JUVMProfile().JUVMDisplayClock then list[1] = true else list[2] = true end end
	t.SaveSelections = function(self, list)
		if list[1] then JUVMProfile().JUVMDisplayClock = true;  PROFILEMAN:SaveMachineProfile() end
		if list[2] then JUVMProfile().JUVMDisplayClock = false; PROFILEMAN:SaveMachineProfile() end
	end
	return t
end

function HalfwayDisplay()
	local t = OptionRowBase('HalfwayDisplay')
	t.OneChoiceForAllPlayers = true
	t.Choices = { "Enable", "Disable" }
	t.LoadSelections = function(self, list) if JUVMProfile().JUVMDisplayHalfway then list[1] = true else list[2] = true end end
	t.SaveSelections = function(self, list)
		if list[1] then JUVMProfile().JUVMDisplayHalfway = true;  PROFILEMAN:SaveMachineProfile() end
		if list[2] then JUVMProfile().JUVMDisplayHalfway = false; PROFILEMAN:SaveMachineProfile() end
	end
	return t
end

function SongTimerDisplay()
	local t = OptionRowBase('SongTimerDisplay')
	t.OneChoiceForAllPlayers = true
	t.Choices = { "Enable", "Disable" }
	t.LoadSelections = function(self, list) if JUVMProfile().JUVMDisplaySongTimer then list[1] = true else list[2] = true end end
	t.SaveSelections = function(self, list)
		if list[1] then JUVMProfile().JUVMDisplaySongTimer = true;  PROFILEMAN:SaveMachineProfile() end
		if list[2] then JUVMProfile().JUVMDisplaySongTimer = false; PROFILEMAN:SaveMachineProfile() end
	end
	return t
end

function ShowSongBackgroundSM()
	local t = OptionRowBase('ShowSongBackgroundSM')
	t.OneChoiceForAllPlayers = true
	t.Choices = { "Enable", "Disable" }
	t.LoadSelections = function(self, list) if JUVMProfile().JUVMShowSongBackgroundSM then list[1] = true else list[2] = true end end
	t.SaveSelections = function(self, list)
		if list[1] then JUVMProfile().JUVMShowSongBackgroundSM = true;  PROFILEMAN:SaveMachineProfile() end
		if list[2] then JUVMProfile().JUVMShowSongBackgroundSM = false; PROFILEMAN:SaveMachineProfile() end
	end
	return t
end

function AnimatedEditorBackground()
	local t = OptionRowBase('AnimatedEditorBackground')
	t.OneChoiceForAllPlayers = true
	t.Choices = { "Enable", "Disable" }
	t.LoadSelections = function(self, list) if JUVMProfile().JUVMAnimatedEditorBG then list[1] = true else list[2] = true end end
	t.SaveSelections = function(self, list)
		if list[1] then JUVMProfile().JUVMAnimatedEditorBG = true;  PROFILEMAN:SaveMachineProfile() end
		if list[2] then JUVMProfile().JUVMAnimatedEditorBG = false; PROFILEMAN:SaveMachineProfile() end
	end
	return t
end

function SLGJUVMDailyBackground()
	local t = OptionRowBase('SLGJUVMDailyBackground')
	t.OneChoiceForAllPlayers = true
	t.Choices = { "Daily", "Lucy", "Shame", "Banshee", "Hexagons", "GOODTEK", "Maze", "Zero" }
	t.LoadSelections = function(self, list) if JUVMProfile().JUVMDailyBG == true then list[1] = true elseif JUVMProfile().JUVMDailyBG == 'Lucy' then list[2] = true elseif JUVMProfile().JUVMDailyBG == 'Shame' then list[3] = true elseif JUVMProfile().JUVMDailyBG == 'Banshee' then list[4] = true elseif JUVMProfile().JUVMDailyBG == 'Hexagons' then list[5] = true elseif JUVMProfile().JUVMDailyBG == 'GOODTEK' then list[6] = true elseif JUVMProfile().JUVMDailyBG == 'Maze' then list[7] = true elseif JUVMProfile().JUVMDailyBG == 'Zero' then list[8] = true else list[1] = true end end
	t.SaveSelections = function(self, list)
		if list[1] then JUVMProfile().JUVMDailyBG = true;  end
		if list[2] then JUVMProfile().JUVMDailyBG = 'Lucy'; end
		if list[3] then JUVMProfile().JUVMDailyBG = 'Shame'; end
		if list[4] then JUVMProfile().JUVMDailyBG = 'Banshee'; end
		if list[5] then JUVMProfile().JUVMDailyBG = 'Hexagons'; end
		if list[6] then JUVMProfile().JUVMDailyBG = 'GOODTEK'; end
		if list[7] then JUVMProfile().JUVMDailyBG = 'Maze'; end
		if list[8] then JUVMProfile().JUVMDailyBG = 'Zero'; end
	end
	return t
end