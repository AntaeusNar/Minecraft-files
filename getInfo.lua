--[[
This is a LUA code snipet for use in Minecraft with Computercraft and Logistic Pipes Mods.
Original code found at https://pastebin.com/7gb2cH88 credit MOOMOOMOO309 Jan 25th, 2015
]]

filePath="Info"
 
local function removeAll(str,char)
  if #char~=1 then
    return nil
  end
  for i=1,#str do
    if string.sub(str,i,i)==char then
      str=string.sub(str,1,i-1)..string.sub(str,i+1)
    end
  end
  return str
end
 
local function findPeripheral(type)
  local Peripherals=peripheral.getNames()
  wildcardBeginning=string.sub(type,1,1)=="*"
  wildcardEnd=string.sub(type,#type)=="*"
  for i=1,#Peripherals do
    index1,index2=string.find(peripheral.getType(Peripherals[i]),removeAll(type,"*"))
    if wildcardBeginning and wildcardEnd and index1 then
      return Peripherals[i]
    elseif wildcardBeginning then
      if index2==#peripheral.getType(Peripherals[i]) then
        return Peripherals[i]
      end
    elseif wildcardEnd then
      if index1==1 then
        return Peripherals[i]
      end
    elseif peripheral.getType(Peripherals[i])==type then
      return Peripherals[i]
    end
  end
end
 
local Items=peripheral.call(findPeripheral("LogisticsPipes*"),"getAvailableItems")
f=fs.open(filePath,"w")
for k,v in pairs(Items) do
  id=v.getValue1()
  f.write("ID: "..id.getId().."\n")
  f.write("Unlocalized Name: "..id.getName().."\n")
  f.write("Mod Name: "..id.getModName().."\n")
  f.write("Meta: "..id.getData().."/"..id.getUndamaged().getData().."\n")
  f.write("Count: "..m.getItemAmount(id).."\n\n")
end
f.close()  
--[[
Sample Output:
ID: 542
Unlocalized Name: Copper Ore
Mod Name: IC2
Meta: 0/0
Count: 50251
]]
