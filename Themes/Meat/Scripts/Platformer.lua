function Initialize(s,x,y) --Declare variables as lists.
	Ax = {}			-- Acceleration in X direction
	Ay = {}			-- Acceleration in Y direction
	Vx = {}			-- Velocity in X direction
	Vy = {}			-- Velocity in Y direction
	Dx = {}			-- Destination in X direction
	Dy = {}			-- Destination in Y direction
	Sx1 = {}		-- Size in X direction, left of center
	Sy1 = {}		-- Size in Y direction, above center
	Sx2 = {}		-- Size in X direction, right of center
	Sy2 = {}		-- Size in Y direction, below center
	var = {}		-- For Condition Check, which parameter to compare
	con = {}		-- For Condition Check, what type of comparison
	val = {}		-- For Condition Check, value to compare with
	cmd = {}		-- For Condition Check, command to play when condition is met
	state = {}		-- Track state to avoid changing unless change is needed
	newState = {}	-- Check current conditions to compare with current state to see if change is needed
	splash = {}		-- Decides if any splash or trail animation is needed based on changing states
	armSplash = {}	-- Limits Jumping trails to happen only when actually jumping, not when sliding up past the top of a wall
	trail = {}		-- Indexes sprinting trail to allow multiple to play properly
	bounce = {}		-- How an object bounces when it hits ground
	stop = {}		-- Tells object to stop moving.
	lock = {}		-- Used to guarantee that an object is only moved by 1 move command at a time.
	Object = {}		-- Allows object to be called without carrying around 'self'
	class = {}		-- To track the class number by index number
	class1 = {}		-- For use with ipairs. Tracks all Hero objects
	class2 = {}		-- For use with ipairs. Tracks all Goal objects
	class3 = {}		-- For use with ipairs. Tracks all Ground objects
	class4 = {}		-- For use with ipairs. Tracks all Obstacle objects that do not interact with ground
	class5 = {}		-- For use with ipairs. Tracks all Obstacle objects that do interact with ground
	class6 = {}		-- For use with ipairs. Tracks all Item objects
	blockSize = s
	blockXOffset = x
	blockYOffset = y
	G = 1/30
end

function QuadFromRegister(self,k,c)
		if c == 1 then n = class1[k]; self:diffuse(1,0,0,.5)
	elseif c == 2 then n = class2[k]; self:diffuse(1,.7,.7,.5)
	elseif c == 3 then n = class3[k]; self:diffuse(0,1,.5,.5)
	elseif c == 4 then n = class4[k]; self:diffuse(1,0,1,.5)
	elseif c == 5 then n = class5[k]; self:diffuse(1,.5,0,.5)
	elseif c == 6 then n = class6[k]; self:diffuse(0,1,0,.5)
	elseif c == 7 then n = class7[k]; self:diffuse(1,1,1,.5)
	end
	if n then
		self:stretchto(Sx1[n]+Dx[n],Sy1[n]+Dy[n],Sx2[n]+Dx[n],Sy2[n]+Dy[n])
	else
		self:zoom(0)
	end
end

function Register(self,x1,y1,x2,y2,c)	 -- Populate list
	n = table.getn(class)+1
	Object[n] = self
	class[n] = c
		if c == 1 then ClassTable(class1,n)
	elseif c == 2 then ClassTable(class2,n)
	elseif c == 3 then ClassTable(class3,n)
	elseif c == 4 then ClassTable(class4,n)
	elseif c == 5 then ClassTable(class5,n)
	elseif c == 6 then ClassTable(class6,n)
	end
	Vx[n] = 0
	Vy[n] = 0
	Ax[n] = 0
	Ay[n] = 0   
	Dx[n] = self:GetX()
	Dy[n] = self:GetY()
	Sx1[n] = math.min(x1,x2)
	Sy1[n] = math.min(y1,y2)
	Sx2[n] = math.max(x1,x2)
	Sy2[n] = math.max(y1,y2)
	state[n] = 3
	newState[n] = 8
	trail[n] = 1
	splash[n] = 0
	bounce[n] = 0
	self:z(n)
end

function RegisterHero(self)
	Register(self,math.floor(-.42*blockSize),math.floor(-.25*blockSize),math.floor(.42*blockSize),math.floor(.62*blockSize),1)
end

