require("types.settings")
require("types.color")
require("cell.all")
require("area.one_level")


Area = {}

function Area:new (obj)
    obj = obj or {}
    setmetatable(obj, self)

    self.__index = self
    self.cells = {}
    self.TH = ""
    self.SEPARETE = " "

    return obj
end

function Area:do_random_map()
    self.cells = {}

    for y=START_INX, AREA_N+START_INX do
        local row = {}

        for x=START_INX, AREA_N+START_INX do
            local cell = Cell:new(nil, COLORS_SET.rand(), x, y)
            table.insert(row, cell)
        end

        table.insert(self.cells, row)
    end

    return self.cells
end

function Area:do_level ()
    self.cells = {}

    for y, _row in pairs(OneLevel.color_map) do
        local row = {}

        for x, color in pairs(_row) do
            local cell = Cell:new(nil, color, x, y)
            table.insert(row, cell)
        end

        table.insert(self.cells, row)
    end

    return self.cells
end

function Area:get_cell(row_num, cell_num)
    if row_num and cell_num then
        return self.cells[tonumber(row_num)][tonumber(cell_num)]
    end
end

function Area:get_active_cell(cell)
    return self:get_cell_hassattr("_active")
end

function Area:get_change_cell(cell)
    return self:get_cell_hassattr("_change")
end

function Area:set_active_cell(cell)
    self.cells[cell.y][cell.x] = ActiveCell:new(cell)
end

function Area:set_change_cell(cell)
    self.cells[cell.y][cell.x] = ChangeCell:new(cell)
end

function Area:get_cell_hassattr(name)
    for _y, row in ipairs(self.cells) do
        
        for _x, cell in pairs(row) do
            if cell[name] and cell[name] == true then
                return cell
            end
        end
    end
end

function Area:get_remove_cells()
    local cells = {}
    for _, row in ipairs(self.cells) do
        for _, cell in pairs(row) do
            if cell._remove and cell._remove == true then
                table.insert(cells, cell)
            end
        end
    end
    return cells
end

function Area:get_empty_cells()
    local cells = {}
    for _, row in ipairs(self.cells) do
        for _, cell in pairs(row) do
            if not cell.color then
                table.insert(cells, cell)
            end
        end
    end
    return cells
end

function Area:str ()
    return string.format("%s", self.cells)
end

function Area:dump ()
    for inx, row in ipairs(self.cells) do
        print(inx..self.TH)
        local row_str = self.SEPARETE

        for _, cell in pairs(row) do
            row_str = row_str..cell:str().." "..self.SEPARETE
        end

        print(row_str)
    end

    print(self.TH)
end


