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

return M
