require("area.area")
require("cell.all")
require("cli.cli")

IGame = {}


function IGame:new (obj)
   obj = obj or {}
   setmetatable(obj, self)
   self.__index = self

   self.area = Area:new(nil)
   self.cli = nil

   return obj
end

function IGame:init()
   -- You can make some map random
   ----------------------------------
   -- self.area:do_random_map()

   -- You can create a new custom map
   ----------------------------------
   self.area:do_level()
end

function IGame:tick()
   print("Press command to move a crystal ('q' to exit):")

   local command = io.read()

   if CLI:in_pairs(CLI.EXIT, command) then
      return { false, "Exit" }
   end

   self.cli = CLI:new(nil, command)

   if self.cli.has_valid then
      local cell = self.area:get_cell(self.cli.y, self.cli.x)

      local change_point = self.cli:prepare_position(cell)
      local change_cell = self.area:get_cell(change_point[2], change_point[1])

      self.area:set_active_cell(cell)
      self.area:set_change_cell(change_cell)

      -- print('Tick')
      -- self:dump()

      return {true, "ok"}
   else
      local err = "Command '"..command.."' has invalid!"
      return { false, err }
   end

end

function IGame:move()
   local from_cell = self.area:get_active_cell()
   local to_cell   = self.area:get_change_cell()

   local old_x, old_y  = from_cell.x, from_cell.y

   from_cell.x, from_cell.y = to_cell.x, to_cell.y
   self.area.cells[from_cell.y][from_cell.x] = from_cell

   to_cell.x, to_cell.y = old_x, old_y
   self.area.cells[to_cell.y][to_cell.x] = to_cell
end

function IGame:mix()
   -- print("Prepare to remove_horizontal_crystals")
   Cell:remove_horizontal_crystals(self.area.cells)
   -- print("Prepare to remove_vertical_crystals")
   Cell:remove_vertical_crystals(self.area.cells)
   --self:dump()

   Cell:fill_crystals(self.area)
end

function IGame:dump()
   print(self.area:dump())
end


IGame.help = string.format([[
-------------------------------------------------------------------
Размер карты: %d x %d
Начало координат: %d
Режим: %s (normal / small)

Доступные команды:
   m 4 2 >     "m": движение ячейки, "4", "2": X, Y, ">" направление
   q           выход из игры
-------------------------------------------------------------------
]], AREA_N + START_INX, AREA_N + START_INX, START_INX, MODE)
