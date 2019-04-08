local tetris_lib = require("tetris")

function love.load()
    math.randomseed(os.time())
    love.keyboard.setKeyRepeat(true)

    width = 10
    height = 22 -- top 2 rows are spwaning points
    tetris = tetris_lib.Tetris:new(width, height)
    tetris:resetTetromino()

    time = 0
end

function love.update(dt)
    time = time + dt
    if time > 0.25 then
        if tetris:isGameOver() then
            tetris = tetris_lib.Tetris:new(width, height)
            tetris:resetTetromino()
        else
            local checkpointUsed = tetris:moveWithCheckpoint(tetris.moveTetrominoDown)
            if checkpointUsed then
                -- resetTetromino if it can't move down
                tetris:resetTetromino()
            end
            tetris:clearCompleteRows()
        end
        time = 0
    end
end

function love.keypressed(key)
    if key == "down" then
        tetris:moveWithCheckpoint(tetris.moveTetrominoDown)
    elseif key == "left" then
        tetris:moveWithCheckpoint(tetris.moveTetrominoLeft)
    elseif key == "right" then
        tetris:moveWithCheckpoint(tetris.moveTetrominoRight)
    elseif key == "rshift" or key == "space" then
        tetris:moveWithCheckpoint(tetris.rotateTetrominoClockwise)
    elseif key == "lshift" then
        tetris:moveWithCheckpoint(tetris.rotateTetrominoCounterClockwise)
    end
end

function love.draw()
    tetris:draw(width, height)
end
