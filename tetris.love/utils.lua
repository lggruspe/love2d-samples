local M = {}

function M.getRandomShape()
    local shapes = {"I", "J", "L", "O", "T", "S", "Z"}
    return shapes[math.random(1, 7)]
end

function M.findMember(set, ind)
    -- find member of set that satisfies ind function
    for _, a in pairs(set) do
        if ind(a) then
            return a
        end
    end
    return nil
end

function M.getShapeColor(shape)
    if shape == "I" then
        return 0, 1, 1
    elseif shape == "O" then
        return 1, 1, 0
    elseif shape == "T" then
        return 0.5, 0, 0.5
    elseif shape == "S" then
        return 0, 0.5, 0
    elseif shape == "Z" then
        return 1, 0, 0
    elseif shape == "J" then
        return 0, 0, 1
    elseif shape == "L" then
        return 1, 0.65, 0
    elseif shape == " " then
        return 0, 0, 0
    end
end

return M
