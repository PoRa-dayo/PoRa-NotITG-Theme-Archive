--[[
	Jose's Dialog System
	Lua Segment
	Version 2.4
	It might not be robust nor complex as UnderText, but, it's more simple that
	anyone can understand how to use the system.
	-------------------------------------------------
				DO NOT TOUCH, KIDDO
		ONLY EDIT IF YOU KNOW WHAT IS GOING ON.
	-------------------------------------------------
]]
function LoadTextBox()
	return LOAD_GLOBAL('TextBox.xml')
end

function LoadTextBox_Anim()
	return LOAD_GLOBAL('ANIM_TextBox.xml')
end

function Char_InputNothing(self)
	self:settext(' ')
	self:diffuse( 1,1,1,1 )
end

-- Warning Signs
-- These are to prevent crashing. But rather, provide information as what was the
-- cause of the error.
function Warning_NoDialog() SCREENMAN:SystemMessage("Error on Current Dialog!\nReason: Initial Text global segment doesn't exist/was not found!\nThe engine was stopped.") end
function Warning_RequestForNewText() SCREENMAN:SystemMessage("Error on Current Dialog!\nReason: RequestForNewText was enabled but no NewTextName was found. Operation was aborted.") end
function Warning_TextBoxMissing() SCREENMAN:SystemMessage("Error on Global Dialog!\nTextbox doesn't appear to exist on Textbox.xml!") end
function Warning_NewTextName()
	local TextToGrab = DialogTextBank[TextBankData1][TextBankData2].NewTextName
	SCREENMAN:SystemMessage("Error on Current Dialog!\nReason: NewTextName assigned:\n'"..TextToGrab.."'\ndoesn't exist! Operation was aborted.") 
end
function Warning_NoColorFormat() SCREENMAN:SystemMessage("Error on Current Dialog!\nReason: PlaySound was enabled and SoundType was found,\nbut no SoundName was found. Operation was aborted.") end
function Warning_NoSoundName() SCREENMAN:SystemMessage("Error on Current Dialog!\nReason: PlaySound was enabled and SoundType was found,\nbut no SoundName was found. Operation was aborted.") end
function Warning_NoSoundType() SCREENMAN:SystemMessage("Error on Current Dialog!\nReason: PlaySound was enabled but no SoundType was found. Operation was aborted.") end
function Warning_ColorMissing(n) SCREENMAN:SystemMessage("Error on Current Dialog!\nReason: Colour value '"..n.."' was not found.\nValue has been replaced to 255 to prevent crashing.") end

function LoadCharacterData(self)
	if DialogTextBank[TextBankData1] ~= nil then
		if DialogTextBank[TextBankData1][TextBankData2] ~= nil then
			local TextData = DialogTextBank[TextBankData1][TextBankData2]

				self:x(SCREEN_CENTER_X-230)
				self:y(SCREEN_BOTTOM-155)
				self:shadowlength(2)
				self:horizalign('left')
				self:vertalign('top')
				self:zoom(0.6)
		
			if TextData.CharacterName ~= nil and TextData.CharacterColor ~= nil then
				self:settext( TextData.CharacterName )
				if TextData.CharacterColor[1] ~= nil then
					if TextData.CharacterColor[2] ~= nil then
						if TextData.CharacterColor[3] ~= nil then
							self:diffuse( TextData.CharacterColor[1]/255,TextData.CharacterColor[2]/255,TextData.CharacterColor[3]/255,1 )
						else
							Warning_ColorMissing(3)
							self:diffuse( TextData.CharacterColor[1]/255,TextData.CharacterColor[2]/255,255,1 )
						end
					else
						Warning_ColorMissing(2)
						self:diffuse( TextData.CharacterColor[1]/255,255,TextData.CharacterColor[3]/255,1 )
					end
				else
					Warning_ColorMissing(1)
					self:diffuse( 255,TextData.CharacterColor[2]/255,TextData.CharacterColor[3]/255,1 )
				end
			else
				Char_InputNothing(self)
			end

		end

	else
		Char_InputNothing(self)
		Warning_NoDialog()
	end
end

function LoadNewCharacterData(self)
if DialogTextBank[TextBankData1][TextBankData2].NewTextName ~= nil then
	local TextToGrab = DialogTextBank[TextBankData1][TextBankData2].NewTextName
		if DialogTextBank[TextBankData1][TextToGrab] ~= nil then
			local Bank = DialogTextBank[TextBankData1]
			if Bank[TextToGrab].CharacterName ~= nil and Bank[TextToGrab].CharacterColor ~= nil then
				self:settext( Bank[TextToGrab].CharacterName )
				self:diffuse( Bank[TextToGrab].CharacterColor[1]/255,Bank[TextToGrab].CharacterColor[2]/255,Bank[TextToGrab].CharacterColor[3]/255,1 )
			else
				self:settext(' ')
				self:diffuse( 1,1,1,1 )
			end
			self:queuecommand('PlayText')
		else
			Warning_NewTextName()
		end
	else
		Warning_RequestForNewText()
	end
