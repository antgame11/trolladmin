local thread = {}
local running = {}

function thread.create(name, func)
    thread.stop(name)
    local co = coroutine.create(func)
    running[name] = co
    coroutine.resume(co)
end

function thread.terminate(name)
    local co = running[name]
    if co and coroutine.status(co) ~= "dead" then
        running[name] = nil
    end
end

return thread
