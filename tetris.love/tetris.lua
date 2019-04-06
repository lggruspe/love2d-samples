local utils = require("utils")

local M = {}

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
        local i = coord[1]
        local j = coord[2]
        self.grid[i][j] = 1
    end
end

local function createITetromino(width, height)
    -- width and height refer to the size of the tetris grid
    -- TODO
end

local function createJTetromino(width, height)
    -- width and height refer to the size of the tetris grid
end
local function createLTetromino(width, height)
    -- width and height refer to the size of the tetris grid
end
local function createTTetromino(width, height)
    -- width and height refer to the size of the tetris grid
end
local function createSTetromino(width, height)
    -- width and height refer to the size of the tetris grid
end
local function createZTetromino(width, height)
    -- width and height refer to the size of the tetris grid
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
    if shape == "I" then
        createITetromino()
    elseif shape == "J" then
        createJTetromino()
    elseif shape == "L" then
        createLTetromino()
    elseif shape == "T" then
        createTTetromino()
    elseif shape == "S" then
        createSTetromino()
    elseif shape == "Z" then
        createZTetromino()
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

function M.Tetris:moveTetrominoDown()
    local function canMoveDown()
        for _, coord in pairs(self:getTetrominoCoordinates()) do
            local i = coord[1]
            local j = coord[2]
            if self.grid[i+1][j] ~= 0 then  -- this works even when i+1 goes out of bounds
                return false
            end
        end
        return true
    end

    if canMoveDown() then
        for _, coord in pairs(self:getTetrominoCoordinates()) do
            coord.i = coord.i + 1
        end
    end
end

function M.Tetris:moveTetrominoLeft()
    local function canMoveLeft()
        for _, coord in pairs(self:getTetrominoCoordinates()) do
            local i = coord[1]
            local j = coord[2]
            if self.grid[i][j-1] ~= 0 then
                return false
            end
        end
        return true
    end

    if canMoveLeft() then
        for _, coord in pairs(self:getTetrominoCoordinates()) do
            coord.j = coord.j - 1
        end
    end
end

function M.Tetris:moveTetrominoRight()
    local function canMoveRight()
        for _, coord in pairs(self:getTetrominoCoordinates()) do
            local i = coord[1]
            local j = coord[2]
            if self.grid[i][j+1] ~= 0 then
                return false
            end
        end
        return true
    end

    if canMoveRight() then
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
    for i, square in pairs(self:getTetrominoCoordinates()) do
        local x = square[2]
        local y = square[1]
        love.graphics.rectangle("line", x, y, square_size, square_size)
    end
end

return M
