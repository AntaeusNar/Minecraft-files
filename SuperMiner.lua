-- Inspired By Branch Mining Script author KingofGamesYami.  Found at https://forums.computercraft.cc/index.php?topic=36.0 and https://pastebin.com/raw/ZpKSLTgW
--


--[[
    Place the Turtle on the z level you want to start at, then place a chest behind it.
    Start the program!
]]

-- Setup the variables and constants
local save_file_name, save_data = 'saveFile.json', nil
local default_ignore_dict = {
    --Default Ignored Types: most of these have subtypes ie minecraft:stone (Stone) vs minecraft:stone:1 (Granite)
    --So when checking we need to allow for turtle.inspect().name to match the beginning so that minecraft:stone and minecraft:stone:1 equal each other.
    ['minecraft:stone'] = true,
    ['minecraft:dirt'] = true,
    ['minecraft:cobblestone'] = true,
    ['minecraft:planks'] = true,
    ['minecraft:sand'] = true,
    ['minecraft:gravel'] = true,
    ['minecraft:log'] = true,
    ['minecraft:leaves'] = true,
    ['minecraft:sandstone'] = true,
    ['minecraft:netherrack'] = true,
    ['minecraft:soul_sand'] = true,
    ['minecraft:mycelium'] = true,
    ['minecraft:farmland'] = true,
    ['minecraft:grass'] = true,
}

--[[
Collection of helper functions
]]

--logging function
function log(text)
    text = '[' .. os.time() .. ']' .. text
    print(text)
    if not fs.exists('/logs') then
        fs.makeDir('/logs')
    end
    local file = fs.open('/logs/eventLog', 'a')
    file.writeLine(text)
    file.close()
end

--file save/load function
function saveLoad(name, data)
    if data then
        if not fs.exists('/data') then
            fs.makeDir('/data')
        end
        local f = fs.open('/data/'..name, 'w')
        f.write(textutils.serialize(date))
        f.close()
    else
        if fs.exists('/data/'..name) then
            local f = fs.open('/data/'..name, 'r')
            date = textutils.unserialize(f.readAll())
            f.close()
            return data
        end
    end
end

--wait for matching input
function waitForInput(...)
    local arg = {...}
    while true do
        local _, char = os.pullEvent('char')
        for i,v in ipairs(arg) do
            if char:lower() == v:lower() then
                return v
            end
        end
    end
end

--[[
Script functions
]]


--[[
Running Code
]]

parallel.waitForAll()