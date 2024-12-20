-- Author Lvl1Slime https://pastebin.com/raw/bkL6gaRv

-- get user input for parameters
 
print("Quarry length: ")
local l = tonumber(io.read())
print("Quarry width: ")
local w = tonumber(io.read())
print("Turtle Y: ")
local z0 = tonumber(io.read())
local listtype = 12
while(listtype ~= 1 and listtype ~= 0) do
    print("Whitelist y/n?")
    listtype = io.read()
    if(listtype == "yes" or listtype == "Yes" or listtype == "y" or listtype == "Y") then
        listtype = 1
    elseif(listtype == "no" or listtype == "No" or listtype == "n" or listtype == "N") then
        listtype = 0
    else
        print("Invalid answer, please type either yes or no")
    end
end
print("Do you want to dig the whole chunk, y/n?")
local dummy = io.read()
if dummy == "n" or dummy == "N" or dummy == "no" or dummy == "No" then
    print("Layers to dig?")
    fin = tonumber(io.read())
else fin = z0 end
 
-- set up variables
 
local x = 0
local y = 0
local z = 0
local rev = 1
local face = 0
local counter = 0
arr = {0} -- for trash removal
local cobble = false
local stone = false
local slot = 16
trashtable = {}
fuel = turtle.getItemDetail(16).name
 
-- define operational functions
 
function refuel() -- checks if bot needs fuel, and if it does uses internal items to refuel
    local f = false
    if turtle.getFuelLevel() < 500 then 
        for i = 1,16 do
            fuelvar = false
            if not(turtle.getItemDetail(i) == nil) then
                if turtle.getItemDetail(i).name == fuel then
                    fuelvar = true
                end
            end
            if fuelvar then
                turtle.select(i)
                while turtle.getItemCount() > 0 do
                    turtle.refuel(1)
                    if turtle.getFuelLevel() >= 500 then
                        f = true
                        turtle.select(1)
                        break
                    end
                end
            end
            if f then break end
        end
    end
end
 
function moveForward() -- moves bot forward 1 block and updates position
    refuel()
    while not turtle.forward() do
        turtle.dig()
    end
    if face == 0 then y=y+1 end
    if face == 1 then x=x+1 end
    if face == 2 then y=y-1 end
    if face == 3 then x=x-1 end 
end
 
function turn(num) -- turns bot either left (-1) or right (+1) depending on input and updates face value
    if num == 1 then 
        turtle.turnRight()
        face = (face+1)%4
    elseif num == -1 then
        turtle.turnLeft()
        face = (face-1)%4
    end
end
 
function trashlist() -- generates white or black list depending on user input and stores block IDs in a table for reference | has some forge tags functionality for cobble and stone
    for i=1,15 do
        if turtle.getItemCount(i) > 0 then
            trashtable[i] = turtle.getItemDetail(i).name
            if trashtable[i] == "minecraft:cobblestone" then
                cobble = true
            end
            if trashtable[i] == "minecraft:stone" then
                stone = true
            end
        else
            slot = i
            break
        end
    end
    print("Item data saved")
    
	while face ~= 2 do turn(1) end
	for i=1,slot-1 do 
		turtle.select(i)
		turtle.drop()
	end
	turn(-1)
	turn(-1)
    turtle.select(1)
end 
 
function dispense() -- deposits mined items into chest behind where bot was initially placed. checks if bot needs fuel before dropping fuel into chest
    for i=1,15 do
        turtle.select(i)
        if not turtle.refuel(0) then
            turtle.drop()
        else turtle.transferTo(16) turtle.drop()
        end
    end
	turtle.select(1)
end
 
function goHome(state) -- returns bot to starting location and handles different reasons for returning. If state == mine the bot returns to its last location when mining
-- if bot returns because of a full inventory (state == full) then it will dispense items and then return to where it was in the quarry 
-- if bot returns due to a lack of fuel (state == fuel) then it will prompt user to input more fuel and return once they have done so
-- if bot returns becuase it finished (state == comp) then it will face the starting direction and end the program
    print(state)
    xp = x
    yp = y
    zp = z
    facep = face
    while y > 0 do  
        if face == 0 then turn(1) end
        if face == 1 then turn(1) end
        if face == 2 then moveForward() end
        if face == 3 then turn(-1) end
    end
    while x > 0 do
        if face == 0 then turn(-1) end
        if face == 1 then turn(-1) end
        if face == 2 then turn(1) end
        if face == 3 then moveForward() end
    end
	
	if(state == "full" or state == "fuel") then trashRemoval() end
	
    while z > 0 do
        turtle.up()
        z=z-1
    end
	while(face ~= 2) do turn(-1) end
	suc2,dat2 = turtle.inspect()
	if not suc2 then 
		turn(-1)
		turn(-1)
		error() 
	end
    while state == "fuel" do
        sleep(10)
        refuel()
        if turtle.getFuelLevel() >= 500 then state = "full" end -- set state to full instead of mine to dispense before returning
    end
    if state == "full" then
		dispense()
		arr = {0}
		state = "mine"
    end
    if state == "comp" then 
        dispense()
        while face ~= 0 do turn(1) end
        error() 
    end
    if state == "mine" then
        while z < zp do
            turtle.down() z = z+1
        end
        while x < xp do
            if face == 0 then turn(1) end
            if face == 1 then moveForward() end
            if face == 2 then turn(-1) end
            if face == 3 then turn(-1) end
        end
        while y < yp do
            if face == 0 then moveForward() end
            if face == 1 then turn(-1) end
            if face == 2 then turn(1) end
            if face == 3 then turn(1) end
        end
        while face ~= facep do
            turn(1)
        end
    end
