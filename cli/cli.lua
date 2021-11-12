CLI = {}
CLI.EXIT = {"q", "e", "exit", "quit"}

CLI.ALLOWED_CHARS = {
    UP = {"u", "t", "up", "top", "^"},
    DOWN = {"d", "b", "down", "bottom"},
    LEFT = {"<", "l", "left"},
    RIGHT = {">", "r", "right"}
}


function CLI:new (obj, cmd)
    obj = obj or {}
    setmetatable(obj, self)

    self.__index = self
    self.cmd = string.lower(cmd)
    self.args = self:split(self.cmd, " ")
    self.has_valid = false

    self:parse_cmd()

    return obj
end


function CLI:parse_cmd()

    self.m = self:get_m()
    self.x = self:get_x()
    self.y = self:get_y()
    self.d = self:get_d()

    if self.m and self.x and self.y and self.d then
        if self.x <= START_INX and self.y <= START_INX and (
            CLI:in_pairs(CLI.ALLOWED_CHARS.LEFT,  self.d) or CLI:in_pairs(CLI.ALLOWED_CHARS.UP,  self.d)
        ) then
            self.has_valid = false
        elseif self.x <= START_INX and self.y >= START_INX + AREA_N and (
            CLI:in_pairs(CLI.ALLOWED_CHARS.LEFT,  self.d) or CLI:in_pairs(CLI.ALLOWED_CHARS.DOWN,  self.d)
        ) then
            self.has_valid = false
        elseif self.x >= START_INX + AREA_N and self.y >= START_INX + AREA_N and (
            CLI:in_pairs(CLI.ALLOWED_CHARS.RIGHT,  self.d) or CLI:in_pairs(CLI.ALLOWED_CHARS.DOWN,  self.d)
        ) then
            self.has_valid = false
        elseif self.x >= START_INX + AREA_N and self.y <= START_INX and (
            CLI:in_pairs(CLI.ALLOWED_CHARS.RIGHT,  self.d) or CLI:in_pairs(CLI.ALLOWED_CHARS.UP,  self.d)
        ) then
        else
            self.has_valid = true
        end
    end

    return self.args
end

function CLI:prepare_position (active_cell)
    local d = self:get_duration()
    local nx, ny = active_cell.x + d[2], active_cell.y + d[1]
    return {nx, ny}
end

function CLI:get_duration()
    local dx, dy = 0, 0

    if self:in_pairs(CLI.ALLOWED_CHARS.UP, self.d) then
        dx = -1
    elseif self:in_pairs(CLI.ALLOWED_CHARS.DOWN, self.d) then
        dx = 1
    elseif self:in_pairs(CLI.ALLOWED_CHARS.RIGHT, self.d) then
        dy = 1
    elseif self:in_pairs (CLI.ALLOWED_CHARS.LEFT, self.d) then
        dy = -1
    end

    return {dx, dy}
end

function CLI:get_m()
    local valid_arr = self:is_valid_m(self.args[1])
    return CLI:get_value(valid_arr, self.args[1])
end

function CLI:get_x()
    local valid_arr = self:is_valid_num(self.args[2])
    if valid_arr then
        return tonumber(CLI:get_value(valid_arr, self.args[2]))
    end
end

function CLI:get_y()
    local valid_arr = self:is_valid_num(self.args[3])
    if valid_arr then
        return tonumber(CLI:get_value(valid_arr, self.args[3]))
    end
end

function CLI:get_d()
    local valid_arr = self:is_valid_d(self.args[4])
    return CLI:get_value(valid_arr, self.args[4])
end

function CLI:get_value(valid_arr, args_val)
    local is_valid, m_msg = valid_arr[1], valid_arr[2]
    if is_valid then
        return args_val
    end
end

function CLI:split(s, delimiter)
    local arr = {}
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(arr, match);
    end
    return arr
end

function CLI:is_valid_m (arg)
    local m = arg
    local has_valid, msg = false, "Undefined"

    has_valid, msg = m == "m", ""
    if not has_valid then
        -- msg = "\r\nERROR:\r\n".."Got `"..m.."`, Expected: `m`\r\n"
    end

    --self.has_valid = has_valid
    return {has_valid, msg}
end

function CLI:is_valid_num(arg)
    local x = tonumber(arg)
    local has_valid = false
    local msg = ""

    if x then
        has_valid = (START_INX <= x and AREA_N + START_INX >= x)
        -- if not has_valid then
        --     msg = "\r\nERROR:\r\n".."Got `"..x.."`, Expected: `0-10` of number values\r\n"
        -- end

        return {has_valid, msg}
    end

    --self.has_valid = has_valid
    return {has_valid, msg}
end

function CLI:is_valid_d (arg)
    local msg = ""
    local has_valid = false

    if arg then
        local d = arg
        has_valid = (
            self:in_pairs(CLI.ALLOWED_CHARS.UP, d)   or
            self:in_pairs(CLI.ALLOWED_CHARS.DOWN, d) or
            self:in_pairs(CLI.ALLOWED_CHARS.LEFT, d) or
            self:in_pairs(CLI.ALLOWED_CHARS.RIGHT, d)
        )

        -- if not has_valid then
        --     msg = "\r\nERROR:\r\n".."Got `"..d.."`\r\n"
        -- end
    end

    --self.has_valid = has_valid
    return  {has_valid, msg}
end

function CLI:in_pairs (arr, val)
    for _, value in ipairs(arr) do
        if value == val then
            return true
        end
    end
    return false
end