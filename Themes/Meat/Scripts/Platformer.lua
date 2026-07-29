function Initialize(s,x,y) --Declare variables as lists.
	ITGMeatPlat.Ax = {}			-- Acceleration in X direction
	ITGMeatPlat.Ay = {}			-- Acceleration in Y direction
	ITGMeatPlat.Vx = {}			-- Velocity in X direction
	ITGMeatPlat.Vy = {}			-- Velocity in Y direction
	ITGMeatPlat.Dx = {}			-- Destination in X direction
	ITGMeatPlat.Dy = {}			-- Destination in Y direction
	ITGMeatPlat.Sx1 = {}		-- Size in X direction, left of center
	ITGMeatPlat.Sy1 = {}		-- Size in Y direction, above center
	ITGMeatPlat.Sx2 = {}		-- Size in X direction, right of center
	ITGMeatPlat.Sy2 = {}		-- Size in Y direction, below center
	ITGMeatPlat.var = {}		-- For Condition Check, which parameter to compare
	ITGMeatPlat.con = {}		-- For Condition Check, what type of comparison
	ITGMeatPlat.val = {}		-- For Condition Check, value to compare with
	ITGMeatPlat.cmd = {}		-- For Condition Check, command to play when condition is met
	ITGMeatPlat.state = {}		-- Track state to avoid changing unless change is needed
	ITGMeatPlat.newState = {}	-- Check current conditions to compare with current state to see if change is needed
	ITGMeatPlat.splash = {}		-- Decides if any splash or trail animation is needed based on changing states
	ITGMeatPlat.armSplash = {}	-- Limits Jumping trails to happen only when actually jumping, not when sliding up past the top of a wall
	ITGMeatPlat.trail = {}		-- Indexes sprinting trail to allow multiple to play properly
	ITGMeatPlat.bounce = {}		-- How an object bounces when it hits ground
	ITGMeatPlat.stop = {}		-- Tells object to stop moving.
	ITGMeatPlat.lock = {}		-- Used to guarantee that an object is only moved by 1 move command at a time.
	ITGMeatPlat.Object = {}		-- Allows object to be called without carrying around 'self'
	ITGMeatPlat.class = {}		-- To track the class number by index number
	ITGMeatPlat.class1 = {}		-- For use with ipairs. Tracks all Hero objects
	ITGMeatPlat.class2 = {}		-- For use with ipairs. Tracks all Goal objects
	ITGMeatPlat.class3 = {}		-- For use with ipairs. Tracks all Ground objects
	ITGMeatPlat.class4 = {}		-- For use with ipairs. Tracks all Obstacle objects that do not interact with ground
	ITGMeatPlat.class5 = {}		-- For use with ipairs. Tracks all Obstacle objects that do interact with ground
	ITGMeatPlat.class6 = {}		-- For use with ipairs. Tracks all Item objects
	ITGMeatPlat.blockSize = s
	ITGMeatPlat.blockXOffset = x
	ITGMeatPlat.blockYOffset = y
	ITGMeatPlat.G = 1/30
end

function QuadFromRegister(self,k,c)
		if c == 1 then ITGMeatGlob.n = ITGMeatPlat.class1[k]; self:diffuse(1,0,0,.5)
	elseif c == 2 then ITGMeatGlob.n = ITGMeatPlat.class2[k]; self:diffuse(1,.7,.7,.5)
	elseif c == 3 then ITGMeatGlob.n = ITGMeatPlat.class3[k]; self:diffuse(0,1,.5,.5)
	elseif c == 4 then ITGMeatGlob.n = ITGMeatPlat.class4[k]; self:diffuse(1,0,1,.5)
	elseif c == 5 then ITGMeatGlob.n = ITGMeatPlat.class5[k]; self:diffuse(1,.5,0,.5)
	elseif c == 6 then ITGMeatGlob.n = ITGMeatPlat.class6[k]; self:diffuse(0,1,0,.5)
	elseif c == 7 then ITGMeatGlob.n = class7[k]; self:diffuse(1,1,1,.5)
	end
	if ITGMeatGlob.n then
		self:stretchto(ITGMeatPlat.Sx1[ITGMeatGlob.n]+ITGMeatPlat.Dx[ITGMeatGlob.n],ITGMeatPlat.Sy1[ITGMeatGlob.n]+ITGMeatPlat.Dy[ITGMeatGlob.n],ITGMeatPlat.Sx2[ITGMeatGlob.n]+ITGMeatPlat.Dx[ITGMeatGlob.n],ITGMeatPlat.Sy2[ITGMeatGlob.n]+ITGMeatPlat.Dy[ITGMeatGlob.n])
	else
		self:zoom(0)
	end
