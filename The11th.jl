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

function alongg!(r::Robot, side::HorizonSide, q::Integer)::Nothing
    for i in 1:q
        move!(r, side)
    end
end

function count!(r::Robot)::Int
    numsteps_west=numsteps_along!(r, West)
    numsteps_sud=numsteps_along!(r, Sud)
    my_ans = 0
    border_now = false
    side = Ost
    while !isborder(r, Nord)
        
        while !isborder(r, side)
            my_ans, border_now = find_special!(r, my_ans, border_now, Nord)
            move!(r,side)
        end
        my_ans, border_now = find_special!(r, my_ans, border_now, Nord)

        side = inverse!(side)
        move!(r, Nord)
    end
    alongg!(r, Nord, numsteps_sud)
    alongg!(r, Ost, numsteps_west)
    
    return my_ans
end

function inverse!(side::HorizonSide)::HorizonSide
    return HorizonSide(mod(Int(side)-2, 4))
end

function find_special!(r::Robot, my_ans::Int, border_now::Bool, side::HorizonSide)
    if isborder(r, side)
        border_now = true
    end
    if !isborder(r, side) && border_now
        border_now = false
        my_ans += 1
    end
    return my_ans, border_now
end
count!(r)
