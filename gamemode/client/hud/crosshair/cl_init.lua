include('cl_utils.lua')

function DrawCrosshair()
    local wep = LocalPlayer():GetActiveWeapon()
    local crosshairThick, crosshairSize = 2, 30
    local h, w = ScrH(), ScrW()

    surface.SetDrawColor(255, 255, 255, 255)

    -- Horizontal
    surface.DrawRect(
        w / 2 - crosshairThick / 2, 
        h / 2 - crosshairSize / 2, 
        2,
        crosshairSize
    )

    -- Vertical
    surface.DrawRect(
        w / 2 - crosshairSize / 2, 
        h / 2 - crosshairThick / 2, 
        crosshairSize,
        2
    )

    -- Draw ammo
    if IsValid(wep) then
        DrawCircleWithSquares(
            w /2, 
            h / 2, 
            wep:GetMaxClip1(), 
            wep:GetMaxClip1() - wep:Clip1() + 1, 
            20,
            2
        )
    end
end

-- Add crosshair hook
hook.Add("HUDPaint", "DrawCrosshair", DrawCrosshair)

net.Receive("smod.damage", function()
    local ply = net.ReadEntity()
    local damage = net.ReadFloat()
    local amount = net.ReadFloat()

    LocalPlayer():EmitSound("smashmod/hit.mp3", 75, math.random(85, 115))
end)