local M = {}

M.CA = {}
function M.CA:new(width, height)
    -- creates a blank cellular automaton with given dimensions
    local ca = {}
    for i = 1, height do
        ca[i] = {}
        for j = 1, width do
            ca[i][j] = false
        end
    end
    self.__index = self
    return setmetatable(ca, self)
end

function M.CA:count_live_neighbors(x, y)
    local width, height = #self[1], #self
    local count = 0
    for i = math.max(1, x-1), math.min(x+1, width) do
        for j = math.max(1, y-1), math.min(y+1, height) do
            if not (i == x and j == y) and self[j][i] then
                count = count + 1
            end
        end
    end
    return count
end

function M.CA:evolve()
    local next_gen = {}
    for i = 1, #self do
        for j = 1, #(self[i]) do
            local count = self:count_live_neighbors(j,i)
            if count == 3 or (self[i][j] and count == 2) then
                table.insert(next_gen, {i,j,true})
            else
                table.insert(next_gen, {i,j,false})
            end
        end
    end

    for _, cell in pairs(next_gen) do
        local i, j, alive = cell[1], cell[2], cell[3]
        self[i][j] = alive
    end
end

function M.CA:draw(cell_size, border_size)
    local b = border_size
    local y = 0
    for _, row in pairs(self) do
        local x = 0
        for _, cell in pairs(row) do
            if cell then
                love.graphics.setColor(1,0.5,0.5)
            else
                love.graphics.setColor(0.8,0.8,0.8)
            end
            love.graphics.rectangle("fill", x+b, y+b, cell_size-b, cell_size-b)
            x = x + cell_size
        end
        y = y + cell_size
    end
end

return M
