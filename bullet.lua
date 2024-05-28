local Bullet = {}
Bullet.__index = Bullet

function Bullet.new(x, y, rotation)
    local self = setmetatable({}, Bullet)
    self.x = x
    self.y = y
    self.rotation = rotation
    self.speed = 800
    self.size = 5
    self.color = {1, 1, 0} -- Yellow color
    return self
end

function Bullet:update(dt)
    self.x = self.x + math.cos(self.rotation) * self.speed * dt
    self.y = self.y + math.sin(self.rotation) * self.speed * dt
end

function Bullet:draw()
    love.graphics.setColor(self.color)
    love.graphics.circle("fill", self.x, self.y, self.size)
    love.graphics.setColor(1, 1, 1) -- Reset color to white
end

function Bullet:isOffScreen()
    return self.x < 0 or self.x > love.graphics.getWidth() or self.y < 0 or self.y > love.graphics.getHeight()
end

return Bullet
