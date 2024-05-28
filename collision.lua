local function checkCollision(entity1, entity2)
    return entity1.x > entity2.x - entity2.size / 2 and entity1.x < entity2.x + entity2.size / 2 and
           entity1.y > entity2.y - entity2.size / 2 and entity1.y < entity2.y + entity2.size / 2
end

return checkCollision
