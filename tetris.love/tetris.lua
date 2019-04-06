local utils = require("utils")

local M = {}

M.Tetris = {}

function M.Tetris:getTetrominoCoordinates()
    -- return table of tetromino coordinates
    -- note: this function should work whether tetromino is a table of coordinates or a grid
    local coords = {}

    -- TODO add coordinates to coords

    return coords
end

function M.Tetris:flipTetrominoBits()
    for i, coord in pairs(self:getTetrominoCoordinates()) do
        local y = coord[1]
        local x = coord[2]
        self.grid[y][x] = 1
    end
end

function M.Tetris:resetTetromino()
    -- flip the coordinates in the grid specified by tetromino,
    -- create a new one, and update nextShape
    -- NOTE: flipTetrominoBits should work even if tetromino is null
    self:flipTetrominoBits()

    -- create tetromino object based on nextShape
    -- TODO should tetromino be a set of coordinates? or a grid?
    local shape = self.nextShape
    if shape == "I" then
    elseif shape == "J" then
    elseif shape == "L" then
    elseif shape == "T" then
    elseif shape == "S" then
    elseif shape == "Z" then
    end

    self.nextShape = utils.getRandomShape()
end

function M.Tetris:new(width, height)
    -- create new Tetris instance with width-by-height grid,
    -- the coordinates of the squares of a tetromino, and
    -- the shape of the next tetromino

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

    self:resetTetromino()

    self.__index = self
    return setmetatable(tetris, self)
end

function M.Tetris:moveTetromino(direction)
    -- direction should be down, left or right
    -- TODO
    if direction == "down" then
    elseif direction == "left" then
    elseif direction == "right" then
    end
end

function M.Tetris:rotateTetrominoClockwise()
end

function M.Tetris:rotateTetrominoCounterClockwise()

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
