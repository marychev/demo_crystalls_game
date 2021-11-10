require("cell.cell")
ActiveCell = Cell:new()


function ActiveCell:new (obj)
    obj = Cell:new(nil, obj.color, obj.x, obj.y)
    setmetatable(obj, self)

    self.__index = self
    self._active = true
    self.char = '!'

    return obj
end

function ActiveCell:active ()
    self._active = true
    return self
end