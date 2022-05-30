local ply = FindMetaTable("Player")

-- Gets all the players that are next to the crosshair
function ply:GetPlayersNextToView(minDistance)
    local players = {}
    minDistance = minDistance or 60

    for _, other in pairs(player.GetAll()) do
        if other == self then continue end
        local hit = util.IntersectRayWithPlane(self:EyePos(), self:GetAimVector(), other:GetPos(), self:GetForward())
        if not hit then continue end
        local distance = other:GetPos():Distance(hit)

        if distance < minDistance then
            table.insert(players, other)
        end
    end

    return players
end