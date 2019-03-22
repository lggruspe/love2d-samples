-- TODO loop screen, or add walls

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

local function createRandomFruit(width, height, square_size, blacklist)
    -- (width and height of the window)
    -- fruit must not be in blacklist

    local function isBlacklisted(x, y)
        for _, pair in pairs(blacklist) do
            if pair.x == x and pair.y == y then
                return true
            end
        end
        return false
    end

    repeat 
        x = math.random(0, width-1)
        y = math.random(0, height-1)
        x = x - x % square_size
        y = y - y % square_size
    until(not isBlacklisted(x, y))
    return Square:new{ x=x, y=y, dx=0, dy=0 }
end

local Snake = {}
function Snake:new()
    -- dx and dy are in pixels
    square_size = 20
    snake = {
        alive = true,
        direction = "right",
        nextDirection = "right",
        squares = { Square:new{ x = 300, y = 300, dx = square_size, dy = 0} }
    }
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

function Snake:changeNextDirection(direction)
    if direction == "up" or direction == "down" or direction == "left" or direction == "right" then
        self.nextDirection = direction
    end
end

function Snake:move(square_size)
    if #self.squares >= 2 then
        table.remove(self.squares)
    end

    -- check if self.direction and self.nextDirection are compatible
    -- then change coordinates
    dir = self.direction
    nextDir = self.nextDirection
    head = self:getHead()
    coordinates = {
        up = { x = head.x, y = head.y - square_size },
        down = { x = head.x, y = head.y + square_size },
        left = { x = head.x - square_size, y = head.y },
        right = { x = head.x + square_size, y = head.y }
    }
    if ((nextDir == "up" or nextDir == "down") and (dir == "left" or dir == "right")
            or (nextDir == "left" or nextDir == "right") and (dir == "up" or dir == "down")) then
        square = Square:new(coordinates[nextDir])
        self.direction = nextDir
    else
        -- cancel most recent input
        square = Square:new(coordinates[dir])
        self.nextDirection = dir
    end
    table.insert(self.squares, 1, square)
end

function Snake:getHead()
    return self.squares[1]
end

function Snake:collides(squares)
    -- check if snake collides with squares[2:] (first member excluded)
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
    snake:grow()
    snake:grow()
    fruit = createRandomFruit(love.graphics.getWidth(), love.graphics.getHeight(), square_size, snake.squares)
    time = 0
end

function love.update(dt)
    time = time + dt
    if snake.alive then
        if time >= 0.15 then
            snake:move(square_size)
            if snake:collides{"dummy", fruit} then
                snake:grow()
                fruit = createRandomFruit(love.graphics.getWidth(), love.graphics.getHeight(), square_size, snake.squares)
            end
            if snake:collides(snake.squares) then
                snake.alive = false
                snake:kill()
            end
            time = 0
        end
    else
        -- TODO if snake is dead, wait for snake to shrink to its original size
        if time >= 1.5 then
            snake = Snake:new()
        end
    end
end

function love.keypressed(key)
    if snake.alive then
        if key == "up" or key == "down" or key == "left" or key == "right" then
            snake:changeNextDirection(key)
        end
    end
end

function love.draw()
    snake:draw()
    fruit:draw(square_size, 1,0,0)
end
