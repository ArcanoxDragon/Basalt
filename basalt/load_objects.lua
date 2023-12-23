local utils = require("utils")
local _OBJECTS = {}

if(packaged)then
    for k,v in pairs(getProject("objects"))do
        _OBJECTS[k] = v()
    end
    return _OBJECTS
end

local args = table.pack(...)
local dir = fs.getDir(args[2] or "Basalt")
if(dir==nil)then
    error("Unable to find directory "..args[2].." please report this bug to our discord.")
end

for _,v in pairs(fs.list(fs.combine(dir, "objects")))do
    if(v~="example.lua")and not(v:find(".disabled"))then
        local moduleName = v:gsub(".lua", "")
        local objectName = utils.convertModuleName(moduleName)
        _OBJECTS[objectName] = require(moduleName)
    end
end
return _OBJECTS