function RegisterGoal(self)
	Register(self,math.floor(-.9*blockSize),math.floor(-.25*blockSize),math.floor(.9*blockSize),math.floor(.8*blockSize),2)
end

function RegisterGround(self,i,j)
	self:zoomtowidth(blockSize)
	self:zoomtoheight(blockSize)
	self:x(blockSize*i+blockXOffset)
	self:y(blockSize*j+blockYOffset)
	Register(self,-blockSize/2,-blockSize/2,blockSize/2,blockSize/2,3)
end


function BuildLevel(self,i,j)
	if levelMapR[j][i] < 0 then self:rotationy(180) end
	self:rotationz(90*math.abs(levelMapR[j][i]))
	self:zoomtowidth(blockSize)
	self:zoomtoheight(blockSize)
	self:x(blockSize*i+blockXOffset)
	self:y(blockSize*j+blockYOffset)
end

function BuildLeft(self,i,j)
	if leftMapR[j][i] < 0 then self:rotationy(180) end
	self:rotationz(90*math.abs(leftMapR[j][i]))
	self:zoomtowidth(blockSize)
	self:zoomtoheight(blockSize)
	self:x(blockSize*(i-4)+blockXOffset)
	self:y(blockSize*j+blockYOffset)
end

function BuildRight(self,i,j)
	if rightMapR[j][i] < 0 then self:rotationy(180) end
	self:rotationz(90*math.abs(rightMapR[j][i]))
	self:zoomtowidth(blockSize)
	self:zoomtoheight(blockSize)
	self:x(blockSize*(i+table.getn(levelMap[1]))+blockXOffset)
	self:y(blockSize*j+blockYOffset)
end

function Remove(self)
	n = self:GetZ()
	Dx[n] = -1000
	Dy[n] = -1000
	stop[n] = 1
	if class[n] == 3 then for i,k in ipairs(class3) do if k == n then table.remove(class3,i) end end end
end

function Restore(self)
	n = self:GetZ()
	state[n] = 3
	self:finishtweening()
end

function ClassTable(c,n)
	for i,k in ipairs(c) do
		if k == n then return end
	end
	c[table.getn(c)+1] = n
end

function LevelGround(i,j) if levelMap[j] and levelMap[j][i] and levelMap[j][i] > 0 then return true else return false end end
function LevelBackground(i,j) if levelMap[j] and levelMap[j][i] and levelMap[j][i] < 0 then return true else return false end end
function LevelOpen(i,j) if j > 0 and i > 0 and levelMap[j] and levelMap[j][i] and levelMap[j][i] <= 0 then return true else return false end end

function BlockFile(i,j) return LevelType() ..'/World'..world..'/Level'..level..'/' .. math.abs(levelMap[j][i]) .. '.png' end
function LeftBlockFile(i,j) return LevelType() ..'/World'..world..'/Level'..level..'/' .. math.abs(leftMap[j][i]) .. '.png' end
function RightBlockFile(i,j) return LevelType() ..'/World'..world..'/Level'..level..'/' .. math.abs(rightMap[j][i]) .. '.png' end

function Move(self,xV,yV,xA,yA,a,b,c,d)
	n = self:GetZ()
	stop[n] = 0
	if xV ~= '' then Vx[n] = xV end
	if yV ~= '' then if yV < Vy[n] then armSplash[n] = 1 end Vy[n] = yV end
	if xA ~= '' then Ax[n] = xA end
	if yA ~= '' then Ay[n] = yA + G end
	if a then var[n] = a end
	if b then con[n] = b else con[n] = '' end
	if c then val[n] = c end
	if d then cmd[n] = d end
	Object[n]:queuecommand('Move')
end

function Update(self)
	n = self:GetZ()
	if stop[n] == 1 then return end
	UpdateCoordinates(n)
	CheckGround(n)
	CheckState(n)
	Cx = Dx[n] - Object[n]:GetX()
	Cy = Dy[n] - Object[n]:GetY()
	Object[n]:linear(.03)	   
	Object[n]:addx(Cx)
	Object[n]:addy(Cy)
	UpdateState(n)
	CheckInteractions(n)
	CheckCondition(n)
end

function UpdateCoordinates(n)
	Vx[n] = Vx[n] + Ax[n]
	Vy[n] = Vy[n] + Ay[n]
	Vx[n] = clamp(Vx[n],-1,1)
	Dx[n] = Object[n]:GetX() + Vx[n]*blockSize
	Dy[n] = Object[n]:GetY() + Vy[n]*blockSize
