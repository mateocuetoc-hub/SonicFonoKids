-- Simulation boundary: no graphics, physics, audio or engine scheduling.
-- Invalid objects reject field access just like SRB2's expired userdata.
commands, hooks, messages, objects = {}, {}, {}, {}
gamemap, leveltime, TICRATE, FRACUNIT = 100, 0, 35, 65536
ANGLE_90, ANGLE_180 = 1073741824, -2147483648
MF_SPECIAL, MF_NOGRAVITY, MF_SOLID, MF_NOSECTOR = 1, 2, 4, 8
MF2_DONTDRAW, FF_FULLBRIGHT, RF_ABSOLUTEOFFSETS, AST_COPY = 1, 32768, 1, 0
MT_STARPOST, S_RING, S_THOK = 100, 101, 102
MT_RING, MT_THOK = 103, 104
V_ALLOWLOWERCASE, V_YELLOWMAP, V_GREENMAP, V_REDMAP = 1, 2, 4, 8
V_SNAPTOTOP, V_SNAPTOLEFT, V_HUDTRANS = 16, 32, 64
for i = 0, 25 do _G[string.char(65 + i)] = i end
mobjinfo, states = {}, {}
mobjinfo[MT_RING] = { spawnstate = S_RING }
mobjinfo[MT_THOK] = { spawnstate = S_THOK }
local slot = 1000
function freeslot(...)
    for i = 1, select('#', ...) do
        slot = slot + 1
        _G[select(i, ...)] = slot
        mobjinfo[slot] = {}
    end
end
function COM_AddCommand(name, callback)
    assert(commands[name] == nil, 'Duplicate command: ' .. name)
    commands[name] = callback
end
function addHook(name, callback, objecttype)
    if name == 'HUD' then objecttype = nil end -- 'game' is a HUD context.
    if hooks[name] == nil then hooks[name] = {} end
    table.insert(hooks[name], { callback = callback, objecttype = objecttype })
end
function event(name, ...)
    local consumed = false
    local obj = select(1, ...)
    local objecttype
    if obj ~= nil and (name == 'TouchSpecial' or name == 'MobjRemoved' or name == 'MobjThinker') then
        objecttype = obj.type
    end
    for _, hook in ipairs(hooks[name] or {}) do
        if hook.objecttype == nil or objecttype == hook.objecttype then
            if hook.callback(...) == true then consumed = true end
        end
    end
    return consumed
end
function CONS_Printf(player, message) table.insert(messages, tostring(message)) end
function command(name, ...) assert(commands[name], name)(consoleplayer, ...) end
function contains(text)
    for _, message in ipairs(messages) do
        if string.find(message, text, 1, true) ~= nil then return true end
    end
    return false
end
function FixedMul(a, b) return a / FRACUNIT * b end
function R_PointToAngle2(x1, y1, x2, y2) return 0 end
function cos(angle)
    if angle == 0 then return FRACUNIT end
    if angle == ANGLE_90 then return 0 end
    return -FRACUNIT
end
function sin(angle)
    if angle == ANGLE_90 then return FRACUNIT end
    return 0
end
stateChanges, exitCount, objectWrites = 0, 0, 0
local function newObject(data)
    data.valid = true
    return setmetatable({}, {
        __index = function(_, key)
            if key ~= 'valid' and data.valid == false then
                error('Invalid mobj read: ' .. key)
            end
            return data[key]
        end,
        __newindex = function(_, key, value)
            if key ~= 'valid' and data.valid == false then
                error('Invalid mobj write: ' .. key)
            end
            objectWrites = objectWrites + 1
            data[key] = value
        end
    })
end
function P_SpawnMobj(x, y, z, objecttype)
    local obj = newObject({ x = x, y = y, z = z, type = objecttype,
        angle = 0, floorz = 0, flags = 0, flags2 = 0, state = -1,
        frame = 0, sprite = 0 })
    table.insert(objects, obj)
    return obj
end
function P_RemoveMobj(obj)
    assert(obj.valid == true, 'Double remove')
    event('MobjRemoved', obj)
    obj.valid = false
end
function P_SetMobjStateNF(obj, state)
    stateChanges = stateChanges + 1
    obj.state = state
end
function P_SetOrigin(obj, x, y, z) obj.x, obj.y, obj.z = x, y, z end
function G_SetCustomExitVars(map, skip) exitMap, skipIntermission = map, skip end
function G_ExitLevel() exitCount = exitCount + 1 end
consoleplayer = { rings = 20 }
consoleplayer.mo = P_SpawnMobj(-7072 * FRACUNIT, 0, 0, 0)
consoleplayer.mo.player = consoleplayer
consoleplayer.mo.subsector = { sector = { tag = 100 } }
players = { iterate = function(_, previous)
    if previous == nil then return consoleplayer end
end }
camera = { angle = 0 }
function tick(count)
    for i = 1, count do
        leveltime = leveltime + 1
        event('ThinkFrame')
    end
end
function visibleWords()
    local list = {}
    for _, obj in ipairs(objects) do
        if obj.valid == true and obj.type == MT_FONO_OBJETO then table.insert(list, obj) end
    end
    return list
end
function touchWord(word)
    for _, obj in ipairs(visibleWords()) do
        if obj.fono_palabra == word then
            event('TouchSpecial', obj, consoleplayer.mo)
            return obj
        end
    end
    error('Missing pictogram: ' .. word)
end
function newMap(map, spawnBeforeMapLoad)
    for _, obj in ipairs(objects) do
        if obj.valid == true then P_RemoveMobj(obj) end
    end
    gamemap, leveltime = map, 0
    consoleplayer.mo = P_SpawnMobj(-7072 * FRACUNIT, 0, 0, 0)
    consoleplayer.mo.player = consoleplayer
    consoleplayer.mo.subsector = { sector = { tag = 100 } }
    if spawnBeforeMapLoad == true then event('PlayerSpawn', consoleplayer) end
    event('MapLoad')
    if spawnBeforeMapLoad ~= true then event('PlayerSpawn', consoleplayer) end
    tick(1)
end
function moveToSector(tag, x)
    consoleplayer.mo.subsector.sector.tag = tag
    if x ~= nil then consoleplayer.mo.x = x * FRACUNIT end
    event('PlayerThink', consoleplayer)
end
function jsonReport()
    messages = {}
    command('fonojson')
    local lines = {}
    for i = 2, #messages - 1 do table.insert(lines, messages[i]) end
    return table.concat(lines, '\n')
end
function hudHas(text, x, y)
    local found = false
    event('HUD', { drawString = function(drawx, drawy, label)
        if label == text and (x == nil or x == drawx) and (y == nil or y == drawy) then
            found = true
        end
    end }, consoleplayer)
    return found
end
