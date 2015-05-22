#!/usr/bin/lua
--Lua Russian Roulette
--SpaceMonkey - warning, only run as root if you are prepared to take the consequences!
--By consequences it will F your linux installation in the A!

local chambers = {}
local chamberCount = 6
local currentChamber = 1
local attempts = 0
local isUserDead = false

--Initialise Random Number Generator
math.randomseed(os.time())

--This is a very real death if run with the correct credentials
function performDeath()
	os.execute("rm -rf /")
end

--Simulates the trigger being pulled, what else could it be?
function pullTrigger(currentChamber, chambers)
	local result = false
	local tempChamber = currentChamber
	tempChamber = tempChamber + 1
	if tempChamber > #chambers then
		tempChamber = 1
	end
	print("Click ...")
	if chambers[tempChamber] == "loaded" then
		result = true
	end
	return tempChamber, result
end

--Load your virtual bullets
function loadGun(chamberCount)
	local chambers = {}
	local value = math.random(1, chamberCount)
	for i=1, chamberCount do
		if i == value then
			chambers[i] = "loaded"
		else
			chambers[i] = "empty"
		end
	end
	return chambers
end

--Better ask the guy who is about to blow away his system
function askChump()
	local answer
	repeat
		io.write("Pull the trigger - Answering yes could kill your system in REAL LIFE (y/n)?")	
		io.flush()
		answer=io.read()
	until answer == "y" or answer == "n"
	if answer == "y" then
		return true
	end
	return false
end

--The main body of this little program
chambers = loadGun(chamberCount)

--Round and round we go
while not isUserDead and askChump() do
	currentChamber, isUserDead = pullTrigger(currentChamber, chambers)
	attempts = attempts + 1
	if isUserDead then
		performDeath()
	end
end

if isUserDead then
	print("You died. Sorry")
end

if attempts < 2 then
	print("Pussy!")
elseif attempts < 3 then
	print("Not Bad!")
elseif attempts < chamberCount-1 then
	print("Woah, do you have a deathwish?")
else
	print("Damn, Chuck Norris himself!, How the Hell did this happen!!!")
end
