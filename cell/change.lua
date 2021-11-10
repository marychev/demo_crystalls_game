require("cell.cell")
ChangeCell = Cell:new()


function ChangeCell:new (obj)
    obj = Cell:new(nil, obj.color, obj.x, obj.y)
    setmetatable(obj, self)

    self.__index = self
    self._change = true
    self.char = '_'

    return obj
end

function ChangeCell:active ()
    self._change = true
    return self
end