using HorizonSideRobots
r=Robot(animate=true)
function inverse!(side::HorizonSide)::HorizonSide
    return HorizonSide(mod(Int(side)-2, 4))
end
function clockwise_side!(side::HorizonSide)::HorizonSide
    return HorizonSide(mod(Int(side)+1,4))
end
function ag_clockwise_side!(side::HorizonSide)::HorizonSide
    return HorizonSide(mod(Int(side)+3,4))
end

function numsteps_along!(r::Robot, side::HorizonSide)::Integer
    numst=0
    while !isborder(r, side)
        move!(r, side)
        numst+=1
    end
    return numst
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

function mark_line!(r::Robot, side::HorizonSide)::Nothing
    while !isborder(r, side)
        move!(r, side)
        putmarker!(r)
    end
end

function perimeter!(r)::Nothing
    d=Ost
    for i in 1:4
        mark_line!(r, d)
        d=clockwise_side!(d)
    end
end

function sneak!(r, side)::Nothing
    while !isborder(r, side)
        (isborder(r, Ost)) ? break : move!(r,side)
    end
    if isborder(r, Ost)
        my_ans = "border"
    else
        move!(r, Ost)
        my_ans = inverse!(side)
    end
    return my_ans
end

function inner_perimeter!(r::Robot)::Nothing

    a=numsteps_along!(r, Sud)
    b=numsteps_along!(r, West)
    
    perimeter!(r)

    side = Nord
    
    while side != "border"
        side = sneak!(r, side)
    end

    for i in (Sud, Ost, Nord, West)
        while isborder(r, clockwise_side!(i) )
            putmarker!(r)
            move!(r, i)
        end
        putmarker!(r)
        move!(r, clockwise_side!(i) )
    end 
    along!(r, West)
    along!(r, Sud)
    alongg!(r, Nord, a)
    alongg!(r, Ost, b)
end
