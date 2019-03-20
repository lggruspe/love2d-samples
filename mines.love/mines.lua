local M = {}

local Tile = {}
function Tile:new(tile)
    tile = tile or {
        hidden = true,
        flagged = false,
        mine = false,
        x = 0,
        y = 0,
        score = 0,
    }
    self.__index = self
    return setmetatable(tile, self)
end

M.Board = {}
function M.Board:new(width, height)
    -- scores still need to be initialized afterwards
    board = { 
        width = width,
        height = height, 
        hiddenCount = width * height, 
        mineCount = 0,
        gameStatus = "playing"
    }
    board.tiles = {}
    for i = 1, height do
        board.tiles[i] = {}
        for j = 1, width do
            mine = math.random()
            if mine < 0.3 then
                mine = true
                board.mineCount = board.mineCount + 1
            else
                mine = false
            end
            --TODO how to use default parameters?
            tile = Tile:new{hidden=true, flagged=false, mine=mine, x=j, y=i, score=0}
            board.tiles[i][j] = tile
        end
    end
    self.__index = self
    return setmetatable(board, self)
end

function M.Board:getTile(x, y)
    if 1 <= x and x <= self.width and 1 <= y and y <= self.height then
        return self.tiles[y][x]
    end
end

function M.Board:initializeScores()
    -- update score (for each tile, increment every neighbor's score)
    for i = 1, self.height do
        for j = 1, self.width do
            tile = self:getTile(j,i)
            if tile.mine then
                for _, v in pairs(self:getNeighbors(tile)) do
                    v.score = v.score + 1
                end
            end
        end
    end
end

function M.Board:getNeighbors(tile)
    neighbors = {}      -- including tile
    for i = tile.y - 1, tile.y + 1 do
        for j = tile.x - 1, tile.x + 1 do
            v = self:getTile(j, i)
            if v then
                table.insert(neighbors, v)
            end
        end
    end
    return neighbors
end

function M.Board:reveal(tile)
    -- reveals tile and adjacent tiles that are not flagged or mines
    -- also changes gameStatus if you step on a mine
    if tile.mine then
        tile.hidden = false
        self.hiddenCount = self.hiddenCount - 1
        self.gameStatus = "fail"
        return
    end

    for _, v in pairs(self:getNeighbors(tile)) do
        if v.hidden and not v.flagged and not v.mine then
            v.hidden = false
            self.hiddenCount = self.hiddenCount - 1
        end
    end

    if self.hiddenCount <= self.mineCount then
        self.gameStatus = "success"
    end
end

function M.Board:draw()
    y = 0
    for i = 1, self.height do
        x = 0
        for j = 1, self.width do
            tile = self:getTile(j, i)
            if tile.flagged then
                love.graphics.draw(images.flag, x, y)
            elseif tile.hidden then
                love.graphics.draw(images.hidden, x, y)
            elseif not tile.mine then
                love.graphics.draw(images["grid" .. tile.score], x, y)
            elseif tile.mine then
                love.graphics.draw(images.mine, x, y)
            end
            x = x + grid_size
        end
        y = y + grid_size
    end
end

return M
