local M = {}

M.Board = {}

function M.Board:new()
    local board = {}
    for i = 1, 4 do
        board[i] = {}
        for j = 1, 4 do
            board[i][j] = 0
        end
    end
    self.__index = self
    return setmetatable(board, self)
end

function M.Board:spawn()
    -- spawn 2 or 4 in a free square, assuming there's >= 1 free square
    local possibleSquares = {}
    for i = 1, 4 do
        for j = 1, 4 do
            if self[i][j] == 0 then
                table.insert(possibleSquares, { i = i, j = j })
            end
        end
    end

    local idx = math.random(1, #possibleSquares)
    local square = possibleSquares[idx]
    local i = square.i
    local j = square.j
    self[i][j] = 2

    -- 50% the 2 becomes a 4
    if math.random() < 0.5 then
        self[i][j] = 4
    end
end

function M.Board:transpose()
    for i = 1, 3 do
        for j = i+1, 4 do
            local a = self[i][j]
            self[i][j] = self[j][i]
            self[j][i] = a
        end
    end
end

local function areListsEqual(A, B)
    if #A ~= #B then
        return false
    end

    for i = 1, #A do
        if A[i] ~= B[i] then
            return false
        end
    end
    return true
end

function M.Board:slideLeft()
    local function slideRow(row)
        -- delete zero elements
        local strippedRow = {}
        for _, a in pairs(row) do
            if a ~= 0 then
                table.insert(strippedRow, a)
            end
        end

        -- combine adjancent numbers that are equal
        local newRow = {}
        while(#strippedRow > 0) do
            local a = table.remove(strippedRow, 1)
            local b = table.remove(strippedRow, 1)
            if b and a == b then
                table.insert(newRow, 2*a)
            else
                table.insert(newRow, a)
                if b then
                    table.insert(strippedRow, 1, b)
                end
            end
        end


        -- copy newRow to row, while checking if the row moved
        local moved = false
        for i = 1, 4 do
            local a = newRow[i]
            if not a then
                a = 0
            end
            if row[i] ~= a then
                row[i] = a
                moved = true
            end
        end
        return moved
    end

    local moved = false
    for _, row in pairs(self) do
        if slideRow(row) then
            moved = true
        end
    end
    return moved
end

function M.Board:slideRight()
    local function slideRow(row)
        local strippedRow = {}
        for _, a in pairs(row) do
            if a ~= 0 then
                table.insert(strippedRow, a)
            end
        end

        local newRow = {}
        while(#strippedRow > 0) do
            local a = table.remove(strippedRow)
            local b = table.remove(strippedRow)
            if b and a == b then
                table.insert(newRow, 2*a)
            else
                table.insert(newRow, a)
                if b then
                    table.insert(strippedRow, b)
                end
            end
        end

        -- copy newRow back to row in reverse, while checking if the array moved
        local moved = false
        for i = 1, #newRow do
            if row[5-i] ~= newRow[i] then
                row[5 - i] = newRow[i]
                moved = true
            end
        end
        for i = #newRow + 1, 4 do
            if row[5-i] ~= 0 then
                row[5 - i] = 0
                moved = true
            end
        end
        return moved
    end

    local moved = false
    for _, row in pairs(self) do
        if slideRow(row) then
            moved = true
        end
    end
    return moved
end

function M.Board:slideUp()
    self:transpose()
    local moved = self:slideLeft()
    self:transpose()
    return moved
end

function M.Board:slideDown()
    self:transpose()
    local moved = self:slideRight()
    self:transpose()
    return moved
end

-- the ff. needs love

function M.Board:draw()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()

    local y = 0
    for _, row in pairs(self) do
        local x = 0
        for _, square in pairs(row) do
            love.graphics.rectangle("line", x, y, square_size, square_size)
            if square > 0 then
                love.graphics.print(square, x, y)
            end
            x = x + square_size
        end
        y = y + square_size
    end
end

return M
