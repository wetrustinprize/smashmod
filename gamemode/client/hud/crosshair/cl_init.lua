include('cl_utils.lua')

local tex_crosshair = Material("smashmod/crosshair.png", "noclamp smooth")
local tex_hitscan = Material("smashmod/hitscan.png", "noclamp smooth")

local alpha = 0
local hideSpeed = 0.25

function DrawCrosshair()
    local wep = LocalPlayer():GetActiveWeapon()
    local crosshairSize = 30
    local hitscanSize = crosshairSize * 1.5
    local h, w = ScrH(), ScrW()

    -- Draw crosshair
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(tex_crosshair)

    surface.DrawTexturedRect(
        w / 2 - crosshairSize / 2,
        h / 2 - crosshairSize / 2,
        crosshairSize,
        crosshairSize
    )

    -- Draw hitscan
    surface.SetDrawColor(255, 255, 255, 255 * alpha)

    surface.SetMaterial(tex_hitscan)
    surface.DrawTexturedRect(
        w / 2 - hitscanSize / 2,
        h / 2 - hitscanSize / 2,
        hitscanSize,
        hitscanSize
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

    -- Animations
    alpha = math.max(0, alpha - FrameTime() / hideSpeed)
end

-- Add crosshair hook
hook.Add("HUDPaint", "DrawCrosshair", DrawCrosshair)

net.Receive("smod.damage", function()
    local ply = net.ReadEntity()
    local damage = net.ReadFloat()
    local amount = net.ReadFloat()

    LocalPlayer():EmitSound("smashmod/hit.mp3", 75, math.random(85, 115))
    alpha = 1
end)