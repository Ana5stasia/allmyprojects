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

function along!(r::Robot, side::HorizonSide)::Nothing
    while !isborder(r, side)
        move!(r, side)
    end
end

function alongg!(r::Robot, side::HorizonSide, q::Integer)::Nothing
    for i in 1:q
        move!(r, side)
    end
end

function inverse!(side::HorizonSide)::HorizonSide
    return HorizonSide(mod(Int(side)-2, 4))
end
#side1 - Nord, Sud
#side2 - OSt, West
function draw_map!(r, side1, side2)
    numsteps_1=numsteps_along!(r, side1)
    numsteps_2=numsteps_along!(r, side2)
    d1=inverse!(side1)
    d2=inverse!(side2)
    while !isborder(r, d1)
        putmarker!(r)
        mark_line!(r, d2)
        move!(r, d1)
        d2=inverse!(d2)
    end
    putmarker!(r)
    mark_line!(r, d2)
    along!(r, side2)
    along!(r, side1)
    alongg!(r, d1, numsteps_1)
    alongg!(r, d2, numsteps_2)
end
draw_map!(r, Nord, West)
draw_map!(r, Sud, West)
draw_map!(r, Sud, Ost)
