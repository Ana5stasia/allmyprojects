using HorizonSideRobots

function along_d!(r::Robot, side1::HorizonSide, side2::HorizonSide)::Nothing
    while !isborder(r, side1) && !isborder(r, side2)
        move!(r, side1)
        move!(r, side2)
    end
end

function numsteps_along_d!(r::Robot, side1::HorizonSide, side2::HorizonSide)::Integer
    numst=0
    while !isborder(r, side1) && !isborder(r, side2)
        move!(r, side1)
        move!(r, side2)
        numst+=1
    end
    return numst
end

function alongg_d!(r::Robot, side1::HorizonSide, side2::HorizonSide, q::Integer)::Nothing
    for i in 1:q
        move!(r, side1)
        move!(r, side2)
    end
end

function inverse!(side::HorizonSide)::HorizonSide
    return HorizonSide(mod(Int(side)+2, 4))
end

function numsteps_mark_along_d!(r::Robot, side1::HorizonSide, side2::HorizonSide)::Int
    num_steps = 0
    while !isborder(r, side1) && !isborder(r, side2)
        move!(r, side1)
        move!(r, side2)
        putmarker!(r)
        num_steps += 1
    end
    return num_steps
end


r=Robot(animate=true)
function mark_kross_2!(r::Robot)::Nothing
    for side1 in (Nord, Sud)
        for side2 in (West, Ost)
            num_steps = numsteps_mark_along_d!(r, side1, side2) 
            alongg_d!(r, inverse!(side1), inverse!(side2), num_steps) 
        end
    end
    putmarker!(r) 
end
mark_kross_2!(r)
