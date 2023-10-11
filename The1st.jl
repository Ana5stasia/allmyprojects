using HorizonSideRobots
function along!(r::Robot, side::HorizonSide)::Nothing
    while !isborder(r, side)
        move!(r, side)
    end
end
function numsteps_along!(r::Robot, side::HorizonSide)::Integer
    numst=0
    while !isborder(r, side)
        move!(r, side)
        numst+=1
    end
    return numst
end
function alongg!(r::Robot, side::HorizonSide, q::Integer)::Nothing
    for i in 1:q
        move!(r, side)
    end
end
function inverse!(side::HorizonSide)::HorizonSide
    return HorizonSide(mod(Int(side)+2, 4))
end
function numsteps_mark_along!(r::Robot, side::HorizonSide)::Int
    num_steps = 0
    while !isborder(r, side)
        move!(r, side)
        putmarker!(r)
        num_steps += 1
    end
    return num_steps
end
#Exersize1
r=Robot(animate=true)
function mark_kross!(r::Robot)::Nothing
    for side in (Nord, West, Sud, Ost)
        num_steps = numsteps_mark_along!(r, side) 
        alongg!(r, inverse!(side), num_steps) 
    end
    putmarker!(r) 
end
mark_kross!(r)
