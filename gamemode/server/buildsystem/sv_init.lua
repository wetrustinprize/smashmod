include("load.lua")

hook.Add("PlayerSpawn", "GiveBuild", function(ply)
    local build = Builds:GetRandom()

    print(table.ToString(build))

    ply:SetNWFloat("smod_damage", build.initialDamage)

    for _, weapon in pairs(build.weapons) do
        ply:Give(weapon)
    end
end)