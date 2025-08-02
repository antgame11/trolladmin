local Players = findservice(Game, "Players")
local LocalPlayer = getlocalplayer()
local CONTACT_FORCE = 1700
local FLING_DURATION = 6

local isFlinging = false

local function getRootPart(player)
    local char = getcharacter(player)
    if not char then return nil end
    return findfirstchild(char, "HumanoidRootPart")
end

local function safeGetPosition(part)
    local pos = {getposition(part)}
    if type(pos[1]) == "table" then
        return pos[1].x or pos[1].X, pos[1].y or pos[1].Y, pos[1].z or pos[1].Z
    else
        return pos[1], pos[2], pos[3]
    end
end

local function fling(player)
    if isFlinging then return false end

    local targetRoot = getRootPart(player)
    local localRoot = getRootPart(LocalPlayer)

    if not targetRoot or not localRoot then return false end

    isFlinging = true
    spawn(function()
        local start = tick()
        while tick() - start < FLING_DURATION and isFlinging do
            local x, y, z = safeGetPosition(targetRoot)
            if x and y and z then
                setposition(localRoot, {x, y, z})
                setvelocity(localRoot, {
                    math.random(-CONTACT_FORCE, CONTACT_FORCE),
                    math.random(0, CONTACT_FORCE),
                    math.random(-CONTACT_FORCE, CONTACT_FORCE)
                })
            end
            wait()
        end
        isFlinging = false
    end)

    return true
end

return fling