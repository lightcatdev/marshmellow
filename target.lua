local Target = {}
Target.__index = Target

function Target.new(x, y, size, health)
    health = health or 100 -- Default initial health is 100
    local self = setmetatable({}, Target)
    self.x = x
    self.y = y
    self.size = size * 2
    self.initialSize = size * 2 -- Set initial size attribute
    self.color = {1, 1, 1} -- Initial color (white)
    self.targetColor = {1, 1, 1} -- Target color for interpolation
    self.shrinkFactor = 0.9 -- Shrink to 90% its size when hit
    self.growSpeed = 2 -- Speed at which it grows back
    self.isHit = false -- Hit status
    self.hitTime = 0 -- Time since last hit
    self.hitCooldown = 0.2 -- Time to flash red
    self.colorLerpSpeed = 5 -- Speed at which color changes back to white
    self.followSpeed = 100 -- Speed at which the target follows the player
    self.rotation = 0 -- Initial rotation
    self.rotationSpeed = 2 -- Speed of rotation
    self.health = health -- Initial health
    return self
end

function Target:update(dt, player)
    -- Spin constantly
    self.rotation = self.rotation + self.rotationSpeed * dt

    -- Follow the player
    local directionX = player.x - self.x
    local directionY = player.y - self.y
    local distance = math.sqrt(directionX^2 + directionY^2)

    if distance > 0 then
        local moveX = directionX / distance * self.followSpeed * dt
        local moveY = directionY / distance * self.followSpeed * dt
        self.x = self.x + moveX
        self.y = self.y + moveY
    end

    -- Grow back to initial size if it's smaller
    if self.size < self.initialSize then
        self.size = self:lerpSize(self.size, self.initialSize, self.growSpeed * dt)
    end

    -- Smoothly transition the color back to white
    self.color = {
        self:lerp(self.color[1], self.targetColor[1], self.colorLerpSpeed * dt),
        self:lerp(self.color[2], self.targetColor[2], self.colorLerpSpeed * dt),
        self:lerp(self.color[3], self.targetColor[3], self.colorLerpSpeed * dt)
    }

    if self.isHit then
        self.hitTime = self.hitTime + dt
        if self.hitTime >= self.hitCooldown then
            self.isHit = false
            self.hitTime = 0
            self.targetColor = {1, 1, 1} -- Transition back to white
        end
    end
end


function Target:lerp(a, b, t)
    return a + (b - a) * t
end

function Target:lerpSize(currentSize, targetSize, speed)
    -- Perform linear interpolation to smoothly grow the size back to initial size
    return currentSize + (targetSize - currentSize) * speed
end

function Target:draw()
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    love.graphics.rotate(self.rotation)
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", -self.size / 2, -self.size / 2, self.size, self.size)
    love.graphics.pop()
    love.graphics.setColor(1, 1, 1) -- Reset color to white
end

function Target:hit(damage)
    self.isHit = true
    self.size = self.size * self.shrinkFactor -- Shrink to 90% of current size
    if self.size < self.initialSize * 0.5 then
        self.size = self.initialSize * 0.5 -- Ensure size doesn't go below 50% of initial size
    end
    self.health = self.health - damage -- Decrease health based on damage received
    self.targetColor = {1, 0, 0} -- Transition to red when hit
end

function Target:isDead()
    return self.health <= 0
end

function Target:returnPos()
    return self.x, self.y
end

return Target