end

function Register(self,x1,y1,x2,y2,c)	 -- Populate list
	ITGMeatGlob.n = table.getn(ITGMeatPlat.class)+1
	ITGMeatPlat.Object[ITGMeatGlob.n] = self
	ITGMeatPlat.class[ITGMeatGlob.n] = c
		if c == 1 then ClassTable(ITGMeatPlat.class1,ITGMeatGlob.n)
	elseif c == 2 then ClassTable(ITGMeatPlat.class2,ITGMeatGlob.n)
	elseif c == 3 then ClassTable(ITGMeatPlat.class3,ITGMeatGlob.n)
	elseif c == 4 then ClassTable(ITGMeatPlat.class4,ITGMeatGlob.n)
	elseif c == 5 then ClassTable(ITGMeatPlat.class5,ITGMeatGlob.n)
	elseif c == 6 then ClassTable(ITGMeatPlat.class6,ITGMeatGlob.n)
	end
	ITGMeatPlat.Vx[ITGMeatGlob.n] = 0
	ITGMeatPlat.Vy[ITGMeatGlob.n] = 0
	ITGMeatPlat.Ax[ITGMeatGlob.n] = 0
	ITGMeatPlat.Ay[ITGMeatGlob.n] = 0   
	ITGMeatPlat.Dx[ITGMeatGlob.n] = self:GetX()
	ITGMeatPlat.Dy[ITGMeatGlob.n] = self:GetY()
	ITGMeatPlat.Sx1[ITGMeatGlob.n] = math.min(x1,x2)
	ITGMeatPlat.Sy1[ITGMeatGlob.n] = math.min(y1,y2)
	ITGMeatPlat.Sx2[ITGMeatGlob.n] = math.max(x1,x2)
	ITGMeatPlat.Sy2[ITGMeatGlob.n] = math.max(y1,y2)
	ITGMeatPlat.state[ITGMeatGlob.n] = 3
	ITGMeatPlat.newState[ITGMeatGlob.n] = 8
	ITGMeatPlat.trail[ITGMeatGlob.n] = 1
	ITGMeatPlat.splash[ITGMeatGlob.n] = 0
	ITGMeatPlat.bounce[ITGMeatGlob.n] = 0
	self:z(ITGMeatGlob.n)
end

function RegisterHero(self)
	Register(self,math.floor(-.42*ITGMeatPlat.blockSize),math.floor(-.25*ITGMeatPlat.blockSize),math.floor(.42*ITGMeatPlat.blockSize),math.floor(.62*ITGMeatPlat.blockSize),1)
end

function RegisterGoal(self)
	Register(self,math.floor(-.9*ITGMeatPlat.blockSize),math.floor(-.25*ITGMeatPlat.blockSize),math.floor(.9*ITGMeatPlat.blockSize),math.floor(.8*ITGMeatPlat.blockSize),2)
end

function RegisterGround(self,i,j)
	self:zoomtowidth(ITGMeatPlat.blockSize)
	self:zoomtoheight(ITGMeatPlat.blockSize)
	self:x(ITGMeatPlat.blockSize*i+ITGMeatPlat.blockXOffset)
	self:y(ITGMeatPlat.blockSize*j+ITGMeatPlat.blockYOffset)
	Register(self,-ITGMeatPlat.blockSize/2,-ITGMeatPlat.blockSize/2,ITGMeatPlat.blockSize/2,ITGMeatPlat.blockSize/2,3)
end


function BuildLevel(self,i,j)
	if ITGMeatGlob.levelMapR[j][i] < 0 then self:rotationy(180) end
	self:rotationz(90*math.abs(ITGMeatGlob.levelMapR[j][i]))
	self:zoomtowidth(ITGMeatPlat.blockSize)
	self:zoomtoheight(ITGMeatPlat.blockSize)
	self:x(ITGMeatPlat.blockSize*i+ITGMeatPlat.blockXOffset)
	self:y(ITGMeatPlat.blockSize*j+ITGMeatPlat.blockYOffset)
end

function BuildLeft(self,i,j)
	if leftMapR[j][i] < 0 then self:rotationy(180) end
	self:rotationz(90*math.abs(leftMapR[j][i]))
	self:zoomtowidth(ITGMeatPlat.blockSize)
	self:zoomtoheight(ITGMeatPlat.blockSize)
	self:x(ITGMeatPlat.blockSize*(i-4)+ITGMeatPlat.blockXOffset)
	self:y(ITGMeatPlat.blockSize*j+ITGMeatPlat.blockYOffset)
