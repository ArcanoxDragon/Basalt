local utils = require("utils")

local max,min,sub,rep,len = math.max,math.min,string.sub,string.rep,string.len

return function(name, basalt)
    local base = basalt.getObject("Container")(name, basalt)
    base:setType("Frame")
    local parent
    
    base:setSize(30, 10)
    base:setZ(10)

    base:addProperty("XOffset", "number", 0)
    base:addProperty("YOffset", "number", 0)
    base:combineProperty("Offset", "XOffset", "YOffset")

    local object = {
        getBase = function(self)
            return base
        end,

        setParent = function(self, p, ...)
            base.setParent(self, p, ...)
            parent = p
            return self
        end,

        render = function(self)
            if(base.render~=nil)then
                if(self:isVisible())then
                    base.render(self)
                    local children = self:getChildren()
                    for _, child in ipairs(children) do
                        if (child.element.render ~= nil) then
                            child.element:render()
                        end
                    end
                end
            end
        end,

        updateDraw = function(self)
            if(parent~=nil)then
                parent:updateDraw()
            end
            return self
        end,

        blit = function (self, x, y, t, f, b)
            local obx, oby = self:getPosition()
            local xO, yO = parent:getOffset()
            obx = obx - xO
            oby = oby - yO
            local w, h = self:getSize()        
            if y >= 1 and y <= h then
                local t_visible = sub(t, max(1 - x + 1, 1), max(w - x + 1, 1))
                local f_visible = sub(f, max(1 - x + 1, 1), max(w - x + 1, 1))
                local b_visible = sub(b, max(1 - x + 1, 1), max(w - x + 1, 1))        
                parent:blit(max(x + (obx - 1), obx), oby + y - 1, t_visible, f_visible, b_visible)
            end
        end,

        setCursor = function(self, blink, x, y, color)
            local obx, oby = self:getPosition()
            local xO, yO = self:getOffset()
            parent:setCursor(blink or false, (x or 0)+obx-1 - xO, (y or 0)+oby-1 - yO, color or colors.white)
            return self
        end,
    }

    for _,v in pairs({"drawBackgroundBox", "drawForegroundBox", "drawTextBox"})do
        object[v] = function(self, x, y, width, height, symbol)
            local obx, oby = self:getPosition()
            local xO, yO = parent:getOffset()
            obx = obx - xO
            oby = oby - yO
            height = (y < 1 and (height + y > self:getHeight() and self:getHeight() or height + y - 1) or (height + y > self:getHeight() and self:getHeight() - y + 1 or height))
            width = (x < 1 and (width + x > self:getWidth() and self:getWidth() or width + x - 1) or (width + x > self:getWidth() and self:getWidth() - x + 1 or width))
            parent[v](parent, max(x + (obx - 1), obx), max(y + (oby - 1), oby), width, height, symbol)
        end
    end

    for _,v in pairs({"setBg", "setFg", "setText"})do
        object[v] = function(self, x, y, str)
            local obx, oby = self:getPosition()
            local xO, yO = parent:getOffset()
            obx = obx - xO
            oby = oby - yO
            local w, h  = self:getSize()
            if (y >= 1) and (y <= h) then
                parent[v](parent, max(x + (obx - 1), obx), oby + y - 1, sub(str, max(1 - x + 1, 1), max(w - x + 1,1)))
            end
        end
    end

    object.__index = object
    return setmetatable(object, base)
end