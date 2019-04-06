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

    self.__index = self
    return setmetatable(tetromino, self)
end

M.Tetris = {}

function M.Tetris:getTetrominoCoordinates()
    -- defaults to {} instead of nil
    if self.tetromino == nil or self.tetromino == {} then
        return {}
    end

    local p = self.tetromino.pivot.i
    local q = self.tetromino.pivot.j
    local coords = {}
    for _, coord in pairs(self.tetromino.coordinates) do
        table.insert(coords, {
            i = coord.i + p,
            j = coord.j + q
        })
    end
    return coords
end

function M.Tetris:flipTetrominoBits()
    -- NOTE: flipTetrominoBits should work even if tetromino is null
    if self.tetromino == null then
        return
    end

    for _, coord in pairs(self:getTetrominoCoordinates()) do
        local i = coord.i
        local j = coord.j
        self.grid[i][j] = 1
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
            tetris.grid[i][j] = 0
        end
    end

    self.__index = self
    return setmetatable(tetris, self)
end

function M.Tetris:canTetrominoMove(di, dj)
    for _, coord in pairs(self:getTetrominoCoordinates()) do
        local i = coord.i
        local j = coord.j
        if self.grid[i+di] == nil or self.grid[i+di][j+dj] ~= 0 then
            return false
        end
    end
    return true
end

function M.Tetris:moveTetrominoDown()
    if self:canTetrominoMove(1, 0) then
        self.tetromino.pivot.i = self.tetromino.pivot.i + 1
    end
end

function M.Tetris:moveTetrominoLeft()
    if self:canTetrominoMove(0, -1) then
        self.tetromino.pivot.j = self.tetromino.pivot.j - 1
    end
end

function M.Tetris:moveTetrominoRight()
    if self:canTetrominoMove(0, 1) then
        self.tetromino.pivot.j = self.tetromino.pivot.j + 1
    end
end

function M.Tetris:rotateTetrominoClockwise()
    -- TODO
end

function M.Tetris:rotateTetrominoCounterClockwise()
    -- TODO
end

function M.Tetris:draw()
    local square_size = 30

    -- draw grid
    local y = 0
    for i, row in pairs(self.grid) do
        local x = 0
        for j, square in pairs(row) do
            -- 1: white, 0: black
            love.graphics.setColor(square, square, square)
            love.graphics.rectangle("fill", x, y, square_size, square_size)
            x = x + square_size
        end
        y = y + square_size
    end

    -- draw tetromino
    love.graphics.setColor(1,1,1)
    for _, coord in pairs(self:getTetrominoCoordinates()) do
        local y = (coord.i - 1) * square_size
        local x = (coord.j - 1) * square_size
        love.graphics.rectangle("fill", x, y, square_size, square_size)
    end
end

return M
