ca = require('ca')

function love.load()
    cell_size = 15
    border_size = 1     -- borders are within the cell
    grid_width = math.floor(love.graphics.getWidth()/cell_size)
    grid_height = math.floor(love.graphics.getHeight()/cell_size)
    grid = ca.CA:new(grid_width, grid_height)
    mode = "continuous"
    time = 0

    love.graphics.setBackgroundColor(0,0,0)
end

function love.update(dt)
    if mode == "continuous" then
        time = time + dt
        if time >= 0.25 then
            grid:evolve()
            time = 0
        end    
    end
end

function love.mousepressed(x, y)
    -- transform (x, y) to cell on the grid, then toggle that cell
    local x = math.floor(x/cell_size) + 1
    local y = math.floor(y/cell_size) + 1
    if 1 <= y and y <= grid_height and 1 <= y and x <= grid_width then
        grid[y][x] = not grid[y][x]
    end
end

function love.keypressed(key)
    if key == "backspace" then
        -- clear grid
        grid = ca:new(grid_width, grid_height)
    elseif key == "return" then
        -- next step
        if mode == "step" then
            grid:evolve()
        end
    elseif key == "space" then
        -- change mode
        if mode == "step" then
            mode = "continuous"
        elseif mode == "continuous" then
            mode = "step"
        end
    end
end

function love.draw()
    grid:draw(cell_size, border_size)
    love.graphics.setColor(0,0,0)
    love.graphics.print("mode = " .. mode)
end
