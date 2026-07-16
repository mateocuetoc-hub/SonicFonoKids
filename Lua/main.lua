-- Forward declarations FonoKids
local fonoLimpiarObjetosActivos

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
        CONS_Printf(player, "Actividad completada. Escribe fonoreporte para ver el reporte.")
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

    CONS_Printf(player, "Buen intento. Busquemos palabras con " .. sesion.objetivo)
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

    CONS_Printf(player, "====================================")
    CONS_Printf(player, "Sonic FonoKids activo")
    CONS_Printf(player, "Objetivo: trabajar silaba inicial " .. sesion.objetivo)
    CONS_Printf(player, "Usa fononivel1auto para iniciar la actividad educativa.")
    CONS_Printf(player, "====================================")
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
    if sesion.actividad ~= nil and string.find(tostring(sesion.actividad), "vocabulario") ~= nil then
        CONS_Printf(player, "Actividad: vocabulario - categoria " .. tostring(sesion.objetivo))
    elseif sesion.actividad ~= nil and string.find(tostring(sesion.actividad), "eleccion_pares") ~= nil then
        CONS_Printf(player, "Actividad: eleccion entre 2 opciones - silaba inicial " .. tostring(sesion.objetivo))
    else
        CONS_Printf(player, "Actividad: silaba inicial " .. tostring(sesion.objetivo))
    end
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


-- ================================
-- Inicio rapido Sonic FonoKids
-- ================================

local function mostrarInstruccionesFonoKids(player)
    CONS_Printf(player, "========== SONIC FONOKIDS ==========")
    CONS_Printf(player, "Actividad: conciencia fonologica")
    CONS_Printf(player, "Objetivo: identificar palabras que comienzan con MA")
    CONS_Printf(player, " ")
    CONS_Printf(player, "Comandos principales:")
    CONS_Printf(player, "fonokids       -> inicia la actividad")
    CONS_Printf(player, "fonoquiz       -> inicia el quiz")
    CONS_Printf(player, "fonoquizsi     -> responder SI")
    CONS_Printf(player, "fonoquizno     -> responder NO")
    CONS_Printf(player, "fonoreporte    -> ver reporte descriptivo")
    CONS_Printf(player, "fonoia         -> ver datos para IA")
    CONS_Printf(player, "fonolista      -> ver banco de palabras")
    CONS_Printf(player, "fonoreset      -> reiniciar sesion")
    CONS_Printf(player, " ")
    CONS_Printf(player, "Este juego no diagnostica.")
    CONS_Printf(player, "Los datos deben ser interpretados por una persona del area fonoaudiologica.")
    CONS_Printf(player, "====================================")
end

COM_AddCommand("fonoayuda2", function(player)
    mostrarInstruccionesFonoKids(player)
end)

COM_AddCommand("fonokids", function(player)
    mostrarInstruccionesFonoKids(player)
    iniciarSesion()
    quizFono.activo = true
    quizFono.indice = 1

    CONS_Printf(player, "Sesion iniciada.")
    CONS_Printf(player, "Comenzando quiz...")
    mostrarPreguntaQuiz(player)
end)


-- ================================
-- Objetos educativos tocables
-- ================================

freeslot("MT_FONO_OBJETO")

mobjinfo[MT_FONO_OBJETO] = {
    spawnstate = mobjinfo[MT_RING].spawnstate,
    radius = 16*FRACUNIT,
    height = 32*FRACUNIT,
    flags = MF_SPECIAL|MF_NOGRAVITY
}

local objetosFono = {}

local function crearObjetoFono(player, palabra, indice)
    if player == nil or player.mo == nil then
        CONS_Printf(player, "No se pudo crear el objeto: jugador no valido.")
        return
    end

    local clave = limpiarPalabra(palabra)

    if clave == nil or clave == "" then
        clave = "mano"
    end

    if bancoPalabras[clave] == nil then
        CONS_Printf(player, "La palabra '" .. clave .. "' no existe en el banco.")
        CONS_Printf(player, "Usa fonolista para ver palabras disponibles.")
        return
    end

    if indice == nil then
        indice = 0
    end

    local distancia = (96 + indice * 80) * FRACUNIT
    local x = player.mo.x + distancia
    local y = player.mo.y
    local z = player.mo.z + 32*FRACUNIT

    local objeto = P_SpawnMobj(x, y, z, MT_FONO_OBJETO)

    if objeto == nil then
        CONS_Printf(player, "No se pudo crear el objeto educativo.")
        return
    end

    objeto.fono_palabra = clave
    objeto.fuse = TICRATE * 60
    objetosFono[objeto] = clave

    CONS_Printf(player, "Objeto educativo creado: " .. clave)
    return objeto
end

local function procesarObjetoFono(special, toucher)
    if toucher == nil or toucher.player == nil then
        return true
    end

    local player = toucher.player
    local palabra = special.fono_palabra

    if palabra == nil then
        palabra = objetosFono[special]
    end

    if palabra == nil then
        return true
    end

    local dato = bancoPalabras[palabra]

    if dato == nil then
        CONS_Printf(player, "Objeto con palabra no registrada: " .. tostring(palabra))
        return true
    end

    if dato.correcto == true then
        registrarCorrecto(player, dato.texto)
        -- Feedback detallado manejado por registrarCorrecto.
    else
        registrarError(player, dato.texto, dato.tipo)
        -- Feedback detallado manejado por registrarError.
    end

    objetosFono[special] = nil

    if special.valid then
        P_RemoveMobj(special)
    end

    return true
end

addHook("TouchSpecial", procesarObjetoFono, MT_FONO_OBJETO)

COM_AddCommand("fonoobj", function(player, palabra)
    crearObjetoFono(player, palabra, 4)
end)

COM_AddCommand("fonoobjetosdemo", function(player)
    crearObjetoFono(player, "mano", 0)
    crearObjetoFono(player, "mapa", 1)
    crearObjetoFono(player, "pato", 2)
    crearObjetoFono(player, "bala", 3)
    CONS_Printf(player, "Demo creada: mano, mapa, pato, bala.")
end)


-- ================================
-- Nivel educativo 1: silaba MA
-- ================================

COM_AddCommand("fononivel1", function(player)
    if fonoLimpiarObjetosActivos ~= nil then
        fonoLimpiarObjetosActivos(player)
    end

    iniciarSesion()

    CONS_Printf(player, "========== SONIC FONOKIDS ==========")
    CONS_Printf(player, "NIVEL 1: Bosque de la silaba MA")
    CONS_Printf(player, "Objetivo educativo:")
    CONS_Printf(player, "Toca las palabras que comienzan con MA.")
    CONS_Printf(player, " ")
    CONS_Printf(player, "Palabras objetivo:")
    CONS_Printf(player, "- mano")
    CONS_Printf(player, "- mapa")
    CONS_Printf(player, " ")
    CONS_Printf(player, "Distractores:")
    CONS_Printf(player, "- pato")
    CONS_Printf(player, "- bala")
    CONS_Printf(player, " ")
    CONS_Printf(player, "Al terminar, escribe fonoreporte o fonoia.")
    CONS_Printf(player, "====================================")

    crearObjetoFono(player, "mano", 0)
    crearObjetoFono(player, "mapa", 1)
    crearObjetoFono(player, "pato", 2)
    crearObjetoFono(player, "bala", 3)
end)


-- ================================
-- Nivel 1 automatico con cierre de actividad
-- ================================

local function revisarCierreActividad(player)
    if sesion.total_esperado == nil then
        return
    end

    if sesion.reporte_auto_mostrado == true then
        return
    end

    if sesion.intentos >= sesion.total_esperado then
        sesion.completado = true
        sesion.reporte_auto_mostrado = true

        CONS_Printf(player, "Actividad finalizada automaticamente.")
        CONS_Printf(player, "Mostrando reporte descriptivo...")

        mostrarReporteDescriptivo(player)
    end
end

COM_AddCommand("fononivel1auto", function(player)
    if fonoLimpiarObjetosActivos ~= nil then
        fonoLimpiarObjetosActivos(player)
    end

    iniciarSesion()

    sesion.total_esperado = 4
    sesion.reporte_auto_mostrado = false

    CONS_Printf(player, "========== SONIC FONOKIDS ==========")
    CONS_Printf(player, "NIVEL 1 AUTO: Bosque de la silaba MA")
    CONS_Printf(player, "Objetivo: toca las palabras que comienzan con MA.")
    CONS_Printf(player, " ")
    CONS_Printf(player, "Palabras objetivo:")
    CONS_Printf(player, "- mano")
    CONS_Printf(player, "- mapa")
    CONS_Printf(player, " ")
    CONS_Printf(player, "Distractores:")
    CONS_Printf(player, "- pato")
    CONS_Printf(player, "- bala")
    CONS_Printf(player, " ")
    CONS_Printf(player, "El reporte aparecera automaticamente al tocar los 4 objetos.")
    CONS_Printf(player, "====================================")

    crearObjetoFono(player, "mano", 0)
    crearObjetoFono(player, "mapa", 1)
    crearObjetoFono(player, "pato", 2)
    crearObjetoFono(player, "bala", 3)
end)

COM_AddCommand("fonoprogreso", function(player)
    CONS_Printf(player, "========== PROGRESO FONOKIDS ==========")
    CONS_Printf(player, "Intentos: " .. tostring(sesion.intentos))
    CONS_Printf(player, "Correctos: " .. tostring(sesion.correctos))
    CONS_Printf(player, "Errores: " .. tostring(sesion.errores))

    if sesion.total_esperado ~= nil then
        CONS_Printf(player, "Total esperado: " .. tostring(sesion.total_esperado))
    else
        CONS_Printf(player, "Total esperado: no definido")
    end

    CONS_Printf(player, "Completado: " .. tostring(sesion.completado))
    CONS_Printf(player, "=======================================")
end)


-- ================================
-- Nivel 1 secuencial: un objeto a la vez
-- ================================

local nivelSecuencial = {
    activo = false,
    indice = 1,
    palabras = {
        "mano",
        "mapa",
        "pato",
        "bala"
    }
}

