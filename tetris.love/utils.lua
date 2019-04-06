local M = {}

function M.getRandomShape()
    local shapes = {"I", "J", "L", "O", "T", "S", "Z"}
    return shapes[math.random(1, 7)]
end

return M
