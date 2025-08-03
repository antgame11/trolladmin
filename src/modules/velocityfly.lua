return function(movespeed)
    if movespeed == nil then
        movespeed = 1
    end
    SET_MEMORY_READ_STRENGTH(0.00001)
    SET_MEMORY_WRITE_STRENGTH(0.00001)

    local function getRootPart(player)
        local character = getcharacter(player)
        return findfirstchild(character, "HumanoidRootPart")
    end

    local function getCamera()
        return findfirstchild(Workspace, "Camera")
    end

    local function multiplyVector(vector, scalar)
        return {x = vector.x * scalar, y = vector.y * scalar, z = vector.z * scalar}
    end

    local function addVector(...)
        local args = {...}
        local newvector = {x = 0, y = 0, z = 0}
        for _, v in pairs(args) do
            newvector.x += v.x
            newvector.y += v.y
            newvector.z += v.z
        end
        return newvector
    end

    while true do
        local player = getlocalplayer()
        local hrp = getRootPart(player)

        local cam = getCamera()

        local look = getlookvector(cam)
        local right = getrightvector(cam)
        local defaultVel = getvelocity(hrp)

        local moveDir = {x = 0, y = 0, z = 0}
        local keys = getpressedkeys()
        if table.find(keys,"W") then
            moveDir = addVector(moveDir, {x = look.x, y = look.y, z = look.z})
        end
        if table.find(keys,"S") then
            moveDir = addVector(moveDir, {x = -look.x, y = -look.y, z = -look.z})
        end
        if table.find(keys,"A") then
            moveDir = addVector(moveDir, {x = -right.x, y = look.y, z = -right.z})
        end
        if table.find(keys,"D") then
            moveDir = addVector(moveDir, {x = right.x, y = look.y, z = right.z})
        end
        local moveVel = multiplyVector(moveDir, movespeed * 100)
        setvelocity(hrp, moveVel)
    end
end