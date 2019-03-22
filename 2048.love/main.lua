m2048 = require("2048")

function love.load()
    board = m2048.Board:new()
    board:spawn()
    board:spawn()
    square_size = 80

    math.randomseed(os.clock())
    font = love.graphics.newFont(30)
    love.graphics.setFont(font)
    love.window.setMode(square_size*4, square_size*4)
end

function love.draw()
    board:draw()
end

function love.keypressed(key)
    local moved = false
    if key == "up" then
        moved = board:slideUp()
    elseif key == "down" then
        moved = board:slideDown()
    elseif key == "left" then
        moved = board:slideLeft()
    elseif key == "right" then
        moved = board:slideRight()
    elseif key == "space" then
        board = m2048.Board:new()
        board:spawn()
        board:spawn()
    end

    local isDir = (key == "up" or key == "down" or key == "left" or key == "right")
    if isDir and moved then
        board:spawn()
    end
end
