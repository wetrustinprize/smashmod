include("load.lua")

hook.Add("PlayerAmmoChanged", "InfiniteAmmo", function(ply, ammoId)
    ply:SetAmmo(9999, ammoId)
end)

hook.Add("PlayerSpawn", "GiveBuild", function(ply)
    local build, key = Builds:GetRandom()
    ply:SetModel(build.model)
    ply:SetNWString("smod_build", key)
    ply:SetNWFloat("smod_damage", build.initialDamage)

    for _, weapon in pairs(build.weapons) do
        local w = weapons.Get(weapon)
        if w == nil then
            continue
        end

        local primary, secondary = w:GetPrimaryAmmoType(), w:GetSecondaryAmmoType()

        if primary ~= nil then
            ply:SetAmmo(primary, 9999)
        end

        if secondary ~= nil then
            ply:SetAmmo(secondary, 9999)
        end

        ply:Give(weapon)
    end
end)