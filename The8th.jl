using HorizonSideRobots
r=Robot(animate=true)

function ag_clockwise_side(side::HorizonSide)::HorizonSide
    return HorizonSide(mod(Int(side)+1,4))
end

function spiral(r::Robot)::Nothing
    steps = 1
    side = Nord
    while ismarker(r)==false
        for _ in 1:2
            special_move!(r,side,steps)
            side=ag_clockwise_side(side)
        end
        steps += 1
    end
end
function special_move!(r::Robot,side::HorizonSide,num::Int)::Nothing
    for _ in 1:num
        if ismarker(r)
            return nothing
        end
        move!(r,side)
    end
end
spiral(r)
