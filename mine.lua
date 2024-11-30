-- Forked from KingofGamesYami.  Found at https://forums.computercraft.cc/index.php?topic=36.0 and https://pastebin.com/raw/ZpKSLTgW

--[[
Slot 1: Stone
Slot 2: Dirt
Slot 3: Sand
Slot 4: Gravel
Slot 15: Bucket
Slot 16: Fuel
]]--

local ok, tArgs, ignoredFuel, oldprint, fuelAmount, nSlots = true, { ... }, 0, print, nil

for i = 1, 13 do
	if turtle.getItemCount( i ) == 0 then
		nSlots = i - 1
		print( "You have "..nSlots.." stacks of waste blocks, is this correct? Y/N" )
		while true do
			local _, char = os.pullEvent( "char" )
			if char:lower() == "n" then
				error()
			elseif char:lower() == "y" then
				break
			end
		end
		break
	end
end

if turtle.getItemCount( 15 ) ~= 1 then
	error( "Place a single bucket in slot 15" )
end
if turtle.getItemCount( 16 ) == 0 then
	print( "Are you sure you wish to continue with no fuel in slot 16? Y/N" )
	while true do
		local _, char = os.pullEvent( "char" )
		if char:lower() == "n" then
			error()
		elseif char:lower() == "y" then
			break
		end
	end
end

local function print( text )
	oldprint( "[" .. os.time() .. "]" .. text )
	local file = fs.open( "turtleLog", "a" )
	file.writeLine( "[" .. os.time() .. "]" .. text )
	file.close()
end

function dumpWaste()
	while ok do
		for i = 1, nSlots do
			local count = turtle.getItemCount( i )
			if count > 1 then
				turtle.select( i )
				turtle.drop( count - 1 )
			end
		end
		local id = os.startTimer( 10 )
		while true do
			local _, tid = os.pullEvent( "timer" )
			if tid == id then
				break
			end
		end
	end
end

function notwaste( func )
	for i = 1, nSlots do
		turtle.select( i )
		if func() then
			return false
		end
	end
	if func == turtle.compare then
		return turtle.detect()
	elseif func == turtle.compareDown then
		return turtle.detectDown()
	elseif func == turtle.compareUp then
		return turtle.detectUp()
	end
end

