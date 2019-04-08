local utils = require("utils")
local M = {}

M.Tetromino = {}

function M.Tetromino:new(shape, width, height)
    -- width and height refer to the size of the tetris grid
    local tetromino = {
        shape = shape,
        coordinates = {},
        pivot = {
            i = 1,
            j = math.floor(width/2),
        }
    }

    if shape == "I" then
        tetromino.coordinates = {
            {i = 0, j = -1},
            {i = 0, j = 0},
            {i = 0, j = 1},
            {i = 0, j = 2}
        }
    elseif shape == "J" then
        tetromino.coordinates = {
            {i = 0, j = -1},
            {i = 0, j = 0},
            {i = 0, j = 1},
            {i = 1, j = 1}
        }
    elseif shape == "L" then
        tetromino.coordinates = {
            {i = 1, j = -1},
            {i = 1, j = 0},
            {i = 1, j = 1},
            {i = 0, j = 1}
        }
    elseif shape == "O" then
        tetromino.coordinates = {
            {i = 0, j = 0},
            {i = 0, j = 1},
            {i = 1, j = 0},
            {i = 1, j = 1}
        }
    elseif shape == "T" then
        tetromino.coordinates = {
            {i = 0, j = -1},
            {i = 0, j = 0},
            {i = 0, j = 1},
            {i = 1, j = 0}
        }
    elseif shape == "S" then
        tetromino.coordinates = {
            {i = 0, j = 0},
            {i = 0, j = 1},
            {i = 1, j = 0},
            {i = 1, j = -1}
        }
    elseif shape == "Z" then
        tetromino.coordinates = {
            {i = 0, j = -1},
            {i = 0, j = 0},
            {i = 1, j = 0},
            {i = 1, j = 1}
        }
    end

    local coords = tetromino.coordinates
    for idx, coord in pairs(coords) do
        coords[idx].i = coords[idx].i + tetromino.pivot.i
        coords[idx].j = coords[idx].j + tetromino.pivot.j
    end

    self.__index = self
    return setmetatable(tetromino, self)
end

M.Tetris = {}

function M.Tetris:getTetrominoCoordinates()
    -- defaults to {} instead of nil
    if self.tetromino == nil or self.tetromino == {} then
        return {}
    end
    return self.tetromino.coordinates
end

function M.Tetris:flipTetrominoBits()
    -- NOTE: flipTetrominoBits should work even if tetromino is null
    if self.tetromino == null then
        return
    end

    for _, coord in pairs(self:getTetrominoCoordinates()) do
        local i = coord.i
        local j = coord.j
        self.grid[i][j] = self.tetromino.shape
    end
end

function M.Tetris:resetTetromino()
    -- flip the coordinates in the grid specified by tetromino,
    -- create a new one, and update nextShape
    -- NOTE: flipTetrominoBits should work even if tetromino is null
    self:flipTetrominoBits()

    -- create tetromino object based on nextShape
    local height = #(self.grid)
    local width = #(self.grid[1])

    local shape = self.nextShape
    if shape == nil then
        shape = utils.getRandomShape()
    end

    self.tetromino = M.Tetromino:new(shape, width, height)
    self.nextShape = utils.getRandomShape()
end

function M.Tetris:new(width, height)
    -- create new Tetris instance with width-by-height grid,
    -- the coordinates of the squares of a tetromino, and
    -- the shape of the next tetromino
    -- usage note: resetTetromino needs to be called right after

    local tetris = {
        grid = {},
        tetromino = nil,
        nextShape = nil
    }

    for i = 1, height do
        tetris.grid[i] = {}
        for j = 1, width do
            tetris.grid[i][j] = ' '
        end
    end

    self.__index = self
    return setmetatable(tetris, self)
end

function M.Tetris:moveTetromino(di, dj)
    local coords = self.tetromino.coordinates
    for idx, coord in pairs(coords) do
        coords[idx].i = coords[idx].i + di
        coords[idx].j = coords[idx].j + dj
    end

    self.tetromino.pivot.i = self.tetromino.pivot.i + di
    self.tetromino.pivot.j = self.tetromino.pivot.j + dj
end

