mines = require('mines')

function love.load()
    math.randomseed(os.clock())
    grid_size = 32
    board = mines.Board:new(16,16)
    board:initializeScores()
    mode = "touch"  -- or flag

    images = {}
    images.hidden = love.graphics.newImage("images/minesweeper_00.png")
    images.flag = love.graphics.newImage("images/minesweeper_02.png")
    images.mine = love.graphics.newImage("images/minesweeper_05.png")
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

function love.update(dt)
    
end

function love.keypressed(key)
    if key == "space" then
        -- toggle mode
        if mode == "touch" then
            mode = "flag"
        else
            mode = "touch"
        end
    elseif key == "r" then
        -- reset board
        board = mines.Board:new(board.width, board.height)
        board:initializeScores()
    end
end

function love.mousepressed(x, y, button, istouch)
    -- find i such that i*height <= y < (i+1)*height
    -- find j such that j*width <= x < (j+1)*width
    j = math.floor((x - (x % grid_size)) / grid_size) + 1   -- + 1 for index 1
    i = math.floor((y - (y % grid_size)) / grid_size) + 1
    if 1 <= i and i <= board.height
            and 1 <= j and j <= board.width then
        tile = board:getTile(j, i)
        if mode == "flag" and tile.hidden then
            tile.flagged = not tile.flagged
        elseif mode == "touch" and not tile.flagged then
            board:reveal(tile)
        end
    end
end

function love.draw()
    board:draw()
    if board.gameStatus == "success" then
        love.graphics.print("You win!")
    elseif board.gameStatus == "fail" then
        love.graphics.print("Game over")
    else
        love.graphics.print("mode = " .. mode)
    end
end
