-- ammo.lua
local Ammo = {}
Ammo.__index = Ammo

function Ammo.new(x, y)
    local self = setmetatable({}, Ammo)
    self.x = x
    self.y = y
    self.size = 20
    self.rotation = 0
    self.rotationSpeed = 3 -- Rotation speed in radians per second
    return self
end

function Ammo:update(dt)
    self.rotation = self.rotation + self.rotationSpeed * dt
end

function Ammo:draw()
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    love.graphics.rotate(self.rotation)
    love.graphics.setColor(0, 1, 0) -- Green color
    love.graphics.rectangle("fill", -self.size / 2, -self.size / 2, self.size, self.size)
    love.graphics.pop()
    love.graphics.setColor(1, 1, 1) -- Reset color to white
end

return Ammo
