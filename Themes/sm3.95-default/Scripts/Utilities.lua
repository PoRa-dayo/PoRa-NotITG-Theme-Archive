-- Find a key in tab with the given value.
function FindValue(tab, value)
	for key, name in tab do
		if value == name then
			return key
		end
	end

	return nil
end

-- Return the index of a true value in list.
function FindSelection( list )
	for index, on in list do
		if on then
			return index
		end
	end

	return nil
end

-- Look up each value in a table, returning a table with the resulting strings.
function TableMetricLookup( t, group )
	local ret = { }
	for key, val in t do
		Trace(val)
		ret[key] = THEME:GetMetric(group,val)
	end
	return ret
end

-- Scales x so that l1 corresponds to l2 and h1 corresponds to h2.
function scale( x, l1, h1, l2, h2 )
	return (((x) - (l1)) * ((h2) - (l2)) / ((h1) - (l1)) + (l2))
end

-- Scales x so that l1 corresponds to l2 and h1 corresponds to h2.
function scale( x, l1, h1, l2, h2 )
	return (((x) - (l1)) * ((h2) - (l2)) / ((h1) - (l1)) + (l2))
end

function split( delimiter, text )
	local list = {}
	local pos = 1
	while 1 do
		local first,last = string.find( text, delimiter, pos )
		if first then
			table.insert( list, string.sub(text, pos, first-1) )
			pos = last+1
		else
			table.insert( list, string.sub(text, pos) )
			break
		end
	end
	return list
end

function join( delimiter, list )
	local ret = ""
	for i = 1,table.getn(list) do 
		ret = ret .. delimiter .. list[i] 
	end
	return ret
end

function clamp(val,low,high)
	return math.max( low, math.min(val,high) )
end

function wrap(val,n)
	local x = val
	Trace( "wrap "..x.." "..n )
	if x<0 then 
		x = x + (math.ceil(-x/n)+1)*n;
	end
	Trace( "adjusted "..x )
	local ret = math.mod(x,n)
	Trace( "ret "..ret )
	return ret
end

function fapproach( val, other_val, to_move )
	if val == other_val then return val end
	local fDelta = other_val - val
	local fSign = fDelta / math.abs( fDelta )
	local fToMove = fSign*to_move
	if math.abs(fToMove) > math.abs(fDelta) then
		fToMove = fDelta	-- snap
	end
	val = val + fToMove
	return val
end

function tableshuffle( t )
	local ret = { }
	for i=1,table.getn(t) do
		table.insert( ret, math.random(i), t[i] );
	end
	return ret
end


function PDiff( pn ) return GAMESTATE:GetCurrentSteps(pn):GetDifficulty() end
function PMeter( pn ) return GAMESTATE:GetCurrentSteps(pn):GetMeter() end

function GameplayDiffIcon(self, pn)
    if pn==1 and not GAMESTATE:IsPlayerEnabled(PLAYER_1) then
        self:hidden(1)
        return
    end
    if pn==2 and not GAMESTATE:IsPlayerEnabled(PLAYER_2) then
        self:hidden(1)
        return
    end
    if GAMESTATE:GetCurrentSong() then
        self:setstate(PDiff(pn-1)*2+(pn-1))
    else
        self:hidden(1)
    end
end

function LevelNum(self, pn)
	self:finishtweening()
    self:settext(' ')
    self:hidden(1)
    if GAMESTATE:GetCurrentSong() then
        if PMeter(pn) > 12 then
            self:settext( PMeter(pn) )
            self:hidden(0)
        else
            self:settext( ' ' )
            self:hidden(1)
        end
    else
        self:settext(' ')
        self:hidden(1)
        if GAMESTATE:IsPlayerEnabled(PLAYER_1) and GAMESTATE:IsPlayerEnabled(PLAYER_2) then
            self:settext(' ')
        end
    end
end

function GetStepsDescriptionText(n)
	local steps = GAMESTATE:GetCurrentSteps(n)
	if not steps then
		text = ''
	else
		text = steps:GetDescription()
	end
	if string.lower(text) == 'blank' then text = '' end
	return text
end


