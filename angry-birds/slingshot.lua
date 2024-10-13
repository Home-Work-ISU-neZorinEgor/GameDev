local Slingshot = {}
Slingshot.__index = Slingshot

function Slingshot:new(x, y)
    local slingshot = {}
    setmetatable(slingshot, Slingshot)

    slingshot.x = x
    slingshot.y = y
    slingshot.radius = 10
    slingshot.maxStretch = 100

    return slingshot
end

return Slingshot