end

function BuildRight(self,i,j)
	if rightMapR[j][i] < 0 then self:rotationy(180) end
	self:rotationz(90*math.abs(rightMapR[j][i]))
	self:zoomtowidth(ITGMeatPlat.blockSize)
	self:zoomtoheight(ITGMeatPlat.blockSize)
	self:x(ITGMeatPlat.blockSize*(i+table.getn(ITGMeatGlob.levelMap[1]))+ITGMeatPlat.blockXOffset)
	self:y(ITGMeatPlat.blockSize*j+ITGMeatPlat.blockYOffset)
end

function Remove(self)
	ITGMeatGlob.n = self:GetZ()
	ITGMeatPlat.Dx[ITGMeatGlob.n] = -1000
	ITGMeatPlat.Dy[ITGMeatGlob.n] = -1000
	ITGMeatPlat.stop[ITGMeatGlob.n] = 1
	if ITGMeatPlat.class[ITGMeatGlob.n] == 3 then for i,k in ipairs(ITGMeatPlat.class3) do if k == ITGMeatGlob.n then table.remove(ITGMeatPlat.class3,i) end end end
end

function Restore(self)
	ITGMeatGlob.n = self:GetZ()
	ITGMeatPlat.state[ITGMeatGlob.n] = 3
	self:finishtweening()
end

function ClassTable(c,n)
	for i,k in ipairs(c) do
		if k == n then return end
	end
	c[table.getn(c)+1] = n
end

function LevelGround(i,j) if ITGMeatGlob.levelMap[j] and ITGMeatGlob.levelMap[j][i] and ITGMeatGlob.levelMap[j][i] > 0 then return true else return false end end
function LevelBackground(i,j) if ITGMeatGlob.levelMap[j] and ITGMeatGlob.levelMap[j][i] and ITGMeatGlob.levelMap[j][i] < 0 then return true else return false end end
function LevelOpen(i,j) if j > 0 and i > 0 and ITGMeatGlob.levelMap[j] and ITGMeatGlob.levelMap[j][i] and ITGMeatGlob.levelMap[j][i] <= 0 then return true else return false end end

function BlockFile(i,j) return LevelType() ..'/World'..ITGMeatGlob.world..'/Level'..ITGMeatGlob.level..'/' .. math.abs(ITGMeatGlob.levelMap[j][i]) .. '.png' end
function LeftBlockFile(i,j) return LevelType() ..'/World'..ITGMeatGlob.world..'/Level'..ITGMeatGlob.level..'/' .. math.abs(leftMap[j][i]) .. '.png' end
function RightBlockFile(i,j) return LevelType() ..'/World'..ITGMeatGlob.world..'/Level'..ITGMeatGlob.level..'/' .. math.abs(rightMap[j][i]) .. '.png' end

function MoveITGMeat(self,xV,yV,xA,yA,a,b,c,d)
	ITGMeatGlob.n = self:GetZ()
	ITGMeatPlat.stop[ITGMeatGlob.n] = 0
	if xV ~= '' then ITGMeatPlat.Vx[ITGMeatGlob.n] = xV end
	if yV ~= '' then if yV < ITGMeatPlat.Vy[ITGMeatGlob.n] then ITGMeatPlat.armSplash[ITGMeatGlob.n] = 1 end ITGMeatPlat.Vy[ITGMeatGlob.n] = yV end
	if xA ~= '' then ITGMeatPlat.Ax[ITGMeatGlob.n] = xA end
	if yA ~= '' then ITGMeatPlat.Ay[ITGMeatGlob.n] = yA + ITGMeatPlat.G end
	if a then ITGMeatPlat.var[ITGMeatGlob.n] = a end
	if b then ITGMeatPlat.con[ITGMeatGlob.n] = b else ITGMeatPlat.con[ITGMeatGlob.n] = '' end
	if c then ITGMeatPlat.val[ITGMeatGlob.n] = c end
	if d then ITGMeatPlat.cmd[ITGMeatGlob.n] = d end
	ITGMeatPlat.Object[ITGMeatGlob.n]:queuecommand('Move')
end