function SelectMusicCheckScores()
    local p1pane = SCREENMAN:GetTopScreen():GetChild('PaneDisplayP1')
    local p2pane = SCREENMAN:GetTopScreen():GetChild('PaneDisplayP2')
    if p1pane then
        p1pane = p1pane:GetChild('')
        if PROFILEMAN:IsPersistentProfile(PLAYER_1) then
            p1pane:GetChild('MachineHighScoreText'):hidden(1)
            p1pane:GetChild('CourseMachineHighScoreText'):hidden(1)
        else
            p1pane:GetChild('ProfileHighScoreText'):hidden(1)
            p1pane:GetChild('CourseProfileHighScoreText'):hidden(1)
        end
    end
    if p2pane then
        p2pane = p2pane:GetChild('')
        if PROFILEMAN:IsPersistentProfile(PLAYER_2) then
            p2pane:GetChild('MachineHighScoreText'):hidden(1)
            p2pane:GetChild('CourseMachineHighScoreText'):hidden(1)
        else
            p2pane:GetChild('ProfileHighScoreText'):hidden(1)
            p2pane:GetChild('CourseProfileHighScoreText'):hidden(1)
        end
    end
end


--[[
Lua Theme Switcher, OpenITG beta 1, version 1.5
Licensed under Creative Commons Attribution-Share Alike 3.0 Unported
(http://creativecommons.org/licenses/by-sa/3.0/)

Written by Mark Cannon ("Vyhd") for OpenITG (http://www.boxorroxors.net/)
All I ask is that you keep this notice intact and don't redistribute in bytecode.
--]]

local function IsThemeBlacklisted( name )
	-- never display fallback folders (e.g. "fallback", "fallback3")
	if string.sub( name, 1, 8 ) == "fallback" then return true end
    if name == "OITGThemerFallback" then return true end

	-- never display default folders (e.g. "default", "default-h4x")
	if string.sub( name, 1, 7 ) == "default" then return true end

	-- never display arcade folders (e.g. "arcade", "arcade-h4x")
	-- if string.sub( name, 1, 6 ) == "arcade" then return true end

	-- never display dot directories (e.g. ".svn", ".nano")
	if string.sub( name, 1, 1 ) == "." then return true end

	-- never display the themes in this list
	-- local BlacklistedThemes = { "ps2", "ps2onpc" }
	-- for i=1,table.getn(BlacklistedThemes) do
		-- if name == BlacklistedThemes[i] then return true end
	-- end

	return false
end

local function GetThemesFiltered()
	local ret = {}
	local themes = THEME:GetThemeNames()

	for i=1,table.getn(themes) do
		if not IsThemeBlacklisted(themes[i]) then
			Debug( "Adding theme: " .. themes[i] )
			ret[table.getn(ret)+1] = themes[i]
		else
			Debug( "Threw out theme: " .. themes[i] )
		end
	end

	return ret
end

-- changed to use an argument for the next screen to go to
function ThemeSwitcher( next_screen )
	-- default to options menu unless otherwise set
	next_screen = next_screen or "ScreenOptionsMenu"

	local Names = GetThemesFiltered()
	local amt = table.getn(Names)

	local function Load(self, list, pn)
		local theme = string.lower(THEME:GetCurThemeName())
		for i=1,amt do
			if string.lower(Names[i]) == theme then list[i] = true return end
		end

		-- fall back to Default if we have no matches
		for i=1,amt do
			if string.lower(Names[i]) == "default" then list[i] = true return end
		end

		-- fall back to the first option, so we don't crash
		list[1] = true
	end

	local function Save(self, list, pn)
		for i=1,amt do if list[i] then
			local command = "theme," .. Names[i]
			command = command .. ";screen," .. next_screen
			GAMESTATE:DelayedGameCommand( command ) end
		end
	end

	-- grab the pre-used metrics from the built-in language INI.
	local Params = { Name = "Theme" }

	return CreateOptionRow( Params, Names, Load, Save )
end

-- (c) 2005 Glenn Maynard, Chris Danford
-- All rights reserved.
-- 
-- Permission is hereby granted, free of charge, to any person obtaining a
-- copy of this software and associated documentation files (the
-- "Software"), to deal in the Software without restriction, including
-- without limitation the rights to use, copy, modify, merge, publish,
-- distribute, and/or sell copies of the Software, and to permit persons to
-- whom the Software is furnished to do so, provided that the above
-- copyright notice(s) and this permission notice appear in all copies of
-- the Software and that both the above copyright notice(s) and this
-- permission notice appear in supporting documentation.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
-- OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF
-- THIRD PARTY RIGHTS. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR HOLDERS
-- INCLUDED IN THIS NOTICE BE LIABLE FOR ANY CLAIM, OR ANY SPECIAL INDIRECT
-- OR CONSEQUENTIAL DAMAGES, OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS
-- OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
-- OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
-- PERFORMANCE OF THIS SOFTWARE.

