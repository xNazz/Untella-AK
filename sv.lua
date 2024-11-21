local cooldown = 6 --6hour

local function isVehicleOccupied(veh)
    for seat = -1, 20 do 
        if GetPedInVehicleSeat(veh, seat) ~= 0 then 
            return true 
        end
    end
    return false 
end

local function askel()
    for i, veh in pairs(GetAllVehicles()) do 
        if HasVehicleBeenOwnedByPlayer(veh) then 
            if not isVehicleOccupied(veh) then
                DeleteEntity(veh)
            end
        end
    end
    TriggerClientEvent('ox_lib:notify', -1, {
        title = 'Asuransi Keliling',
        description = 'Asuransi keliling telah selesai',
        type = 'success'
    })
end

local function sendCountdown(menit)
    for i = menit, 0, -1 do
        if i >= 1 then
            TriggerClientEvent('ox_lib:notify', -1, {
                title = 'Asuransi Keliling',
                description = 'Asuransi keliling akan bekerja dalam '..i..' menit',
                type = 'success'
            })
            if i == 1 then
                Wait(30000)
                for j = 3, 1, -1 do
                    TriggerClientEvent('ox_lib:notify', -1, {
                        title = 'Asuransi Keliling',
                        description = 'Asuransi keliling akan bekerja dalam '..j..'0 detik',
                        type = 'success'
                    })
                    Wait(j ~= 1 and 10000 or 1000)

                    if j == 1 then
                        for k = 9, 1, -1 do
                            TriggerClientEvent('ox_lib:notify', -1, {
                                title = 'Asuransi Keliling',
                                description = 'Asuransi keliling akan bekerja dalam '..k..' detik',
                                type = 'success'
                            })
                            Wait(1000)
                        end
                    end
                end
            else
                Wait(60000)
            end
        else
            askel()
        end
    end
end

lib.addCommand('asuransikeliling', {
    help = 'Asuransi Keliling',
    params = {
        {
            name = 'menit',
            type = 'number',
            help = 'Menit',
            optional = true,
        },
    },
    restricted = 'group.admin'
}, function(source, args, raw)
    local menit = tonumber(args.menit)
    if menit then
        sendCountdown(menit)
    else
        askel()
    end
end)

lib.cron.new('* */' .. cooldown .. ' * * *', function()
    sendCountdown(10)--10minute countdown
end)