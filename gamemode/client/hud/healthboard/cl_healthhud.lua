include("cl_utils.lua")
HealthHUD = {}
HealthHUD.__index = HealthHUD

-- Constants
-- Animation: Hide
local hideSpeed = 2
local showSpeed = 0.05

-- Animation: Damage
local slowSpeed = 1

-- Creates a new HUD
function HealthHUD:new(player)
    local newHUD = {
        -- Should show this HUD
        show = true,
        -- The player of this HUD
        ply = player,
        -- Animation variables
        -- Animation: Hide
        __hidePercentage = 0,

        -- Animation: Damage
        __damageAnimSpeed = 0,
        __damageAnimDeslocation = 0,
        __damageAnimPercentage = 0,
        __lastDamage = player:GetNWFloat("smod_damage"),
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
    -- Start hiding
    self.__hidePercentage = 
        not self.show and math.min(1, self.__hidePercentage + FrameTime() / hideSpeed) 
        or math.max(0, self.__hidePercentage - FrameTime() / showSpeed)

    -- Start slowing damage animation
    if(self.__damageAnimPercentage > 0) then
        self.__damageAnimPercentage = math.max(0, self.__damageAnimPercentage - FrameTime() / slowSpeed)
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

    -- Check if should animate damage
    if damage ~= self.__lastDamage then
        if(damage > self.__lastDamage) then
            local diffPerHundred = math.abs(damage - self.__lastDamage) / 100

            self.__damageAnimSpeed = math.max(50 * diffPerHundred, 10)
            self.__damageAnimPercentage = math.max(math.min(0.5 * diffPerHundred, 1), 0.5)
            self.__damageAnimDeslocation = math.max(math.min(30 * diffPerHundred, 50), 30)
        end

        -- Set the new last damage
        self.__lastDamage = damage
    end

    -- Draw hud
    -- Draw damage big text
    local bigDamageWidth, bigDamageHeight = DrawAnimatedText(
        self.__damageAnimSpeed, self.__damageAnimDeslocation * self.__damageAnimPercentage, 5, 
        string.format("%0.0f", damage),
        "HealthFont", 
        xOffset, yOffset, 
        Color(255, 255, 255, 255 * transparency), 
        TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 
        3, Color(0, 0, 0, 255 * transparency)
    )

    -- Draw damage small text
    local smallDamageWidth, _ = DrawAnimatedText(
        self.__damageAnimSpeed, self.__damageAnimDeslocation * self.__damageAnimPercentage, 5, 
        "." .. string.Right(string.format("%0.2f", damage%1), 2) .. "%",
        "HealthFontSmall",
        xOffset + bigDamageWidth, yOffset + bigDamageHeight, 
        Color(255, 255, 255, 255 * transparency), 
        TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 
        3, Color(0, 0, 0, 255 * transparency)
    )

    -- Draw background rect
    surface.SetDrawColor(0, 0, 0, 255 * 0.75 * transparency)
    surface.DrawRect(xOffset, yOffset + bigDamageHeight, bigDamageWidth + smallDamageWidth, draw.GetFontHeight("PlayerName"))

    -- Draw player name
    draw.SimpleText(name, "PlayerName", xOffset + (bigDamageWidth + smallDamageWidth) / 2, yOffset + bigDamageHeight, Color(255, 255, 255, 255 * transparency), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

    -- Check if is local player, if so, draw bar in green otherwise red
    if ply == LocalPlayer() then
        surface.SetDrawColor(0, 255, 0, 255 * transparency)
    else
        surface.SetDrawColor(255, 0, 0, 255 * transparency)
    end

    -- Draw upper bar
    surface.DrawRect(xOffset, yOffset + bigDamageHeight - 2.5, bigDamageWidth + smallDamageWidth, 5)
    -- Return final size

    return bigDamageWidth + smallDamageWidth, bigDamageHeight + draw.GetFontHeight("PlayerName") / 2
end

setmetatable(HealthHUD, {
    __call = HealthHUD.new
})