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

local Snake = {}
function Snake:new()
    snake = {}
    table.insert(snake, Square:new{ x=300, y=300, dx=10, dy=0 })
    self.__index = self
    return setmetatable(snake, self)
end

function Snake:grow()
    tail = self[#self]
    square = Square:new{
        x = tail.x - tail.dx,
        y = tail.y - tail.dy,
        dx = tail.dx,
        dy = tail.dy, 
        prev=tail
    }
    tail.next = square      -- or self[#self].next = square
    table.insert(self, square)
end

function love.load()
    snake = Snake:new()
    time = 0 
end

function love.update(dt)
    -- should be every second
    print(dt)
    time = time + dt
    if time >= 0.25 then
        for i = #snake, 2, -1 do
            snake[i].x = snake[i-1].x
            snake[i].y = snake[i-1].y
            snake[i].dx = snake[i-1].dx
            snake[i].dy = snake[i-1].dy
        end
        snake[1].x = snake[1].x + snake[1].dx
        snake[1].y = snake[1].y + snake[1].dy
        time = 0
    end
end

function love.keypressed(key)
    -- TODO prevent from going the opposite direction
    if key == "w" then
        snake[1].dx = 0
        snake[1].dy = -10
    elseif key == "a" then
        snake[1].dx = -10
        snake[1].dy = 0
    elseif key == "s" then
        snake[1].dx = 0
        snake[1].dy = 10
    elseif key == "d" then
        snake[1].dx = 10
        snake[1].dy = 0
    elseif key == "space" then
        snake:grow()
    end
end

function love.draw()
    -- draw squares in snake
    for _, square in pairs(snake) do
        love.graphics.rectangle("line", square.x, square.y, 10, 10)
    end
end
