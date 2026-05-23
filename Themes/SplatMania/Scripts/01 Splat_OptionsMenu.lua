-- Options menu managament.
-- This is to make the faster for the engine to load them.

function Splat_OptionsMenu_OptionIcon(self, name, n1, n2)
	if name == "Start" then
		self:x(0)
		self:y(0)
		self:zoom(0)
	elseif name == "GainFocus" then
		self:finishtweening()
		self:bounceend(0.1)
		self:diffuse(0,1,1,1)
		self:zoom(n1)
		self:zoomx(n2)
	elseif name == "LoseFocus" then
		self:finishtweening()
		self:bouncebegin(0.1)
		self:diffuse(0,0.2,0.2,1)
		self:zoom(0.3)
	end
end

function Splat_OptionsMenu_OptionLabel(self, name1, name2, name3, n1, n2)
	if name1 == "Cursor" then
		if name2 == "Start" then
			if n2 ~= nil then
				self:x(n2)
			else
				self:x(-240)
			end
			self:y(50)
			self:rotationz(45)
			self:zoom(2)
			self:diffusetopedge(1,0.5,0.5,1)
			self:diffusebottomedge(1,0.8,0.3,1)
		elseif name2 == "GainFocus" then
			self:finishtweening()
			self:bounceend(0.1)
			self:zoom(2)
		elseif name2 == "LoseFocus" then
			self:finishtweening()
			self:bouncebegin(0.1)
			self:zoom(0)
		end
	end
	if name1 == "Label" then
		if name3 ~= nil then
			self:settext(name3)
		end
		if name2 == "Start" then
			self:x(20)
			self:y(n1)
			self:zoom(0.9)
			self:shadowlength(1)
		elseif name2 == "GainFocus" then
			self:finishtweening()
			self:bounceend(0.1)
			self:diffuse(1,1,1,1)
			self:zoom(1.3)
			self:y(n1)
		elseif name2 == "LoseFocus" then
			self:finishtweening()
			self:bouncebegin(0.1)
			self:y( n1 - ( n1 + 5) )
			self:diffuse(0.2,0.2,0.2,1)
			self:zoom(0.3)
		end
	end
end