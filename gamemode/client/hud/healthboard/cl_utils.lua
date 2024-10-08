ANIMATION_SPIN = 0

function lerpColor(color1, color2, amount)
    return Color(
        color1.r + (color2.r - color1.r) * amount,
        color1.g + (color2.g - color1.g) * amount,
        color1.b + (color2.b - color1.b) * amount,
        color1.a + (color2.a - color1.a) * amount
    )
end

function DrawAnimatedText(animationSpeed, animationDeslocation, animationDelay, text, font, x, y, color, xAlign, yAlign, outlinedWidth, outlinedColor)
    -- Default variables
    local text = tostring(text)
    local animationSpeed = tonumber(string.format("%0.2f", animationSpeed))
    local color = color or Color(255, 255, 255, 255)
    local yAlign = yAlign or TEXT_ALIGN_TOP
    local xAlign = xAlign or TEXT_ALIGN_LEFT
    local outlinedWidth = outlinedWidth or -1
    local outlinedColor = outlinedColor or Color(0, 0, 0, 255)
    -- Final variables
    local totalWidth = 0
    local totalHeight = 0
    local lastHeight = 0

    -- Render each letter
    for i = 1, #text do
        -- Render variables
        local char = text:sub(i, i)
        -- Size variables
        local width, height = 0, 0
        -- Animation variables
        local timeSpeed = (CurTime() + animationDelay * (i - 1)) * animationSpeed
        local xOffset = math.cos(timeSpeed) * animationDeslocation
        local yOffset = math.sin(timeSpeed) * animationDeslocation

        if outlinedWidth > 0 then
            width, height = draw.SimpleTextOutlined(char, font, x + totalWidth + xOffset, y + yOffset, color, xAlign, yAlign, outlinedWidth, outlinedColor)
        else
            width, height = draw.SimpleText(char, font, x + totalWidth + xOffset, y + yOffset, color, xAlign, yAlign)
        end

        totalWidth = totalWidth + width
        totalHeight = math.max(totalHeight, height)
    end

    return totalWidth, totalHeight
end