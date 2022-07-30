ESX                 = nil
local PlayerData    = {}

local turvatarkastus = {
    allowedWeapons = {
        "WEAPON_KNIFE",
        "WEAPON_BAT",
        "WEAPON_HAMMER",
        "WEAPON_NIGHTSTICK",
        "WEAPON_KNUCKLE",
        "WEAPON_GOLFCLUB",
        "WEAPON_CROWBAR",
        "WEAPON_BOTTLE",
        "WEAPON_DAGGER",
        "WEAPON_HATCHET",
        "WEAPON_MACHETE",
        "WEAPON_SWITCHBLADE",
        "WEAPON_PROXMINE",
        "WEAPON_BZGAS",
        "WEAPON_SMOKEGRENADE",
        "WEAPON_MOLOTOV",
        "WEAPON_FIREEXTINGUISHER",
        "WEAPON_SNOWBALL",
        "WEAPON_FLARE",
        "WEAPON_BALL",
        "WEAPON_REVOLVER",
        "WEAPON_POOLCUE",
        "WEAPON_PIPEWRENCH",
        "WEAPON_PISTOL",
        "WEAPON_PISTOL_MK2",
        "WEAPON_COMBATPISTOL",
        "WEAPON_APPISTOL",
        "WEAPON_PISTOL50",
        "WEAPON_SNSPISTOL",
        "WEAPON_HEAVYPISTOL",
        "WEAPON_VINTAGEPISTOL",
        "WEAPON_FLAREGUN",
        "WEAPON_MARKSMANPISTOL",
        "WEAPON_MICROSMG",
        "WEAPON_MINISMG",
        "WEAPON_SMG",
        "WEAPON_SMG_MK2",
        "WEAPON_ASSAULTSMG",
        "WEAPON_MG",
        "WEAPON_COMBATMG",
        "WEAPON_COMBATMG_MK2",
        "WEAPON_COMBATPDW",
        "WEAPON_GUSENBERG",
        "WEAPON_MACHINEPISTOL",
        "WEAPON_ASSAULTRIFLE",
        "WEAPON_ASSAULTRIFLE_MK2",
        "WEAPON_CARBINERIFLE",
        "WEAPON_CARBINERIFLE_MK2",
        "WEAPON_ADVANCEDRIFLE",
        "WEAPON_SPECIALCARBINE",
        "WEAPON_BULLPUPRIFLE",
        "WEAPON_COMPACTRIFLE",
        "WEAPON_PUMPSHOTGUN",
        "WEAPON_SWEEPERSHOTGUN",
        "WEAPON_SAWNOFFSHOTGUN",
        "WEAPON_BULLPUPSHOTGUN",
        "WEAPON_ASSAULTSHOTGUN",
        "WEAPON_MUSKET",
        "WEAPON_HEAVYSHOTGUN",
        "WEAPON_DBSHOTGUN",
        "WEAPON_SNIPERRIFLE",
        "WEAPON_HEAVYSNIPER",
        "WEAPON_HEAVYSNIPER_MK2",
        "WEAPON_MARKSMANRIFLE",
        "WEAPON_GRENADELAUNCHER",
        "WEAPON_RPG",
        "WEAPON_MINIGUN",
        "WEAPON_FIREWORK",
        "WEAPON_RAILGUN",
        "WEAPON_HOMINGLAUNCHER",
        "WEAPON_GRENADE",
        "WEAPON_STICKYBOMB",
        "WEAPON_COMPACTLAUNCHER",
        "WEAPON_SNSPISTOL_MK2",
        "WEAPON_REVOLVER_MK2",
        "WEAPON_DOUBLEACTION",
        "WEAPON_SPECIALCARBINE_MK2",
        "WEAPON_BULLPUPRIFLE_MK2",
        "WEAPON_PUMPSHOTGUN_MK2",
        "WEAPON_MARKSMANRIFLE_MK2",
        "WEAPON_RAYPISTOL",
        "WEAPON_RAYCARBINE",
        "WEAPON_RAYMINIGUN",
        "WEAPON_DIGISCANNER",
        "WEAPON_NAVYREVOLVER",
        "WEAPON_CERAMICPISTOL",
        "WEAPON_STONE_HATCHET",
        "WEAPON_PIPEBOMB",
    }
}

