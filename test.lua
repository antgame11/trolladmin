local Players = findservice(Game, "Players")
local LocalPlayer = getlocalplayer()
local isFlinging = false

local function getrootpart(character)
    return findfirstchild(character, "HumanoidRootPart")
end

local function safeGetPosition(part)
    local pos = {getposition(part)}
    local x = pos[1] or pos.x or pos.X
    local y = pos[2] or pos.y or pos.Y
    local z = pos[3] or pos.z or pos.Z
    return x, y, z
end

local function fling(player,CONTACT_FORCE,FLING_DURATION)
    if isFlinging then return false end
    
    local targetChar = getcharacter(player)
    local localChar = getcharacter(LocalPlayer)
    if not targetChar or not localChar then return false end

    local targetRoot = getrootpart(targetChar)
    local localRoot = getrootpart(localChar)
    if not targetRoot or not localRoot then return false end

    isFlinging = true
    spawn(function()
        local startTime = tick()
        while tick() - startTime < FLING_DURATION and isFlinging do
            local x, y, z = safeGetPosition(targetRoot)
            setposition(localRoot, {x, y, z})
            setvelocity(localRoot, {
                math.random(-CONTACT_FORCE, CONTACT_FORCE),
                math.random(0, CONTACT_FORCE),
                math.random(-CONTACT_FORCE, CONTACT_FORCE)
            })
            wait()
        end
        isFlinging = false
    end)

    return true
end
local playersService = findservice(Game, "Players")
local player = findfirstchild(playersService,"JamesMcGeeOnBro")
fling(player,1700,10)