end

function CheckCondition(n)
		if var[n] == 'Dx' then coord = Dx[n]
	elseif var[n] == 'Dy' then coord = Dy[n]
	elseif var[n] == 'Vx' then coord = Vx[n]
	elseif var[n] == 'Vy' then coord = Vy[n]
	elseif var[n] == 'state' then coord = math.abs(state[n])
	end
	queue = 'Move'
		if con[n] == '>' and coord >= val[n] and var[n] ~= 'state' then queue = 'Move'..cmd[n]
	elseif con[n] == '>' and coord > val[n] and var[n] == 'state' then queue = 'Move'..cmd[n]
	elseif con[n] == '<' and coord <= val[n] and var[n] ~= 'state' then queue = 'Move'..cmd[n]
	elseif con[n] == '<' and coord < val[n] and var[n] == 'state' then queue = 'Move'..cmd[n]
	elseif con[n] == '=' and coord == val[n] then queue = 'Move'..cmd[n]
	end
	Object[n]:queuecommand(queue)
end

function NewState(n,i)
	if math.abs(i) < math.abs(newState[n]) then newState[n] = i end
end

function CheckState(n)
	if class[n] ~= 1 then return end
	if Vy[n] < 0 then NewState(n,6) end
	if Vy[n] > 0 then NewState(n,7) end
	if Vy[n] > -.15 and Vy[n] < .15 then NewState(n,5) end
	if newState[n] == 3 and Vx[n] ~= 0 then NewState(n,2) end
	if newState[n] == 2 and math.abs(Vx[n]) > .25 then NewState(n,1) end
	if newState[n] == 3 and Ax[n] ~= 0 then NewState(n,2) end
	if newState[n] == 2 and math.abs(Ax[n]) > .1 then NewState(n,1) end
	if math.abs(state[n]) < 4 or newState[n] > 4 then UpdateState(n) end
end

queueState = {'Sprint','Walk','Stand','Wall','Jump2','Jump1','Jump3'}

function UpdateState(n)
	if class[n] ~= 1 then return end
	if newState[n] == 8 then newState[n] = state[n] end
	if math.abs(newState[n]) ~= 4 then
		if Ax[n] < 0 then newState[n] = -1*math.abs(newState[n]) end
		if Ax[n] == 0 and state[n] < 0 then newState[n] = -1*math.abs(newState[n]) end
	end   
	if math.abs(newState[n]) < 4 then
		if Ax[n] == 0 and Vx[n] < 0 then newState[n] = -1*math.abs(newState[n]) end
		if Ax[n] == 0 and Vx[n] > 0 then newState[n] = math.abs(newState[n]) end
	end
	if newState[n] ~= state[n] then
		CheckSplash(n)
		state[n] = newState[n]
		if state[n] > 0 then Object[n]:sleep(0) Object[n]:rotationy(0) else Object[n]:sleep(0) Object[n]:rotationy(180) end
		Object[n]:queuecommand(queueState[math.abs(state[n])])
	elseif math.abs(state[n]) < 3 and trail[n] ~= 0 then
		CheckSplash(n)
	end
	newState[n] = 8
end



--Splashes:
--Splash 1 = sprint trail
--Splash 2 = place holder for walk trail
--Splash 3 = jump trail
--Splash 4 = wall jump trail
--Splash 5 = ground splash
--Splash 6 = wall splash

function CheckSplash(n)
	splash[n] = 0
	if math.abs(state[n]) == 1 and math.abs(newState[n]) ~= 4 then splash[n] = 1 end
	if math.abs(state[n]) == 2 and math.abs(newState[n]) ~= 4 then splash[n] = 1 end
	if math.abs(state[n]) < 4 and math.abs(newState[n]) > 4 and armSplash[n] == 1 then splash[n] = 3 end
	if math.abs(state[n]) == 4 and math.abs(newState[n]) > 4 and armSplash[n] == 1 then splash[n] = 4 end
	if math.abs(state[n]) > 4 and math.abs(newState[n]) < 4 then splash[n] = 5 end
	if math.abs(state[n]) > 4 and math.abs(newState[n]) == 4 then splash[n] = 6 end
	if (newState[n] < 0 and state[n] ~= 4) or state[n] == -4 then splash[n] = -1*splash[n] end
	if splash[n] ~= 0 then MESSAGEMAN:Broadcast('Splash') end
	armSplash[n] = 0
