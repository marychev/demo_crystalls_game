require("cell.cell")
RemoveCell = Cell:new()


function RemoveCell:new (obj)
    obj = Cell:new(nil, obj.color, obj.x, obj.y)
    setmetatable(obj, self)

    self.__index = self
    self._remove = true
    self.char = 'x'

    return obj
end

function RemoveCell:active ()
    self._remove = true
    return self
end