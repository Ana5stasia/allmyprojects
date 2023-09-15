using HorizonSideRobots
r=Robot(animate=true)
function numsteps_along!(r::Robot, side::HorizonSide)::Integer
    numst=0
    while !isborder(r, side)
        move!(r, side)
        numst+=1
    end
    return numst
end

function mark_line!(r::Robot, side::HorizonSide)::Nothing
    while !isborder(r, side)
        move!(r, side)
        putmarker!(r)
    end
end

function alongg!(r::Robot, side::HorizonSide, q::Integer)::Nothing
    for i in 1:q
        move!(r, side)
    end
end

function inverse(side::HorizonSide)::HorizonSide
    return HorizonSide(mod(Int(side)-1, 4))
end

function draw_map!(r, )
end