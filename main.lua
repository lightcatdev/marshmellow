-- Load necessary modules
local Player = require("player")
local Bullet = require("bullet")
local Target = require("target")
local checkCollision = require("collision")

-- Screen shake variables
local screenShakeMagnitude = 0
local screenShakeDuration = 0
local screenShakeTime = 0

-- Sound variables
local shootSound
local explosionSound
local hitSound

-- Camera variables
local cameraX = 0
local cameraY = 0
local cameraSpeed = 5 -- Adjust as needed for desired smoothness

-- Score variables
local score = 0
local scoreFont = love.graphics.newFont(36) -- Define a font for the score

-- Enemy variables
local enemies = {} -- Table to store enemies
local enemySpawnTimer = 0
local enemySpawnInterval = 2 -- Spawn new enemy every 2 seconds

-- Bullets table
local bullets = {} -- Table to store bullets

function love.load()
    -- Initialize player
    player = Player.new(400, 300, 40)
    
    -- Load sounds
    shootSound = love.audio.newSource("sounds/Shoot.wav", "static")
    explosionSound = love.audio.newSource("sounds/Explosion.wav", "static")
    hitSound = love.audio.newSource("sounds/Hit.wav", "static")
end

function love.update(dt)
    player:update(dt, cameraX, cameraY)

    -- Shooting bullets
    if love.mouse.isDown(1) and player.timeSinceLastShot >= player.shootCooldown then
        table.insert(bullets, Bullet.new(player.x, player.y, player.rotation))
        playSound(shootSound, true)
        player.timeSinceLastShot = 0
    end

    -- Update bullets
    for i = #bullets, 1, -1 do
        local bullet = bullets[i]
        bullet:update(dt)

        if bullet:isOffScreen(cameraX, cameraY, love.graphics.getWidth(), love.graphics.getHeight()) then
            table.remove(bullets, i)
        else
            for j = #enemies, 1, -1 do
                local enemy = enemies[j]
                if checkCollision(bullet, enemy) then
                    local damage = math.random(5, 8) -- Random damage between 5 and 8
                    enemy:hit(damage) -- Pass the damage value to the hit function
                    playSound(hitSound, false)
                    table.remove(bullets, i)
                    score = score + math.random(100, 250)
                    if enemy:isDead() then
                        table.remove(enemies, j)
                        playSound(explosionSound, false)
                        startScreenShake(0.5, 5)
                    end
                    break
                end
            end
        end
    end

    -- Update enemies
    for _, enemy in ipairs(enemies) do
        enemy:update(dt, player)
        if checkCollision(player, enemy) then
            player:hit(1) -- Decrease player's health when colliding with enemy
        end
    end

    -- Smoothly follow the player with the camera
    cameraX = lerp(cameraX, player.x - love.graphics.getWidth() / 2, cameraSpeed * dt)
    cameraY = lerp(cameraY, player.y - love.graphics.getHeight() / 2, cameraSpeed * dt)

    updateScreenShake(dt)

    -- Spawn new enemies
    enemySpawnTimer = enemySpawnTimer + dt
    if enemySpawnTimer >= enemySpawnInterval then
        spawnEnemy()
        enemySpawnTimer = 0
    end
end

function love.draw()
    -- Draw score UI
    love.graphics.setFont(scoreFont)
    love.graphics.printf("Score: " .. score, 0, 20, love.graphics.getWidth(), "center")
    love.graphics.push()
    love.graphics.translate(-cameraX, -cameraY) -- Translate by the negative of the camera position

    -- Apply screen shake
    local shakeX = love.math.random(-screenShakeMagnitude, screenShakeMagnitude)
    local shakeY = love.math.random(-screenShakeMagnitude, screenShakeMagnitude)
    love.graphics.translate(shakeX, shakeY)

    player:draw()
    for _, bullet in ipairs(bullets) do
        bullet:draw()
    end
    for _, enemy in ipairs(enemies) do
        enemy:draw()
    end

    love.graphics.pop()
end

function startScreenShake(duration, magnitude)
    screenShakeDuration = duration
    screenShakeMagnitude = magnitude
    screenShakeTime = 0
end

function updateScreenShake(dt)
    if screenShakeTime < screenShakeDuration then
        screenShakeTime = screenShakeTime + dt
    else
        -- Reset screen shake variables
        screenShakeTime = 0
        screenShakeMagnitude = 0
        screenShakeDuration = 0
    end
end

function playSound(sound, pitchRandomization)
    if pitchRandomization == true then
        local pitch = love.math.random(0.8, 1.2)
        sound:setPitch(pitch)
    end
    love.audio.play(sound:clone())
end

-- Linear interpolation function
function lerp(a, b, t)
    return a + (b - a) * t
end

function spawnEnemy()
    local enemy = Target.new(cameraX + math.random(100, love.graphics.getWidth() - 100), cameraY + math.random(100, love.graphics.getHeight() - 100), 40)
    table.insert(enemies, enemy)
end
