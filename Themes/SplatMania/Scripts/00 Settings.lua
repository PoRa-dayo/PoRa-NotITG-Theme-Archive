function RadarValue(pn,n)
	-- 0 - Stream
	-- 1 - Voltage
	-- 2 - Air
	-- 3 - Freeze
	-- 4 - Chaos
	return GAMESTATE:GetCurrentSteps(pn):GetRadarValues(pn):GetValue(n)
end

function ThemeFile( file )
	return THEME:GetPath(EC_GRAPHICS,'', file )
end

function ColCon(n1, n2, n3)
	return (n1/255),(n2/255),(n3/255),1
end

function ThemeName() local str = string.sub(THEME:GetPath(2,'','_blank.png'),9) return string.sub(str,1,string.find(str,'/')-1) end

function LOAD_GLOBAL( file ) return "../GLOBAL/"..file end