function M.Tetris:isTetrominoValid()
    for _, coord in pairs(self:getTetrominoCoordinates()) do
        local i = coord.i
        local j = coord.j
        if self.grid[i] == nil or self.grid[i][j] ~= ' ' then
            return false
        end
    end
    return true
end

local function printCoordinates(coords)
    print("coordinates: {" )
    for _, coord in pairs(coords) do
        print("\t(" .. coord.i .. ", " .. coord.j .. ")")
    end
    print("}")
end

function M.Tetris:rotateTetrominoClockwise()
    -- FIXME tetromino pivot gets thrown off after bumping into either wall
    -- TODO also check isTetrominoValid
    -- or moveWithCheckpoint
    if self.tetromino.shape == "O" then
        return
    end

    -- rotate
    local p = self.tetromino.pivot.i
    local q = self.tetromino.pivot.j
    local coords = self:getTetrominoCoordinates()
    for idx, coord in pairs(coords) do
        local i = coord.i
        local j = coord.j
        local di = i - p
        local dj = j - q
        coords[idx].i = p + dj
        coords[idx].j = q - di
    end
end

function M.Tetris:rotateTetrominoCounterClockwise()
    for i = 1, 3 do
        self:rotateTetrominoClockwise()
    end
end

function M.Tetris:draw(width, height)
    local minWindowDim = math.min(love.graphics.getHeight(), love.graphics.getWidth())
    local maxGridDim = math.max(width, height)
    local square_size = math.floor(minWindowDim/maxGridDim)

    -- draw grid
    local y = 0
    for i, row in pairs(self.grid) do
        local x = 0
        for j, square in pairs(row) do
            local r, g, b = utils.getShapeColor(square)
            love.graphics.setColor(r, g, b)
            love.graphics.rectangle("fill", x, y, square_size, square_size)
            x = x + square_size
        end
        y = y + square_size
    end

    -- draw tetromino
    local r, g, b = utils.getShapeColor(self.tetromino.shape)
    love.graphics.setColor(r, g, b)
    for _, coord in pairs(self:getTetrominoCoordinates()) do
        local y = (coord.i - 1) * square_size
        local x = (coord.j - 1) * square_size
        love.graphics.rectangle("fill", x, y, square_size, square_size)
    end
end

function M.Tetris:moveTetrominoDown()
    tetris:moveTetromino(1,0)
end

function M.Tetris:moveTetrominoLeft()
    tetris:moveTetromino(0,-1)
end

function M.Tetris:moveTetrominoRight()
    tetris:moveTetromino(0,1)
end

function M.Tetris:moveWithCheckpoint(moveMethod)
    -- returns true if checkpoint used
    local checkpoint = {
        shape = self.tetromino.shape,
        coordinates = {},
        pivot = self.tetromino.pivot
    }
    for _, coord in pairs(self.tetromino.coordinates) do
        table.insert(checkpoint.coordinates, {i=coord.i, j=coord.j})
    end

    moveMethod(self)
    if not self:isTetrominoValid() then
        self.tetromino = checkpoint
        return true
    end

    return false
end

function M.Tetris:clearCompleteRows()
    local function getRowState(i)
        local empty = true
        local complete = true
        for j, a in pairs(self.grid[i]) do
            if a ~= ' ' then
                empty = false
            elseif a == ' ' then
                complete = false
            end
        end
        if empty then
            return "empty"
        elseif complete then
            return "complete"
        else
            return "nonempty"
        end
    end

    local function moveRowsDown(i)
        -- (row i will be removed)
        local width = #(self.grid[i])

        local j = i - 1
        while j >= 1 do
            if getRowState(j) == "empty" then
                break
            end
            self.grid[j+1] = self.grid[j]
            j = j - 1
        end
        self.grid[j+1] = {}
        for k = 1, width do
            self.grid[j+1][k] = ' '
        end
    end

    for i = #self.grid, 1, -1 do
        -- stop when row is empty
        local state = getRowState(i)
        if state == "empty" then
            return
        elseif state == "complete" then
            moveRowsDown(i)
        end
    end
end

function M.Tetris:isGameOver()
    local width = #(self.grid[1])
    for i = 1, 2 do
        for j = 1, width do
            if self.grid[i][j] ~= ' ' then
                print('debug', self.grid[i][j], i, j)
                return true
            end

        end
    end
    return false
end

return M
