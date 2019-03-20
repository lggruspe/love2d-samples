local MenuSelection = {}
function MenuSelection:new()
    -- maps selection name to game screen
    selection = {}

    self.__index = self
    return setmetatable(selection, self)
end

local Menu = {}
function Menu:new(selection)
    -- assume selection is nonempty table of MenuSelections
    menu = {}
    menu.selected = 1
    menu.selection = selection
    self.__index = self
    return setmetatable(menu, self)
end

function Menu:move_selection(key)
    mvmt = 0
    if key == "up" then
        mvmt = - 1
    elseif key == "down" then
        mvmt = 1
    end

    self.selected = self.selected + mvmt
    if self.selected == 0 then
        self.selected = #(self.selection)
    elseif self.selected == #(self.selection) + 1 then
        self.selected = 1
    end
end

function Menu:draw()
    -- will this work if placed in anothe file?
    for i, choice in pairs(self.selection) do
        if (i == self.selected) then
            love.graphics.setColor(0.5,0.5,1)
        else
            love.graphics.setColor(1,1,1)
        end
        love.graphics.print(choice, 10, 10*i)
    end
end

function love.load()
    game_screen = "menu"
    main_menu = Menu:new{ "Start game", "Continue", "Options" }
end

function love.update(dt)

end

function love.keypressed(key)
    print(key)
    if game_screen == "menu" then
        if key == "return" then
            -- change game_screen
        else
            main_menu:move_selection(key)
        end

    end
end

function love.draw()
    if game_screen == "menu" then
        main_menu:draw()
    end
end
