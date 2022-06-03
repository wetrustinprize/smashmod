include("cl_fonts.lua")

include("healthboard/cl_init.lua")
include("crosshair/cl_init.lua")

local hide = {
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
    ["CHudCrosshair"] = true,
}

-- Hide default Garry's Mod hud
hook.Add("HUDShouldDraw", "HideHUD", function(name)
    if hide[name] then return false end
end)

hook.Add("HUDDrawTargetID", "HideTargetID", function() return false end)