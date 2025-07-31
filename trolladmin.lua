local bob = loadstring(game:HttpGet("https://raw.githubusercontent.com/DCHARLESAKAMRGREEN/Severe-Luas/refs/heads/main/Internal%20Helper.lua"))()
local walkspeedran = false
local commands = {}
function PlayerID(playername)
    local playersService = findservice(Game, "Players")
    local players = getchildren(playersService)

    local PlayerName = playername:lower()
    for _, v in pairs(players) do
        local name = getname(v):lower()
        if name:find(PlayerName, 1, true) then
            return {v}
        end
    end

    return {}
end

local function addCommand(aliases, exec, description, parameters)
	local primary = aliases[1]
	commands[primary] = 
		{
			aliases = aliases,
			exec = exec,
			description = description,
			params = parameters,
		}
end



local function callCommand(cmdName, ...)
	print(cmdName)
	local cmd = commands[cmdName]
	if cmd then
		return cmd.exec(...)
	end
	for _, v in pairs(commands) do
		for _, alias in ipairs(v.aliases) do
			if alias == cmdName then
				return v.exec(...)
			end
		end
	end
end

local function getRootPart(player)
	local character = getcharacter(player)
	return findfirstchild(character, "HumanoidRootPart")
end

local function getHumanoid(player)
	local character = getcharacter(player)
	return findfirstchild(character, "Humanoid")
end

addCommand({"to","goto","tp"}, function(plrname)
	print(plrname)
	local otherplayer = PlayerID(plrname)[1]
	local otherposition = getposition(getRootPart(otherplayer))
	setposition(getRootPart(getlocalplayer()), otherposition)
end,"Brings yourself to another player","<plr>")

addCommand({"ws","walkspeed"}, function(speed)
	local localplayer = getlocalplayer()
	local Humanoid = getHumanoid(localplayer)
	if walkspeedran == false then
		bob.setwalkspeedcheck(Humanoid,9999)
		walkspeedran = true
	end
	bob.setwalkspeed(Humanoid,tonumber(speed))
end,"Sets your walkspeed","<speed>")


addCommand({"wscheck","walkspeedcheck","wsc"}, function(speed)
	local localplayer = getlocalplayer()
	local Humanoid = getHumanoid(localplayer)
	bob.setwalkspeedcheck(Humanoid,tonumber(speed))
end,"Sets your walkspeed check","<speed>")

local ws = websocket_connect("ws://localhost:8765")
websocket_onmessage(ws, function(message)
	local command = string.split(message," ")
	print("Running".. message)
    callCommand(unpack(command))
end)