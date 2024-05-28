local function checkCollision(bullet, target)
    return bullet.x > target.x - target.size / 2 and bullet.x < target.x + target.size / 2 and
           bullet.y > target.y - target.size / 2 and bullet.y < target.y + target.size / 2
end

return checkCollision
