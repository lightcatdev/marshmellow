local Bullet = {}
Bullet.__index = Bullet

-- Load the bullet image
local bulletImage = love.graphics.newImage("images/Bullet.png")

function Bullet.new(x, y, rotation)
    local self = setmetatable({}, Bullet)
    self.x = x
    self.y = y
    self.rotation = rotation
    self.speed = 800
    self.size = 5
    -- Remove color attribute since we're using an image now
    return self
end

function Bullet:update(dt)
    self.x = self.x + math.cos(self.rotation) * self.speed * dt
    self.y = self.y + math.sin(self.rotation) * self.speed * dt
end

function Bullet:draw()
    -- Draw the bullet image at its position
    love.graphics.draw(bulletImage, self.x, self.y, self.rotation, 0.35, 0.35, bulletImage:getWidth()/2, bulletImage:getHeight()/2)
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
