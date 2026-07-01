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

local function mostrarReporteIA(player)
    CONS_Printf(player, "========== DATOS PARA IA ==========")
    CONS_Printf(player, "Proyecto: Sonic FonoKids")
    CONS_Printf(player, "Tipo de reporte: descriptivo_no_clinico")
    CONS_Printf(player, "Jugador anonimo: " .. tostring(sesion.jugador))
    CONS_Printf(player, "Nivel: " .. tostring(sesion.nivel))
    CONS_Printf(player, "Actividad: " .. tostring(sesion.actividad))
    CONS_Printf(player, "Objetivo trabajado: silaba inicial " .. tostring(sesion.objetivo))
    CONS_Printf(player, "Intentos totales: " .. tostring(sesion.intentos))
    CONS_Printf(player, "Respuestas correctas: " .. tostring(sesion.correctos))
    CONS_Printf(player, "Errores: " .. tostring(sesion.errores))
    CONS_Printf(player, "Ayudas usadas: " .. tostring(sesion.ayudas))
    CONS_Printf(player, "Tiempo total aproximado: " .. tostring(tiempoTranscurrido()) .. " segundos")
    CONS_Printf(player, "Nivel completado: " .. tostring(sesion.completado))

    if sesion.intentos > 0 then
        local porcentaje = (sesion.correctos * 100) / sesion.intentos
        CONS_Printf(player, "Porcentaje de logro: " .. tostring(porcentaje) .. "%")
    else
        CONS_Printf(player, "Porcentaje de logro: 0%")
    end

    if #sesion.errores_detalle > 0 then
        CONS_Printf(player, "Detalle de errores:")
        for i = 1, #sesion.errores_detalle do
            local e = sesion.errores_detalle[i]
            CONS_Printf(player, tostring(i) .. ") palabra: " .. tostring(e.palabra) .. " | tipo: " .. tostring(e.tipo))
        end
    else
        CONS_Printf(player, "Detalle de errores: sin errores registrados")
    end

    CONS_Printf(player, "Advertencia: estos datos no constituyen diagnostico.")
    CONS_Printf(player, "Interpretacion: debe realizarla una persona del area fonoaudiologica.")
    CONS_Printf(player, "==================================")
end

COM_AddCommand("fonoia", function(player)
    mostrarReporteIA(player)
end)


-- ================================
-- Banco de palabras Sonic FonoKids
-- ================================

local bancoPalabras = {
    mano = {
        texto = "mano",
        silaba = "MA",
        correcto = true,
        tipo = "objetivo"
    },

    mapa = {
        texto = "mapa",
        silaba = "MA",
        correcto = true,
        tipo = "objetivo"
    },

    mama = {
        texto = "mama",
        silaba = "MA",
        correcto = true,
        tipo = "objetivo"
    },

    masa = {
        texto = "masa",
        silaba = "MA",
        correcto = true,
        tipo = "objetivo"
    },

    pato = {
        texto = "pato",
        silaba = "PA",
        correcto = false,
        tipo = "distractor_fonologico"
    },

    bala = {
        texto = "bala",
        silaba = "BA",
        correcto = false,
        tipo = "distractor_fonologico"
    },

    luna = {
        texto = "luna",
        silaba = "LU",
        correcto = false,
        tipo = "distractor_no_fonologico"
    },

    sopa = {
        texto = "sopa",
        silaba = "SO",
        correcto = false,
        tipo = "distractor_no_fonologico"
    }
}

local function limpiarPalabra(palabra)
    if palabra == nil then
        return nil
    end

    return string.lower(palabra)
end

COM_AddCommand("fonopalabra", function(player, palabra)
    local clave = limpiarPalabra(palabra)

    if clave == nil or clave == "" then
        CONS_Printf(player, "Uso: fonopalabra <palabra>")
        CONS_Printf(player, "Ejemplo: fonopalabra mano")
        return
    end

    local dato = bancoPalabras[clave]

    if dato == nil then
        CONS_Printf(player, "La palabra '" .. clave .. "' no esta registrada en el banco.")
        CONS_Printf(player, "Usa fonolista para ver palabras disponibles.")
        return
    end

    if dato.correcto == true then
        registrarCorrecto(player, dato.texto)
    else
        registrarError(player, dato.texto, dato.tipo)
    end
end)

COM_AddCommand("fonolista", function(player)
    CONS_Printf(player, "===== BANCO DE PALABRAS =====")
    CONS_Printf(player, "Objetivo actual: silaba inicial " .. tostring(objetivoActual))
    CONS_Printf(player, "Correctas: mano, mapa, mama, masa")
    CONS_Printf(player, "Distractores fonologicos: pato, bala")
    CONS_Printf(player, "Distractores no fonologicos: luna, sopa")
    CONS_Printf(player, "=============================")
end)


-- ================================
-- Reporte descriptivo presentable
-- ================================

local function obtenerPorcentajeLogro()
    if sesion.intentos == nil or sesion.intentos == 0 then
        return 0
    end

    return (sesion.correctos * 100) / sesion.intentos
end

