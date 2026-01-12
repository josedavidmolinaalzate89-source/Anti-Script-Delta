-- ==============================================
-- ANTI-SCRIPT DELTA - Protección contra scripts no autorizados
-- Repositorio: https://github.com/josedavidmolinaalzate89-source/Anti-Script-Delta
-- ==============================================

-- Configuración básica
local Config = {
    PermitirScriptsAutorizados = {"TuScriptPrincipal.lua", "ModulosOficiales.lua"}, -- Nombres de scripts permitidos
    MensajeBloqueo = "Script no autorizado detectado y bloqueado.",
    ActivarLogs = true -- Muestra mensajes en consola si está activado
}

-- Función para registrar logs
local function Log(mensaje)
    if Config.ActivarLogs then
        print("[Anti-Script-Delta] " .. mensaje)
    end
end

-- Función para detectar scripts no autorizados
local function DetectarScriptsNoAutorizados()
    Log("Iniciando escaneo de seguridad...")
    
    -- Recorre todos los scripts cargados en el entorno
    for _, script in pairs(game:GetDescendants()) do
        if script:IsA("LocalScript") or script:IsA("Script") then
            local nombreScript = script.Name
            
            -- Verifica si el script está en la lista de permitidos
            local esAutorizado = false
            for _, nombrePermitido in pairs(Config.PermitirScriptsAutorizados) do
                if nombreScript == nombrePermitido then
                    esAutorizado = true
                    break
                end
            end
            
            -- Bloquea el script si no está autorizado
            if not esAutorizado then
                Log("Script no autorizado detectado: " .. nombreScript)
                script.Disabled = true
                warn(Config.MensajeBloqueo .. " Nombre: " .. nombreScript)
            end
        end
    end
    
    Log("Escaneo completado.")
end

-- Función para prevenir la carga de scripts externos no autorizados
local function BloquearCargaExterna()
    local originalHttpGet = game.HttpGet
    game.HttpGet = function(self, url)
        -- Verifica si la URL está autorizada (aquí puedes agregar tus dominios permitidos)
        if not string.find(url, "github.com/josedavidmolinaalzate89-source") then
            Log("Intento de carga externa bloqueada: " .. url)
            return ""
        end
        return originalHttpGet(self, url)
    end
end

-- Inicializar protección
Log("Iniciando sistema de protección Anti-Script Delta...")
BloquearCargaExterna()
DetectarScriptsNoAutorizados()

-- Repetir escaneo cada 10 segundos para mayor seguridad
while true do
    wait(10)
    DetectarScriptsNoAutorizados()
end
