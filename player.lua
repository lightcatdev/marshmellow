
local checkCollision = require("collision")
local bullet = require("bullet")
local Player = {}
Player.__index = Player

-- Load player hurt sound
local playerHurtSound = love.audio.newSource("sounds/Player Hurt.wav", "static")

function Player.new(x, y, size)
    local self = setmetatable({}, Player)
    self.x = x
    self.y = y
    self.size = size
    self.speed = 200
    self.acceleration = 1500
    self.maxVelocity = 1000
    self.velocityX = 0
    self.velocityY = 0
    self.rotation = 0
    self.shootCooldown = 0.07
    self.timeSinceLastShot = 0
    self.health = 100 -- Initial health
    self.ammo = 32 -- Initial ammo
    return self
end

function Player:update(dt, cameraX, cameraY)
    self.timeSinceLastShot = self.timeSinceLastShot + dt

    local dx, dy = 0, 0

    if love.keyboard.isDown("d") then
        dx = 1
    elseif love.keyboard.isDown("a") then
        dx = -1
    end

    if love.keyboard.isDown("s") then
        dy = 1
    elseif love.keyboard.isDown("w") then
        dy = -1
    end

    local ax, ay = dx * self.acceleration, dy * self.acceleration

    self.velocityX = self.velocityX * (1 - 5 * dt)
    self.velocityY = self.velocityY * (1 - 5 * dt)

    self.velocityX = self.velocityX + ax * dt
    self.velocityY = self.velocityY + ay * dt

    local currentSpeed = math.sqrt(self.velocityX^2 + self.velocityY^2)
    if currentSpeed > self.maxVelocity then
        local scale = self.maxVelocity / currentSpeed
        self.velocityX = self.velocityX * scale
        self.velocityY = self.velocityY * scale
    end

    self.x = self.x + self.velocityX * dt
    self.y = self.y + self.velocityY * dt

    local mouseX, mouseY = love.mouse.getPosition()
    mouseX = mouseX + cameraX -- Adjust mouse position based on camera
    mouseY = mouseY + cameraY -- Adjust mouse position based on camera
    self.rotation = math.atan2(mouseY - self.y, mouseX - self.x)

    -- Check for collision with target
    if target and checkCollision(self, target) then
        self:hit(1) -- Player takes 1 damage
    end
end

function Player:draw()
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    love.graphics.rotate(self.rotation)
    love.graphics.rectangle("fill", -self.size / 2, -self.size / 2, self.size, self.size)
    love.graphics.pop()
end

function Player:hit(damage)
    print(self.health)
    self.health = self.health - damage
    if self.health <= 0 then
        print("RIP")
    else
        -- Play player hurt sound
        love.audio.play(playerHurtSound)
    end
end

function Player:shootTriple(bullets, shootSound)
    if self.ammo >= 3 then
        local angleOffset = math.rad(15) -- 15 degrees offset for the side bullets
        table.insert(bullets, bullet.new(self.x, self.y, self.rotation - angleOffset))
        table.insert(bullets, bullet.new(self.x, self.y, self.rotation))
        table.insert(bullets, bullet.new(self.x, self.y, self.rotation + angleOffset))
        playSound(shootSound, true)
        self.ammo = self.ammo - 3
    end
end

return Player