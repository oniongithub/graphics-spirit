local function angleToRadians(angle)
    return angle * (math.pi / 180);
end

function Color.RGBA(r, g, b, a)
    if (not a) then a = 255; end
    return Color.new(r / 255, g / 255, b / 255, a / 255);
end

local function drawCircle(x, y, r, color, segments, secondRadius, startAngle, angle, outline)
    local perAngle = 360 / segments;

    local lastPos, lastPos2;
    for i = 0, segments do
        if (i * perAngle <= angle) then
            local curPos, curPos2;
            local currentAngle = angleToRadians(i * perAngle + startAngle);

            if (not lastPos) then
                lastPos = Vector2.new(r * math.cos(currentAngle) + x, r * math.sin(currentAngle) + y);
                
                if (secondRadius) then
                    lastPos2 = Vector2.new(secondRadius * math.cos(currentAngle) + x, secondRadius * math.sin(currentAngle) + y);
                end
            else
                curPos = Vector2.new(r * math.cos(currentAngle) + x, r * math.sin(currentAngle) + y);
                
                if (secondRadius) then
                    curPos2 = Vector2.new(secondRadius * math.cos(currentAngle) + x, secondRadius * math.sin(currentAngle) + y);
                end

                if (outline and outline == true) then
                    Render.Line(curPos, lastPos, Color.new(color.r, color.g, color.b, 1))

                    if (angle < 360 and secondRadius and secondRadius > 0) then
                        if (i == 1) then
                            Render.Line(lastPos, lastPos2, Color.new(color.r, color.g, color.b, 1))
                        elseif ((i + 1) * perAngle > angle) then
                            Render.Line(curPos, curPos2, Color.new(color.r, color.g, color.b, 1))
                        end
                    end
                end

                if (secondRadius) then
                    Render.PolyFilled(color, lastPos, curPos, lastPos2)
                    Render.PolyFilled(color, curPos2, curPos, lastPos2)

                    if (outline and outline == true) then
                        Render.Line(curPos2, lastPos2, Color.new(color.r, color.g, color.b, 1))
                    end

                    lastPos2 = curPos2
                else
                    Render.PolyFilled(color, lastPos, curPos, Vector2.new(x, y))
                end

                lastPos = curPos;
            end
        end
    end
end
