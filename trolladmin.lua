local bob = loadstring(game:HttpGet("https://raw.githubusercontent.com/antgame11/trolladmin/refs/heads/main/helper.lua"))()
local fling = loadstring(game:HttpGet("https://raw.githubusercontent.com/antgame11/trolladmin/refs/heads/main/fling.lua"))()


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
	--let's try with display names :D
    for _, v in pairs(players) do
        local name = Helper.getdisplayname(v):lower()
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

local function getCamera()
	return findfirstchild(Workspace,"Camera")
end

addCommand({"to","goto","tp"}, function(plrname)
	local otherplayer = PlayerID(plrname)[1]
	local otherposition = getposition(getRootPart(otherplayer))
	setposition(getRootPart(getlocalplayer()), otherposition)
end,"Brings yourself to another player","<plr>")

addCommand({"loopto","loopgoto"}, function(plrname)
	pcall(function ()
		thread.terminate("loopgoto")
	end)
	rwait(0.3)
	thread.create("loopgoto",function ()
		while true do
			pcall(function ()
				local otherplayer = PlayerID(plrname)[1]
				local otherposition = getposition(getRootPart(otherplayer))
				setposition(getRootPart(getlocalplayer()), otherposition)
				rwait(0.0001)
			end)
		end
	end)
end,"loop goes to a player","<plr>")

addCommand({"unloopto","unloopgoto"}, function()
	pcall(function ()
		thread.terminate("loopgoto")
	end)
end,"loop goes to a player","<plr>")

addCommand({"ws","walkspeed"}, function(speed)
	local localplayer = getlocalplayer()
	local Humanoid = getHumanoid(localplayer)
	local speednum = tonumber(speed)
	if speednum > 1 and speednum < 10000 then
		bob.setwalkspeedcheck(Humanoid,speednum)
		if tonumber(bob.getwalkspeedcheck(Humanoid)) == speednum then
			bob.setwalkspeed(Humanoid,speednum)
		end
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
	fling(otherplayer)
end,"flings a player i guess","<player>")

addCommand({"sit"}, function()
	local localplayer = getlocalplayer()
	local Humanoid = getHumanoid(localplayer)
	bob.setsit(Humanoid,"True")
end,"makes you sit","")

addCommand({"infjump"}, function()
	pcall(function ()
		thread.terminate("infjump")
	end)
	rwait(0.3)
	thread.create("infjump",function ()
	while true do
		SET_MEMORY_WRITE_STRENGTH(0.00001)
		local localplayer = getlocalplayer()
		local character = getcharacter(localplayer)
		local primarypart = findfirstchild(character, "HumanoidRootPart")

		if character and primarypart then
			local velocity = getvelocity(primarypart)
			local keys = getpressedkeys()
			
			if table.find(keys, "Space") and not pressed and velocity ~= {velocity.x, 0, velocity.z} then
				setvelocity(primarypart, {velocity.x, 50, velocity.z})
				pressed = true
			elseif not table.find(keys, "Space") then
				pressed = false
			end
		end
		
		rwait(0.000001)
	end
	end)
end,"makes you jump infinitely","")

addCommand({"setfov", "fov"}, function(fovinput)
	local fov = tonumber(fovinput)
	local camera = getCamera()
	bob.setfov(camera,fov)
end,"sets your fov","")


addCommand({"stopinfjump","noinfjump"}, function()
	thread.terminate("infjump")
end,"makes you jump infinitely","")

addCommand({"infjump"}, function()
	pcall(function ()
		thread.terminate("infjump")
	end)
	rwait(0.3)
	thread.create("infjump",function ()
	while true do
		local localplayer = getlocalplayer()
		local character = getcharacter(localplayer)
		local primarypart = findfirstchild(character, "HumanoidRootPart")

		if character and primarypart then
			local velocity = getvelocity(primarypart)
			local keys = getpressedkeys()
			
			if table.find(keys, "Space") and not pressed and velocity ~= {velocity.x, 0, velocity.z} then
				setvelocity(primarypart, {velocity.x, 50, velocity.z})
				pressed = true
			elseif not table.find(keys, "Space") then
				pressed = false
			end
		end
		
		rwait(0.000001)
	end
	end)
end,"makes you jump infinitely","")


local ws = websocket_connect("ws://localhost:8765")

websocket_onmessage(ws, function(message)
	local command = string.split(message," ")
	print("Running ".. message)
	pcall(function ()
		callCommand(unpack(command))
	end)
end)

