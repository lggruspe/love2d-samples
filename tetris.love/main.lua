local tetris_lib = require("tetris")

function love.load()
    local width = 10
    local height = 10
    tetris = tetris_lib.Tetris:new(width, height)
    tetris:resetTetromino()
end

function love.update(dt)
    -- TODO update every second
    --tetris:moveTetrominoDown()
end

function love.keypressed(key)
    if key == "down" then
        tetris:moveTetrominoDown()
    elseif key == "left" then
        tetris:moveTetrominoLeft()
    elseif key == "right" then
        tetris:moveTetrominoRight()
    elseif key == "rshift" then
        tetris:rotateTetrominoClockwise()
    elseif key == "lshift" then
        tetris:rotateTetrominoCounterClockwise()
    end
end

function love.draw()
    tetris:draw()
end
