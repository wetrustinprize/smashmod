include("cl_healthhud.lua")
-- Variables
local huds = {}
local playerHud = HealthHUD(LocalPlayer())
local marginW, marginH = 10, 10

local function updateHuds(players)
    -- Check if should create a new HUD
    for _, ply in pairs(players) do
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
    end
end

-- Draws the Health Board HUD
function DrawHealthBoard()
    updateHuds(LocalPlayer():GetPlayersNextToView())
    local scrH = ScrH()
    playerHud:Draw(marginW, scrH / 2 - marginH)
end

-- Draws the other players HUD
function DrawOtherPlayersHealth()
    for ply, hud in pairs(huds) do
        local angles = Angle(0, LocalPlayer():EyeAngles().y - 90, 90)
        local pos = ply:EyePos() + ply:GetUp() * 10 + LocalPlayer():GetRight() * 15
        cam.Start3D2D(pos, angles, 0.3)
        hud:Draw()
        cam.End3D2D()
    end
end

-- Draw custom HUDs
hook.Add("HUDPaint", "HealthBoardHUD", DrawHealthBoard)
hook.Add("PostPlayerDraw", "OtherPlayersHealth", DrawOtherPlayersHealth)