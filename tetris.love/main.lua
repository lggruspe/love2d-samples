local tetris_lib = require("tetris")

function love.load()
    local width = 10
    local height = 10
    tetris = tetris_lib.Tetris:new(width, height)
    tetris:resetTetromino()

    time = 0
end

function love.update(dt)
    -- TODO clear complete rows

    time = time + dt
    if time > 1.0 then
        if not tetris:canTetrominoMove(1, 0) then
            -- resetTetromino if it can't move down
            tetris:resetTetromino()
        end
        tetris:moveTetrominoDown()
        time = 0
    end
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
