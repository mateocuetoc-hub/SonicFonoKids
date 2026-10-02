local zero = tonumber('0')
assert(not zero, 'These tests require SRB2 Lua: zero must be false')
newMap(100, false)

-- A completed selection waits for the evaluator and accepts only one response.
command('fonoma2')
local words = visibleWords()
assert(#words == 2 and words[1].fono_palabra == 'mano' and words[2].fono_palabra == 'pato')
assert(words[1].y > words[2].y, 'Keep the established left/right placement')
assert(words[1].frame == (A|FF_FULLBRIGHT) and words[2].frame == (S|FF_FULLBRIGHT))
local stateBefore = stateChanges
local writesBefore = objectWrites
for i = 1, 100 do event('MobjThinker', words[1]) end
assert(stateChanges == stateBefore, 'Stable sprites must not reapply their state')
assert(objectWrites == writesBefore, 'Stable sprites must not rewrite their visual properties every tic')
assert(words[1].alpha == FRACUNIT and words[1].spritexoffset == 48*FRACUNIT)
assert(words[1].spriteyoffset == 96*FRACUNIT and words[1].fuse == 0)
words[1].state = S_RING
event('MobjThinker', words[1])
assert(words[1].state == S_FONO_MANO and stateChanges == stateBefore + 1)
touchWord('mano')
assert(#visibleWords() == 0)
command('fonoerror', 'pato')
assert(string.find(jsonReport(), '"intentos_totales": 1', 1, true) ~= nil)
command('fonoproduccion', 'invalid')
assert(#visibleWords() == 0)
assert(event('KeyDown', { name = '1', repeated = true }) == false)
assert(event('KeyDown', { name = '1', repeated = false }) == true)

-- The wait must survive an expired player mobj until a valid spawn appears.
consoleplayer.mo.valid = false
tick(TICRATE + 3)
assert(#visibleWords() == 0)
consoleplayer.mo = P_SpawnMobj(0, 0, 0, 0)
consoleplayer.mo.player = consoleplayer
consoleplayer.mo.subsector = { sector = { tag = 100 } }
event('PlayerSpawn', consoleplayer)
tick(1)
words = visibleWords()
assert(#words == 2 and words[1].fono_palabra == 'bala' and words[2].fono_palabra == 'mapa')
touchWord('bala')
command('fono3')
local completed = jsonReport()
print('BEGIN_JSON')
print(completed)
print('END_JSON')
assert(string.find(completed, '"completado": true', 1, true) ~= nil)
assert(string.find(completed, '"intentos_totales": 2', 1, true) ~= nil)
assert(string.find(completed, '"respuestas_correctas": 1', 1, true) ~= nil)
assert(string.find(completed, '"palabra": "mapa", "resultado": "sustitucion"', 1, true) ~= nil)
command('fonocorrect', 'mano')
command('fonoerror', 'pato')
assert(jsonReport() == completed, 'Finished sessions must not accumulate ghost records')

-- Undo restores the pending oral word without counting a second selection.
command('fonopa2')
touchWord('pato')
command('fono5')
command('fonoproducciondeshacer')
assert(string.find(jsonReport(), '"ayudas_usadas": 0', 1, true) ~= nil)
command('fono1')
tick(TICRATE + 1)
assert(#visibleWords() == 2)
local nextPair = jsonReport()
command('fonoproducciondeshacer')
assert(jsonReport() == nextPair, 'Undo must not corrupt a displayed next pair')

-- Switching categories and session identity must discard the old objects/mode.
command('fonoba')
command('fononivel1seq')
assert(#visibleWords() == 1 and visibleWords()[1].fono_palabra == 'mano')
command('fonocomida')
command('fonovocab')
assert(#visibleWords() == 1 and visibleWords()[1].fono_palabra == 'pato')
assert(string.find(jsonReport(), '"objetivo": "ANIMALES"', 1, true) ~= nil)
command('fonosesion', 'Demo_new', '5a0m')
assert(#visibleWords() == 0)
command('fonoma2')
touchWord('mano')
command('fonoproduccion', '3', 'nota"\\\n\t\r' .. string.char(0))
local escaped = jsonReport()
assert(string.find(escaped, '\\u000a', 1, true) ~= nil)
assert(string.find(escaped, '\\u0009', 1, true) ~= nil)
assert(string.find(escaped, '\\u000d', 1, true) ~= nil)
assert(string.find(escaped, '\\u0000', 1, true) ~= nil)
print('BEGIN_JSON')
print(escaped)
print('END_JSON')

-- The old quiz must count its full list, even after five correct responses.
command('fonoquiz')
local answers = {'fonoquizsi', 'fonoquizno', 'fonoquizsi', 'fonoquizno',
    'fonoquizsi', 'fonoquizno'}
for _, answer in ipairs(answers) do command(answer) end
assert(string.find(jsonReport(), '"intentos_totales": 6', 1, true) ~= nil)
assert(string.find(jsonReport(), '"respuestas_correctas": 6', 1, true) ~= nil)

-- Every legacy starter remains callable; reports and help do not start modes.
local starters = {
    'fonoquiz', 'fonokids', 'fonoobjetosdemo', 'fononivel1', 'fononivel1auto',
    'fononivel1seq', 'fonoma', 'fonopa', 'fonoba', 'fonovocab', 'fonocomida',
    'fonotransporte', 'fonodemo', 'fonodemoma', 'fonodemovocab', 'fonoma2',
    'fonoparesma', 'fonodemopares', 'fonovocab2', 'fonocomida2',
    'fonotransporte2', 'fonodemovocab2', 'fonoparesvocab', 'fonopa2',
    'fonoba2', 'fonodemopa2', 'fonodemoba2', 'fonosala1', 'fonosala2'
}
for _, name in ipairs(starters) do command(name) end
local objectCount = #visibleWords()
command('fonosala')
command('fonosala3')
command('fonosalademo')
command('fonoparesvocab')
assert(#visibleWords() == objectCount, 'Help must not remove active objects')
local beforeInvalidStart = jsonReport()
consoleplayer.mo.valid = false
command('fonoma2')
assert(jsonReport() == beforeInvalidStart)
print('PASS: pairs, oral input, respawn, undo, category switches, JSON, sprite states and legacy commands')
