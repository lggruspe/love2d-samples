local tetris_lib = require("tetris")

function love.load()
    math.randomseed(os.time())

    local width = 10
    local height = 20
    tetris = tetris_lib.Tetris:new(width, height)
    tetris:resetTetromino()

    time = 0
end

function love.update(dt)
    -- TODO clear complete rows

    time = time + dt
    if time > 0.5 then
        if not tetris:canTetrominoMove(1, 0) then
            -- resetTetromino if it can't move down
            tetris:resetTetromino()
        end
        tetris:moveTetromino(1,0)
        time = 0
    end
end

function love.keypressed(key)
    if key == "down" then
        tetris:moveTetromino(1,0)
    elseif key == "left" then
        tetris:moveTetromino(0,-1)
    elseif key == "right" then
        tetris:moveTetromino(0,1)
    elseif key == "rshift" then
        tetris:rotateTetrominoClockwise()
    elseif key == "lshift" then
        tetris:rotateTetrominoCounterClockwise()
    end
end

function love.draw()
    tetris:draw()
end