function UpdateITGMeat(self)
	ITGMeatGlob.n = self:GetZ()
	if ITGMeatPlat.stop[ITGMeatGlob.n] == 1 then return end
	UpdateCoordinates(ITGMeatGlob.n)
	CheckGround(ITGMeatGlob.n)
	CheckState(ITGMeatGlob.n)
	Cx = ITGMeatPlat.Dx[ITGMeatGlob.n] - ITGMeatPlat.Object[ITGMeatGlob.n]:GetX()
	Cy = ITGMeatPlat.Dy[ITGMeatGlob.n] - ITGMeatPlat.Object[ITGMeatGlob.n]:GetY()
	ITGMeatPlat.Object[ITGMeatGlob.n]:linear(.03)	   
	ITGMeatPlat.Object[ITGMeatGlob.n]:addx(Cx)
	ITGMeatPlat.Object[ITGMeatGlob.n]:addy(Cy)
	UpdateState(ITGMeatGlob.n)
	CheckInteractions(ITGMeatGlob.n)
	CheckCondition(ITGMeatGlob.n)
end

function UpdateCoordinates(n)
	ITGMeatPlat.Vx[n] = ITGMeatPlat.Vx[n] + ITGMeatPlat.Ax[n]
	ITGMeatPlat.Vy[n] = ITGMeatPlat.Vy[n] + ITGMeatPlat.Ay[n]
	ITGMeatPlat.Vx[n] = clamp(ITGMeatPlat.Vx[n],-1,1)
	ITGMeatPlat.Dx[n] = ITGMeatPlat.Object[n]:GetX() + ITGMeatPlat.Vx[n]*ITGMeatPlat.blockSize
	ITGMeatPlat.Dy[n] = ITGMeatPlat.Object[n]:GetY() + ITGMeatPlat.Vy[n]*ITGMeatPlat.blockSize
end

function CheckCondition(n)
		if ITGMeatPlat.var[n] == 'Dx' then coord = ITGMeatPlat.Dx[n]
	elseif ITGMeatPlat.var[n] == 'Dy' then coord = ITGMeatPlat.Dy[n]
	elseif ITGMeatPlat.var[n] == 'Vx' then coord = ITGMeatPlat.Vx[n]
	elseif ITGMeatPlat.var[n] == 'Vy' then coord = ITGMeatPlat.Vy[n]
	elseif ITGMeatPlat.var[n] == 'state' then coord = math.abs(ITGMeatPlat.state[n])
	end
	queue = 'Move'
        if ITGMeatPlat.con[n] == '>' and coord >= ITGMeatPlat.val[n] and ITGMeatPlat.var[n] ~= 'state' then queue = 'Move'..ITGMeatPlat.cmd[n]
    elseif ITGMeatPlat.con[n] == '>' and coord > ITGMeatPlat.val[n] and ITGMeatPlat.var[n] == 'state' then queue = 'Move'..ITGMeatPlat.cmd[n]
    elseif ITGMeatPlat.con[n] == '<' and coord <= ITGMeatPlat.val[n] and ITGMeatPlat.var[n] ~= 'state' then queue = 'Move'..ITGMeatPlat.cmd[n]
    elseif ITGMeatPlat.con[n] == '<' and coord < ITGMeatPlat.val[n] and ITGMeatPlat.var[n] == 'state' then queue = 'Move'..ITGMeatPlat.cmd[n]
    elseif ITGMeatPlat.con[n] == '=' and coord == ITGMeatPlat.val[n] then queue = 'Move'..ITGMeatPlat.cmd[n]
    end
	ITGMeatPlat.Object[n]:queuecommand(queue)
end

function NewState(n,i)
	if math.abs(i) < math.abs(ITGMeatPlat.newState[n]) then ITGMeatPlat.newState[n] = i end
end

function CheckState(n)
	if ITGMeatPlat.class[n] ~= 1 then return end
	if ITGMeatPlat.Vy[n] < 0 then NewState(n,6) end
	if ITGMeatPlat.Vy[n] > 0 then NewState(n,7) end
	if ITGMeatPlat.Vy[n] > -.15 and ITGMeatPlat.Vy[n] < .15 then NewState(n,5) end
	if ITGMeatPlat.newState[n] == 3 and ITGMeatPlat.Vx[n] ~= 0 then NewState(n,2) end
	if ITGMeatPlat.newState[n] == 2 and math.abs(ITGMeatPlat.Vx[n]) > .25 then NewState(n,1) end
	if ITGMeatPlat.newState[n] == 3 and ITGMeatPlat.Ax[n] ~= 0 then NewState(n,2) end
	if ITGMeatPlat.newState[n] == 2 and math.abs(ITGMeatPlat.Ax[n]) > .1 then NewState(n,1) end
	if math.abs(ITGMeatPlat.state[n]) < 4 or ITGMeatPlat.newState[n] > 4 then UpdateState(n) end
end

queueState = {'Sprint','Walk','Stand','Wall','Jump2','Jump1','Jump3'}