end

function CheckInteractions(n)
	if class[n] ~= 1 then return end
	Interact(n,class1)
	Interact(n,class2)
	Interact(n,class4)
	Interact(n,class5)
	Interact(n,class6)
end
   
interactCommand = {'Hero','Goal','Ground','Obstacle','Obstacle','Item'}

function Interact(n,c)
	for i,k in ipairs(c) do
		if Collide(n,k) then
			Object[n]:queuecommand(interactCommand[class[k]])
			Object[k]:queuecommand(interactCommand[class[n]])
		end
	end
end

function Collide(n,k)
	if number(Dx[n]+Sx2[n]) > number(Dx[k]+Sx1[k]) and number(Dx[n]+Sx1[n]) < number(Dx[k]+Sx2[k]) and number(Dy[n]+Sy2[n]) > number(Dy[k]+Sy1[k]) and number(Dy[n]+Sy1[n]) < number(Dy[k]+Sy2[k]) then return true end
	return false
end

function CheckGround(n)
	if class[n] ~= 1 and class[n] ~= 5 and class[n] ~= 6 then return end
	checkGround = {}; x = Dx[n]; y = Dy[n]; GroundTable(n)
	for i,k in ipairs(class3) do if Collide(n,k) then checkGround[table.getn(checkGround)+1] = k end end
	if table.getn(collideLevel) ~= 0 or table.getn(checkGround) ~= 0 then
		Object[n]:queuecommand('Ground')
		Gx = Dx[n]; Gy = Dy[n]
		for i,k in ipairs(collideLevel) do
			if number(Dx[n] + Sx2[n] - Vx[n]*blockSize) <= number(k[1]) then Gx = math.min(k[1] - Sx2[n],Gx) end
			if number(Dx[n] + Sx1[n] - Vx[n]*blockSize) >= number(k[2]) then Gx = math.max(k[2] - Sx1[n],Gx) end
			if number(Dy[n] + Sy2[n] - Vy[n]*blockSize) <= number(k[3]) then Gy = math.min(k[3] - Sy2[n],Gy) end	   
			if number(Dy[n] + Sy1[n] - Vy[n]*blockSize) >= number(k[4]) then Gy = math.max(k[4] - Sy1[n],Gy) end
		end
		for i,k in ipairs(checkGround) do 
			if number(Dx[n] + Sx2[n] - Vx[n]*blockSize) <= number(Dx[k] + Sx1[k] - Vx[k]*blockSize) then Nx = Dx[k] + Sx1[k] - Sx2[n]; Gx = math.min(Nx,Gx) end
			if number(Dx[n] + Sx1[n] - Vx[n]*blockSize) >= number(Dx[k] + Sx2[k] - Vx[k]*blockSize) then Nx = Dx[k] + Sx2[k] - Sx1[n]; Gx = math.max(Nx,Gx) end
			if number(Dy[n] + Sy2[n] - Vy[n]*blockSize) <= number(Dy[k] + Sy1[k] - Vy[k]*blockSize) then Ny = Dy[k] + Sy1[k] - Sy2[n]; Gy = math.min(Ny,Gy) end		
			if number(Dy[n] + Sy1[n] - Vy[n]*blockSize) >= number(Dy[k] + Sy2[k] - Vy[k]*blockSize) then Ny = Dy[k] + Sy2[k] - Sy1[n]; Gy = math.max(Ny,Gy) end
		end
		Dy[n] = Gy; GroundTable(n)
		if table.getn(collideLevel) ~= 0 then Dx[n] = Gx; Dy[n] = y; GroundTable(n) end
		if table.getn(collideLevel) ~= 0 then Dy[n] = Gy end

		for i,k in ipairs(touchLevel) do
			Nx = Vx[n]; Ny = Vy[n]
				if number(Dy[n] + Sy2[n]) == number(k[3]) then Ny = math.min(Ny,-Vy[n]*bounce[n]); NewState(n,3)
			elseif number(Dx[n] + Sx2[n]) == number(k[1]) then Nx = math.min(Nx,-Vx[n]*bounce[n]); NewState(n,-4)
			elseif number(Dx[n] + Sx1[n]) == number(k[2]) then Nx = math.max(Nx,-Vx[n]*bounce[n]); NewState(n,4)
			elseif number(Dy[n] + Sy1[n]) == number(k[4]) then Ny = math.max(Ny,-Vy[n]*bounce[n]); NewState(n,7)
			end
			Vx[n] = Nx; Vy[n] = Ny
		end
		for i,k in ipairs(checkGround) do 
			Nx = Vx[n]; Ny = Vy[n]
				if number(Dy[n] + Sy2[n]) == number(Dy[k] + Sy1[k]) then Ny = math.min(Ny,-Vy[n]*bounce[n]); NewState(n,3); Object[k]:queuecommand(interactCommand[class[n]])
			elseif number(Dx[n] + Sx2[n]) == number(Dx[k] + Sx1[k]) then Nx = math.min(Nx,-Vx[n]*bounce[n]); NewState(n,-4); Object[k]:queuecommand(interactCommand[class[n]])
			elseif number(Dx[n] + Sx1[n]) == number(Dx[k] + Sx2[k]) then Nx = math.max(Nx,-Vx[n]*bounce[n]); NewState(n,4); Object[k]:queuecommand(interactCommand[class[n]])
			elseif number(Dy[n] + Sy1[n]) == number(Dy[k] + Sy2[k]) then Ny = math.max(Ny,-Vy[n]*bounce[n]); NewState(n,7); Object[k]:queuecommand(interactCommand[class[n]])
			end
			Vx[n] = Nx; Vy[n] = Ny
		end
	end
	for i,k in ipairs(touchLevel) do
			if number(Dx[n] + Sx2[n]) == number(k[1]) and number(Dy[n]+Sy2[n]) > number(k[3]) and number(Dy[n]+Sy1[n]) < number(k[4]) then NewState(n,-4)
		elseif number(Dx[n] + Sx1[n]) == number(k[2]) and number(Dy[n]+Sy2[n]) > number(k[3]) and number(Dy[n]+Sy1[n]) < number(k[4]) then NewState(n,4)
		end
	end
	for i,k in ipairs(class3) do 
			if number(Dx[n] + Sx2[n]) == number(Dx[k] + Sx1[k]) and number(Dy[n]+Sy2[n]) > number(Dy[k]+Sy1[k]) and number(Dy[n]+Sy1[n]) < number(Dy[k]+Sy2[k]) then NewState(n,-4); Object[k]:queuecommand(interactCommand[class[n]])
		elseif number(Dx[n] + Sx1[n]) == number(Dx[k] + Sx2[k]) and number(Dy[n]+Sy2[n]) > number(Dy[k]+Sy1[k]) and number(Dy[n]+Sy1[n]) < number(Dy[k]+Sy2[k]) then NewState(n,4); Object[k]:queuecommand(interactCommand[class[n]])
		end
	end
