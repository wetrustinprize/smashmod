include("load.lua")

hook.Add( "GetFallDamage", "CSSFallDamage", function( ply, speed )
	return math.max( 0, math.ceil( 0.2418 * speed - 141.75 ) )
end )

hook.Add("PlayerAmmoChanged", "InfiniteAmmo", function(ply, ammoId)
    ply:SetAmmo(9999, ammoId)
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