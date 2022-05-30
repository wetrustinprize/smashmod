HealthHUD = {}
HealthHUD.__index = HealthHUD

-- Creates a new HUD
function HealthHUD:new(player)
    local newHUD = {
        -- Should show this HUD
        show = true,
        -- The player of this HUD
        ply = player,
        -- Animation variables
        __hidePercentage = 0,
    }

    setmetatable(newHUD, HealthHUD)

    return newHUD
end

function HealthHUD:Show()
    self.show = true
end

function HealthHUD:Hide()
    self.show = false
end

function HealthHUD:Draw(xOffset, yOffset)
    -- Get the variables
    local hideSpeed = 0.5
    local showSpeed = 15

    -- Start hiding
    if not self.show then
        self.__hidePercentage = math.min(1, self.__hidePercentage + hideSpeed * FrameTime())
    else
        self.__hidePercentage = math.max(0, self.__hidePercentage - showSpeed * FrameTime())
    end

    -- Check if should show
    if self.__hidePercentage == 1 then return 0, 0 end
    -- Variables to render
    local ply = self.ply
    if not ply then return 0, 0 end
    local transparency = 1 - self.__hidePercentage
    local name = #ply:Name() > 7 and ply:Name():sub(1, 7) .. "..." or ply:Name()
    local damage = ply:GetNWFloat("smod_damage")
    local xOffset = xOffset or 0
    local yOffset = yOffset or 0
    -- Draw hud
    -- Draw damage
    local bigDamageWidth, bigDamageHeight = draw.SimpleTextOutlined(damage, "HealthFont", xOffset, yOffset, Color(255, 255, 255, 255 * transparency), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 3, Color(0, 0, 0, 255 * transparency))
    local smallDamageWidth, _ = draw.SimpleTextOutlined(".00%", "HealthFontSmall", xOffset + bigDamageWidth, yOffset + bigDamageHeight, Color(255, 255, 255, 255 * transparency), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 3, Color(0, 0, 0, 255 * transparency))
    -- Draw Name
    surface.SetDrawColor(0, 0, 0, 255 * 0.75 * transparency)
    surface.DrawRect(xOffset, yOffset + bigDamageHeight, bigDamageWidth + smallDamageWidth, draw.GetFontHeight("PlayerName"))
    draw.SimpleText(name, "PlayerName", xOffset + (bigDamageWidth + smallDamageWidth) / 2, yOffset + bigDamageHeight, Color(255, 255, 255, 255 * transparency), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

    -- Check if is local player, if so, draw bar in green otherwise red
    if ply == LocalPlayer() then
        surface.SetDrawColor(0, 255, 0, 255 * transparency)
    else
        surface.SetDrawColor(255, 0, 0, 255 * transparency)
    end

    surface.DrawRect(xOffset, yOffset + bigDamageHeight - 2.5, bigDamageWidth + smallDamageWidth, 5)

    return bigDamageWidth + smallDamageWidth, bigDamageHeight + draw.GetFontHeight("PlayerName") / 2
end

setmetatable(HealthHUD, {
    __call = HealthHUD.new
})