end

function GroundTable(n)

	local c = {	math.floor(number((Dx[n] + Sx1[n] - blockXOffset)/blockSize + .5)),
				math.ceil(number((Dx[n] + Sx2[n] - blockXOffset)/blockSize - .5)),
				math.floor(number((Dy[n] + Sy1[n] - blockYOffset)/blockSize + .5)),
				math.ceil(number((Dy[n] + Sy2[n] - blockYOffset)/blockSize - .5))}

	Tracker = c
	touchLevel = {}
	collideLevel = {}

	for i=c[1], c[2] do
		for j=c[3], c[4] do
			if not LevelOpen(i,j) then
				collideLevel[table.getn(collideLevel)+1] = {
					blockSize*(i - .5) + blockXOffset,
					blockSize*(i + .5) + blockXOffset,
					blockSize*(j - .5) + blockYOffset,
					blockSize*(j + .5) + blockYOffset,
					i,j}
			end
		end
	end

	for i=c[1]-1, c[2]+1 do
		for j=c[3]-1, c[4]+1 do
			if not LevelOpen(i,j) then
				touchLevel[table.getn(touchLevel)+1] = {
					blockSize*(i - .5) + blockXOffset,
					blockSize*(i + .5) + blockXOffset,
					blockSize*(j - .5) + blockYOffset,
					blockSize*(j + .5) + blockYOffset,
					i,j}
			end
		end
	end
	for i,k in ipairs(checkGround) do if Collide(n,k) then collideLevel[table.getn(collideLevel)+1] = {-1,-1,-1,-1,-1,-1} end end
end 