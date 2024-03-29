using HorizonSideRobots
HSR = HorizonSideRobots
 
mutable struct Coordinates
    x :: Int
    y :: Int
end
 
function HSR.move!(r :: Coordinates, side)
    if side == Nord 
        r.x += 1
    elseif side == reverse(Nord)
        r.x -= 1
    elseif side == West
        r.y -= 1
    else
        r.y += 1
    end
end

# робот запоминает свои координаты
struct WalkingRobot
    robot :: Robot
    coordinates :: Coordinates
end
#объявление функция для wr
function HSR.isborder(r :: WalkingRobot, side)
    isborder(r.robot, side)
end

function HSR.move!(r :: WalkingRobot, side)
    move!(r.robot, side)
    move!(r.coordinates, side)
end

#функции изменения направления
clockwise(side :: HorizonSide) = HorizonSide(mod(Int(side) + 1, 4)) #против часовой
counterclockwise(side :: HorizonSide) = HorizonSide(mod(Int(side) + 3, 4)) #по часовой
reverse(side::HorizonSide)=HorizonSide(mod(Int(side)-2,4)) #на 180

# Обход покругу лабиринта, находящийся со стороны side от robot. 
function go_around_labirint(tick, robot :: Robot, side :: HorizonSide)
    ItMoved = false
    robot = WalkingRobot(robot, Coordinates(0, 0))
    moveSide = clockwise(side)
    while !ItMoved || (robot.coordinates.x!=0 || robot.coordinates.y!=0)
        while isborder(robot, moveSide)
            moveSide = clockwise(moveSide)
            tick(robot, counterclockwise(moveSide))    
        end
        move!(robot, moveSide)
        while !isborder(robot, counterclockwise(moveSide))
            moveSide = counterclockwise(moveSide)
            move!(robot, moveSide)
        end
        tick(robot, counterclockwise(moveSide))    
        ItMoved = true
    end
end

# подсчет площади лабиринта, стена которого находится со стороны side. 
function sum_around_labirint(r, side)
    sum = 0
    go_around_labirint(r, side) do robot, leadingSide 
        if leadingSide == West && isborder(robot, West)
            sum += robot.coordinates.y - 1
        elseif leadingSide == reverse(West) && isborder(robot, reverse(West))
            sum -= robot.coordinates.y
        end
    end
    return sum
end

# проверка того, является ли робот снаружи лабиринта, стена которого находится со стороны side. 
function is_outside_labirint(robot, side)
    max_leading_side = ()
    max_x_coordinate = 0

    go_around_labirint(robot, side) do robot, leadingSide
        if robot.coordinates.x > max_x_coordinate 
            max_x_coordinate = robot.coordinates.x
            max_leading_side = leadingSide
        elseif robot.coordinates.x == max_x_coordinate 
            if leadingSide == Nord 
                max_leading_side = Nord
            end
        end
    end
    return max_leading_side != Nord
end
