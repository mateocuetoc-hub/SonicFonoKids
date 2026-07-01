print("====================================")
print("Sonic FonoKids v0.0.3 cargado")
print("====================================")

local nombreProyecto = "Sonic FonoKids"
local jugadorDemo = "Nino_001"
local objetivoActual = "MA"

local sesion = {}

local function iniciarSesion()
    sesion = {
        jugador = jugadorDemo,
        nivel = gamemap,
        actividad = "conciencia_fonologica_silaba_inicial",
        objetivo = objetivoActual,
        intentos = 0,
        correctos = 0,
        errores = 0,
        ayudas = 0,
        completado = false,
        errores_detalle = {},
        tiempo_inicio = leveltime
    }
end

local function tiempoTranscurrido()
    if sesion.tiempo_inicio == nil then
        return 0
    end

    return (leveltime - sesion.tiempo_inicio) / TICRATE
end

local function registrarCorrecto(player, palabra)
    if sesion.completado == true then
        return
    end

    sesion.intentos = sesion.intentos + 1
    sesion.correctos = sesion.correctos + 1

    CONS_Printf(player, "Muy bien. " .. palabra .. " comienza con " .. sesion.objetivo)

    if sesion.correctos >= 5 then
        sesion.completado = true
        CONS_Printf(player, "Actividad completada. Escribe fonostatus para ver el reporte.")
    end
end

local function registrarError(player, palabra, tipo)
    if sesion.completado == true then
        return
    end

    sesion.intentos = sesion.intentos + 1
    sesion.errores = sesion.errores + 1

    table.insert(sesion.errores_detalle, {
        palabra = palabra,
        tipo = tipo
    })

    CONS_Printf(player, "Intentalo otra vez. Busca palabras con " .. sesion.objetivo)
end

local function registrarAyuda(player)
    sesion.ayudas = sesion.ayudas + 1
    CONS_Printf(player, "Ayuda: escucha la silaba inicial " .. sesion.objetivo)
end

local function mostrarReporte(player)
    CONS_Printf(player, "========== REPORTE ACTUAL ==========")
    CONS_Printf(player, "Proyecto: " .. nombreProyecto)
    CONS_Printf(player, "Jugador: " .. sesion.jugador)
    CONS_Printf(player, "Nivel: " .. tostring(sesion.nivel))
    CONS_Printf(player, "Actividad: " .. sesion.actividad)
    CONS_Printf(player, "Objetivo: " .. sesion.objetivo)
    CONS_Printf(player, "Intentos: " .. tostring(sesion.intentos))
    CONS_Printf(player, "Correctos: " .. tostring(sesion.correctos))
    CONS_Printf(player, "Errores: " .. tostring(sesion.errores))
    CONS_Printf(player, "Ayudas: " .. tostring(sesion.ayudas))
    CONS_Printf(player, "Tiempo: " .. tostring(tiempoTranscurrido()) .. " segundos")
    CONS_Printf(player, "Completado: " .. tostring(sesion.completado))

    if #sesion.errores_detalle > 0 then
        CONS_Printf(player, "----- Detalle de errores -----")
        for i = 1, #sesion.errores_detalle do
            local e = sesion.errores_detalle[i]
            CONS_Printf(player, tostring(i) .. ". palabra=" .. e.palabra .. " tipo=" .. e.tipo)
        end
    end

    CONS_Printf(player, "===================================")
end

addHook("MapLoad", function()
    iniciarSesion()
end)

addHook("PlayerSpawn", function(player)
    if sesion.jugador == nil then
        iniciarSesion()
    end

    player.rings = 20
    player.fono_lastRings = player.rings

    CONS_Printf(player, "====================================")
    CONS_Printf(player, "Sonic FonoKids activo")
    CONS_Printf(player, "Objetivo: junta 5 palabras con " .. sesion.objetivo)
    CONS_Printf(player, "Por ahora, cada anillo cuenta como palabra correcta.")
    CONS_Printf(player, "====================================")
end)

addHook("ThinkFrame", function()
    for player in players.iterate do
        if player.mo then
            if player.fono_lastRings == nil then
                player.fono_lastRings = player.rings
            end

            if player.rings > player.fono_lastRings then
                local ganados = player.rings - player.fono_lastRings

                for i = 1, ganados do
                    registrarCorrecto(player, "mano")
                end
            end

            player.fono_lastRings = player.rings
        end
    end
end)

COM_AddCommand("fonostatus", function(player)
    mostrarReporte(player)
end)

COM_AddCommand("fonocorrect", function(player, palabra)
    if palabra == nil or palabra == "" then
        palabra = "mano"
    end

    registrarCorrecto(player, palabra)
end)

COM_AddCommand("fonoerror", function(player, palabra, tipo)
    if palabra == nil or palabra == "" then
        palabra = "pato"
    end

    if tipo == nil or tipo == "" then
        tipo = "distractor_fonologico"
    end

    registrarError(player, palabra, tipo)
end)

COM_AddCommand("fonoayuda", function(player)
    registrarAyuda(player)
end)

COM_AddCommand("fonoreset", function(player)
    iniciarSesion()
    player.rings = 20
    player.fono_lastRings = player.rings
    CONS_Printf(player, "Sesion reiniciada.")
end)