function LoadCutscene(cut, flag1, flag2)
  if (not flag1) then
    RequestCutscene(cut, 8)
  else
    RequestCutsceneEx(cut, flag1, flag2)
  end
  while (not HasThisCutsceneLoaded(cut)) do Wait(0) end
  return
end

local function BeginCutsceneWithPlayer()
  local plyrId = PlayerPedId()
  local playerClone = ClonePed_2(plyrId, 0.0, false, true, 1)

  SetBlockingOfNonTemporaryEvents(playerClone, true)
  SetEntityVisible(playerClone, false, false)
  SetEntityInvincible(playerClone, true)
  SetEntityCollision(playerClone, false, false)
  FreezeEntityPosition(playerClone, true)
  SetPedHelmet(playerClone, false)
  RemovePedHelmet(playerClone, true)

  SetCutsceneEntityStreamingFlags('MP_1', 0, 1)
  RegisterEntityForCutscene(plyrId, 'MP_1', 0, GetEntityModel(plyrId), 64)

  Wait(10)
  StartCutscene(0)
  Wait(10)
  ClonePedToTarget(playerClone, plyrId)
  Wait(10)
  DeleteEntity(playerClone)
  Wait(50)
  DoScreenFadeIn(250)

  return playerClone
end

local function Finish(timer)
  local tripped = false

  repeat
    Wait(0)
    if (timer and (GetCutsceneTime() > timer))then
      DoScreenFadeOut(250)
      tripped = true
    end

    if (GetCutsceneTotalDuration() - GetCutsceneTime() <= 250) then
      DoScreenFadeOut(250)
      tripped = true
    end
  until not IsCutscenePlaying()
  if (not tripped) then
    DoScreenFadeOut(100)
    Wait(150)
  end
  return
end

local landAnim = {1, 2, 4}
local timings = {
  [1] = 9100,
  [2] = 17500,
  [4] = 25400
}


Citizen.CreateThread(function ()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(1)
    end
    while ESX.GetPlayerData() == nil do
        Citizen.Wait(10)
    end
    PlayerData = ESX.GetPlayerData()
    TehaanBlipit()
end) 

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

function TehaanBlipit()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(5)
            local Sijaintisi = GetEntityCoords(PlayerPedId())
            for Sijainti, Data in pairs(Config.MinneVoisTP) do
                local Mene = Data['Meno']
                local Poistu = Data['Poistuminen']
                local MatkaTP, MatkaPoisTP = GetDistanceBetweenCoords(Sijaintisi, Mene['x'], Mene['y'], Mene['z'], true), GetDistanceBetweenCoords(Sijaintisi, Poistu['x'], Poistu['y'], Poistu['z'], true)
           			if MatkaTP <= 2.0 then 
                        DisplayHelpText(Mene['Teksti'], -1, Mene['x'], Mene['y'], Mene['z'])
                        if MatkaTP <= 2.0 then
                            if IsControlJustPressed(0, 38) then
                                if lentolippu("tiirikka") then
                                Teleport(Data, 'Meno')
                                else
                                ESX.ShowNotification('Sinulla ei ole lentolippua')
                            end
                        end
                    end
                end
                if MatkaPoisTP <= 2.0 then
                    DisplayHelpText(Poistu['Teksti'], -1, Poistu['x'], Poistu['y'], Poistu['z'])
                    if MatkaPoisTP <= 2.0 then
                        if IsControlJustPressed(0, 38)then
                            Teleport(Data, 'Poistuminen')
                        end
                    end
                end
            end
        end
    end)
end

