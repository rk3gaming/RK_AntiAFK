local Config = Config or {}

if Config.EnableAFK then
    local afkTimeMinutes = Config.afkTimeMinutes
    local kickTime = Config.kickTime 
    local captchaLength = Config.captchaLength
    local captchaChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    local timeLeft = afkTimeMinutes * 60
    local prevPos = nil
    local captchaActive = false

    local function generateCaptcha(length)
        local captcha = ""
        for i = 1, length do
            local rand = math.random(1, #captchaChars)
            captcha = captcha .. captchaChars:sub(rand, rand)
        end
        return captcha
    end

    local function checkAFK()
        if captchaActive then return end  
        captchaActive = true
        local captcha = generateCaptcha(captchaLength)
        local kickTimer = kickTime
        local responded = false

        Citizen.CreateThread(function()
            while kickTimer > 0 do
                Wait(1000)  
                kickTimer = kickTimer - 1
                if responded then
                    return  
                end
            end

            if not responded then
                TriggerServerEvent('LSC:AntiAFK:kick')  
            end
        end)

        local input = lib.inputDialog('Anti AFK', {
            {type = 'input', label = 'CAPTCHA: ' .. captcha, description = 'Enter The CAPTCHA to Avoid Being Kicked', required = true, min = captchaLength, max = captchaLength}
        })

        if input and input[1] then
            if input[1] == captcha then
                responded = true
                captchaActive = false
                local message = "AFK System: You have answered the CAPTCHA correctly. You will not be kicked for being AFK."
                TriggerEvent('chat:addMessage', {
                    color = {11, 131, 69},  
                    args = {message}
                })
                timeLeft = afkTimeMinutes * 60
            else
                local message = "AFK System: You have answered the CAPTCHA incorrectly. Please try again."
                TriggerEvent('chat:addMessage', {
                    color = {170, 20, 20},  
                    args = {message}
                })
                captchaActive = false
                checkAFK()  
            end
        else
            TriggerServerEvent('LSC:AntiAFK:kick') 
        end
    end

    Citizen.CreateThread(function()
        while true do
            Wait(1000)
            local playerPed = PlayerPedId()
            if playerPed then
                local currentPos = GetEntityCoords(playerPed, true)
                if prevPos and currentPos == prevPos then
                    if timeLeft > 0 then
                        timeLeft = timeLeft - 1
                        if timeLeft == 0 then
                            checkAFK()
                        end
                    end
                else
                    timeLeft = afkTimeMinutes * 60
                end
                prevPos = currentPos
            end
        end
    end)
end
