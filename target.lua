local Target = {}
Target.__index = Target

function Target.new(x, y, size, health)
    local self = setmetatable({}, Target)
    self.x = x
    self.y = y
    self.size = size
    self.initialSize = size
    self.color = {1, 1, 1} -- Initial color (white)
    self.shrinkFactor = 0.9 -- Shrink to 90% its size
    self.growSpeed = 2 -- Speed at which it grows back
    self.isHit = false -- Hit status
    self.hitTime = 0 -- Time since last hit
    self.hitCooldown = 0.2 -- Time to flash red
    self.followSpeed = 100 -- Speed at which the target follows the player
    self.rotation = 0 -- Rotation to look at the player
    self.rotationSpeed = 5 -- Speed of rotation interpolation
    self.health = health -- Initial health
    return self
end

function Target:update(dt, player)
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

    -- Smoothly rotate to look at the player
    local targetRotation = math.atan2(player.y - self.y, player.x - self.x)
    self.rotation = self:lerpAngle(self.rotation, targetRotation, self.rotationSpeed * dt)

    if self.isHit then
        self.hitTime = self.hitTime + dt
        if self.hitTime >= self.hitCooldown then
            self.isHit = false
            self.hitTime = 0
        end
    end

    if self.size < self.initialSize then
        self.size = self.size + self.growSpeed * dt * (self.initialSize - self.size)
        if self.size > self.initialSize then
            self.size = self.initialSize
        end
    end
end

function Target:lerpAngle(a, b, t)
    local difference = b - a
    local shortest_angle = ((difference + math.pi) % (2 * math.pi)) - math.pi
    return a + shortest_angle * t
end

function Target:draw()
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    love.graphics.rotate(self.rotation)
    if self.isHit then
        love.graphics.setColor(1, 0, 0) -- Red color
    else
        love.graphics.setColor(self.color)
    end
    love.graphics.rectangle("fill", -self.size / 2, -self.size / 2, self.size, self.size)
    love.graphics.pop()
    love.graphics.setColor(1, 1, 1) -- Reset color to white
end

function Target:hit(damage)
    self.isHit = true
    self.size = self.size * self.shrinkFactor
    self.health = self.health - damage -- Decrease health based on damage received
end

function Target:isDead()
    return self.health <= 0
end

return Target
