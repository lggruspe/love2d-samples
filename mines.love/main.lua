mines = require('mines')

function love.load()
    math.randomseed(os.clock())
    grid_size = 32
    difficulty = 0.2
    width = math.floor(love.graphics.getWidth()/grid_size)
    height = math.floor(love.graphics.getHeight()/grid_size)
    board = mines.Board:new(width,height,difficulty)
    mode = "touch"  -- or flag
    gameOver = false

    images = {}
    images.hidden = love.graphics.newImage("images/minesweeper_00.png")
    images.flag = love.graphics.newImage("images/minesweeper_02.png")
    images.gridinf = love.graphics.newImage("images/minesweeper_05.png")
    images.grid0 = love.graphics.newImage("images/minesweeper_01.png")
    images.grid1 = love.graphics.newImage("images/minesweeper_08.png")
    images.grid2 = love.graphics.newImage("images/minesweeper_09.png")
    images.grid3 = love.graphics.newImage("images/minesweeper_10.png")
    images.grid4 = love.graphics.newImage("images/minesweeper_11.png")
    images.grid5 = love.graphics.newImage("images/minesweeper_12.png")
    images.grid6 = love.graphics.newImage("images/minesweeper_13.png")
    images.grid7 = love.graphics.newImage("images/minesweeper_14.png")
    images.grid8 = love.graphics.newImage("images/minesweeper_15.png")
end

function love.keypressed(key)
    if mode == "touch" then
        mode = "flag"
    else
        mode = "touch"
    end
end

function love.mousereleased(x, y, button, istouch)
    -- transform (x, y) coordinates to tile
    if gameOver then
        -- reset game on mouse release
        gameOver = false
        board = mines.Board:new(width, height, difficulty)
        return
    end

    j = math.floor(x/grid_size) + 1
    i = math.floor(y/grid_size) + 1
    if mode == "flag" then
        board:flag(i, j)
    elseif mode == "touch" then
        mine = board:reveal(i, j)
        if mine or board.hiddenCount <= board.mineCount then
            gameOver = true
            -- reveal all times
            for i = 1, board.height do
                for j = 1, board.width do
                    tile = board:getTile(i,j)
                    tile.flagged = false
                    tile.hidden = false
                end
            end
        end
    end
end

function love.draw()
    board:draw()
    love.graphics.print("mode -- " .. mode)
end
