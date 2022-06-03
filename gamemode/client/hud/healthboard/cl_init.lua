include("cl_healthhud.lua")
include("cl_minimalhealthhud.lua")

-- Variables
local huds = {}
local minimalHuds = {
    [LocalPlayer()] = MinimalHealthHUD(LocalPlayer())
}
local playerHud = HealthHUD(LocalPlayer())

local function updateMinimalHuds()
    -- Check if should create a new HUD
    for _, ply in pairs(player.GetAll()) do
        if not minimalHuds[ply] then
            minimalHuds[ply] = MinimalHealthHUD(ply)
        end
    end

    -- Check if should remove a HUD
    for ply, hud in pairs(minimalHuds) do
        if not IsValid(ply) then
            table.RemoveByValue(minimalHuds, hud)
        end
    end
end

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
    end
end

-- Draws the player hud
function DrawPlayerHud()
    local scrH = ScrH()

    playerHud:Draw(50, scrH - 150)
end

-- Draws the minimal huds
function DrawMinimalHuds()
    updateMinimalHuds()
    local scrW = ScrW()

    local huds = {}
    for _, hud in pairs(minimalHuds) do
        table.insert(huds, hud)
    end
    table.sort(huds, function(left, right)
        return left.ply:Frags() > right.ply:Frags()
    end)

    local totalH = 0

    for index, hud in pairs(huds) do
        local _, h = hud:Draw(
            0,
            0 + totalH + 10 + 5 * (index - 1)
        )

        totalH = totalH + h
    end
end

-- Draws the other players HUD
function DrawHealthBoards()
    updateHuds(LocalPlayer():GetPlayersNextToView())

    for ply, hud in pairs(huds) do
        local angles = Angle(0, LocalPlayer():EyeAngles().y - 90, - LocalPlayer():EyeAngles().x + 90 )
        local pos = ply:EyePos() + ply:GetUp() * 10 + LocalPlayer():GetRight() * 15
        cam.Start3D2D(pos, angles, 0.3)
            hud:Draw()
        cam.End3D2D()
    end
end

-- Get if scoreboard is open or closed
hook.Add("ScoreboardShow", "MinimalHUDShow", function()
    for _, hud in pairs(minimalHuds) do
        hud:Show()
    end

    return false
end)
hook.Add("ScoreboardHide", "MinimalHUDHide", function()
    for _, hud in pairs(minimalHuds) do
        hud:Hide()
    end

    return false
end)

-- Draw custom HUDs
hook.Add("HUDPaint", "MinimalHuds", DrawMinimalHuds)
hook.Add("HUDPaint", "PlayerHealthHUD", DrawPlayerHud)
hook.Add("PostPlayerDraw", "OtherPlayersHealth", DrawHealthBoards)