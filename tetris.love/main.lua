local tetris_lib = require("tetris")

function love.load()
    local width = 10
    local height = 10
    tetris = tetris_lib.Tetris:new(width, height)
end

function love.update(dt)
    -- TODO update every second
    --tetris:moveTetromino("down")
end

function love.keypressed(key)
    if key == "down" or key == "left" or key == "right" then
        tetris:moveTetromino(key)
    elseif key == "rshift" then
        tetris:rotateTetrominoClockwise()
    elseif key == "lshift" then
        tetris:rotateTetrominoCounterClockwise()
    end
end

function love.draw()
    tetris:draw()
end