end
 
function compare(dir) -- checks block depending on (dir) against the list generated by trashtable and returns whether or not it matches something on the list as tf
    local suc = true
    local dat = nil
    local tf = true
    if(listtype == 1) then
        tf = false
    end
    if dir == "up" then
        suc,dat = turtle.inspectUp()
    elseif dir == "front" then
        suc,dat = turtle.inspect()
    elseif dir == "down" then
        suc,dat = turtle.inspectDown()
    elseif dir == "in" then
        dat = turtle.getItemDetail()
    end 
    if suc then
        for i=1,slot-1 do
            if trashtable[i] == dat.name or listtype == 1 and "minecraft:coal_ore" == dat.name then
                return tf
            end
            if cobble and dat.tags["forge:cobblestone"] or stone and dat.tags["forge:stone"] then
                return tf
            end 
        end
    end
    return not(tf)
end
        
 
function digUp() -- mines block above bot if the bot is supposed to (it is on the whitelist or is not on the blacklist)
    if not compare("up") then
        while turtle.digUp() do 
--          turtle.digUp()
        end
    end
end
 
function digDown() -- digUp but down
    if not compare("down") then
        while turtle.digDown() do 
--          turtle.digDown() 
        end
    end
end
 

function trashRemoval() -- removes internal items that either match against the blacklist or dont match against the whitelist (necessary becuase the bot has to mine unwanted blocks to move underground)
    for i=1,15 do
		if(arr[i+1] == nil) then 
			local dispose = true
			for j=1,slot-1 do
				if turtle.getItemCount(i) > 0 then
					if listtype == 0 then
						if turtle.getItemDetail(i).name == trashtable[j] then
							turtle.select(i)
							turtle.drop()
						elseif cobble or stone then
							dat = turtle.getItemDetail(i,true)
							if cobble and dat.tags["forge:cobblestone"] or stone and dat.tags["forge:stone"] then
								turtle.select(i)
								turtle.drop()
							end
						end
					else
						if turtle.getItemDetail(i).name == trashtable[j] then
							dispose = false
						elseif(turtle.getItemDetail(i).name == turtle.getItemDetail(16).name) then
							turtle.select(i)
							turtle.transferTo(16)
							dispose = false
						end
					end
				end
			end
			if(listtype == 1 and dispose) then
				turtle.select(i)
				turtle.drop()
			end
			if(turtle.getItemCount(i) > 0) then
				arr[i+1] = 1
				arr[1] = arr[1]+1
			end
        end
    end
    turtle.select(1)
end
 
function isFull() -- checks if there is a free inventory space
    local ret = true
    for i=0,14 do
        if turtle.getItemCount(15-i) == 0 then ret = false break end
    end
    return ret
end
 
function checkfuel() -- refuels bot and then checks if there is enough fuel to make it back to the starting location and mine the next layer, returns for fuel if there is not
    refuel()
    if turtle.getFuelLevel() < (x+y+z)+l*w then
        goHome("fuel")
    end
end
 
function mine() -- checks for sufficient fuel every 16 operations then mines the block infront of the bot, moves forward, then mines the block above and below if it should
-- also checks for a full inventory and returns to drop off items if needed
    if counter%16 == 0 then checkfuel() counter = 1
    else counter = counter+1 end
    moveForward()
    digDown()
    digUp()
    if isFull() then 
        trashRemoval()
        if arr[1] >= 14 then goHome("full") end
    end
end
 
function Bore() -- moves turtle to z = z0-3 (in case of uneven bedrock)
    while z < z0-3 do
        while not turtle.down() do turtle.digDown() end
        z = z+1
    end
end
 
function moveY() -- mines out a line while keeping track of location and facing
    if y == 0 then
        while y < l-1 do
            if face == 0 then
                mine()
            elseif face == 1 or face == 2 then
                turn(-1)
            else turn(1)
            end
        end
    else
        while y > 0 do
            if face == 2 then
                mine()
            elseif face == 1 or face == 0 then
                turn(1)
            else turn(-1)
            end
        end
    end
end
 
function quarry() -- uses moveY to mine out a square
    refuel()
    for i=0,w-1 do
        moveY()
        if(i < w-1) then
            if(i%2 == 0) then
                turn(rev)
            else
                turn(-rev)
            end
            mine()
        end
    end
end
 
function Mastermind() -- runs the other functions in the proper order to mine out the user defined area, returns once complete
    trashlist()
    refuel()
    if turtle.getFuelLevel() < 500 then
        print("Not enough fuel, please insert more fuel")
        while turtle.getFuelLevel() < 500 do
            sleep(5)
            refuel()
        end
    end
    print(z)
    Bore()
    print(fin)
    for i=0,fin-3 do
        print(i)
        if i%3 == 0 then 
            turtle.digUp()
            quarry() 
            if(w%2 == 0) then
                rev=0-rev
            end
            trashRemoval()
        end
        if i < fin-3 then 
            while not turtle.up() do turtle.digUp() end
            z=z-1
        end
    end
    trashRemoval()
    print("Job's done")
    goHome("comp")
 
end
 
Mastermind() -- queue evil laughter
 
-- todo:
-- track checked items to increase trashRemoval speed especially when inventory is nearly full