function UpdateState(n)
	if ITGMeatPlat.class[n] ~= 1 then return end
	if ITGMeatPlat.newState[n] == 8 then ITGMeatPlat.newState[n] = ITGMeatPlat.state[n] end
	if math.abs(ITGMeatPlat.newState[n]) ~= 4 then
		if ITGMeatPlat.Ax[n] < 0 then ITGMeatPlat.newState[n] = -1*math.abs(ITGMeatPlat.newState[n]) end
		if ITGMeatPlat.Ax[n] == 0 and ITGMeatPlat.state[n] < 0 then ITGMeatPlat.newState[n] = -1*math.abs(ITGMeatPlat.newState[n]) end
	end   
	if math.abs(ITGMeatPlat.newState[n]) < 4 then
		if ITGMeatPlat.Ax[n] == 0 and ITGMeatPlat.Vx[n] < 0 then ITGMeatPlat.newState[n] = -1*math.abs(ITGMeatPlat.newState[n]) end
		if ITGMeatPlat.Ax[n] == 0 and ITGMeatPlat.Vx[n] > 0 then ITGMeatPlat.newState[n] = math.abs(ITGMeatPlat.newState[n]) end
	end
	if ITGMeatPlat.newState[n] ~= ITGMeatPlat.state[n] then
		CheckSplash(n)
		ITGMeatPlat.state[n] = ITGMeatPlat.newState[n]
		if ITGMeatPlat.state[n] > 0 then ITGMeatPlat.Object[n]:sleep(0) ITGMeatPlat.Object[n]:rotationy(0) else ITGMeatPlat.Object[n]:sleep(0) ITGMeatPlat.Object[n]:rotationy(180) end
		ITGMeatPlat.Object[n]:queuecommand(queueState[math.abs(ITGMeatPlat.state[n])])
	elseif math.abs(ITGMeatPlat.state[n]) < 3 and ITGMeatPlat.trail[n] ~= 0 then
		CheckSplash(n)
	end
	ITGMeatPlat.newState[n] = 8
end



--Splashes:
--Splash 1 = sprint trail
--Splash 2 = place holder for walk trail
--Splash 3 = jump trail
--Splash 4 = wall jump trail
--Splash 5 = ground splash
--Splash 6 = wall splash

function CheckSplash(n)
	ITGMeatPlat.splash[n] = 0
	if math.abs(ITGMeatPlat.state[n]) == 1 and math.abs(ITGMeatPlat.newState[n]) ~= 4 then ITGMeatPlat.splash[n] = 1 end
	if math.abs(ITGMeatPlat.state[n]) == 2 and math.abs(ITGMeatPlat.newState[n]) ~= 4 then ITGMeatPlat.splash[n] = 1 end
	if math.abs(ITGMeatPlat.state[n]) < 4 and math.abs(ITGMeatPlat.newState[n]) > 4 and ITGMeatPlat.armSplash[n] == 1 then ITGMeatPlat.splash[n] = 3 end
	if math.abs(ITGMeatPlat.state[n]) == 4 and math.abs(ITGMeatPlat.newState[n]) > 4 and ITGMeatPlat.armSplash[n] == 1 then ITGMeatPlat.splash[n] = 4 end
	if math.abs(ITGMeatPlat.state[n]) > 4 and math.abs(ITGMeatPlat.newState[n]) < 4 then ITGMeatPlat.splash[n] = 5 end
	if math.abs(ITGMeatPlat.state[n]) > 4 and math.abs(ITGMeatPlat.newState[n]) == 4 then ITGMeatPlat.splash[n] = 6 end
	if (ITGMeatPlat.newState[n] < 0 and ITGMeatPlat.state[n] ~= 4) or ITGMeatPlat.state[n] == -4 then ITGMeatPlat.splash[n] = -1*ITGMeatPlat.splash[n] end
	if ITGMeatPlat.splash[n] ~= 0 then MESSAGEMAN:Broadcast('Splash') end
	ITGMeatPlat.armSplash[n] = 0
end

function CheckInteractions(n)
	if ITGMeatPlat.class[n] ~= 1 then return end
	Interact(n,ITGMeatPlat.class1)
	Interact(n,ITGMeatPlat.class2)
	Interact(n,ITGMeatPlat.class4)
	Interact(n,ITGMeatPlat.class5)
	Interact(n,ITGMeatPlat.class6)
end
   
interactCommand = {'Hero','Goal','Ground','Obstacle','Obstacle','Item'}

function Interact(n,c)
	for i,k in ipairs(c) do
		if Collide(n,k) then
			ITGMeatPlat.Object[n]:queuecommand(interactCommand[ITGMeatPlat.class[k]])
			ITGMeatPlat.Object[k]:queuecommand(interactCommand[ITGMeatPlat.class[n]])
		end
	end
