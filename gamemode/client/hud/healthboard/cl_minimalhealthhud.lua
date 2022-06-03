MinimalHealthHUD = {}
MinimalHealthHUD.__index = MinimalHealthHUD

-- Constants
-- Animation: Hide
local hideSpeed = 0.1
local showSpeed = 0.025

function MinimalHealthHUD:new(player)

    local newHUD = {
        -- The player of this HUD
        ply = player,
        -- Should hide other information
        hide = true,

        -- Animation variables
        -- Animation: Hide
        __hidePercentage = 0
    }

    setmetatable(newHUD, MinimalHealthHUD)

    return newHUD
end

function MinimalHealthHUD:Hide()
    self.hide = true
end

function MinimalHealthHUD:Show()
    self.hide = false
end

function MinimalHealthHUD:Draw(xOffset, yOffset)

    local ply = self.ply
    local name = #ply:Name() > 7 and ply:Name():sub(1, 7) .. "..." or ply:Name()
    local damage = ply:GetNWFloat("smod_damage")
    local kills = ply:Frags()

    -- Start hiding
    self.__hidePercentage = 
        self.hide and math.min(1, self.__hidePercentage + FrameTime() / hideSpeed) 
        or math.max(0, self.__hidePercentage - FrameTime() / showSpeed)

    -- Set font
    surface.SetFont("MinimalPlayerName")

    -- Get sizes
    local totalHeight = 
        draw.GetFontHeight("PlayerName")

    local totalWidth = 
        5 
        + surface.GetTextSize(name)
        + surface.GetTextSize(math.Round(damage) .. "%") + 10
        + surface.GetTextSize(kills .. " kills")

    local xOffset = xOffset - totalWidth * self.__hidePercentage

    -- Draw background box
    surface.SetDrawColor(0, 0, 0, 255 * 0.75)
    surface.DrawRect(
        xOffset, yOffset, 
        totalWidth,
        totalHeight
    )
    
    -- Draw name
    local nameW, nameH = draw.SimpleText(
        name, 
        "MinimalPlayerName",
        xOffset + 5, 
        yOffset, 
        Color(255,255,255)
    )

    -- Draw damage
    local damageW, _ =draw.SimpleText(
        math.Round(damage) .. "%", 
        "MinimalPlayerDamage",
        xOffset + nameW + 10, 
        yOffset + nameH, 
        Color(255,255,255),
        TEXT_ALIGN_LEFT,
        TEXT_ALIGN_BOTTOM
    )

    -- Draw kill count
    draw.SimpleText(
        kills .. " kills",
        "MinimalPlayerKills",
        xOffset + nameW + 10 + damageW + 10,
        yOffset + nameH,
        Color(255,255,255),
        TEXT_ALIGN_LEFT,
        TEXT_ALIGN_BOTTOM
    )

    -- Draw color bar
    surface.SetDrawColor(ply == LocalPlayer() and Color(0, 255, 0) or Color(255, 0, 0))
    surface.DrawRect(
        xOffset + totalWidth,
        yOffset,
        5,
        totalHeight
    )


    -- Return the total sizes
    return totalWidth, totalHeight
end

setmetatable(MinimalHealthHUD, {
  __call = MinimalHealthHUD.new
})