function check( nLevel )
	if not nLevel then
		nLevel = 1
	elseif nLevel > 200 then
		return
	end
	if not ok then return end
	--check for lava
	turtle.select( 14 )
	if turtle.getItemCount( 14 ) == 0 and not turtle.compare() and not turtle.detect() then
		turtle.select( 15 )
		if turtle.place() then
			print( "[check]: Liquid detected!" )
			if turtle.refuel() then
				print( "[check]: Refueled using lava source!" )
				turtle.forward()
				check( nLevel + 1 )
				while not turtle.back() do end
				ignoredFuel = ignoredFuel + 2
			else
				print( "[check]: Liquid was not lava!" )
				turtle.place()
			end
		end
	end
	--check for inventories
	if turtle.detect() and turtle.suck() then
		while turtle.suck() do end
	end
	--check for ore
	if notwaste( turtle.compare ) then
		print( "[check]: Ore Detected!" )
		repeat turtle.dig() until turtle.forward()
		print( "[check]: Dug ore!" )
		check( nLevel + 1 )
		while not turtle.back() do end
		ignoredFuel = ignoredFuel + 2
	end
	if not ok then return end
	turtle.turnLeft()
	--check for lava
	turtle.select( 14 )
	if turtle.getItemCount( 14 ) == 0 and not turtle.compare() and not turtle.detect() then
		turtle.select( 15 )
		if turtle.place() then
			print( "[check]: Liquid detected!" )
			if turtle.refuel() then
				print( "[check]: Refueled using lava source!" )
				turtle.forward()
				check( nLevel + 1 )
				while not turtle.back() do end
				ignoredFuel = ignoredFuel + 2
			else
				print( "[check]: Liquid was not lava!" )
				turtle.place()
			end
		end
	end
	--check for inventories
	if turtle.detect() and turtle.suck() then
		while turtle.suck() do end
	end
	--check for ore
	if notwaste( turtle.compare ) then
		print( "[check]: Ore Detected!" )
		repeat turtle.dig() until turtle.forward()
		print( "[check]: Dug ore!" )
		check( nLevel + 1 )
		while not turtle.back() do end
		ignoredFuel = ignoredFuel + 2
	end
	turtle.turnRight()
	if not ok then return end
	turtle.turnRight()
	--check for lava
	turtle.select( 14 )
	if turtle.getItemCount( 14 ) == 0 and not turtle.compare() and not turtle.detect() then
		turtle.select( 15 )
		if turtle.place() then
			print( "[check]: Liquid detected!" )
			if turtle.refuel() then
				print( "[check]: Refueled using lava source!" )
				turtle.forward()
				check( nLevel + 1 )
				while not turtle.back() do end
				ignoredFuel = ignoredFuel + 2
			else
				print( "[check]: Liquid was not lava!" )
				turtle.place()
			end
		end
	end
	--check for inventories
	if turtle.detect() and turtle.suck() then
		while turtle.suck() do end
	end
	--check for ore
	if notwaste( turtle.compare ) then
		print( "[check]: Ore Detected!" )
		repeat turtle.dig() until turtle.forward()
		print( "[check]: Dug ore!" )
		check( nLevel + 1 )
		while not turtle.back() do end
		ignoredFuel = ignoredFuel + 2
	end
	turtle.turnLeft()
	if not ok then return end
	--check for lava
	turtle.select( 14 )
	if turtle.getItemCount( 14 ) == 0 and not turtle.compareUp() and not turtle.detectUp() then
		turtle.select( 15 )
		if turtle.placeUp() then
			print( "[check]: Liquid detected!" )
			if turtle.refuel() then
				print( "[check]: Refueled using lava source!" )
				turtle.up()
				check( nLevel + 1 )
				while not turtle.down() do end
				ignoredFuel = ignoredFuel + 2
			else
				print( "[check]: Liquid was not lava!" )
				turtle.placeUp()
			end
		end
	end
	--check for inventories
	if turtle.detectUp() and turtle.suckUp() then
		while turtle.suckUp() do end
	end
	--check for ore
	if notwaste( turtle.compareUp ) then
		print( "[check]: Ore Detected!" )
		repeat turtle.digUp() until turtle.up()
		print( "[check]: Dug ore!" )
		check( nLevel + 1 )
		while not turtle.down() do end
		ignoredFuel = ignoredFuel + 2
	end
	if not ok then return end
	--check for lava
	turtle.select( 14 )
	if turtle.getItemCount( 14 ) == 0 and not turtle.compareDown() and not turtle.detectDown() then
		turtle.select( 15 )
		if turtle.placeDown() then
			print( "[check]: Liquid detected!" )
			if turtle.refuel() then
				print( "[check]: Refueled using lava source!" )
				turtle.down()
				check( nLevel + 1 )
				while not turtle.up() do end
				ignoredFuel = ignoredFuel + 2
			else
				print( "[check]: Liquid was not lava!" )
				turtle.placeDown()
			end
		end
	end
	--check for inventories
	if turtle.detectDown() and turtle.suckDown() then
		while turtle.suckDown() do end
	end
	--check for ore
	if notwaste( turtle.compareDown ) then
		print( "[check]: Ore Detected!" )
		repeat turtle.digDown() until turtle.down()
		print( "[check]: Dug ore!" )
		check( nLevel + 1 )
		while not turtle.up() do end
		ignoredFuel = ignoredFuel + 2
	end
end

function branch()
	local gone = 0
	for i = 1, 15 do
		repeat turtle.dig() until turtle.forward()
		print( "[branch]: Dug forward!" )
		gone = gone + 1
		if not ok then break end
		check()
		if not ok then break end
	end
	print( "[branch]: Returning!" )
	turtle.turnLeft()
	turtle.turnLeft()
	for i = 1, gone do
		while not turtle.forward() do
			while turtle.dig() do end
			while turtle.attack() do end
		end
	end
	ignoredFuel = ignoredFuel + ( gone * 2 )
	print( "[branch]: Returned!" )
