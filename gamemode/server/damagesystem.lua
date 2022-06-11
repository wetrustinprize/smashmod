-- https://steamcommunity.com/sharedfiles/filedetails/?id=2809055293
-- Created by: Your Local Birb
CreateConVar("smod_killatpercent", 1000, FCVAR_ARCHIVE, "Kill anything at this percentage or higher. 0 means disabled", 0)
CreateConVar("smod_knockback", 1, FCVAR_ARCHIVE, "Knockback Multiplier. 0 means disabled", 0, 100)

--Code used from the Gmod wiki (thanks)
function DoExplosion(pos, ent)
    ent:EmitSound("NPC_CombineBall.Explosion")
    util.ScreenShake(pos, 20, 150, 1, 1250)
    local data = EffectData()
    data:SetOrigin(pos)
    util.Effect("cball_explode", data)

    effects.BeamRingPoint(pos, 0.2, 12, 1024, 64, 0, Color(255, 255, 225, 32), {
        speed = 0,
        spread = 0,
        delay = 0,
        framerate = 2,
        material = "sprites/lgtning.vmt"
    })

    effects.BeamRingPoint(pos, 0.5, 12, 1024, 64, 0, Color(255, 255, 225, 64), {
        speed = 0,
        spread = 0,
        delay = 0,
        framerate = 2,
        material = "sprites/lgtning.vmt"
    })
end

local deathruncheck = 1

local function Damage(target, info)
    if target:IsNPC() or target:IsNextBot() or target:IsPlayer() then
        if target:GetNWBool("shoulddie") == false then
            local damage = info:GetDamage()

            if damage >= 0.00 and damage < 25.00 then
                target:EmitSound("hit/s.wav", 75, math.random(85, 115))
            end

            if damage >= 25.00 and damage < 50.00 then
                target:EmitSound("hit/m.wav", 75, math.random(85, 115))
            end

            if damage >= 50.00 then
                target:EmitSound("hit/l.wav", 75, math.random(85, 115))
            end
        end

        if target.IsDrGNextbot and target:IsOnGround() and GetConVar("smod_knockback"):GetFloat() > 0.00 then
            target:SetPos(target:GetPos() + Vector(0, 0, 20))
        end

        if target:IsPlayer() and target:IsOnGround() and GetConVar("smod_knockback"):GetFloat() > 0.00 then
            target:SetPos(target:GetPos() + Vector(0, 0, 5))
        end

        if target:IsRagdoll() then
            target:SetVelocity(Vector(0, 0, target:GetNWFloat("smod_damage")))
        end

        target:SetNWFloat("smod_damage", target:GetNWFloat("smod_damage") + info:GetDamage())

        if info:GetAttacker():IsValid() then
            if info:GetAttacker():IsPlayer() or info:GetAttacker():IsNPC() or info:GetAttacker():IsNextBot() then
                target:SetVelocity((Vector(0, 0, target:GetNWFloat("smod_damage")) + (-info:GetAttacker():GetAimVector() * -target:GetNWFloat("smod_damage")) * 3) * GetConVar("smod_knockback"):GetFloat())
            else
                target:SetVelocity(Vector(0, 0, target:GetNWFloat("smod_damage")))
            end
        end

        if target:GetNWFloat("smod_damage") >= GetConVar("smod_killatpercent"):GetInt() and GetConVar("smod_killatpercent"):GetInt() ~= 0 then
            target:SetHealth(9999999)
            local attacker = info:GetAttacker()

            if deathruncheck == 1 and target:GetNWBool("shoulddie") == false then
                target:SetNWBool("shoulddie", true)
                info:GetAttacker():EmitSound("ko.mp3", 90)

                if target.IsDrGNextbot then
                    target:SetPos(target:GetPos() + Vector(0, 0, 20))
                end

                if info:GetAttacker():IsPlayer() or info:GetAttacker():IsNPC() or info:GetAttacker():IsNextBot() then
                    target:SetVelocity((Vector(0, 0, target:GetNWFloat("smod_damage") * 10) + (-info:GetAttacker():GetAimVector() * -target:GetNWFloat("smod_damage")) * 10) * GetConVar("smod_knockback"):GetFloat())
                else
                    target:SetVelocity(Vector(0, 0, target:GetNWFloat("smod_damage")))
                end

                timer.Create("KillEntity" .. target:EntIndex(), 0.75, 1, function()
                    if target:IsValid() then
                        target:SetHealth(1)
                        target:AddFlags(FL_NOTARGET)
                        deathruncheck = 0
                        local effectdata = EffectData()
                        effectdata:SetOrigin(target:GetPos())
                        util.Effect("Explosion", effectdata)
                        DoExplosion(target:GetPos(), target)
                        target:SetNWBool("shoulddie", true)
                        target:SetNWFloat("smod_damage", 0)

                        if target:IsPlayer() then
                            for i = 1, 40 do
                                target:TakeDamage(99999999, attacker, attacker)
                            end
                        end

                        if target:IsNextBot() or target:IsNPC() then
                            for i = 1, 40 do
                                target:TakeDamage(99999999, attacker, attacker)

                                if target.IsDrGNextbot then
                                    target:Kill(attacker)
                                end
                            end
                        end

                        target:RemoveFlags(FL_NOTARGET)
                        target:Remove()
                        deathruncheck = 1
                    end
                end)
            end
        end

        if target:GetNWBool("shoulddie") == false then
            return true
        else
            return false
        end
    end
end

hook.Add("EntityTakeDamage", "DamageSystemSmashBros", Damage)

hook.Add("PostPlayerDeath", "ResetDeathSmashBros", function(ply)
    ply:SetNWFloat("smod_damage", 0)
    ply:SetNWBool("shoulddie", false)
end)

hook.Add("PlayerSpawn", "PlayerSpawnSmashBros", function(ply)
    ply:SetNWBool("shoulddie", false)
end)