using HorizonSideRobots
r=Robot(animate=true)
HSR = HorizonSideRobots

struct Kross_robot
    r :: Robot
end

function clockwise!(side::HorizonSide)::HorizonSide
    return HorizonSide(mod(Int(side)+1,4)) 
end

HSR.move!(robot::Kross_robot, side) = move!(robot.r, side) &&  move!(robot.r, clockwise(side))
HSR.isborder(robot::Kross_robot, side) = isborder(robot.r, side) && isborder(robot.r, clockwise(side))
HSR.putmarker!(robot::Kross_robot) = putmarker!(robot.r)

function numst_along_dg_m!(r, side1::HorizonSide)::Int
    n=0
    while !isborder(r, side1)
        move!(r, side1)
        putmarker!(r)
        n+=1
    end
    return n
end
