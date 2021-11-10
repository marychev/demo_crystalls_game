Cell = {}

function Cell:new (obj, color, x, y)
    obj = {
        color =  color,
        x =  x,
        y = y
    }
    setmetatable(obj, self)

    self.__index = self
    self.color = color
    self.x = x
    self.y = y
    self.char = ' '

    return obj
end

function Cell:fill_crystals(area)
    local remove_cells = area:get_remove_cells()

    -- Total replace case
    for _, rc in ipairs(remove_cells) do
        local to_remove, to_replace = Cell:prepare_col_cells(area.cells, rc.x)
        local count_remove = #to_remove

        while count_remove > 0 do
            for row=START_INX, AREA_N do
                if to_replace[row] and to_remove[row] then
                    local tmp_replace_y = to_remove[START_INX].y - row
                    local tmp_remove_y = #to_remove - row + START_INX
                    local remove = to_remove[tmp_remove_y]

                    if to_replace[tmp_replace_y] then
                        local replace = to_replace[tmp_replace_y]
                        local remove_x, remove_y = to_remove[tmp_remove_y].x, to_remove[tmp_remove_y].y

                        remove.x, remove.y = replace.x, replace.y
                        area.cells[replace.y][replace.x] = remove

                        replace.x, replace.y = remove_x, remove_y
                        area.cells[remove_y][remove_x] = replace
                    end
                end
            end

        count_remove = count_remove - 1
        end
    end


    -- Random case of top
    for _, cell in ipairs(remove_cells) do
        area.cells[cell.y][cell.x] = Cell:new(nil, COLORS_SET.rand(), cell.x, cell.y)
    end

    remove_cells = area:get_remove_cells()
    if #remove_cells == 0 then

        local active_cell = area:get_active_cell()
        if active_cell then
            active_cell.char = " "
            active_cell._active = false
            area.cells[active_cell.y][active_cell.x] = Cell:new(nil, active_cell.color, active_cell.x, active_cell.y)
        end
        local change_cell = area:get_change_cell()
        if change_cell then
            change_cell.char = " "
            change_cell._change = false
            area.cells[change_cell.y][change_cell.x] = Cell:new(nil, change_cell.color, change_cell.x, change_cell.y)
        end

    end

end


function Cell:prepare_col_cells(area_cells, x)
    local to_remove, to_replace = {}, {}

    for y = START_INX, AREA_N + START_INX do

        local col_cell = area_cells[y][x]

        if col_cell and not col_cell._remove then
            table.insert(to_replace, col_cell)
        else
            table.insert(to_remove, col_cell)
        end
    end

    return to_remove, to_replace
end

function Cell:prepare_total_cells(cells_list)
    local total = {}
    local _cells_list = cells_list

    for k, cell in pairs(_cells_list) do
        local tmp = {}
        local num = START_INX

        for i=k, AREA_N+START_INX do
            local has_valid_position = (_cells_list[i].y == cell.y+num-START_INX or _cells_list[i].x == cell.x+num-START_INX)
            if _cells_list[i].color == cell.color and has_valid_position then
                table.insert(tmp, _cells_list[i])
                num = num + START_INX
            end
        end

        if #tmp >= DELETIONS_IN_ROW then
            for i, c in ipairs(tmp) do
                table.insert(total, c)
            end
        end
    end

    return total
end

function Cell:remove_vertical_crystals(area_cells)
    for x = START_INX, AREA_N + START_INX do
       local vertical_list = {}

       for y = START_INX, AREA_N + START_INX do
          table.insert(vertical_list, area_cells[y][x])
       end

       local prepared_cells = self:prepare_total_cells(vertical_list)
       for _, cell in ipairs(prepared_cells) do
            area_cells[cell.y][cell.x] = RemoveCell:new(cell)
       end
    end
end

function Cell:remove_horizontal_crystals(area_cells)
    for y=START_INX, AREA_N+START_INX do
        local horizonatal_list = area_cells[y]
        local prepared_cells = Cell:prepare_total_cells(horizonatal_list)

        for _, cell in ipairs(prepared_cells) do
            area_cells[cell.y][cell.x] = RemoveCell:new(cell)
        end
    end
end

function Cell:str ()
    if MODE == "normal" then
        local x = string.format(" %d", self.x)
        local y = string.format(" %d", self.y)
    
        if self.x > 9 then
            x = string.format("%d", self.x)
        end
        if self.y > 9 then
            y = string.format("%d", self.y)
        end
    
        return string.format("%s%s:%s,%s", self.char, self.color, x, y)  
    else
        return string.format("%s%s", self.char, self.color)
    end
end