local function crearSiguienteObjetoSecuencial(player)
    if nivelSecuencial.activo == false then
        return
    end

    if nivelSecuencial.indice > #nivelSecuencial.palabras then
        nivelSecuencial.activo = false
        return
    end

    local palabra = nivelSecuencial.palabras[nivelSecuencial.indice]
    local dato = bancoPalabras[palabra]

    CONS_Printf(player, "========== OBJETO FONOKIDS ==========")
    CONS_Printf(player, "Objeto " .. tostring(nivelSecuencial.indice) .. " de " .. tostring(#nivelSecuencial.palabras))
    CONS_Printf(player, "Palabra actual: " .. tostring(palabra))

    if dato ~= nil and dato.correcto == true then
        CONS_Printf(player, "Esta palabra comienza con " .. tostring(objetivoActual) .. ".")
    else
        CONS_Printf(player, "Esta palabra NO comienza con " .. tostring(objetivoActual) .. ".")
    end

    CONS_Printf(player, "Toca el objeto para responder.")
    CONS_Printf(player, "=====================================")

    crearObjetoFono(player, palabra, 4)
end

COM_AddCommand("fononivel1seq", function(player)
    if fonoLimpiarObjetosActivos ~= nil then
        fonoLimpiarObjetosActivos(player)
    end

    iniciarSesion()

    sesion.total_esperado = 4
    sesion.reporte_auto_mostrado = false

    nivelSecuencial.activo = true
    nivelSecuencial.indice = 1

    CONS_Printf(player, "========== SONIC FONOKIDS ==========")
    CONS_Printf(player, "NIVEL 1 SECUENCIAL: silaba MA")
    CONS_Printf(player, "Aparecera un objeto a la vez.")
    CONS_Printf(player, "El sistema registrara si la palabra corresponde o no a la silaba MA.")
    CONS_Printf(player, "Al terminar, el reporte aparecera automaticamente.")
    CONS_Printf(player, "====================================")

    crearSiguienteObjetoSecuencial(player)
end)


-- ================================
-- HUD VISUAL FONOKIDS
-- ================================

local function fonoSetHud(player, linea1, linea2, tiempo)
    if player == nil then
        return
    end

    player.fono_hud_linea1 = tostring(linea1 or "")
    player.fono_hud_linea2 = tostring(linea2 or "")
    player.fono_hud_timer = tiempo or TICRATE * 5
end

local crearObjetoFonoHudBase = crearObjetoFono

crearObjetoFono = function(player, palabra, indice)
    local textoPalabra = string.upper(tostring(palabra or ""))
    local textoObjetivo = "OBJETIVO: " .. tostring(objetivoActual)

    fonoSetHud(player, "OBJETO: " .. textoPalabra, textoObjetivo, TICRATE * 8)

    return crearObjetoFonoHudBase(player, palabra, indice)
end

addHook("ThinkFrame", function()
    for player in players.iterate do
        if player.fono_hud_timer ~= nil and player.fono_hud_timer > 0 then
            player.fono_hud_timer = player.fono_hud_timer - 1
        end
    end
end)

addHook("HUD", function(v, player)
    if player == nil then
        return
    end

    local hudX = 180
    local hudY = 8

    v.drawString(hudX, hudY, "SONIC FONOKIDS")

    local intentos = 0
    local correctos = 0
    local errores = 0
    local total = 0

    if sesion ~= nil then
        intentos = sesion.intentos or 0
        correctos = sesion.correctos or 0
        errores = sesion.errores or 0
        total = sesion.total_esperado or 0
    end

    v.drawString(hudX, hudY + 10, "OK: " .. tostring(correctos) .. "  ERR: " .. tostring(errores))
    v.drawString(hudX, hudY + 20, "INT: " .. tostring(intentos) .. "/" .. tostring(total))

    if player.fono_hud_timer ~= nil and player.fono_hud_timer > 0 then
        if player.fono_hud_linea1 ~= nil then
            v.drawString(hudX, hudY + 36, player.fono_hud_linea1)
        end

        if player.fono_hud_linea2 ~= nil then
            v.drawString(hudX, hudY + 46, player.fono_hud_linea2)
        end
    end
end, "game")

COM_AddCommand("fonohudtest", function(player)
    fonoSetHud(player, "OBJETO: MANO", "OBJETIVO: MA", TICRATE * 6)
    CONS_Printf(player, "HUD FonoKids probado.")
end)


-- ================================
-- Feedback infantil FonoKids
-- ================================

local function fonoTextoPalabra(palabra)
    return string.upper(tostring(palabra or ""))
end

local function fonoMostrarFeedbackCorrecto(player, palabra)
    local p = fonoTextoPalabra(palabra)
    local objetivo = tostring(sesion.objetivo or objetivoActual)

    CONS_Printf(player, "¡Muy bien! " .. p .. " empieza con " .. objetivo .. ".")
    CONS_Printf(player, "¡Sigue asi!")

    if fonoSetHud ~= nil then
        fonoSetHud(player, "MUY BIEN: " .. p, "EMPIEZA CON " .. objetivo, TICRATE * 4)
    end
end

local function fonoMostrarFeedbackError(player, palabra)
    local p = fonoTextoPalabra(palabra)
    local objetivo = tostring(sesion.objetivo or objetivoActual)

    CONS_Printf(player, "Buen intento. " .. p .. " no empieza con " .. objetivo .. ".")
    CONS_Printf(player, "Busquemos una palabra que suene con " .. objetivo .. ".")

    if fonoSetHud ~= nil then
        fonoSetHud(player, "BUEN INTENTO: " .. p, "NO EMPIEZA CON " .. objetivo, TICRATE * 4)
    end
end

registrarCorrecto = function(player, palabra)
    if sesion.completado == true then
        return
    end

    sesion.intentos = (sesion.intentos or 0) + 1
    sesion.correctos = (sesion.correctos or 0) + 1

    fonoMostrarFeedbackCorrecto(player, palabra)

    if sesion.total_esperado == nil and sesion.correctos >= 5 then
        sesion.completado = true
        CONS_Printf(player, "Actividad completada. Escribe fonoreporte para ver el reporte.")
    end

    if revisarCierreActividad ~= nil then
        revisarCierreActividad(player)
    end

    if nivelSecuencial ~= nil and nivelSecuencial.activo == true and sesion.completado ~= true then
        nivelSecuencial.indice = nivelSecuencial.indice + 1
        crearSiguienteObjetoSecuencial(player)
    end
end

registrarError = function(player, palabra, tipo)
    if sesion.completado == true then
        return
    end

    sesion.intentos = (sesion.intentos or 0) + 1
    sesion.errores = (sesion.errores or 0) + 1

    table.insert(sesion.errores_detalle, {
        palabra = palabra,
        tipo = tipo
    })

    fonoMostrarFeedbackError(player, palabra)

    if revisarCierreActividad ~= nil then
        revisarCierreActividad(player)
    end

    if nivelSecuencial ~= nil and nivelSecuencial.activo == true and sesion.completado ~= true then
        nivelSecuencial.indice = nivelSecuencial.indice + 1
        crearSiguienteObjetoSecuencial(player)
    end
end


-- ================================
-- Niveles por silaba: MA / PA / BA
-- ================================

-- Ampliacion del banco de palabras
bancoPalabras["pala"] = {
    texto = "pala",
    silaba = "PA",
    correcto = false,
    tipo = "distractor_fonologico"
}

bancoPalabras["papa"] = {
    texto = "papa",
    silaba = "PA",
    correcto = false,
    tipo = "distractor_fonologico"
}

bancoPalabras["barco"] = {
    texto = "barco",
    silaba = "BA",
    correcto = false,
    tipo = "distractor_fonologico"
}

bancoPalabras["banco"] = {
    texto = "banco",
    silaba = "BA",
    correcto = false,
    tipo = "distractor_fonologico"
}

bancoPalabras["banana"] = {
    texto = "banana",
    silaba = "BA",
    correcto = false,
    tipo = "distractor_fonologico"
}

local function fonoEsSilabaCercana(silaba)
    if silaba == "MA" then
        return true
    elseif silaba == "PA" then
        return true
    elseif silaba == "BA" then
        return true
    end

    return false
end

local function fonoConfigurarBancoPorSilaba(silabaObjetivo)
    objetivoActual = silabaObjetivo

    for clave, dato in pairs(bancoPalabras) do
        if dato.silaba == silabaObjetivo then
            dato.correcto = true
            dato.tipo = "objetivo"
        else
            dato.correcto = false

            if fonoEsSilabaCercana(dato.silaba) == true then
                dato.tipo = "distractor_fonologico"
            else
                dato.tipo = "distractor_no_fonologico"
            end
        end
    end
end

local function fonoIniciarNivelSilaba(player, silabaObjetivo, palabrasNivel, nombreNivel)
    if fonoLimpiarObjetosActivos ~= nil then
        fonoLimpiarObjetosActivos(player)
    end

    fonoConfigurarBancoPorSilaba(silabaObjetivo)
    iniciarSesion()

    sesion.objetivo = silabaObjetivo
    sesion.actividad = "conciencia_fonologica_silaba_inicial_" .. silabaObjetivo
    sesion.total_esperado = #palabrasNivel
    sesion.reporte_auto_mostrado = false

    nivelSecuencial.activo = true
    nivelSecuencial.indice = 1
    nivelSecuencial.palabras = palabrasNivel

    CONS_Printf(player, "========== SONIC FONOKIDS ==========")
    CONS_Printf(player, nombreNivel)
    CONS_Printf(player, "Objetivo: identificar palabras con silaba inicial " .. silabaObjetivo)
    CONS_Printf(player, "Aparecera un objeto a la vez.")
    CONS_Printf(player, "Toca el objeto para registrar la respuesta.")
    CONS_Printf(player, "El reporte aparecera automaticamente al finalizar.")
    CONS_Printf(player, "====================================")

    crearSiguienteObjetoSecuencial(player)
end

COM_AddCommand("fonoma", function(player)
    fonoIniciarNivelSilaba(player, "MA", {
        "mano",
        "mapa",
        "pato",
        "bala"
    }, "NIVEL MA: Bosque de la silaba MA")
end)

COM_AddCommand("fonopa", function(player)
    fonoIniciarNivelSilaba(player, "PA", {
        "pato",
        "pala",
        "mano",
        "bala"
    }, "NIVEL PA: Camino de la silaba PA")
end)

COM_AddCommand("fonoba", function(player)
    fonoIniciarNivelSilaba(player, "BA", {
        "bala",
        "barco",
        "pato",
        "mano"
    }, "NIVEL BA: Puente de la silaba BA")
end)

COM_AddCommand("fononiveles", function(player)
    CONS_Printf(player, "========== NIVELES FONOKIDS ==========")
    CONS_Printf(player, "fonoma -> actividad con silaba MA")
    CONS_Printf(player, "fonopa -> actividad con silaba PA")
    CONS_Printf(player, "fonoba -> actividad con silaba BA")
    CONS_Printf(player, "fononivel1seq -> nivel secuencial original MA")
    CONS_Printf(player, "fononivel1auto -> nivel automatico original MA")
    CONS_Printf(player, "======================================")
end)


-- ================================
-- Datos estructurados para IA
-- ================================

local function fonoPorcentajeSeguro()
    return obtenerPorcentajeLogro()
end

local function fonoMostrarJSON(player)
    local porcentaje = fonoPorcentajeSeguro()

    CONS_Printf(player, "========== COPIAR DESDE AQUI ==========")
    CONS_Printf(player, "{")
    CONS_Printf(player, '  "proyecto": "Sonic FonoKids",')
    CONS_Printf(player, '  "tipo_reporte": "descriptivo_no_clinico",')
    CONS_Printf(player, '  "jugador_anonimo": "' .. tostring(sesion.jugador) .. '",')
    CONS_Printf(player, '  "actividad": "' .. tostring(sesion.actividad) .. '",')
    CONS_Printf(player, '  "objetivo": "' .. tostring(sesion.objetivo) .. '",')
    CONS_Printf(player, '  "nivel": "' .. tostring(sesion.nivel) .. '",')
    CONS_Printf(player, '  "intentos_totales": ' .. tostring(sesion.intentos) .. ',')
    CONS_Printf(player, '  "respuestas_correctas": ' .. tostring(sesion.correctos) .. ',')
    CONS_Printf(player, '  "errores": ' .. tostring(sesion.errores) .. ',')
    CONS_Printf(player, '  "ayudas_usadas": ' .. tostring(sesion.ayudas) .. ',')
    CONS_Printf(player, '  "porcentaje_logro": ' .. tostring(porcentaje) .. ',')
    CONS_Printf(player, '  "completado": ' .. tostring(sesion.completado == true) .. ',')
    CONS_Printf(player, '  "advertencia": "Este reporte no constituye diagnostico fonoaudiologico.",')
    CONS_Printf(player, '  "errores_detalle": [')

    if sesion.errores_detalle ~= nil and #sesion.errores_detalle > 0 then
        for i = 1, #sesion.errores_detalle do
            local e = sesion.errores_detalle[i]
            local coma = ","

            if i == #sesion.errores_detalle then
                coma = ""
            end

            CONS_Printf(player, '    { "palabra": "' .. tostring(e.palabra) .. '", "tipo": "' .. tostring(e.tipo) .. '" }' .. coma)
        end
    end

    CONS_Printf(player, "  ]")
    CONS_Printf(player, "}")
    CONS_Printf(player, "========== COPIAR HASTA AQUI ==========")
end

COM_AddCommand("fonojson", function(player)
    fonoMostrarJSON(player)
end)

COM_AddCommand("fonocopia", function(player)
    CONS_Printf(player, "Usa el comando fonojson y copia el bloque entre:")
    CONS_Printf(player, "COPIAR DESDE AQUI / COPIAR HASTA AQUI")
    CONS_Printf(player, "Luego pegalo en la IA junto al prompt de Reports/prompt_reporte_ia.md")
end)


-- ================================
-- Modulo de vocabulario: categorias semanticas
-- ================================

-- Agregar categoria a palabras existentes
if bancoPalabras["pato"] ~= nil then
    bancoPalabras["pato"].categoria = "animal"
end

if bancoPalabras["sopa"] ~= nil then
    bancoPalabras["sopa"].categoria = "comida"
end

if bancoPalabras["mano"] ~= nil then
    bancoPalabras["mano"].categoria = "parte_cuerpo"
end

if bancoPalabras["mapa"] ~= nil then
    bancoPalabras["mapa"].categoria = "objeto"
end

if bancoPalabras["bala"] ~= nil then
    bancoPalabras["bala"].categoria = "objeto"
end

-- Nuevas palabras para vocabulario
bancoPalabras["gato"] = {
    texto = "gato",
    silaba = "GA",
    categoria = "animal",
    correcto = false,
    tipo = "distractor_categoria"
}

bancoPalabras["perro"] = {
    texto = "perro",
    silaba = "PE",
    categoria = "animal",
    correcto = false,
    tipo = "distractor_categoria"
}

bancoPalabras["mesa"] = {
    texto = "mesa",
    silaba = "ME",
    categoria = "objeto",
    correcto = false,
    tipo = "distractor_categoria"
}

bancoPalabras["auto"] = {
    texto = "auto",
    silaba = "AU",
    categoria = "transporte",
    correcto = false,
    tipo = "distractor_categoria"
}

local vocabSecuencial = {
    activo = false,
    indice = 1,
    categoriaObjetivo = "animal",
    palabras = {
        "pato",
        "gato",
        "perro",
        "mesa",
        "auto",
        "sopa"
    }
}

local function fonoConfigurarBancoPorCategoria(categoriaObjetivo)
    for clave, dato in pairs(bancoPalabras) do
        if dato.categoria == categoriaObjetivo then
            dato.correcto = true
            dato.tipo = "objetivo_categoria"
        else
            dato.correcto = false
            dato.tipo = "distractor_categoria"
        end
    end
end

local crearSiguienteObjetoVocabulario

COM_AddCommand("fonovocab", function(player)
    if fonoLimpiarObjetosActivos ~= nil then
        fonoLimpiarObjetosActivos(player)
    end

    fonoConfigurarBancoPorCategoria("animal")

    iniciarSesion()

    sesion.actividad = "vocabulario_categoria_animales"
    sesion.objetivo = "ANIMALES"
    sesion.total_esperado = #vocabSecuencial.palabras
    sesion.reporte_auto_mostrado = false

    vocabSecuencial.activo = true
    vocabSecuencial.indice = 1
    vocabSecuencial.categoriaObjetivo = "animal"

    if nivelSecuencial ~= nil then
        nivelSecuencial.activo = false
    end

    CONS_Printf(player, "========== SONIC FONOKIDS ==========")
    CONS_Printf(player, "NIVEL VOCABULARIO: Animales")
    CONS_Printf(player, "Objetivo educativo:")
    CONS_Printf(player, "Toca solo palabras que sean ANIMALES.")
    CONS_Printf(player, " ")
    CONS_Printf(player, "Animales:")
    CONS_Printf(player, "- pato")
    CONS_Printf(player, "- gato")
    CONS_Printf(player, "- perro")
    CONS_Printf(player, " ")
    CONS_Printf(player, "Distractores:")
    CONS_Printf(player, "- mesa")
    CONS_Printf(player, "- auto")
    CONS_Printf(player, "- sopa")
    CONS_Printf(player, " ")
    CONS_Printf(player, "El reporte aparecera automaticamente al terminar.")
    CONS_Printf(player, "====================================")

    crearSiguienteObjetoVocabulario(player)
end)

COM_AddCommand("fonovocablista", function(player)
    CONS_Printf(player, "========== VOCABULARIO FONOKIDS ==========")
    CONS_Printf(player, "Categoria actual: ANIMALES")
    CONS_Printf(player, "Correctas: pato, gato, perro")
    CONS_Printf(player, "Distractores: mesa, auto, sopa")
    CONS_Printf(player, "Comando: fonovocab")
    CONS_Printf(player, "==========================================")
end)


-- ================================
-- Feedback ajustado por tipo de actividad
-- ================================

local function fonoEsActividadVocabulario()
    if sesion ~= nil and sesion.actividad ~= nil then
        return string.find(tostring(sesion.actividad), "vocabulario") ~= nil
    end

    return false
end

registrarCorrecto = function(player, palabra)
    if sesion.completado == true then
        return
    end

    sesion.intentos = (sesion.intentos or 0) + 1
    sesion.correctos = (sesion.correctos or 0) + 1

    local p = string.upper(tostring(palabra or ""))

    if fonoEsActividadVocabulario() == true then
        CONS_Printf(player, "¡Muy bien! " .. p .. " pertenece a la categoria " .. tostring(sesion.objetivo) .. ".")
        CONS_Printf(player, "¡Sigue asi!")

        if fonoSetHud ~= nil then
            fonoSetHud(player, "MUY BIEN: " .. p, "ES DE " .. tostring(sesion.objetivo), TICRATE * 4)
        end
    else
        fonoMostrarFeedbackCorrecto(player, palabra)
    end

    if sesion.total_esperado == nil and sesion.correctos >= 5 then
        sesion.completado = true
        CONS_Printf(player, "Actividad completada. Escribe fonoreporte para ver el reporte.")
    end

    if revisarCierreActividad ~= nil then
        revisarCierreActividad(player)
    end

    if nivelSecuencial ~= nil and nivelSecuencial.activo == true and sesion.completado ~= true then
        nivelSecuencial.indice = nivelSecuencial.indice + 1
        crearSiguienteObjetoSecuencial(player)
    end

    if vocabSecuencial ~= nil and vocabSecuencial.activo == true and sesion.completado ~= true then
        vocabSecuencial.indice = vocabSecuencial.indice + 1
        crearSiguienteObjetoVocabulario(player)
    end
end

registrarError = function(player, palabra, tipo)
    if sesion.completado == true then
        return
    end

    sesion.intentos = (sesion.intentos or 0) + 1
    sesion.errores = (sesion.errores or 0) + 1

    table.insert(sesion.errores_detalle, {
        palabra = palabra,
        tipo = tipo
    })

    local p = string.upper(tostring(palabra or ""))

    if fonoEsActividadVocabulario() == true then
        CONS_Printf(player, "Buen intento. " .. p .. " no pertenece a la categoria " .. tostring(sesion.objetivo) .. ".")
        CONS_Printf(player, "Busquemos palabras que sean " .. tostring(sesion.objetivo) .. ".")

        if fonoSetHud ~= nil then
            fonoSetHud(player, "BUEN INTENTO: " .. p, "NO ES DE " .. tostring(sesion.objetivo), TICRATE * 4)
        end
    else
        fonoMostrarFeedbackError(player, palabra)
    end

    if revisarCierreActividad ~= nil then
        revisarCierreActividad(player)
    end

    if nivelSecuencial ~= nil and nivelSecuencial.activo == true and sesion.completado ~= true then
        nivelSecuencial.indice = nivelSecuencial.indice + 1
        crearSiguienteObjetoSecuencial(player)
    end

    if vocabSecuencial ~= nil and vocabSecuencial.activo == true and sesion.completado ~= true then
        vocabSecuencial.indice = vocabSecuencial.indice + 1
        crearSiguienteObjetoVocabulario(player)
    end
end


-- ================================
-- Nuevas categorias de vocabulario
-- ================================

-- Palabras de comida
bancoPalabras["pan"] = {
    texto = "pan",
    silaba = "PA",
    categoria = "comida",
    correcto = false,
    tipo = "distractor_categoria"
}

bancoPalabras["queso"] = {
    texto = "queso",
    silaba = "QUE",
    categoria = "comida",
    correcto = false,
    tipo = "distractor_categoria"
}

bancoPalabras["manzana"] = {
    texto = "manzana",
    silaba = "MA",
    categoria = "comida",
    correcto = false,
    tipo = "distractor_categoria"
}

-- Palabras de transporte
bancoPalabras["bus"] = {
    texto = "bus",
    silaba = "BU",
    categoria = "transporte",
    correcto = false,
    tipo = "distractor_categoria"
}

bancoPalabras["tren"] = {
    texto = "tren",
    silaba = "TRE",
    categoria = "transporte",
    correcto = false,
    tipo = "distractor_categoria"
}

-- auto ya existe, pero nos aseguramos de que tenga categoria transporte
if bancoPalabras["auto"] ~= nil then
    bancoPalabras["auto"].categoria = "transporte"
end

-- ================================
-- Vocabulario generico por categoria
-- ================================

local function fonoNombreCategoriaBonito(categoria)
    if categoria == "animal" then
        return "ANIMALES"
    elseif categoria == "comida" then
        return "COMIDAS"
    elseif categoria == "transporte" then
        return "TRANSPORTES"
    end

    return string.upper(tostring(categoria))
end

-- Reemplazamos la funcion visual de vocabulario por una version generica
crearSiguienteObjetoVocabulario = function(player)
    if vocabSecuencial.activo == false then
        return
    end

    if vocabSecuencial.indice > #vocabSecuencial.palabras then
        vocabSecuencial.activo = false
        return
    end

    local palabra = vocabSecuencial.palabras[vocabSecuencial.indice]
    local dato = bancoPalabras[palabra]
    local categoriaBonita = fonoNombreCategoriaBonito(vocabSecuencial.categoriaObjetivo)

    CONS_Printf(player, "========== VOCABULARIO FONOKIDS ==========")
    CONS_Printf(player, "Objeto " .. tostring(vocabSecuencial.indice) .. " de " .. tostring(#vocabSecuencial.palabras))
    CONS_Printf(player, "Palabra actual: " .. tostring(palabra))
    CONS_Printf(player, "Objetivo: toca solo " .. categoriaBonita .. ".")

    if dato ~= nil and dato.categoria == vocabSecuencial.categoriaObjetivo then
        CONS_Printf(player, "Esta palabra pertenece a la categoria " .. categoriaBonita .. ".")
    else
        CONS_Printf(player, "Esta palabra NO pertenece a la categoria " .. categoriaBonita .. ".")
    end

    CONS_Printf(player, "Toca el objeto para registrar la respuesta.")
    CONS_Printf(player, "==========================================")

    if fonoSetHud ~= nil then
        fonoSetHud(player, "PALABRA: " .. string.upper(tostring(palabra)), "CATEGORIA: " .. categoriaBonita, TICRATE * 8)
    end

    crearObjetoFono(player, palabra, 4)
end

local function fonoIniciarVocabCategoria(player, categoria, palabras, nombreNivel)
    if fonoLimpiarObjetosActivos ~= nil then
        fonoLimpiarObjetosActivos(player)
    end

    fonoConfigurarBancoPorCategoria(categoria)

    iniciarSesion()

    local categoriaBonita = fonoNombreCategoriaBonito(categoria)

    sesion.actividad = "vocabulario_categoria_" .. tostring(categoria)
    sesion.objetivo = categoriaBonita
    sesion.total_esperado = #palabras
    sesion.reporte_auto_mostrado = false

    vocabSecuencial.activo = true
    vocabSecuencial.indice = 1
    vocabSecuencial.categoriaObjetivo = categoria
    vocabSecuencial.palabras = palabras

    if nivelSecuencial ~= nil then
        nivelSecuencial.activo = false
    end

    CONS_Printf(player, "========== SONIC FONOKIDS ==========")
    CONS_Printf(player, nombreNivel)
    CONS_Printf(player, "Objetivo educativo:")
    CONS_Printf(player, "Toca solo palabras de la categoria " .. categoriaBonita .. ".")
    CONS_Printf(player, " ")
    CONS_Printf(player, "El reporte aparecera automaticamente al terminar.")
    CONS_Printf(player, "====================================")

    crearSiguienteObjetoVocabulario(player)
end

COM_AddCommand("fonocomida", function(player)
    fonoIniciarVocabCategoria(player, "comida", {
        "pan",
        "queso",
        "manzana",
        "pato",
        "auto",
        "mesa"
    }, "NIVEL VOCABULARIO: Comidas")
end)

COM_AddCommand("fonotransporte", function(player)
    fonoIniciarVocabCategoria(player, "transporte", {
        "auto",
        "bus",
        "tren",
        "pato",
        "sopa",
        "mesa"
    }, "NIVEL VOCABULARIO: Transportes")
end)

COM_AddCommand("fonovocabniveles", function(player)
    CONS_Printf(player, "========== CATEGORIAS FONOKIDS ==========")
    CONS_Printf(player, "fonovocab      -> categoria ANIMALES")
    CONS_Printf(player, "fonocomida     -> categoria COMIDAS")
    CONS_Printf(player, "fonotransporte -> categoria TRANSPORTES")
    CONS_Printf(player, "=========================================")
end)


-- ================================
-- Demo presentable Sonic FonoKids
-- ================================

COM_AddCommand("fonodemo", function(player)
    CONS_Printf(player, "========== SONIC FONOKIDS ==========")
    CONS_Printf(player, "DEMO GENERAL DEL PROYECTO")
    CONS_Printf(player, " ")
    CONS_Printf(player, "Sonic FonoKids es un mod educativo experimental")
    CONS_Printf(player, "creado sobre Sonic Robo Blast 2.")
    CONS_Printf(player, " ")
    CONS_Printf(player, "Objetivo:")
    CONS_Printf(player, "Apoyar actividades ludicas de lenguaje,")
    CONS_Printf(player, "conciencia fonologica y vocabulario infantil.")
    CONS_Printf(player, " ")
    CONS_Printf(player, "Modo recomendado actual:")
    CONS_Printf(player, "Actividades de eleccion entre 2 opciones.")
    CONS_Printf(player, "El nino observa dos alternativas y toca solo una.")
    CONS_Printf(player, " ")
    CONS_Printf(player, "1) Conciencia fonologica en pares:")
    CONS_Printf(player, "   fonoma2 -> silaba inicial MA")
    CONS_Printf(player, "   fonopa2 -> silaba inicial PA")
    CONS_Printf(player, "   fonoba2 -> silaba inicial BA")
    CONS_Printf(player, " ")
    CONS_Printf(player, "2) Vocabulario por categorias en pares:")
    CONS_Printf(player, "   fonovocab2      -> animales")
    CONS_Printf(player, "   fonocomida2     -> comidas")
    CONS_Printf(player, "   fonotransporte2 -> transportes")
    CONS_Printf(player, " ")
    CONS_Printf(player, "Reportes:")
    CONS_Printf(player, "   fonoreporte      -> reporte descriptivo")
    CONS_Printf(player, "   fonoparesdetalle -> detalle de pares")
    CONS_Printf(player, "   fonojson         -> datos estructurados para IA")
    CONS_Printf(player, " ")
    CONS_Printf(player, "Comandos de ayuda:")
    CONS_Printf(player, "   fonocomandos")
    CONS_Printf(player, "   fonoparesniveles")
    CONS_Printf(player, "   fonoparesvocab")
    CONS_Printf(player, " ")
    CONS_Printf(player, "Advertencia:")
    CONS_Printf(player, "Este proyecto no diagnostica ni reemplaza a una fonoaudiologa.")
    CONS_Printf(player, "Los datos deben ser interpretados por una persona del area.")
    CONS_Printf(player, "====================================")

    if fonoSetHud ~= nil then
        fonoSetHud(player, "SONIC FONOKIDS", "PRUEBA: fonoma2", TICRATE * 8)
    end
end)

COM_AddCommand("fonodemoma", function(player)
    CONS_Printf(player, "Iniciando demo de conciencia fonologica: silaba MA.")
    CONS_Printf(player, "Toca los objetos que aparecen.")
    CONS_Printf(player, "Al finalizar se mostrara el reporte automaticamente.")

    fonoIniciarNivelSilaba(player, "MA", {
        "mano",
        "mapa",
        "pato",
        "bala"
    }, "DEMO: Conciencia fonologica - silaba MA")
end)

COM_AddCommand("fonodemovocab", function(player)
    CONS_Printf(player, "Iniciando demo de vocabulario: categoria ANIMALES.")
    CONS_Printf(player, "Toca los objetos que aparecen.")
    CONS_Printf(player, "Al finalizar se mostrara el reporte automaticamente.")

    fonoIniciarVocabCategoria(player, "animal", {
        "pato",
        "gato",
        "perro",
        "mesa",
        "auto",
        "sopa"
    }, "DEMO: Vocabulario - categoria Animales")
end)

COM_AddCommand("fonocomandos", function(player)
    CONS_Printf(player, "========== COMANDOS FONOKIDS ==========")
    CONS_Printf(player, "Presentacion:")
    CONS_Printf(player, "fonodemo        -> guia general del proyecto")
    CONS_Printf(player, "fonocomandos    -> lista completa de comandos")
    CONS_Printf(player, " ")
    CONS_Printf(player, "Pares fonologicos:")
    CONS_Printf(player, "fonoma2         -> elegir palabra con MA")
    CONS_Printf(player, "fonopa2         -> elegir palabra con PA")
    CONS_Printf(player, "fonoba2         -> elegir palabra con BA")
    CONS_Printf(player, "fonoparesniveles -> ayuda de pares fonologicos")
    CONS_Printf(player, " ")
    CONS_Printf(player, "Pares de vocabulario:")
    CONS_Printf(player, "fonovocab2       -> elegir ANIMAL")
    CONS_Printf(player, "fonocomida2      -> elegir COMIDA")
    CONS_Printf(player, "fonotransporte2  -> elegir TRANSPORTE")
    CONS_Printf(player, "fonoparesvocab   -> ayuda de pares vocabulario")
    CONS_Printf(player, " ")
    CONS_Printf(player, "Modos secuenciales antiguos:")
    CONS_Printf(player, "fonoma          -> nivel MA secuencial")
    CONS_Printf(player, "fonopa          -> nivel PA secuencial")
    CONS_Printf(player, "fonoba          -> nivel BA secuencial")
    CONS_Printf(player, "fonovocab       -> animales secuencial")
    CONS_Printf(player, "fonocomida      -> comidas secuencial")
    CONS_Printf(player, "fonotransporte  -> transportes secuencial")
    CONS_Printf(player, " ")
    CONS_Printf(player, "Reportes y datos:")
    CONS_Printf(player, "fonoreporte      -> reporte descriptivo")
    CONS_Printf(player, "fonoparesdetalle -> detalle de respuestas por par")
    CONS_Printf(player, "fonojson         -> datos para IA")
    CONS_Printf(player, "fonoreset        -> reiniciar sesion")
    CONS_Printf(player, "=======================================")
end)



-- ================================
-- Limpieza de objetos activos FonoKids
-- ================================

fonoLimpiarObjetosActivos = function(player)
    if objetosFono ~= nil then
        for objeto, _ in pairs(objetosFono) do
            if objeto ~= nil and objeto.valid then
                P_RemoveMobj(objeto)
            end

            objetosFono[objeto] = nil
        end
    end

    if nivelSecuencial ~= nil then
        nivelSecuencial.activo = false
    end

    if vocabSecuencial ~= nil then
        vocabSecuencial.activo = false
    end

    if quizFono ~= nil then
        quizFono.activo = false
    end

    if player ~= nil then
        CONS_Printf(player, "Objetos anteriores limpiados.")
    end
end


-- ================================
-- Modo de eleccion entre 2 opciones
-- ================================

local fonoProgramarSiguientePar
local crearSiguienteParFono

local fonoPares = {
    activo = false,
    indice = 1,
    objetivo = "MA",
    pares = {},
    objetos = {},
    esperandoSiguiente = false,
    ticsEspera = 0,
    playerEspera = nil
}

local function fonoLimpiarObjetosPares()
    if fonoPares.objetos ~= nil then
        for i = 1, #fonoPares.objetos do
            local objeto = fonoPares.objetos[i]

            if objeto ~= nil then
                if objetosFono ~= nil then
                    objetosFono[objeto] = nil
                end

                if objeto.valid then
                    P_RemoveMobj(objeto)
                end
            end
        end
    end

    fonoPares.objetos = {}
    fonoPares.esperandoSiguiente = false
    fonoPares.ticsEspera = 0
    fonoPares.playerEspera = nil
end

-- Extendemos la limpieza general para que tambien corte el modo de pares.
local fonoLimpiarObjetosActivosBasePares = fonoLimpiarObjetosActivos

fonoLimpiarObjetosActivos = function(player)
    if fonoPares ~= nil then
        fonoPares.activo = false
        fonoLimpiarObjetosPares()
    end

    if fonoLimpiarObjetosActivosBasePares ~= nil then
        fonoLimpiarObjetosActivosBasePares(player)
    end
end

local function crearObjetoFonoPar(player, palabra, lado)
    if player == nil then
        return nil
    end

    if player.mo == nil or player.mo.valid == false then
        return nil
    end

    -- La disposicion se calcula con la vista para que las tarjetas
    -- siempre aparezcan una al lado de la otra en pantalla.
    local distanciaFrente = 120 * FRACUNIT
    local separacionLateral = 72 * FRACUNIT
    local altura = 36 * FRACUNIT

    local anguloFrente = player.mo.angle

    if camera ~= nil and camera.angle ~= nil then
        anguloFrente = camera.angle
    end

    local anguloLado = anguloFrente + ANGLE_90

    local xBase = player.mo.x
        + FixedMul(cos(anguloFrente), distanciaFrente)
    local yBase = player.mo.y
        + FixedMul(sin(anguloFrente), distanciaFrente)

    local x = xBase
        + FixedMul(cos(anguloLado), separacionLateral * lado)
    local y = yBase
        + FixedMul(sin(anguloLado), separacionLateral * lado)
    local z = player.mo.z + altura

    local objeto = P_SpawnMobj(x, y, z, MT_FONO_OBJETO)

    if objeto ~= nil then
        objeto.scale = FRACUNIT * 3 / 2

        if objetosFono ~= nil then
            objetosFono[objeto] = palabra
        end

        table.insert(fonoPares.objetos, objeto)
        CONS_Printf(player, "Objeto educativo creado: " .. tostring(palabra))
    end

    return objeto
end

local function fonoIniciarParesMA(player)
    if fonoLimpiarObjetosActivos ~= nil then
        fonoLimpiarObjetosActivos(player)
    end

    fonoConfigurarBancoPorSilaba("MA")
    iniciarSesion()

    sesion.actividad = "eleccion_pares_silaba_MA"
    sesion.objetivo = "MA"
    sesion.total_esperado = 2
    sesion.reporte_auto_mostrado = false

    if nivelSecuencial ~= nil then
        nivelSecuencial.activo = false
    end

    if vocabSecuencial ~= nil then
        vocabSecuencial.activo = false
    end

    fonoPares.activo = true
    fonoPares.indice = 1
    fonoPares.objetivo = "MA"
    fonoPares.modo = "silaba"
    fonoPares.categoriaObjetivo = nil

    -- Par 1: correcta a la izquierda.
    -- Par 2: correcta a la derecha.
    -- Asi evitamos que el niño aprenda "siempre tocar el mismo lado".
    fonoPares.pares = {
        {
            izquierda = "mano",
            derecha = "pato"
        },
        {
            izquierda = "bala",
            derecha = "mapa"
        }
    }

    CONS_Printf(player, "========== SONIC FONOKIDS ==========")
    CONS_Printf(player, "MODO ELECCION ENTRE 2 OPCIONES")
    CONS_Printf(player, "Objetivo educativo:")
    CONS_Printf(player, "Escoger la palabra que empieza con MA.")
    CONS_Printf(player, " ")
    CONS_Printf(player, "Apareceran dos opciones al mismo tiempo.")
    CONS_Printf(player, "El nino debe tocar solo una.")
    CONS_Printf(player, "Al final se genera el reporte automaticamente.")
    CONS_Printf(player, "====================================")

    crearSiguienteParFono(player)
end

local registrarCorrectoParesBase = registrarCorrecto

registrarCorrecto = function(player, palabra)
    registrarCorrectoParesBase(player, palabra)

    if fonoPares ~= nil and fonoPares.activo == true then
        fonoLimpiarObjetosPares()

        if sesion.completado == true then
            fonoPares.activo = false
            return
        end

        fonoPares.indice = fonoPares.indice + 1
        fonoProgramarSiguientePar(player)
    end
end

local registrarErrorParesBase = registrarError

registrarError = function(player, palabra, tipo)
    registrarErrorParesBase(player, palabra, tipo)

    if fonoPares ~= nil and fonoPares.activo == true then
        fonoLimpiarObjetosPares()

        if sesion.completado == true then
            fonoPares.activo = false
            return
        end

        fonoPares.indice = fonoPares.indice + 1
        fonoProgramarSiguientePar(player)
    end
end

COM_AddCommand("fonoma2", function(player)
    fonoIniciarParesMA(player)
end)

COM_AddCommand("fonoparesma", function(player)
    fonoIniciarParesMA(player)
end)

COM_AddCommand("fonodemopares", function(player)
    CONS_Printf(player, "Iniciando demo de eleccion entre 2 opciones.")
    CONS_Printf(player, "Actividad: silaba inicial MA.")
    fonoIniciarParesMA(player)
end)

COM_AddCommand("fonoparesayuda", function(player)
    CONS_Printf(player, "========== PARES FONOKIDS ==========")
    CONS_Printf(player, "fonoma2        -> eleccion entre 2 opciones con silaba MA")
    CONS_Printf(player, "fonoparesma    -> lo mismo que fonoma2")
    CONS_Printf(player, "fonodemopares  -> demo presentable del modo pares")
    CONS_Printf(player, " ")
    CONS_Printf(player, "Ejemplo:")
    CONS_Printf(player, "Izquierda: MANO")
    CONS_Printf(player, "Derecha: PATO")
    CONS_Printf(player, "El niño toca solo una opcion.")
    CONS_Printf(player, "====================================")
end)



-- ================================
-- Modo pares para vocabulario/categorias
-- ================================

-- Reemplazamos la visualizacion del par por una version que sirve
-- tanto para silabas como para categorias.
crearSiguienteParFono = function(player)
    if fonoPares.activo == false then
        return
    end

    if fonoPares.indice > #fonoPares.pares then
        fonoPares.activo = false
        return
    end

    fonoLimpiarObjetosPares()

    local par = fonoPares.pares[fonoPares.indice]
    local izquierda = par.izquierda
    local derecha = par.derecha

    local textoObjetivo = ""
    local lineaHud1 = ""
    local lineaHud2 = ""

    if fonoPares.modo == "categoria" then
        local categoriaBonita = fonoNombreCategoriaBonito(fonoPares.categoriaObjetivo)

        textoObjetivo = "escoge una palabra de la categoria " .. categoriaBonita .. "."
        lineaHud1 = "BUSCA: " .. categoriaBonita
        lineaHud2 = "IZQ: " .. string.upper(tostring(izquierda)) .. " | DER: " .. string.upper(tostring(derecha))
    else
        textoObjetivo = "escoge una palabra que empiece con " .. tostring(fonoPares.objetivo) .. "."
        lineaHud1 = "BUSCA: " .. tostring(fonoPares.objetivo)
        lineaHud2 = "IZQ: " .. string.upper(tostring(izquierda)) .. " | DER: " .. string.upper(tostring(derecha))
    end

    CONS_Printf(player, "========== ELECCION FONOKIDS ==========")
    CONS_Printf(player, "Par " .. tostring(fonoPares.indice) .. " de " .. tostring(#fonoPares.pares))
    CONS_Printf(player, "Objetivo: " .. textoObjetivo)
    CONS_Printf(player, " ")
    CONS_Printf(player, "Izquierda: " .. string.upper(tostring(izquierda)))
    CONS_Printf(player, "Derecha: " .. string.upper(tostring(derecha)))
    CONS_Printf(player, " ")
    CONS_Printf(player, "Toca solo una opcion.")
    CONS_Printf(player, "=======================================")

    if fonoSetHud ~= nil then
        fonoSetHud(player, lineaHud1, lineaHud2, TICRATE * 10)
    end

    -- Ojo: usamos este orden porque ya quedo probado que coincide
    -- con izquierda/derecha real dentro del juego.
    crearObjetoFonoPar(player, izquierda, 1)
    crearObjetoFonoPar(player, derecha, -1)
end

local function fonoIniciarParesCategoria(player, categoria, pares, nombreNivel)
    if fonoLimpiarObjetosActivos ~= nil then
        fonoLimpiarObjetosActivos(player)
    end

    fonoConfigurarBancoPorCategoria(categoria)
    iniciarSesion()

    local categoriaBonita = fonoNombreCategoriaBonito(categoria)

    sesion.actividad = "eleccion_pares_vocabulario_" .. tostring(categoria)
    sesion.objetivo = categoriaBonita
    sesion.total_esperado = #pares
    sesion.reporte_auto_mostrado = false

    if nivelSecuencial ~= nil then
        nivelSecuencial.activo = false
    end

    if vocabSecuencial ~= nil then
        vocabSecuencial.activo = false
    end

    fonoPares.activo = true
    fonoPares.indice = 1
    fonoPares.modo = "categoria"
    fonoPares.objetivo = categoriaBonita
    fonoPares.categoriaObjetivo = categoria
    fonoPares.pares = pares

    CONS_Printf(player, "========== SONIC FONOKIDS ==========")
    CONS_Printf(player, nombreNivel)
    CONS_Printf(player, "Objetivo educativo:")
    CONS_Printf(player, "Escoger la palabra que pertenece a " .. categoriaBonita .. ".")
    CONS_Printf(player, " ")
    CONS_Printf(player, "Apareceran dos opciones al mismo tiempo.")
    CONS_Printf(player, "El nino debe tocar solo una.")
    CONS_Printf(player, "Al final se genera el reporte automaticamente.")
    CONS_Printf(player, "====================================")

    crearSiguienteParFono(player)
end

COM_AddCommand("fonovocab2", function(player)
    fonoIniciarParesCategoria(player, "animal", {
        {
            izquierda = "gato",
            derecha = "mesa"
        },
        {
            izquierda = "auto",
            derecha = "perro"
        },
        {
            izquierda = "pato",
            derecha = "sopa"
        }
    }, "MODO PARES: Categoria ANIMALES")
end)

COM_AddCommand("fonocomida2", function(player)
    fonoIniciarParesCategoria(player, "comida", {
        {
            izquierda = "pan",
            derecha = "bus"
        },
        {
            izquierda = "perro",
            derecha = "queso"
        },
        {
            izquierda = "manzana",
            derecha = "auto"
        }
    }, "MODO PARES: Categoria COMIDAS")
end)

COM_AddCommand("fonotransporte2", function(player)
    fonoIniciarParesCategoria(player, "transporte", {
        {
            izquierda = "auto",
            derecha = "sopa"
        },
        {
            izquierda = "mesa",
            derecha = "bus"
        },
        {
            izquierda = "tren",
            derecha = "gato"
        }
    }, "MODO PARES: Categoria TRANSPORTES")
end)

COM_AddCommand("fonodemovocab2", function(player)
    CONS_Printf(player, "Iniciando demo de eleccion entre 2 opciones.")
    CONS_Printf(player, "Actividad: categoria ANIMALES.")
    fonoIniciarParesCategoria(player, "animal", {
        {
            izquierda = "gato",
            derecha = "mesa"
        },
        {
            izquierda = "auto",
            derecha = "perro"
        },
        {
            izquierda = "pato",
            derecha = "sopa"
        }
    }, "DEMO PARES: Vocabulario - ANIMALES")
end)

COM_AddCommand("fonoparesvocab", function(player)
    CONS_Printf(player, "========== PARES VOCABULARIO ==========")
    CONS_Printf(player, "fonovocab2       -> elegir ANIMAL")
    CONS_Printf(player, "fonocomida2      -> elegir COMIDA")
    CONS_Printf(player, "fonotransporte2  -> elegir TRANSPORTE")
    CONS_Printf(player, "fonodemovocab2   -> demo de animales")
    CONS_Printf(player, " ")
    CONS_Printf(player, "Ejemplo:")
    CONS_Printf(player, "Izquierda: GATO")
    CONS_Printf(player, "Derecha: MESA")
    CONS_Printf(player, "El nino toca solo una opcion.")
    CONS_Printf(player, "=======================================")
end)



-- ================================
-- Pausa entre pares FonoKids
-- ================================

fonoProgramarSiguientePar = function(player)
    if fonoPares == nil then
        return
    end

    if fonoPares.activo == false then
        return
    end

    fonoPares.esperandoSiguiente = true
    fonoPares.ticsEspera = TICRATE
    fonoPares.playerEspera = player

    CONS_Printf(player, "Preparando siguiente par...")
end

addHook("ThinkFrame", function()
    if fonoPares == nil then
        return
    end

    if fonoPares.esperandoSiguiente ~= true then
        return
    end

    if fonoPares.ticsEspera > 0 then
        fonoPares.ticsEspera = fonoPares.ticsEspera - 1
        return
    end

    fonoPares.esperandoSiguiente = false

    local player = fonoPares.playerEspera

    if player == nil then
        return
    end

    if player.mo == nil or player.mo.valid == false then
        return
    end

    crearSiguienteParFono(player)
end)



-- ================================
-- Pares fonologicos PA y BA
-- ================================

local function fonoIniciarParesSilaba(player, silabaObjetivo, pares, nombreNivel)
    if fonoLimpiarObjetosActivos ~= nil then
        fonoLimpiarObjetosActivos(player)
    end

    fonoConfigurarBancoPorSilaba(silabaObjetivo)
    iniciarSesion()

    sesion.actividad = "eleccion_pares_silaba_" .. tostring(silabaObjetivo)
    sesion.objetivo = silabaObjetivo
    sesion.total_esperado = #pares
    sesion.reporte_auto_mostrado = false

    if nivelSecuencial ~= nil then
        nivelSecuencial.activo = false
    end

    if vocabSecuencial ~= nil then
        vocabSecuencial.activo = false
    end

    fonoPares.activo = true
    fonoPares.indice = 1
    fonoPares.modo = "silaba"
    fonoPares.objetivo = silabaObjetivo
    fonoPares.categoriaObjetivo = nil
    fonoPares.pares = pares

    CONS_Printf(player, "========== SONIC FONOKIDS ==========")
    CONS_Printf(player, nombreNivel)
    CONS_Printf(player, "Objetivo educativo:")
    CONS_Printf(player, "Escoger la palabra que empieza con " .. tostring(silabaObjetivo) .. ".")
    CONS_Printf(player, " ")
    CONS_Printf(player, "Apareceran dos opciones al mismo tiempo.")
    CONS_Printf(player, "El nino debe tocar solo una.")
    CONS_Printf(player, "Al final se genera el reporte automaticamente.")
    CONS_Printf(player, "====================================")

    crearSiguienteParFono(player)
end

COM_AddCommand("fonopa2", function(player)
    fonoIniciarParesSilaba(player, "PA", {
        {
            izquierda = "pato",
            derecha = "mano"
        },
        {
            izquierda = "mapa",
            derecha = "pala"
        },
        {
            izquierda = "papa",
            derecha = "bala"
        }
    }, "MODO PARES: Silaba inicial PA")
end)

COM_AddCommand("fonoba2", function(player)
    fonoIniciarParesSilaba(player, "BA", {
        {
            izquierda = "bala",
            derecha = "pato"
        },
        {
            izquierda = "mano",
            derecha = "barco"
        },
        {
            izquierda = "banco",
            derecha = "mapa"
        }
    }, "MODO PARES: Silaba inicial BA")
end)

COM_AddCommand("fonodemopa2", function(player)
    CONS_Printf(player, "Iniciando demo de eleccion entre 2 opciones.")
    CONS_Printf(player, "Actividad: silaba inicial PA.")

    fonoIniciarParesSilaba(player, "PA", {
        {
            izquierda = "pato",
            derecha = "mano"
        },
        {
            izquierda = "mapa",
            derecha = "pala"
        },
        {
            izquierda = "papa",
            derecha = "bala"
        }
    }, "DEMO PARES: Silaba inicial PA")
end)

COM_AddCommand("fonodemoba2", function(player)
    CONS_Printf(player, "Iniciando demo de eleccion entre 2 opciones.")
    CONS_Printf(player, "Actividad: silaba inicial BA.")

    fonoIniciarParesSilaba(player, "BA", {
        {
            izquierda = "bala",
            derecha = "pato"
        },
        {
            izquierda = "mano",
            derecha = "barco"
        },
        {
            izquierda = "banco",
            derecha = "mapa"
        }
    }, "DEMO PARES: Silaba inicial BA")
end)

COM_AddCommand("fonoparesniveles", function(player)
    CONS_Printf(player, "========== PARES FONOLOGICOS ==========")
    CONS_Printf(player, "fonoma2 -> elegir palabra con silaba inicial MA")
    CONS_Printf(player, "fonopa2 -> elegir palabra con silaba inicial PA")
    CONS_Printf(player, "fonoba2 -> elegir palabra con silaba inicial BA")
    CONS_Printf(player, " ")
    CONS_Printf(player, "Demos:")
    CONS_Printf(player, "fonodemopares -> demo MA")
    CONS_Printf(player, "fonodemopa2   -> demo PA")
    CONS_Printf(player, "fonodemoba2   -> demo BA")
    CONS_Printf(player, "=======================================")
end)



-- ================================
-- Reporte detallado para modo pares
-- ================================

local function fonoEsActividadPares()
    if sesion == nil then
        return false
    end

    if sesion.actividad == nil then
        return false
    end

    return string.find(tostring(sesion.actividad), "eleccion_pares") ~= nil
end

local function fonoPalabraEsCorrectaActual(palabra)
    if bancoPalabras == nil then
        return false
    end

    local dato = bancoPalabras[palabra]

    if dato == nil then
        return false
    end

    if fonoPares ~= nil and fonoPares.modo == "categoria" then
        return dato.categoria == fonoPares.categoriaObjetivo
    end

    return dato.correcto == true
end

local function fonoRespuestaEsperadaDelPar(par)
    if par == nil then
        return "desconocida"
    end

    if fonoPalabraEsCorrectaActual(par.izquierda) == true then
        return tostring(par.izquierda)
    end

    if fonoPalabraEsCorrectaActual(par.derecha) == true then
        return tostring(par.derecha)
    end

    return "desconocida"
end

local function fonoRegistrarDetallePar(resultado, palabraSeleccionada, tipoError)
    if fonoEsActividadPares() == false then
        return
    end

    if fonoPares == nil then
        return
    end

    if fonoPares.activo ~= true then
        return
    end

    if fonoPares.pares == nil then
        return
    end

    local par = fonoPares.pares[fonoPares.indice]

    if par == nil then
        return
    end

    if sesion.pares_detalle == nil then
        sesion.pares_detalle = {}
    end

    local esperado = fonoRespuestaEsperadaDelPar(par)

    table.insert(sesion.pares_detalle, {
        numero = fonoPares.indice,
        izquierda = par.izquierda,
        derecha = par.derecha,
        seleccion = palabraSeleccionada,
        esperado = esperado,
        resultado = resultado,
        tipo = tipoError or ""
    })
end

local registrarCorrectoReporteParesBase = registrarCorrecto

registrarCorrecto = function(player, palabra)
    fonoRegistrarDetallePar("correcto", palabra, "")
    registrarCorrectoReporteParesBase(player, palabra)
end

local registrarErrorReporteParesBase = registrarError

registrarError = function(player, palabra, tipo)
    fonoRegistrarDetallePar("error", palabra, tipo)
    registrarErrorReporteParesBase(player, palabra, tipo)
end

local function fonoPorcentajeSesion()
    return obtenerPorcentajeLogro()
end

local function fonoResultadoDescriptivoPares(porcentaje)
    if porcentaje >= 80 then
        return "desempeno alto dentro de la actividad"
    elseif porcentaje >= 50 then
        return "desempeno intermedio dentro de la actividad"
    end

    return "desempeno bajo dentro de la actividad"
end

local mostrarReporteDescriptivoBasePares = mostrarReporteDescriptivo

mostrarReporteDescriptivo = function(player)
    if fonoEsActividadPares() == false then
        mostrarReporteDescriptivoBasePares(player)
        return
    end

    local porcentaje = fonoPorcentajeSesion()
    local porcentajeTexto = tostring(porcentaje)

    CONS_Printf(player, "========== SONIC FONOKIDS ==========")
    CONS_Printf(player, "REPORTE DESCRIPTIVO NO CLINICO")
    CONS_Printf(player, "Sesion: " .. tostring(sesion.jugador))

    if sesion.actividad ~= nil and string.find(tostring(sesion.actividad), "vocabulario") ~= nil then
        CONS_Printf(player, "Actividad: eleccion entre 2 opciones - categoria " .. tostring(sesion.objetivo))
    else
        CONS_Printf(player, "Actividad: eleccion entre 2 opciones - silaba inicial " .. tostring(sesion.objetivo))
    end

    CONS_Printf(player, "Tipo de actividad: seleccion entre dos alternativas")
    CONS_Printf(player, "Pares presentados: " .. tostring(sesion.total_esperado or 0))
    CONS_Printf(player, "Intentos: " .. tostring(sesion.intentos or 0))
    CONS_Printf(player, "Correctos: " .. tostring(sesion.correctos or 0))
    CONS_Printf(player, "Errores: " .. tostring(sesion.errores or 0))
    CONS_Printf(player, "Ayudas usadas: " .. tostring(sesion.ayudas or 0))
    CONS_Printf(player, "Logro: " .. porcentajeTexto .. "%")
    CONS_Printf(player, "Resultado descriptivo: " .. fonoResultadoDescriptivoPares(porcentaje))

    if sesion.pares_detalle ~= nil and #sesion.pares_detalle > 0 then
        CONS_Printf(player, " ")
        CONS_Printf(player, "Detalle por par:")

        for i = 1, #sesion.pares_detalle do
            local detalle = sesion.pares_detalle[i]
            local resultadoTexto = "CORRECTO"

            if detalle.resultado == "error" then
                resultadoTexto = "ERROR"
            end

            CONS_Printf(player, "Par " .. tostring(detalle.numero) .. ": " .. string.upper(tostring(detalle.izquierda)) .. " / " .. string.upper(tostring(detalle.derecha)))
            CONS_Printf(player, "  Seleccion: " .. string.upper(tostring(detalle.seleccion)))
            CONS_Printf(player, "  Respuesta esperada: " .. string.upper(tostring(detalle.esperado)))
            CONS_Printf(player, "  Resultado: " .. resultadoTexto)
        end
    else
        CONS_Printf(player, "Detalle por par: no se registraron pares.")
    end

    if sesion.errores_detalle ~= nil and #sesion.errores_detalle > 0 then
        CONS_Printf(player, " ")
        CONS_Printf(player, "Errores observados:")

        for i = 1, #sesion.errores_detalle do
            local errorDato = sesion.errores_detalle[i]
            CONS_Printf(player, "- " .. tostring(errorDato.palabra) .. " / " .. tostring(errorDato.tipo))
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

COM_AddCommand("fonoparesdetalle", function(player)
    if sesion == nil or sesion.pares_detalle == nil or #sesion.pares_detalle == 0 then
        CONS_Printf(player, "No hay detalle de pares registrado en esta sesion.")
        return
    end

    CONS_Printf(player, "========== DETALLE DE PARES ==========")

    for i = 1, #sesion.pares_detalle do
        local detalle = sesion.pares_detalle[i]
        CONS_Printf(player, "Par " .. tostring(detalle.numero) .. ": " .. string.upper(tostring(detalle.izquierda)) .. " / " .. string.upper(tostring(detalle.derecha)))
        CONS_Printf(player, "Seleccion: " .. string.upper(tostring(detalle.seleccion)))
        CONS_Printf(player, "Esperada: " .. string.upper(tostring(detalle.esperado)))
        CONS_Printf(player, "Resultado: " .. string.upper(tostring(detalle.resultado)))
    end

    CONS_Printf(player, "======================================")
end)



-- ================================
-- Sala guiada Sonic FonoKids
-- ================================

COM_AddCommand("fonosala", function(player)
    if fonoLimpiarObjetosActivos ~= nil then
        fonoLimpiarObjetosActivos(player)
    end

    CONS_Printf(player, "========== SALA SONIC FONOKIDS ==========")
    CONS_Printf(player, "Bienvenido a la sala guiada del proyecto.")
    CONS_Printf(player, " ")
    CONS_Printf(player, "Esta sala organiza las actividades principales")
    CONS_Printf(player, "para probar el mod de forma mas ordenada.")
    CONS_Printf(player, " ")
    CONS_Printf(player, "1) Conciencia fonologica:")
    CONS_Printf(player, "   fonosala1 -> demo con silaba inicial MA")
    CONS_Printf(player, "   fonopa2   -> actividad con silaba PA")
    CONS_Printf(player, "   fonoba2   -> actividad con silaba BA")
    CONS_Printf(player, " ")
    CONS_Printf(player, "2) Vocabulario por categorias:")
    CONS_Printf(player, "   fonosala2       -> demo con categoria ANIMALES")
    CONS_Printf(player, "   fonocomida2     -> categoria COMIDAS")
    CONS_Printf(player, "   fonotransporte2 -> categoria TRANSPORTES")
    CONS_Printf(player, " ")
    CONS_Printf(player, "3) Reportes:")
    CONS_Printf(player, "   fonosala3        -> ayuda de reportes")
    CONS_Printf(player, "   fonoreporte      -> reporte descriptivo")
    CONS_Printf(player, "   fonoparesdetalle -> detalle de pares")
    CONS_Printf(player, "   fonojson         -> datos estructurados para IA")
    CONS_Printf(player, " ")
    CONS_Printf(player, "Sugerencia de presentacion:")
    CONS_Printf(player, "   1. fonosala")
    CONS_Printf(player, "   2. fonosala1")
    CONS_Printf(player, "   3. fonosala2")
    CONS_Printf(player, "   4. fonosala3")
    CONS_Printf(player, "=========================================")

    if fonoSetHud ~= nil then
        fonoSetHud(player, "SALA FONOKIDS", "USA fonosala1 o fonosala2", TICRATE * 10)
    end
end)

COM_AddCommand("fonosala1", function(player)
    CONS_Printf(player, "========== SALA 1: FONOLOGIA ==========")
    CONS_Printf(player, "Actividad:")
    CONS_Printf(player, "Escoger entre dos opciones la palabra que empieza con MA.")
    CONS_Printf(player, " ")
    CONS_Printf(player, "Ejemplo:")
    CONS_Printf(player, "MANO / PATO")
    CONS_Printf(player, "BALA / MAPA")
    CONS_Printf(player, " ")
    CONS_Printf(player, "El nino toca solo una opcion.")
    CONS_Printf(player, "=======================================")

    if fonoIniciarParesSilaba ~= nil then
        fonoIniciarParesSilaba(player, "MA", {
            {
                izquierda = "mano",
                derecha = "pato"
            },
            {
                izquierda = "bala",
                derecha = "mapa"
            }
        }, "SALA 1: Conciencia fonologica - silaba MA")
    else
        CONS_Printf(player, "No se encontro el sistema de pares fonologicos.")
    end
end)

COM_AddCommand("fonosala2", function(player)
    CONS_Printf(player, "========== SALA 2: VOCABULARIO ==========")
    CONS_Printf(player, "Actividad:")
    CONS_Printf(player, "Escoger entre dos opciones la palabra que pertenece")
    CONS_Printf(player, "a la categoria ANIMALES.")
    CONS_Printf(player, " ")
    CONS_Printf(player, "Ejemplo:")
    CONS_Printf(player, "GATO / MESA")
    CONS_Printf(player, "AUTO / PERRO")
    CONS_Printf(player, "SOPA / PATO")
    CONS_Printf(player, " ")
    CONS_Printf(player, "El nino toca solo una opcion.")
    CONS_Printf(player, "=========================================")

    if fonoIniciarParesCategoria ~= nil then
        fonoIniciarParesCategoria(player, "animal", {
            {
                izquierda = "gato",
                derecha = "mesa"
            },
            {
                izquierda = "auto",
                derecha = "perro"
            },
            {
                izquierda = "sopa",
                derecha = "pato"
            }
        }, "SALA 2: Vocabulario - categoria ANIMALES")
    else
        CONS_Printf(player, "No se encontro el sistema de pares de vocabulario.")
    end
end)

COM_AddCommand("fonosala3", function(player)
    CONS_Printf(player, "========== SALA 3: REPORTES ==========")
    CONS_Printf(player, "Despues de completar una actividad puedes usar:")
    CONS_Printf(player, " ")
    CONS_Printf(player, "fonoreporte")
    CONS_Printf(player, "Muestra un reporte descriptivo no clinico.")
    CONS_Printf(player, " ")
    CONS_Printf(player, "fonoparesdetalle")
    CONS_Printf(player, "Muestra que opcion fue presentada, cual se selecciono")
    CONS_Printf(player, "y cual era la respuesta esperada.")
    CONS_Printf(player, " ")
    CONS_Printf(player, "fonojson")
    CONS_Printf(player, "Entrega datos estructurados para IA.")
    CONS_Printf(player, " ")
    CONS_Printf(player, "Advertencia:")
    CONS_Printf(player, "Los datos describen rendimiento dentro del juego.")
    CONS_Printf(player, "No constituyen diagnostico fonoaudiologico.")
    CONS_Printf(player, "La interpretacion debe realizarla una persona del area.")
    CONS_Printf(player, "======================================")
end)

COM_AddCommand("fonosalademo", function(player)
    CONS_Printf(player, "========== DEMO SALA FONOKIDS ==========")
    CONS_Printf(player, "Orden recomendado para mostrar el proyecto:")
    CONS_Printf(player, " ")
    CONS_Printf(player, "1) fonosala")
    CONS_Printf(player, "   Muestra la sala guiada.")
    CONS_Printf(player, " ")
    CONS_Printf(player, "2) fonosala1")
    CONS_Printf(player, "   Prueba conciencia fonologica con silaba MA.")
    CONS_Printf(player, " ")
    CONS_Printf(player, "3) fonosala2")
    CONS_Printf(player, "   Prueba vocabulario con categoria ANIMALES.")
    CONS_Printf(player, " ")
    CONS_Printf(player, "4) fonosala3")
    CONS_Printf(player, "   Explica reportes y datos para IA.")
    CONS_Printf(player, " ")
    CONS_Printf(player, "5) fonojson")
    CONS_Printf(player, "   Copia los datos finales de la sesion.")
    CONS_Printf(player, "========================================")
end)

COM_AddCommand("fonosalalimpia", function(player)
    if fonoLimpiarObjetosActivos ~= nil then
        fonoLimpiarObjetosActivos(player)
        CONS_Printf(player, "Sala limpiada correctamente.")
    else
        CONS_Printf(player, "No se encontro la funcion de limpieza.")
    end
end)



-- ================================
-- Sprites por palabra FonoKids
-- ================================


local fonoSpriteFrames = {
    mano = A,      -- A
    mapa = B,      -- B
    pato = S,      -- S
    bala = D,      -- D
    gato = E,      -- E
    mesa = F,      -- F
    auto = G,      -- G
    perro = H,     -- H
    sopa = I,      -- I
    pan = J,       -- J
    queso = K,    -- K
    manzana = L,  -- L
    bus = M,      -- M
    tren = N,     -- N
    barco = O,    -- O
    banco = P,    -- P
    pala = Q,     -- Q
    papa = R      -- R
}

local fonoSpriteStates

local function fonoAplicarSpritePalabra(objeto, palabra)
    if objeto == nil then
        return
    end

    if objeto.valid == false then
        return
    end

    local clave = tostring(palabra)
    local estado = nil
    local frame = nil

    if fonoSpriteStates ~= nil then
        estado = fonoSpriteStates[clave]
    end

    if fonoSpriteFrames ~= nil then
        frame = fonoSpriteFrames[clave]
    end

    if estado ~= nil then
        objeto.state = estado
    end

    if frame ~= nil then
        objeto.sprite = SPR_FONI
        objeto.frame = frame
    end

    objeto.scale = FRACUNIT * 3 / 2
    objeto.tics = -1
end

local crearObjetoFonoBaseSprites = crearObjetoFono

crearObjetoFono = function(player, palabra, indice)
    local objeto = crearObjetoFonoBaseSprites(player, palabra, indice)
    fonoAplicarSpritePalabra(objeto, palabra)
    return objeto
end

local crearObjetoFonoParBaseSprites = crearObjetoFonoPar

crearObjetoFonoPar = function(player, palabra, lado)
    local objeto = crearObjetoFonoParBaseSprites(player, palabra, lado)
    fonoAplicarSpritePalabra(objeto, palabra)
    return objeto
end

COM_AddCommand("fonosprites", function(player)
    CONS_Printf(player, "========== SPRITES FONOKIDS ==========")
    CONS_Printf(player, "Sprites activos por palabra:")
    CONS_Printf(player, "mano, mapa, pato, bala")
    CONS_Printf(player, "gato, mesa, auto, perro")
    CONS_Printf(player, "sopa, pan, queso, manzana")
    CONS_Printf(player, "bus, tren, barco, banco")
    CONS_Printf(player, "pala, papa")
    CONS_Printf(player, "======================================")
end)



-- ================================
-- Estados visuales por palabra FonoKids
-- ================================

freeslot("SPR_FONI")

freeslot(
    "S_FONO_MANO",
    "S_FONO_MAPA",
    "S_FONO_PATO",
    "S_FONO_BALA",
    "S_FONO_GATO",
    "S_FONO_MESA",
    "S_FONO_AUTO",
    "S_FONO_PERRO",
    "S_FONO_SOPA",
    "S_FONO_PAN",
    "S_FONO_QUESO",
    "S_FONO_MANZANA",
    "S_FONO_BUS",
    "S_FONO_TREN",
    "S_FONO_BARCO",
    "S_FONO_BANCO",
    "S_FONO_PALA",
    "S_FONO_PAPA"
)

states[S_FONO_MANO]    = {sprite = SPR_FONI, frame = A,  tics = -1, nextstate = S_FONO_MANO}
states[S_FONO_MAPA]    = {sprite = SPR_FONI, frame = B,  tics = -1, nextstate = S_FONO_MAPA}
states[S_FONO_PATO]    = {sprite = SPR_FONI, frame = S,  tics = -1, nextstate = S_FONO_PATO}
states[S_FONO_BALA]    = {sprite = SPR_FONI, frame = D,  tics = -1, nextstate = S_FONO_BALA}
states[S_FONO_GATO]    = {sprite = SPR_FONI, frame = E,  tics = -1, nextstate = S_FONO_GATO}
states[S_FONO_MESA]    = {sprite = SPR_FONI, frame = F,  tics = -1, nextstate = S_FONO_MESA}
states[S_FONO_AUTO]    = {sprite = SPR_FONI, frame = G,  tics = -1, nextstate = S_FONO_AUTO}
states[S_FONO_PERRO]   = {sprite = SPR_FONI, frame = H,  tics = -1, nextstate = S_FONO_PERRO}
states[S_FONO_SOPA]    = {sprite = SPR_FONI, frame = I,  tics = -1, nextstate = S_FONO_SOPA}
states[S_FONO_PAN]     = {sprite = SPR_FONI, frame = J,  tics = -1, nextstate = S_FONO_PAN}
states[S_FONO_QUESO]   = {sprite = SPR_FONI, frame = K, tics = -1, nextstate = S_FONO_QUESO}
states[S_FONO_MANZANA] = {sprite = SPR_FONI, frame = L, tics = -1, nextstate = S_FONO_MANZANA}
states[S_FONO_BUS]     = {sprite = SPR_FONI, frame = M, tics = -1, nextstate = S_FONO_BUS}
states[S_FONO_TREN]    = {sprite = SPR_FONI, frame = N, tics = -1, nextstate = S_FONO_TREN}
states[S_FONO_BARCO]   = {sprite = SPR_FONI, frame = O, tics = -1, nextstate = S_FONO_BARCO}
states[S_FONO_BANCO]   = {sprite = SPR_FONI, frame = P, tics = -1, nextstate = S_FONO_BANCO}
states[S_FONO_PALA]    = {sprite = SPR_FONI, frame = Q, tics = -1, nextstate = S_FONO_PALA}
states[S_FONO_PAPA]    = {sprite = SPR_FONI, frame = R, tics = -1, nextstate = S_FONO_PAPA}

fonoSpriteStates = {
    mano = S_FONO_MANO,
    mapa = S_FONO_MAPA,
    pato = S_FONO_PATO,
    bala = S_FONO_BALA,
    gato = S_FONO_GATO,
    mesa = S_FONO_MESA,
    auto = S_FONO_AUTO,
    perro = S_FONO_PERRO,
    sopa = S_FONO_SOPA,
    pan = S_FONO_PAN,
    queso = S_FONO_QUESO,
    manzana = S_FONO_MANZANA,
    bus = S_FONO_BUS,
    tren = S_FONO_TREN,
    barco = S_FONO_BARCO,
    banco = S_FONO_BANCO,
    pala = S_FONO_PALA,
    papa = S_FONO_PAPA
}



-- ================================
-- Debug visual de sprites FonoKids
-- ================================

COM_AddCommand("fonospritecheck", function(player)
    CONS_Printf(player, "========== SPRITE CHECK ==========")

    if SPR_FONI ~= nil then
        CONS_Printf(player, "SPR_FONI existe.")
    else
        CONS_Printf(player, "SPR_FONI NO existe.")
    end

    if fonoSpriteFrames ~= nil then
        CONS_Printf(player, "fonoSpriteFrames existe.")
    else
        CONS_Printf(player, "fonoSpriteFrames NO existe.")
    end

    if fonoSpriteStates ~= nil then
        CONS_Printf(player, "fonoSpriteStates existe.")
    else
        CONS_Printf(player, "fonoSpriteStates NO existe.")
    end

    if objetosFono ~= nil then
        local total = 0

        for objeto, palabra in pairs(objetosFono) do
            if objeto ~= nil and objeto.valid then
                total = total + 1
                CONS_Printf(player, "Objeto activo: " .. tostring(palabra))
                CONS_Printf(player, "  sprite/frame/state revisados.")
            end
        end

        CONS_Printf(player, "Objetos activos: " .. tostring(total))
    else
        CONS_Printf(player, "objetosFono NO existe.")
    end

    CONS_Printf(player, "==================================")
end)
