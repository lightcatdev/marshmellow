local function checkCollision(entity1, entity2)
    local dx = entity1.x - entity2.x
    local dy = entity1.y - entity2.y
    local distanceSquared = dx * dx + dy * dy
    local radiusSum = (entity1.size + entity2.size) / 2
    return distanceSquared < radiusSum * radiusSum
end

return checkCollision
