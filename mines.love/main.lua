mines = require('mines')

-- TODO fix board.hiddenCount

function love.load()
    math.randomseed(os.clock())
    grid_size = 32
    difficulty = 0.1
    width = love.graphics.getWidth()/grid_size
    height = love.graphics.getHeight()/grid_size
    board = mines.Board:new(width,height,difficulty)
    mode = "touch"  -- or flag
    gameStatus = "playing"

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

    print(board.hiddenCount, board.mineCount)   -- TODO Delete
end

function love.keypressed(key)
    -- TODO top level cases should refer to mode
    if key == "space" then
        -- toggle mode
        if mode == "touch" then
            mode = "flag"
        else
            mode = "touch"
        end
    elseif key == "r" then
        -- reset board
        board = mines.Board:new(board.width, board.height, difficulty)
        gameStatus = "playing"
    end
end

function love.mousepressed(x, y, button, istouch)
    -- transform (x, y) coordinates to tile
    j = math.floor(x/grid_size) + 1
    i = math.floor(y/grid_size) + 1

    print(board.hiddenCount, board.mineCount)   -- TODO Delete

    if mode == "flag" then
        board:flag(i, j)
    elseif mode == "touch" then
        mine = board:reveal(i, j)
        if mine then
            gameStatus = "fail"
        end

        if board.hiddenCount <= board.mineCount then
            gameStatus = "success"
        end
    end
end

function mines.Board:draw()     -- TODO 
    y = 0
    for i = 1, self.height do
        x = 0
        for j = 1, self.width do
            tile = self:getTile(i,j)
            if tile.flagged then
                love.graphics.draw(images.flag, x, y)
            elseif tile.hidden then
                love.graphics.draw(images.hidden, x, y)
            elseif not tile.mine then
                love.graphics.draw(images["grid" .. tile.value], x, y)
            elseif tile.mine then
                love.graphics.draw(images.mine, x, y)
            end
            x = x + grid_size
        end
        y = y + grid_size
    end
end

function love.draw()
    board:draw()
    if gameStatus == "success" then
        love.graphics.print("You win!")
    elseif gameStatus == "fail" then
        love.graphics.print("Game over")
    else
        love.graphics.print("mode = " .. mode)
    end
end