end

function Collide(n,k)
	if number(ITGMeatPlat.Dx[n]+ITGMeatPlat.Sx2[n]) > number(ITGMeatPlat.Dx[k]+ITGMeatPlat.Sx1[k]) and number(ITGMeatPlat.Dx[n]+ITGMeatPlat.Sx1[n]) < number(ITGMeatPlat.Dx[k]+ITGMeatPlat.Sx2[k]) and number(ITGMeatPlat.Dy[n]+ITGMeatPlat.Sy2[n]) > number(ITGMeatPlat.Dy[k]+ITGMeatPlat.Sy1[k]) and number(ITGMeatPlat.Dy[n]+ITGMeatPlat.Sy1[n]) < number(ITGMeatPlat.Dy[k]+ITGMeatPlat.Sy2[k]) then return true end
	return false
end

function CheckGround(n)
	if ITGMeatPlat.class[n] ~= 1 and ITGMeatPlat.class[n] ~= 5 and ITGMeatPlat.class[n] ~= 6 then return end
	checkGround = {}; x = ITGMeatPlat.Dx[n]; y = ITGMeatPlat.Dy[n]; GroundTable(n)
	for i,k in ipairs(ITGMeatPlat.class3) do if Collide(n,k) then checkGround[table.getn(checkGround)+1] = k end end
	if table.getn(collideLevel) ~= 0 or table.getn(checkGround) ~= 0 then
		ITGMeatPlat.Object[n]:queuecommand('Ground')
		Gx = ITGMeatPlat.Dx[n]; Gy = ITGMeatPlat.Dy[n]
		for i,k in ipairs(collideLevel) do
			if number(ITGMeatPlat.Dx[n] + ITGMeatPlat.Sx2[n] - ITGMeatPlat.Vx[n]*ITGMeatPlat.blockSize) <= number(k[1]) then Gx = math.min(k[1] - ITGMeatPlat.Sx2[n],Gx) end
			if number(ITGMeatPlat.Dx[n] + ITGMeatPlat.Sx1[n] - ITGMeatPlat.Vx[n]*ITGMeatPlat.blockSize) >= number(k[2]) then Gx = math.max(k[2] - ITGMeatPlat.Sx1[n],Gx) end
			if number(ITGMeatPlat.Dy[n] + ITGMeatPlat.Sy2[n] - ITGMeatPlat.Vy[n]*ITGMeatPlat.blockSize) <= number(k[3]) then Gy = math.min(k[3] - ITGMeatPlat.Sy2[n],Gy) end	   
			if number(ITGMeatPlat.Dy[n] + ITGMeatPlat.Sy1[n] - ITGMeatPlat.Vy[n]*ITGMeatPlat.blockSize) >= number(k[4]) then Gy = math.max(k[4] - ITGMeatPlat.Sy1[n],Gy) end
		end
		for i,k in ipairs(checkGround) do 
			if number(ITGMeatPlat.Dx[n] + ITGMeatPlat.Sx2[n] - ITGMeatPlat.Vx[n]*ITGMeatPlat.blockSize) <= number(ITGMeatPlat.Dx[k] + ITGMeatPlat.Sx1[k] - ITGMeatPlat.Vx[k]*ITGMeatPlat.blockSize) then Nx = ITGMeatPlat.Dx[k] + ITGMeatPlat.Sx1[k] - ITGMeatPlat.Sx2[n]; Gx = math.min(Nx,Gx) end
			if number(ITGMeatPlat.Dx[n] + ITGMeatPlat.Sx1[n] - ITGMeatPlat.Vx[n]*ITGMeatPlat.blockSize) >= number(ITGMeatPlat.Dx[k] + ITGMeatPlat.Sx2[k] - ITGMeatPlat.Vx[k]*ITGMeatPlat.blockSize) then Nx = ITGMeatPlat.Dx[k] + ITGMeatPlat.Sx2[k] - ITGMeatPlat.Sx1[n]; Gx = math.max(Nx,Gx) end
			if number(ITGMeatPlat.Dy[n] + ITGMeatPlat.Sy2[n] - ITGMeatPlat.Vy[n]*ITGMeatPlat.blockSize) <= number(ITGMeatPlat.Dy[k] + ITGMeatPlat.Sy1[k] - ITGMeatPlat.Vy[k]*ITGMeatPlat.blockSize) then Ny = ITGMeatPlat.Dy[k] + ITGMeatPlat.Sy1[k] - ITGMeatPlat.Sy2[n]; Gy = math.min(Ny,Gy) end		
			if number(ITGMeatPlat.Dy[n] + ITGMeatPlat.Sy1[n] - ITGMeatPlat.Vy[n]*ITGMeatPlat.blockSize) >= number(ITGMeatPlat.Dy[k] + ITGMeatPlat.Sy2[k] - ITGMeatPlat.Vy[k]*ITGMeatPlat.blockSize) then Ny = ITGMeatPlat.Dy[k] + ITGMeatPlat.Sy2[k] - ITGMeatPlat.Sy1[n]; Gy = math.max(Ny,Gy) end
		end
		ITGMeatPlat.Dy[n] = Gy; GroundTable(n)
		if table.getn(collideLevel) ~= 0 then ITGMeatPlat.Dx[n] = Gx; ITGMeatPlat.Dy[n] = y; GroundTable(n) end
		if table.getn(collideLevel) ~= 0 then ITGMeatPlat.Dy[n] = Gy end

		for i,k in ipairs(touchLevel) do
			Nx = ITGMeatPlat.Vx[n]; Ny = ITGMeatPlat.Vy[n]
				if number(ITGMeatPlat.Dy[n] + ITGMeatPlat.Sy2[n]) == number(k[3]) then Ny = math.min(Ny,-ITGMeatPlat.Vy[n]*ITGMeatPlat.bounce[n]); NewState(n,3)
			elseif number(ITGMeatPlat.Dx[n] + ITGMeatPlat.Sx2[n]) == number(k[1]) then Nx = math.min(Nx,-ITGMeatPlat.Vx[n]*ITGMeatPlat.bounce[n]); NewState(n,-4)
			elseif number(ITGMeatPlat.Dx[n] + ITGMeatPlat.Sx1[n]) == number(k[2]) then Nx = math.max(Nx,-ITGMeatPlat.Vx[n]*ITGMeatPlat.bounce[n]); NewState(n,4)
			elseif number(ITGMeatPlat.Dy[n] + ITGMeatPlat.Sy1[n]) == number(k[4]) then Ny = math.max(Ny,-ITGMeatPlat.Vy[n]*ITGMeatPlat.bounce[n]); NewState(n,7)
			end
			ITGMeatPlat.Vx[n] = Nx; ITGMeatPlat.Vy[n] = Ny
		end
		for i,k in ipairs(checkGround) do 
			Nx = ITGMeatPlat.Vx[n]; Ny = ITGMeatPlat.Vy[n]
				if number(ITGMeatPlat.Dy[n] + ITGMeatPlat.Sy2[n]) == number(ITGMeatPlat.Dy[k] + ITGMeatPlat.Sy1[k]) then Ny = math.min(Ny,-ITGMeatPlat.Vy[n]*ITGMeatPlat.bounce[n]); NewState(n,3); ITGMeatPlat.Object[k]:queuecommand(interactCommand[ITGMeatPlat.class[n]])
			elseif number(ITGMeatPlat.Dx[n] + ITGMeatPlat.Sx2[n]) == number(ITGMeatPlat.Dx[k] + ITGMeatPlat.Sx1[k]) then Nx = math.min(Nx,-ITGMeatPlat.Vx[n]*ITGMeatPlat.bounce[n]); NewState(n,-4); ITGMeatPlat.Object[k]:queuecommand(interactCommand[ITGMeatPlat.class[n]])
			elseif number(ITGMeatPlat.Dx[n] + ITGMeatPlat.Sx1[n]) == number(ITGMeatPlat.Dx[k] + ITGMeatPlat.Sx2[k]) then Nx = math.max(Nx,-ITGMeatPlat.Vx[n]*ITGMeatPlat.bounce[n]); NewState(n,4); ITGMeatPlat.Object[k]:queuecommand(interactCommand[ITGMeatPlat.class[n]])
			elseif number(ITGMeatPlat.Dy[n] + ITGMeatPlat.Sy1[n]) == number(ITGMeatPlat.Dy[k] + ITGMeatPlat.Sy2[k]) then Ny = math.max(Ny,-ITGMeatPlat.Vy[n]*ITGMeatPlat.bounce[n]); NewState(n,7); ITGMeatPlat.Object[k]:queuecommand(interactCommand[ITGMeatPlat.class[n]])
			end
			ITGMeatPlat.Vx[n] = Nx; ITGMeatPlat.Vy[n] = Ny
		end
	end
	for i,k in ipairs(touchLevel) do
			if number(ITGMeatPlat.Dx[n] + ITGMeatPlat.Sx2[n]) == number(k[1]) and number(ITGMeatPlat.Dy[n]+ITGMeatPlat.Sy2[n]) > number(k[3]) and number(ITGMeatPlat.Dy[n]+ITGMeatPlat.Sy1[n]) < number(k[4]) then NewState(n,-4)
		elseif number(ITGMeatPlat.Dx[n] + ITGMeatPlat.Sx1[n]) == number(k[2]) and number(ITGMeatPlat.Dy[n]+ITGMeatPlat.Sy2[n]) > number(k[3]) and number(ITGMeatPlat.Dy[n]+ITGMeatPlat.Sy1[n]) < number(k[4]) then NewState(n,4)
		end
	end
	for i,k in ipairs(ITGMeatPlat.class3) do 
			if number(ITGMeatPlat.Dx[n] + ITGMeatPlat.Sx2[n]) == number(ITGMeatPlat.Dx[k] + ITGMeatPlat.Sx1[k]) and number(ITGMeatPlat.Dy[n]+ITGMeatPlat.Sy2[n]) > number(ITGMeatPlat.Dy[k]+ITGMeatPlat.Sy1[k]) and number(ITGMeatPlat.Dy[n]+ITGMeatPlat.Sy1[n]) < number(ITGMeatPlat.Dy[k]+ITGMeatPlat.Sy2[k]) then NewState(n,-4); ITGMeatPlat.Object[k]:queuecommand(interactCommand[ITGMeatPlat.class[n]])
		elseif number(ITGMeatPlat.Dx[n] + ITGMeatPlat.Sx1[n]) == number(ITGMeatPlat.Dx[k] + ITGMeatPlat.Sx2[k]) and number(ITGMeatPlat.Dy[n]+ITGMeatPlat.Sy2[n]) > number(ITGMeatPlat.Dy[k]+ITGMeatPlat.Sy1[k]) and number(ITGMeatPlat.Dy[n]+ITGMeatPlat.Sy1[n]) < number(ITGMeatPlat.Dy[k]+ITGMeatPlat.Sy2[k]) then NewState(n,4); ITGMeatPlat.Object[k]:queuecommand(interactCommand[ITGMeatPlat.class[n]])
		end
	end
