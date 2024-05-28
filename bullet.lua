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

function Bullet:isOffScreen(cameraX, cameraY, screenWidth, screenHeight)
    -- Calculate the visible area considering the camera position
    local leftEdge = cameraX
    local rightEdge = cameraX + screenWidth
    local topEdge = cameraY
    local bottomEdge = cameraY + screenHeight

    -- Check if the bullet is outside the visible area
    return self.x < leftEdge or self.x > rightEdge or self.y < topEdge or self.y > bottomEdge
end


return Bullet