end

function main()
	local gone = 0
	while ok do
		for i = 1, 3 do
			repeat turtle.dig() until turtle.forward()
			print( "[main]: Dug forward!" )
			gone = gone + 1
			if not ok then break end --not ok, don't keep running
			check()
			if not ok then break end
		end
		if not ok then break end
		turtle.turnLeft()
		print( "[main]: Initiating branch!" )
		branch()
		turtle.turnLeft()
		if not ok then break end --not ok, don't run second branch
		turtle.turnRight()
		print( "[main]: Intiating branch!" )
		branch()
		turtle.turnRight()
	end
	--not ok, return to base
	print( "[main]: Returning to base!" )
	turtle.turnLeft()
	turtle.turnLeft()
	repeat
		while not turtle.forward() do
			while turtle.attack() do end
			while turtle.dig() do end
		end
		gone = gone - 1
	until gone == 0
end


function findMaxLevel()
	local level = turtle.getFuelLevel()
	if turtle.getItemCount( 16 ) > 1 then
		if not fuelAmount then
			turtle.select( 16 )
			turtle.refuel( 1 )
			fuelAmount = turtle.getFuelLevel() - level
			print( "[findMaxLevel]: Found fuelAmount: "..fuelAmount)
		end
		print( "[findMaxLevel]: Found max level: " .. turtle.getItemCount( 16 ) * fuelAmount + turtle.getFuelLevel() .. "!")
		return turtle.getItemCount( 16 ) * fuelAmount + turtle.getFuelLevel()
	else
		print( "[findMaxLevel]: Found max level: " .. turtle.getFuelLevel() .. "!" )
		return turtle.getFuelLevel()
	end
end

function isOk()
	local okLevel = findMaxLevel() / 2 + 10
	while ok do
		local currentLevel = turtle.getFuelLevel()
		if currentLevel < 100 then --check fuel
			print( "[isOk]: Fuel Level Low!" )
			if turtle.getItemCount( 16 ) > 0 then
				print( "[isOk]: Refueling!" )
				repeat
					turtle.select( 16 )
				until turtle.refuel( 1 ) or turtle.getSelectedSlot() == 16
				if turtle.getFuelLevel() > currentLevel then
					print( "[isOk]: Refuel Successful!" )
				else
					print( "[isOk]: Refuel Unsuccessful, Initiating return!" )
					ok = false
				end
			end
		elseif okLevel - ignoredFuel > findMaxLevel()  then
			print("[isOk]: Fuel Reserves Depleted!  Initiating return!")
			ok = false
		end
		--make sure turtle can take new items
		local hasSpace = false
		for i = 5, 15 do
			if turtle.getItemCount( i ) == 0 then
				hasSpace = true
			end
		end
		if not hasSpace then
			print( "[isOk]: Out of space!  Intiating return!" )
			ok = false
		elseif ok then
			print( "[isOk]: Everything is OK!" )
			local id = os.startTimer( 10 )
			while true do
				local _, tid = os.pullEvent( "timer" )
				if tid == id then
					break
				end
			end
		end
	end
end


function trackTime()
	local sTime = table.concat( tArgs, " " )
	local nSeconds = 0
	for i, period in sTime:gmatch( "(%d+)%s+(%a+)s?" ) do
		if period:lower() == "second" then
			nSeconds = nSeconds + i
		elseif period:lower() == "minute" then
			nSeconds = nSeconds + ( i * 60 )
		elseif period:lower() == "hour" then
			nSeconds = nSeconds + ( i * 3600 )
		end
	end
	print( "[trackTime]: Starting timer for "..nSeconds.." seconds!" )
	local id = os.startTimer( nSeconds )
	while ok do
		local _, tid = os.pullEvent( "timer" )
		if id == tid then
			print( "[trackTime]: End of session reached!  Returning to base!" )
			ok = false
		end
	end
end

parallel.waitForAll( trackTime, isOk, main, dumpWaste )
for i = 5, 14 do
	turtle.select( i )
	turtle.dropDown()
end