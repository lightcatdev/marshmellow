local DamageCounter = {}

function DamageCounter.new(x, y, damage)
    local self = {}

    self.x = x
    self.y = y
    self.damage = damage
    self.duration = 1 -- Duration in seconds
    self.alpha = 255 -- Initial alpha value (fully opaque)
    self.speed = 100 -- Speed of animation (pixels per second)
    self.timer = 0 -- Timer to track duration

    function self:update(dt)
        self.timer = self.timer + dt
        if self.timer >= self.duration then
            return true -- Signal that the counter should be removed
        end

        -- Move counter upwards
        self.y = self.y - self.speed * dt

        -- Fade out counter
        local fadeTime = self.duration * 0.75 -- Start fading out when 75% of duration is reached
        if self.timer > fadeTime then
            local fadeDuration = self.duration - fadeTime
            local fadeSpeed = 255 / fadeDuration
            self.alpha = self.alpha - fadeSpeed * dt
        end
    end

    function self:draw()
        love.graphics.setFont(love.graphics.newFont()) -- Reset font to default
        love.graphics.setColor(255, 255, 255, self.alpha)
        love.graphics.print(self.damage, self.x, self.y)
        love.graphics.setColor(255, 255, 255, 255) -- Reset color
    end    
    return self
end

return DamageCounter