end

function RemainCharacterName(self)
	local TextData = DialogTextBank[TextBankData1][TextBankData2]

		if TextData.Cut1 ~= nil then   self:sleep( TextData.Cut1 ) end
		if TextData.Time1 ~= nil then  self:sleep( TextData.Time1 ) end
		if TextData.Cut2 ~= nil then   self:sleep( TextData.Cut2 ) end
		if TextData.Sleep1 ~= nil then self:sleep( TextData.Sleep1 ) end
		if TextData.Time2 ~= nil then  self:sleep( TextData.Time2 ) end
		if TextData.Cut3 ~= nil then   self:sleep( TextData.Cut3 ) end
		if TextData.Sleep2 ~= nil then self:sleep( TextData.Sleep2 ) end
		if TextData.Cut4 ~= nil then   self:sleep( TextData.Cut4 ) end
		if TextData.Time3 ~= nil then  self:sleep( TextData.Time3 ) end
		if TextData.Cut5 ~= nil then   self:sleep( TextData.Cut5 ) end
		if TextData.Sleep3 ~= nil then self:sleep( TextData.Sleep3 ) end
		if TextData.Cut6 ~= nil then   self:sleep( TextData.Cut6 ) end

		if TextData.RequestMessage == true then
			if DialogTextBank[TextBankData1][TextBankData2].NewMessageName ~= nil then
				MESSAGEMAN:Broadcast( DialogTextBank[TextBankData1][TextBankData2].NewMessageName )
			else
				-- shit
			end
		end

		if TextData.RequestForNewText == true then
			self:sleep( TextData.SleepTimeBeforeNewText )
			self:queuecommand('UpdateTextString')
		end
end

function InitializeDialog(self)
		self:x(SCREEN_CENTER_X-110)
		self:y(SCREEN_BOTTOM-110)
		self:horizalign('left')
		self:vertalign('top')
		self:shadowlength(2)
		self:zoom(0.5)

		if DialogTextBank[TextBankData1] ~= nil then
			if DialogTextBank[TextBankData1][TextBankData2] ~= nil then
				self:settext( DialogTextBank[TextBankData1][TextBankData2].Text )
				self:queuecommand('PlayText')
			else
				self:settext(' ')
				Warning_NoDialog()
			end
		else
			self:settext(' ')
			Warning_NoDialog()
		end
end

function InitializeFace(self)
		self:x(SCREEN_CENTER_X-180)
		self:y(SCREEN_BOTTOM-75)
		self:SetTextureFiltering(false)
		self:zoom(0.8)
		self:diffusealpha(0)
		self:animate(0)
		self:queuecommand('StartImageTween')
end


function Person_BestScore(n)
	if n == 3 then
		return "First we have"..BestScores[Names][3].."Who came in 3rd place, with a score of"..BestScores[Names][3].."On"..BestScores[Names][3].."!";
	elseif n == 2 then
		return "Then we have"..BestScores[Names][2].."Who came in 2nd place, with a score of"..BestScores[Names][2].."On"..BestScores[Names][2].."!";
	elseif n == 1 then
		return "And finally, we have"..BestScores[Names][1].."Who came in 1st place, with a score of"..BestScores[Names][1].."On"..DialogTextBank[TextBankData1][TextBankData2][BestScores][Names][1].."!";
	end
end

function PlayDialog(self)
	local TextData = DialogTextBank[TextBankData1][TextBankData2]
	
		if TextData.FaceID ~= nil then
			self:wrapwidthpixels(700)
			self:x(SCREEN_CENTER_X-110)
		else
			self:x(SCREEN_CENTER_X-200)
			self:wrapwidthpixels(700)
		end

		if TextData.PlaySound == true then
			if TextData.SoundType ~= nil then
				if TextData.SoundName ~= nil then
					-- SOUND:PlayOnce( 'SplaTest/Sounds/'..TextData.SoundType..'/'..TextData.SoundName )
					SOUND:PlayOnce( THEME:GetPath( EC_SOUNDS, "", TextData.SoundType.."/"..TextData.SoundName ) )
				else
					Warning_NoSoundName()
				end
			else
				Warning_NoSoundType()
			end
		end

		if TextData.Cut1 ~= nil then self:cropright( TextData.Cut1 ) end
		if TextData.Time1 ~= nil then self:linear( TextData.Time1 ) end
		if TextData.Cut2 ~= nil then self:cropright( TextData.Cut2 ) end
		if TextData.Sleep1 ~= nil then self:sleep( TextData.Sleep1 ) end
		if TextData.Time2 ~= nil then self:linear( TextData.Time2 ) end
		if TextData.Cut3 ~= nil then self:cropright( TextData.Cut3 ) end
		if TextData.Sleep2 ~= nil then self:sleep( TextData.Sleep2 ) end
		if TextData.Cut4 ~= nil then self:cropright( TextData.Cut4 ) end
		if TextData.Time3 ~= nil then self:linear( TextData.Time3 ) end
		if TextData.Cut5 ~= nil then self:cropright( TextData.Cut5 ) end
		if TextData.Sleep3 ~= nil then self:sleep( TextData.Sleep3 ) end
		if TextData.Cut6 ~= nil then self:cropright( TextData.Cut6 ) end

		if TextData.RequestMessage == true then
			MESSAGEMAN:Broadcast( DialogTextBank[TextBankData1][TextBankData2].NewMessageName )
		end

		if TextData.RequestForNewText == true then
			self:sleep( TextData.SleepTimeBeforeNewText )
			self:queuecommand('UpdateTextString')
		end

