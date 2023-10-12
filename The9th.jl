using HorizonSideRobots
r=Robot(animate=true)
flag=true

function numsteps_along!(r::Robot, side::HorizonSide, flag::Bool)::Tuple
    numst=0
    while !isborder(r, side)
        move!(r, side)
        flag=!flag
        numst+=1
    end
    return (numst, flag)
end

function move_w_s_corner!(r::Robot)::Tuple
    numsteps_nord=numsteps_along!(r, Sud, true)
    to_south=numsteps_nord[1]
    flagg=numsteps_nord[2]
    numsteps_west=numsteps_along!(r, West, flagg)
    to_west=numsteps_west[1]
    flagg2=numsteps_west[2]
    return (to_south, to_west, flagg2)
end

function alongg!(r::Robot, side::HorizonSide, q::Integer)::Nothing
    for i in 1:q
        move!(r, side)
    end
end

function inverse!(side::HorizonSide)::HorizonSide
    return HorizonSide(mod(Int(side)-2, 4))
end

function mark_line!(r::Robot, side::HorizonSide, f::Bool)::Bool
    while !isborder(r, side)
        if f
            putmarker!(r)
            move!(r, side)
            f=!f
        else
            move!(r, side)
            f=!f
        end
    end
    putmarker!(r)
    return f
end

function along!(r, side)
    while !isborder(r, side)
        move!(r, side)
    end
end

function p!(r)
    a=move_w_s_corner!(r)
    to_nord=a[1]
    to_east=a[2]
    flg=a[3]
    d=Ost
    while !isborder(r, Nord)
        flg=mark_line!(r, d, flg)
        move!(r, Nord)
        flg=!flg
        d=inverse!(d)
    end
    mark_line!(r, d, flg)
    along!(r, West)
    along!(r, Sud)
    alongg!(r, Ost, to_east)
    alongg!(r, Nord, to_nord)
end
