local bob = loadstring(game:HttpGet("https://raw.githubusercontent.com/antgame11/trolladmin/refs/heads/main/helper.lua"))()
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

local function rwait(time)
	waitforchild(Workspace, "dhjkashgdjkashdjas", time)
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
	rwait(1)
	print(plrname)
	local otherplayer = PlayerID(plrname)[1]
	local otherposition = getposition(getRootPart(otherplayer))
	setposition(getRootPart(getlocalplayer()), otherposition)
end,"Brings yourself to another player","<plr>")

addCommand({"ws","walkspeed"}, function(speed)
	local localplayer = getlocalplayer()
	local Humanoid = getHumanoid(localplayer)
	local speednum = tonumber(speed)
	if speednum > 1 and speednum < 10000 then
		bob.setwalkspeedcheck(Humanoid,speednum)
		bob.setwalkspeed(Humanoid,speednum)
	end

end,"Sets your walkspeed","<speed>")

addCommand({"jp","jumppower"}, function(jump)
	local localplayer = getlocalplayer()
	local Humanoid = getHumanoid(localplayer)
	bob.setjumppower(Humanoid,tonumber(jump))
end,"Sets your jumppower","<speed>")

addCommand({"hipheight","hh"}, function(hipheight)
	local localplayer = getlocalplayer()
	local Humanoid = getHumanoid(localplayer)
	bob.sethipheight(Humanoid,tonumber(hipheight))
end,"Sets your hipheight","<hipheight>")

addCommand({"fling"}, function(plrname)
	local otherplayer = PlayerID(plrname)[1]
	local localplayer = getlocalplayer()
	local hrp = getRootPart(localplayer)
	local prefling = getposition(hrp)
	local otherhrp = getRootPart(otherplayer)
	for b = 1, 16, 1 do
		setposition(hrp,getposition(otherhrp))
		setvelocity(hrp,{100000, 1000000, 1000000})
		setposition(hrp,getposition(otherhrp))
		rwait(0.001)
	end
	rwait(1)
	for b = 1, 10, 1 do
		setposition(hrp,prefling)
		setvelocity(hrp,{0, 0, 0})
	end
end,"flings a player i guess","<player>")

addCommand({"sit"}, function()
	local localplayer = getlocalplayer()
	local Humanoid = getHumanoid(localplayer)
	bob.setsit(Humanoid,"True")
end,"makes you sit","")



local ws = websocket_connect("ws://localhost:8765")
websocket_onmessage(ws, function(message)
	local command = string.split(message," ")
	print("Running".. message)
    callCommand(unpack(command))
end)