function Teleport(Table, Sijainti)
    if PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'fib' then
        if Sijainti == 'Meno' then ---TPM SAARELLE
            DoScreenFadeOut(100)
            RequestCollisionAtCoord(-1652.79, -3117.5, 13.98)     		  --LÄHTÖ SAARELLE KIITOTIE XD 
            LoadCutscene('hs4_lsa_take_nimb2')                    		  --LÄHTÖ SAARELLE KIITOTIE XD 
            BeginCutsceneWithPlayer()                             		  --LÄHTÖ SAARELLE KIITOTIE XD 
            Finish()                                              		  --LÄHTÖ SAARELLE KIITOTIE XD 
            RemoveCutscene()                                      		  --LÄHTÖ SAARELLE KIITOTIE XD 
            LoadCutscene('hs4_nimb_lsa_isd', 128, 24)                     ---lÄHTÖ LENTOBAILUT
            BeginCutsceneWithPlayer()                                     ---lÄHTÖ LENTOBAILUT
            Finish(165000)                                                ---lÄHTÖ LENTOBAILUT
            --LoadCutscene('hs4_nimb_lsa_isd', 256, 24)                   ---lÄHTÖ LENTOBAILUT
            --BeginCutsceneWithPlayer()                                   ---lÄHTÖ LENTOBAILUT
            --Finish(170000)                                              ---lÄHTÖ LENTOBAILUT
            LoadCutscene('hs4_nimb_lsa_isd', 512, 24)                     ---lÄHTÖ LENTOBAILUT
            BeginCutsceneWithPlayer()                                     ---lÄHTÖ LENTOBAILUT
            Finish(175200)                                                ---lÄHTÖ LENTOBAILUT
            RemoveCutscene()                                              ---lÄHTÖ LENTOBAILUT
            LoadCutscene('hs4_nimb_lsa_isd_repeat')                       ---LANDAUS SAARISKENE MISSÄ HAKEE UAZILLA  
            RequestCollisionAtCoord(-2392.838, -2427.619, 43.1663)        ---LANDAUS SAARISKENE MISSÄ HAKEE UAZILLA
            BeginCutsceneWithPlayer()                                     ---LANDAUS SAARISKENE MISSÄ HAKEE UAZILLA
            Finish()                                                      ---LANDAUS SAARISKENE MISSÄ HAKEE UAZILLA
            RemoveCutscene()                                              ---LANDAUS SAARISKENE MISSÄ HAKEE UAZILLA
            Citizen.Wait(750)
            ESX.Game.Teleport(PlayerPedId(), Table['Poistuminen'])
            SetEntityHeading(PlayerPedId(), 313.403)
            DoScreenFadeIn(100)
        else
            DoScreenFadeOut(100)
            RequestCollisionAtCoord(-2392.838, -2427.619, 43.1663) --LÄHTÖ SAARELTA 
            LoadCutscene('hs4_nimb_isd_lsa', 8, 24)                --LÄHTÖ SAARELTA 
            BeginCutsceneWithPlayer()                              --LÄHTÖ SAARELTA 
            Finish()                                               --LÄHTÖ SAARELTA 
            RemoveCutscene()                                       --LÄHTÖ SAARELTA 
            RequestCollisionAtCoord(-1652.79, -3117.5, 13.98)      --LÄNDAUS päälentokentälle     
            local flag = landAnim[ math.random( #landAnim ) ]      --LÄNDAUS päälentokentälle
            LoadCutscene('hs4_lsa_land_nimb', flag, 24)            --LÄNDAUS päälentokentälle
            BeginCutsceneWithPlayer()                              --LÄNDAUS päälentokentälle
            Finish(timings[flag])                                  --LÄNDAUS päälentokentälle
            RemoveCutscene()                                       --LÄNDAUS päälentokentälle
            Citizen.Wait(750)
            ESX.Game.Teleport(PlayerPedId(), Table['Meno'])
            SetEntityHeading(PlayerPedId(), 326.732)
            DoScreenFadeIn(100)
        end
    else
        ESX.TriggerServerCallback('lento:getPlayerInventory', function(inventory)
            local onkoaseita = false
            for i=1, #turvatarkastus.allowedWeapons do
               if HasPedGotWeapon(PlayerPedId(), turvatarkastus.allowedWeapons[i], false) then
                  onkoaseita = true
                  break
               end
            end
            
            if onkoaseita == false then
               if Sijainti == 'Meno' then ---TPM SAARELLE
                  DoScreenFadeOut(100)
                  RequestCollisionAtCoord(-1652.79, -3117.5, 13.98)     		  --LÄHTÖ SAARELLE KIITOTIE XD
                  LoadCutscene('hs4_lsa_take_nimb2')                    		  --LÄHTÖ SAARELLE KIITOTIE XD
                  BeginCutsceneWithPlayer()                             		  --LÄHTÖ SAARELLE KIITOTIE XD
                  Finish()                                              		  --LÄHTÖ SAARELLE KIITOTIE XD
                  RemoveCutscene()                                      		  --LÄHTÖ SAARELLE KIITOTIE XD
                  LoadCutscene('hs4_nimb_lsa_isd', 128, 24)                     ---lÄHTÖ LENTOBAILUT
                  BeginCutsceneWithPlayer()                                     ---lÄHTÖ LENTOBAILUT
                  Finish(165000)                                                ---lÄHTÖ LENTOBAILUT                                            ---lÄHTÖ LENTOBAILUT
                  LoadCutscene('hs4_nimb_lsa_isd', 512, 24)                     ---lÄHTÖ LENTOBAILUT
                  BeginCutsceneWithPlayer()                                     ---lÄHTÖ LENTOBAILUT
                  Finish(175200)                                                ---lÄHTÖ LENTOBAILUT
                  RemoveCutscene()                                              ---lÄHTÖ LENTOBAILUT
                  LoadCutscene('hs4_nimb_lsa_isd_repeat')                       ---LANDAUS SAARISKENE MISSÄ HAKEE UAZILLA
                  RequestCollisionAtCoord(-2392.838, -2427.619, 43.1663)        ---LANDAUS SAARISKENE MISSÄ HAKEE UAZILLA
                  BeginCutsceneWithPlayer()                                     ---LANDAUS SAARISKENE MISSÄ HAKEE UAZILLA
                  Finish()                                                      ---LANDAUS SAARISKENE MISSÄ HAKEE UAZILLA
                  RemoveCutscene()                                              ---LANDAUS SAARISKENE MISSÄ HAKEE UAZILLA
                  Citizen.Wait(750)
                  ESX.Game.Teleport(PlayerPedId(), Table['Poistuminen'])
                  SetEntityHeading(PlayerPedId(), 313.403)
                  DoScreenFadeIn(100)
               else
                  DoScreenFadeOut(100)
                  RequestCollisionAtCoord(-2392.838, -2427.619, 43.1663) --LÄHTÖ SAARELTA
                  LoadCutscene('hs4_nimb_isd_lsa', 8, 24)                --LÄHTÖ SAARELTA
                  BeginCutsceneWithPlayer()                              --LÄHTÖ SAARELTA
                  Finish()                                               --LÄHTÖ SAARELTA
                  RemoveCutscene()                                       --LÄHTÖ SAARELTA
                  RequestCollisionAtCoord(-1652.79, -3117.5, 13.98)      --LÄNDAUS päälentokentälle
                  local flag = landAnim[ math.random( #landAnim ) ]      --LÄNDAUS päälentokentälle
                  LoadCutscene('hs4_lsa_land_nimb', flag, 24)            --LÄNDAUS päälentokentälle
                  BeginCutsceneWithPlayer()                              --LÄNDAUS päälentokentälle
                  Finish(timings[flag])                                  --LÄNDAUS päälentokentälle
                  RemoveCutscene()                                       --LÄNDAUS päälentokentälle
                  Citizen.Wait(750)
                  ESX.Game.Teleport(PlayerPedId(), Table['Meno'])
                  SetEntityHeading(PlayerPedId(), 326.732)
                  DoScreenFadeIn(100)
               end
            else
               ESX.ShowNotification("Et päässyt turvatarkastuksesta läpi!")
               ESX.ShowNotification("Oliks sulla taskuissa jotain laitonta? vai unohditko lentolipun kotiin?")
            end
        end)
    end
end

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 0, 0)
end

function lentolippu(item)
    local Inventory = ESX.GetPlayerData().inventory
        for i=1, #Inventory, 1 do
            if Inventory[i].name == item then
                if Inventory[i].count and Inventory[i].count > 0 then
                    return true
                end
            end
        end
    return false 
end