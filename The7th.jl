using HorizonSideRobots
r=Robot(animate=true)
while isborder(r, Nord)
    move!(r, West)
    if !isborder(r, Nord)
        break
    end
end
