include("load.lua")

hook.Add("PlayerSetModel", "SetBuild", function(ply)
end)

hook.Add("PlayerSpawn", "GiveBuild", function(ply)
    local build, key = Builds:GetRandom()
    ply:SetModel(build.model)
    ply:SetNWString("smod_build", key)
    ply:SetNWFloat("smod_damage", build.initialDamage)

    for _, weapon in pairs(build.weapons) do
        ply:Give(weapon)
    end
end)