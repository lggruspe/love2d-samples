local utils = require("utils")
local M = {}

M.Tetromino = {}

function M.Tetromino:new(shape)
    local tetromino = {
        coordinates = {},
        shape = utils.getRandomShape()
    }

    -- TODO update coordinates
end

M.Tetris = {}

function M.Tetris:getTetrominoCoordinates()
    -- defaults to {} instead of nil
    if self.tetromino == nil then
        return {}
    end

    local coords = {}
    for _, coord in pairs(self.tetromino) do
        table.insert(coords, coord)
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

local function createITetromino(width, height)
    -- width and height refer to the size of the tetris grid
    local j0 = math.floor(width/2) - 1
    return {
        {i = 1, j = j0},
        {i = 1, j = j0 + 1},
        {i = 1, j = j0 + 2},
        {i = 1, j = j0 + 3}
    }
end

local function createJTetromino(width, height)
    -- width and height refer to the size of the tetris grid
    local j0 = math.floor(width/2)
    return {
        {i = 1, j = j0},  
        {i = 1, j = j0 + 1}, 
        {i = 1, j = j0 + 2}, 
        {i = 2, j = j0 + 2}
    }
end

local function createLTetromino(width, height)
    -- width and height refer to the size of the tetris grid
    local j0 = math.floor(width/2)
    return {
        {i = 1, j = j0},  
        {i = 1, j = j0 + 1}, 
        {i = 1, j = j0 + 2}, 
        {i = 2, j = j0}
    }
end

local function createOTetromino(width, height)
    -- width and height refer to the size of the tetris grid
    local j0 = math.floor(width/2)
    return {
        {i = 1, j = 1},
        {i = 1, j = 2},
        {i = 2, j = 1},
        {i = 2, j = 2}
    }
end

local function createTTetromino(width, height)
    -- width and height refer to the size of the tetris grid
    local j0 = math.floor(width/2)
    return {
        {i = 1, j = j0},  
        {i = 1, j = j0 + 1}, 
        {i = 1, j = j0 + 2}, 
        {i = 2, j = j0 + 1}
    }
end

local function createSTetromino(width, height)
    -- width and height refer to the size of the tetris grid
    local j0 = math.floor(width/2)
    return {
        {i = 1, j = j0 + 2},
        {i = 1, j = j0 + 1}, 
        {i = 2, j = j0 + 1}, 
        {i = 2, j = j0}
    }
end

local function createZTetromino(width, height)
    -- width and height refer to the size of the tetris grid
    local j0 = math.floor(width/2)
    return {
        {i = 1, j = j0},  
        {i = 1, j = j0 + 1}, 
        {i = 2, j = j0 + 1}, 
        {i = 2, j = j0 + 2}
    }
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

    if shape == "I" then
        self.tetromino = createITetromino(width, height)
    elseif shape == "J" then
        self.tetromino = createJTetromino(width, height)
    elseif shape == "L" then
        self.tetromino = createLTetromino(width, height)
    elseif shape == "O" then
        self.tetromino = createOTetromino(width, height)
    elseif shape == "T" then
        self.tetromino = createTTetromino(width, height)
    elseif shape == "S" then
        self.tetromino = createSTetromino(width, height)
    elseif shape == "Z" then
        self.tetromino = createZTetromino(width, height)
    end

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
        for _, coord in pairs(self:getTetrominoCoordinates()) do
            coord.i = coord.i + 1
        end
    end
end

function M.Tetris:moveTetrominoLeft()
    if self:canTetrominoMove(0, -1) then
        for _, coord in pairs(self:getTetrominoCoordinates()) do
            coord.j = coord.j - 1
        end
    end
end

function M.Tetris:moveTetrominoRight()
    if self:canTetrominoMove(0, 1) then
        for _, coord in pairs(self:getTetrominoCoordinates()) do
            coord.j = coord.j + 1
        end
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
