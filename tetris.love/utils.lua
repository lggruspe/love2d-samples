local M = {}

function M.getRandomShape()
    local shapes = {"I", "J", "L", "T", "S", "Z"}
    return shapes[math.random(1, 6)]
end

return M