local function obtenerNivelDescriptivo(porcentaje)
    if porcentaje >= 80 then
        return "desempeno alto dentro de la actividad"
    elseif porcentaje >= 50 then
        return "desempeno intermedio dentro de la actividad"
    else
        return "desempeno bajo dentro de la actividad"
    end
end

local function mostrarReporteDescriptivo(player)
    local porcentaje = obtenerPorcentajeLogro()
    local nivel = obtenerNivelDescriptivo(porcentaje)

    CONS_Printf(player, "========== SONIC FONOKIDS ==========")
    CONS_Printf(player, "REPORTE DESCRIPTIVO NO CLINICO")
    CONS_Printf(player, "Sesion: " .. tostring(sesion.jugador))
    CONS_Printf(player, "Actividad: silaba inicial " .. tostring(sesion.objetivo))
    CONS_Printf(player, "Intentos: " .. tostring(sesion.intentos))
    CONS_Printf(player, "Correctos: " .. tostring(sesion.correctos))
    CONS_Printf(player, "Errores: " .. tostring(sesion.errores))
    CONS_Printf(player, "Ayudas usadas: " .. tostring(sesion.ayudas))
    CONS_Printf(player, "Logro: " .. tostring(porcentaje) .. "%")
    CONS_Printf(player, "Resultado descriptivo: " .. nivel)

    if sesion.errores > 0 then
        CONS_Printf(player, "Errores observados:")
        for i = 1, #sesion.errores_detalle do
            local e = sesion.errores_detalle[i]
            CONS_Printf(player, "- " .. tostring(e.palabra) .. " / " .. tostring(e.tipo))
        end
    else
        CONS_Printf(player, "Errores observados: no se registraron errores.")
    end

    CONS_Printf(player, "Observacion:")
    CONS_Printf(player, "Estos datos describen el rendimiento dentro del juego.")
    CONS_Printf(player, "No constituyen diagnostico fonoaudiologico.")
    CONS_Printf(player, "La interpretacion debe realizarla una persona del area.")
    CONS_Printf(player, "====================================")
end

COM_AddCommand("fonoreporte", function(player)
    mostrarReporteDescriptivo(player)
end)


-- ================================
-- Modo Quiz: silaba inicial MA
-- ================================

local quizFono = {
    activo = false,
    indice = 1,
    preguntas = {
        "mano",
        "pato",
        "mapa",
        "bala",
        "mama",
        "luna"
    }
}

local function mostrarPreguntaQuiz(player)
    if quizFono.activo == false then
        CONS_Printf(player, "No hay quiz activo. Usa fonoquiz para comenzar.")
        return
    end

    if quizFono.indice > #quizFono.preguntas then
        quizFono.activo = false
        sesion.completado = true
        CONS_Printf(player, "Quiz completado.")
        CONS_Printf(player, "Usa fonoreporte o fonoia para ver resultados.")
        return
    end

    local palabra = quizFono.preguntas[quizFono.indice]

    CONS_Printf(player, "========== PREGUNTA FONOKIDS ==========")
    CONS_Printf(player, "Pregunta " .. tostring(quizFono.indice) .. " de " .. tostring(#quizFono.preguntas))
    CONS_Printf(player, "La palabra '" .. palabra .. "' comienza con " .. tostring(objetivoActual) .. "?")
    CONS_Printf(player, "Responde con: fonoquizsi o fonoquizno")
    CONS_Printf(player, "=======================================")
end

local function responderQuiz(player, respuestaSi)
    if quizFono.activo == false then
        CONS_Printf(player, "No hay quiz activo. Usa fonoquiz para comenzar.")
        return
    end

    local palabra = quizFono.preguntas[quizFono.indice]
    local dato = bancoPalabras[palabra]

    if dato == nil then
        CONS_Printf(player, "Error: palabra no registrada en banco.")
        return
    end

    local respuestaCorrecta = false

    if respuestaSi == true and dato.correcto == true then
        respuestaCorrecta = true
    elseif respuestaSi == false and dato.correcto == false then
        respuestaCorrecta = true
    end

    if respuestaCorrecta == true then
        registrarCorrecto(player, dato.texto)
        CONS_Printf(player, "Respuesta correcta.")
    else
        local tipoError = dato.tipo

        if dato.correcto == true then
            tipoError = "rechazo_palabra_objetivo"
        else
            tipoError = "falso_positivo_" .. tostring(dato.tipo)
        end

        registrarError(player, dato.texto, tipoError)
        CONS_Printf(player, "Respuesta incorrecta.")
    end

    quizFono.indice = quizFono.indice + 1
    mostrarPreguntaQuiz(player)
end

COM_AddCommand("fonoquiz", function(player)
    iniciarSesion()
    quizFono.activo = true
    quizFono.indice = 1

    CONS_Printf(player, "Modo quiz iniciado.")
    CONS_Printf(player, "Objetivo: identificar si la palabra comienza con " .. tostring(objetivoActual))
    mostrarPreguntaQuiz(player)
end)

COM_AddCommand("fonoquizsi", function(player)
    responderQuiz(player, true)
end)

COM_AddCommand("fonoquizno", function(player)
    responderQuiz(player, false)
end)

COM_AddCommand("fonoquizpregunta", function(player)
    mostrarPreguntaQuiz(player)
end)

