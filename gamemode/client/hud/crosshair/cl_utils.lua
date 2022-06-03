function DrawCircleWithSquares(x, y, squares, hideTotal, radius, size, color)
    local radius = radius or 12
    local size = size or 4
    local color = color or Color(255,255,255,255)

    local piPerSquare = (2 * math.pi) / squares;

    for i = 1, squares do
        local circleX = math.cos(i * piPerSquare) * radius;
        local circleY = math.sin(i * piPerSquare) * radius;

        if(i < hideTotal) then
            continue
        end

        surface.SetDrawColor(color)
        surface.DrawRect(
            x + circleX - (size / 2),
            y + circleY - (size / 2),
            size, 
            size
        );
    end    
end