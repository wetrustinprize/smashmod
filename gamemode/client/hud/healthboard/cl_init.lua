include("cl_healthhud.lua")

-- Variables
local huds = {}
local playerHud = nil

local function updateHuds(players)
    -- Check if should create a new HUD
    for _, ply in pairs(players) do
        -- Check if has a HUD
        if not huds[ply] then
            huds[ply] = HealthHUD(ply)
        else
            if not huds[ply].show then
                huds[ply]:Show()
            end
        end
    end

    -- Check if should disable any HUD
    for ply, hud in pairs(huds) do
        if ply == LocalPlayer() then continue end

        if not table.HasValue(players, ply) then
            huds[ply]:Hide()
        end

        if not table.HasValue(player.GetAll(), ply) then
            table.RemoveByValue(huds, hud)
        end
    end

end

-- Draws the player hud
function DrawPlayerHud()
    local scrH = ScrH()

    if not playerHud then
        playerHud = HealthHUD(LocalPlayer())
    end

    playerHud:Draw(50, scrH - 150)
end

-- Draws the other players HUD
function DrawHealthBoards()
    updateHuds(LocalPlayer():GetPlayersNextToView())

    for ply, hud in pairs(huds) do
        local angles = Angle(0, LocalPlayer():EyeAngles().y - 90, - LocalPlayer():EyeAngles().x + 90 )
        local pos = ply:EyePos() + ply:GetUp() * 10 + LocalPlayer():GetRight() * 15

        local distance = LocalPlayer():GetPos():Distance(ply:GetPos())
        local scale = math.Clamp(distance / 1000, 0.3, 1)

        cam.Start3D2D(pos, angles, scale)
            cam.IgnoreZ(true)
            hud:Draw()
            cam.IgnoreZ(false)
        cam.End3D2D()
    end
end

-- Draw custom HUDs
hook.Add("HUDPaint", "PlayerHealthHUD", DrawPlayerHud)
hook.Add("PostDrawTranslucentRenderables", "OtherPlayersHealth", DrawHealthBoards)