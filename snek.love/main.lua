local Square = {}
function Square:new(square)
    -- assume square has x and y
    -- x, y, dx, dy, next, prev
    if not square.dx or not square.dy then
        square.dx = 0
        square.dy = 0
    end
    self.__index = self
    return setmetatable(square, self)
end

function Square:draw(square_size, r,g,b)
    love.graphics.setColor(r,g,b)
    love.graphics.rectangle("fill", self.x, self.y, square_size, square_size)
end

local function createRandomFruit(width, height, square_size)
    -- (width and height of the window)
    -- TODO fruit must not be in self.squares
    x = math.random(0, width-1)
    y = math.random(0, height-1)
    x = x - x % square_size
    y = y - y % square_size
    return Square:new{ x=x, y=y, dx=0, dy=0 }
end

local Snake = {}
function Snake:new()
    -- TODO set x, y, dx and dy from parameters
    -- TODO make new snake longer
    -- dx and dy are in pixels
    square_size = 20
    snake = { alive = true, squares = { Square:new{ x = 300, y = 300, dx = square_size, dy = 0} } }
    self.__index = self
    return setmetatable(snake, self)
end

function Snake:grow()
    tail = self.squares[#self.squares]
    square = Square:new{
        x = tail.x - tail.dx,
        y = tail.y - tail.dy,
        dx = tail.dx,
        dy = tail.dy, 
        prev=tail
    }
    tail.next = square
    table.insert(self.squares, square)
end

function Snake:draw()
    for _, square in pairs(self.squares) do
        if self.alive then
            love.graphics.setColor(0,1,0)
        else
            love.graphics.setColor(0.1,0.1,0.1)
        end
        love.graphics.rectangle("fill", square.x, square.y, square_size, square_size)
    end
end

function Snake:move()
    -- TODO loop screen
    if #self.squares >= 2 then
        table.remove(self.squares)
    end
    old_head = self.squares[1]
    new_head = Square:new{
        x = old_head.x + old_head.dx,
        y = old_head.y + old_head.dy,
        dx = old_head.dx,
        dy = old_head.dy
    }
    table.insert(self.squares, 1, new_head)
end

function Snake:getHead()
    return self.squares[1]
end

function Snake:collides(squares)
    -- check if snake collides with squares[2:] (first member excluded)
    -- FIXME
    -- TODO check if fruit is generate within snake.squares
    --[[
    print(squares)
    for _, snake_square in pairs(self.squares) do
        for _, square in pairs(squares) do
            if snake_square.x == square.x and snake_square.y == square.y then
                return true
            end
        end
    end
    ]]--

    head = self:getHead()
    for i = 2, #squares do
        square = squares[i]
        if head.x == square.x and head.y == square.y then
            return true
        end
    end
    return false
end

function Snake:kill()
    head = self:getHead()
    head.dx = 0
    head.dy = 0
end

function love.load()
    square_size = 20
    snake = Snake:new()
    fruit = createRandomFruit(love.graphics.getWidth(), love.graphics.getHeight(), square_size)
    time = 0
end

function love.update(dt)
    time = time + dt
    if snake.alive then
        if time >= 0.15 then
            snake:move()
            if snake:collides{"dummy", fruit} then
                snake:grow()
                fruit = createRandomFruit(love.graphics.getWidth(), love.graphics.getHeight(), square_size)
            end
            if snake:collides(snake.squares) then
                snake.alive = false
                snake:kill()
            end
            time = 0
        end
    else
        -- TODO if snake is dead, wait for snake to shrink to its original size
        --if time >= 0.15*#snake.squares then
        if time >= 2 then
            snake = Snake:new()
        end
    end
end

function love.keypressed(key)
    -- also prevents snake from going the opposite direction
    -- FIXME the snake can go the opposite direction if you press keys fast enough
    -- (buffer input?)
    if snake.alive then
        head = snake:getHead()
        if key == "up" and head.dy ~= square_size then
            head.dx = 0
            head.dy = -square_size
        elseif key == "left" and head.dx ~= square_size then
            head.dx = -square_size
            head.dy = 0
        elseif key == "down" and head.dy ~= -square_size then
            head.dx = 0
            head.dy = square_size
        elseif key == "right" and head.dx ~= -square_size then
            head.dx = square_size
            head.dy = 0
        end
    end
end

function love.draw()
    snake:draw()
    fruit:draw(square_size, 1,0,0)
end