end

function GroundTable(n)

	local c = {	math.floor(number((ITGMeatPlat.Dx[n] + ITGMeatPlat.Sx1[n] - ITGMeatPlat.blockXOffset)/ITGMeatPlat.blockSize + .5)),
				math.ceil(number((ITGMeatPlat.Dx[n] + ITGMeatPlat.Sx2[n] - ITGMeatPlat.blockXOffset)/ITGMeatPlat.blockSize - .5)),
				math.floor(number((ITGMeatPlat.Dy[n] + ITGMeatPlat.Sy1[n] - ITGMeatPlat.blockYOffset)/ITGMeatPlat.blockSize + .5)),
				math.ceil(number((ITGMeatPlat.Dy[n] + ITGMeatPlat.Sy2[n] - ITGMeatPlat.blockYOffset)/ITGMeatPlat.blockSize - .5))}

	Tracker = c
	touchLevel = {}
	collideLevel = {}

	for i=c[1], c[2] do
		for j=c[3], c[4] do
			if not LevelOpen(i,j) then
				collideLevel[table.getn(collideLevel)+1] = {
					ITGMeatPlat.blockSize*(i - .5) + ITGMeatPlat.blockXOffset,
					ITGMeatPlat.blockSize*(i + .5) + ITGMeatPlat.blockXOffset,
					ITGMeatPlat.blockSize*(j - .5) + ITGMeatPlat.blockYOffset,
					ITGMeatPlat.blockSize*(j + .5) + ITGMeatPlat.blockYOffset,
					i,j}
			end
		end
	end

	for i=c[1]-1, c[2]+1 do
		for j=c[3]-1, c[4]+1 do
			if not LevelOpen(i,j) then
				touchLevel[table.getn(touchLevel)+1] = {
					ITGMeatPlat.blockSize*(i - .5) + ITGMeatPlat.blockXOffset,
					ITGMeatPlat.blockSize*(i + .5) + ITGMeatPlat.blockXOffset,
					ITGMeatPlat.blockSize*(j - .5) + ITGMeatPlat.blockYOffset,
					ITGMeatPlat.blockSize*(j + .5) + ITGMeatPlat.blockYOffset,
					i,j}
			end
		end
	end
	for i,k in ipairs(checkGround) do if Collide(n,k) then collideLevel[table.getn(collideLevel)+1] = {-1,-1,-1,-1,-1,-1} end end
end 