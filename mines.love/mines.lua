local M = {}

local Tile = {}
function Tile:new(x, y, value)
    local tile = {
        hidden = true,
        flagged = false,
        value = value,          -- number of adjacent mines, or inf if tile is a mine
        x = x,
        y = y,
    }
    self.__index = self
    return setmetatable(tile, self)
end

function Tile:isMine()
    return self.value == math.huge
end

M.Board = {}
function M.Board:new(width, height, difficulty)
    -- difficulty is the ratio of mines to all tiles
    local board = { 
        width = width,
        height = height, 
        hiddenCount = width * height, 
        mineCount = 0
    }
    board.tiles = {}
    for i = 1, height do
        board.tiles[i] = {}
        for j = 1, width do
            board.tiles[i][j] = Tile:new(j, i, 0)
            if math.random() < difficulty then
                board.mineCount = board.mineCount + 1
                board.tiles[i][j].value = math.huge
            end
        end
    end

    -- update value of tiles that aren't mines by adding 1 to surrounding tiles
    for i = 1, height do
        for j = 1, width do
            local tile = board.tiles[i][j]
            if tile:isMine() then
                for y = math.max(1, i-1), math.min(i+1, height) do
                    for x = math.max(1, j-1), math.min(j+1, width) do
                        local v = board.tiles[y][x]
                        v.value = v.value + 1
                    end
                end
            end
        end
    end

    self.__index = self
    return setmetatable(board, self)
end

function M.Board:getTile(i, j)
    if self.tiles[i] and self.tiles[i][j] then
        return self.tiles[i][j]
    end
    return nil
end

function M.Board:reveal(i, j)
    -- reveal smallest closed set of tiles containing tile[i][j]
    -- and returns true if the clicked tile is a mine
    local tile = self:getTile(i,j)
    if not tile or tile.flagged or not tile.hidden then
        return false
    elseif tile.value > 0 then
        tile.hidden = false
        self.hiddenCount = self.hiddenCount - 1
        return tile:isMine()
    end

    tile.hidden = false
    self.hiddenCount = self.hiddenCount - 1

    -- elseif tile.value == 0, reveal all adjacent open tiles
    for a = math.max(1, i-1), math.min(i+1, self.height) do
        for b = math.max(1, j-1), math.min(j+1, self.width) do
            self:reveal(a, b)
        end
    end
    return false
end

function M.Board:flag(i, j)
    local tile = self:getTile(i,j)
    if tile and tile.hidden then
        tile.flagged = not tile.flagged
    end
end

function M.Board:draw()
    local y = 0
    for i = 1, self.height do
        local x = 0
        for j = 1, self.width do
            local tile = self:getTile(i,j)
            if tile.flagged then
                love.graphics.draw(images.flag, x, y)
            elseif tile.hidden then
                love.graphics.draw(images.hidden, x, y)
            elseif not tile.mine then
                love.graphics.draw(images["grid" .. tile.value], x, y)
            elseif tile.mine then
                love.graphics.draw(images.mine, x, y)
            end
            x = x + grid_size
        end
        y = y + grid_size
    end
end

return M
