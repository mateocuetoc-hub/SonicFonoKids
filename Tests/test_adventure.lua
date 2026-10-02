newMap(100, false)
command('fonotiempo', '5')
command('fonoaventura', 'Demo_001', '5a0m')
assert(#visibleWords() == 2)
assert(consoleplayer.mo.x == -7072*FRACUNIT)
assert(hudHas('SONIC FONOKIDS', 8, 72), 'Adventure HUD stays below RINGS')
assert(hudHas('ETAPA 1/6: SILABA MA', 8, 82))
local originalWords = visibleWords()
moveToSector(101, -6272)
assert(consoleplayer.mo.x == -7072*FRACUNIT, 'Incomplete stages must keep the checkpoint blocked')
assert(#visibleWords() == 2)
moveToSector(100)

local stages = {
    { sector = 100, checkpoint = 101, nextSector = 110, expected = {'mano', 'mapa'} },
    { sector = 110, checkpoint = 111, nextSector = 120, expected = {'pato', 'pala', 'papa'} },
    { sector = 120, checkpoint = 121, nextSector = 130, expected = {'bala', 'barco', 'banco'} },
    { sector = 130, checkpoint = 131, nextSector = 140, expected = {'gato', 'perro', 'pato'} },
    { sector = 140, checkpoint = 150, nextSector = 160, expected = {'pan', 'queso', 'manzana'} },
    { sector = 160, expected = {'auto', 'bus', 'tren'} }
}
local activityTime
for index, stage in ipairs(stages) do
    for pair, expected in ipairs(stage.expected) do
        assert(#visibleWords() == 2)
        -- Include mistakes: progress rewards finishing, not a perfect score.
        local selected = expected
        if pair == 1 then
            for _, obj in ipairs(visibleWords()) do
                if obj.fono_palabra ~= expected then selected = obj.fono_palabra end
            end
        end
        touchWord(selected)
        assert(#visibleWords() == 0)
        command('fono5')
        if pair < #stage.expected then tick(TICRATE + 1) end
    end
    local report = jsonReport()
    assert(string.find(report, '"completado": true', 1, true) ~= nil)
    assert(string.find(report, '"palabra": "' .. stage.expected[1] .. '", "resultado": "con_ayuda"', 1, true) ~= nil)
    assert(#visibleWords() == 0)
    if stage.checkpoint ~= nil then
        moveToSector(stage.checkpoint)
        moveToSector(stage.nextSector)
    end
end
messages = {}
command('fonostatus')
for _, message in ipairs(messages) do
    if string.sub(message, 1, 7) == 'Tiempo:' then activityTime = message end
end
messages = {}
command('fonoresumen')
assert(contains('17') and contains('Correctos: 11') and contains('Errores: 6'))
assert(contains('Ayudas: 17'))
moveToSector(160, 4800)
assert(exitMap == 1 and exitCount == 1)
newMap(1, true)
assert(hudHas('TIEMPO 05:00', 8, 94))
assert(hudHas('ETAPA 1/6: SILABA MA') == false)
messages = {}
command('fonostatus')
assert(contains(activityTime), 'Activity duration must stay stable across reward maps')
command('fonoma2') -- A standalone mode cannot cancel a reward in progress.
assert(#visibleWords() == 0)
tick(TICRATE * 10)
assert(hudHas('TIEMPO 04:50', 8, 94))
messages = {}
command('fonoetapa')
assert(contains('Fase: juego'))
newMap(2, true)
assert(hudHas('TIEMPO 04:50', 8, 94), 'HUD preserves time when changing acts')
local beforeRewardAdvance = exitCount
tick(TICRATE * 288)
assert(exitCount == beforeRewardAdvance, 'Normal act changes must not reset or prematurely end the timer')
tick(TICRATE * 3)
assert(exitMap == 100 and exitCount == beforeRewardAdvance + 1)

-- PlayerSpawn preceding MapLoad must still trigger exactly one new cycle.
newMap(100, true)
assert(#visibleWords() == 2 and visibleWords()[1].fono_palabra == 'mano')
local checkpoints, walls = 0, 0
for _, obj in ipairs(objects) do
    if obj.valid == true and obj.type == MT_STARPOST then checkpoints = checkpoints + 1 end
    if obj.valid == true and obj.type == MT_FONO_MURO then walls = walls + 1 end
end
assert(checkpoints == 5 and walls == 7, 'Do not duplicate map objects on return')
tick(5)
assert(#visibleWords() == 2)

-- Manual MAPA0 reload clears stale adventure state; startup needs no reset.
newMap(100, true)
assert(#visibleWords() == 0)
command('fonoaventura', 'Demo_second', '6a0m')
assert(#visibleWords() == 2)
command('fonopa2')
messages = {}
command('fonoetapa')
assert(contains('No hay una aventura por etapas activa'))
assert(#visibleWords() == 2)

-- Early ending also survives either engine hook order and reports once.
command('fonojuegotest', '10')
newMap(1, false)
command('fonofinjuego')
newMap(100, true)
assert(contains('La aventura Sonic FonoKids finalizo correctamente.'))
messages = {}
tick(5)
assert(contains('La aventura Sonic FonoKids finalizo correctamente.') == false)
assert(#visibleWords() == 0)
command('fonoaventura')
assert(#visibleWords() == 2)
event('GameQuit')
assert(#visibleWords() == 0)
-- The opposite hook order must also return to exactly one new MA pair.
newMap(100, false)
command('fonojuegotest', '10')
newMap(1, false)
tick(TICRATE * 10)
newMap(100, false)
assert(#visibleWords() == 2 and visibleWords()[1].fono_palabra == 'mano')
print('PASS: 17 selections, six stages, checkpoint gates, reward across acts, timed restart, manual reload and early ending')