end

function SleepData(self)

		self:cropright(1)
		self:linear(0.02)
		self:cropright(0)

	if DialogTextBank[TextBankData1] ~= nil then
		if DialogTextBank[TextBankData1][TextBankData2] ~= nil then
			local TextData = DialogTextBank[TextBankData1][TextBankData2]
	
			TotalSleepTime = 0
			if TextData.RequestForNewText == true then
	
				if TextData.Time1 ~= nil then TotalSleepTime = TotalSleepTime + TextData.Time1 end
				if TextData.Sleep1 ~= nil then TotalSleepTime = TotalSleepTime + TextData.Sleep1 end
				if TextData.Time2 ~= nil then TotalSleepTime = TotalSleepTime + TextData.Time2 end
				if TextData.Sleep2 ~= nil then TotalSleepTime = TotalSleepTime + TextData.Sleep2 end
				if TextData.Time3 ~= nil then TotalSleepTime = TotalSleepTime + TextData.Time3 end
				if TextData.Sleep3 ~= nil then TotalSleepTime = TotalSleepTime + TextData.Sleep3 end
	
				self:sleep( TotalSleepTime + TextData.SleepTimeBeforeNewText - 1 )
				self:queuecommand('UpdateCharacterInfo')
			end

		else
			Char_InputNothing(self)
			Warning_NoDialog()
		end
	else
		Char_InputNothing(self)
		Warning_NoDialog()
	end
end

function LoadCharacterIcon(self)

	if DialogTextBank[TextBankData1] ~= nil then

		if DialogTextBank[TextBankData1][TextBankData2] ~= nil then
	
			self:cropright(1)
			self:linear(0.02)
			self:cropright(0)
	
			local TextData = DialogTextBank[TextBankData1][TextBankData2]
			
				if TextData.FaceID ~= nil then
					self:setstate( TextData.FaceID )
					self:diffusealpha(1)
				else
					self:diffusealpha(0)
				end
	
			TotalSleepTime = 0
				
				if TextData.RequestForNewText == true then
		
					if TextData.Time1 ~= nil then TotalSleepTime = TotalSleepTime + TextData.Time1 end
					if TextData.Sleep1 ~= nil then TotalSleepTime = TotalSleepTime + TextData.Sleep1 end
					if TextData.Time2 ~= nil then TotalSleepTime = TotalSleepTime + TextData.Time2 end
					if TextData.Sleep2 ~= nil then TotalSleepTime = TotalSleepTime + TextData.Sleep2 end
					if TextData.Time3 ~= nil then TotalSleepTime = TotalSleepTime + TextData.Time3 end
					if TextData.Sleep3 ~= nil then TotalSleepTime = TotalSleepTime + TextData.Sleep3 end
		
					self:sleep( TotalSleepTime + TextData.SleepTimeBeforeNewText )
					self:queuecommand('UpdateCharacterInfo')
				end
	
		else
			self:setstate(0)
			self:diffusealpha(0)
			Warning_RequestForNewText()
		end

	else
		self:setstate(0)
		self:diffusealpha(0)
		Warning_NoDialog()
	end

end

function GRABBER_NewText(self)
	if DialogTextBank[TextBankData1][TextBankData2].NewTextName ~= nil then
		local TextToGrab = DialogTextBank[TextBankData1][TextBankData2].NewTextName
			if DialogTextBank[TextBankData1][TextToGrab] ~= nil then
				self:settext( DialogTextBank[TextBankData1][TextToGrab].Text )
				TextBankData2 = DialogTextBank[TextBankData1][TextBankData2].NewTextName
				self:queuecommand('PlayText')
			else
				Warning_NewTextName()
			end
	else
		Warning_RequestForNewText()
	end
end

function GRABBER_NewFace(self)
	if DialogTextBank[TextBankData1][TextBankData2].NewTextName ~= nil then
		local TextToGrab = DialogTextBank[TextBankData1][TextBankData2].NewTextName
			if DialogTextBank[TextBankData1][TextToGrab] ~= nil then
				self:queuecommand('StartImageTween')
			else
				Warning_NewTextName()
			end
	else
		Warning_RequestForNewText()
	end
end


--[[

	(c) 2018, Jose_Varela
	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.

]]