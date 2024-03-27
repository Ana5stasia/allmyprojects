using HorizonSideRobots
r=Robot(animate=true)

"""движемся в заданном направлении, если есть возможность"""
function try_move!(r::Robot, side::HorizonSide)::Bool
    if !isborder(r, side)
        move!(r, side)
        return true
    end
    return false
end

"""движемся в заданном направлении, если есть возможность + рисунок"""
function try_move_m!(r::Robot, side::HorizonSide)::Bool
    if !isborder(r, side)
        move!(r, side)
        putmarker!(r)
        return true
    end
    return false
end

"""перемещает робота до упора в заданном направлении"""
function along!(r::Robot, side::HorizonSide)::Nothing 
    while try_move!(r, side)
    end 
end

"""перемещает робота до упора в заданном направлении + рисунок"""
function along_m!(r::Robot, side::HorizonSide)::Nothing 
    while try_move_m!(r, side)
    end 
end

"""перемещает робота до упора в заданном направлении и возвращает количество сделанных шагов"""
function numst_along!(r::Robot, side::HorizonSide)::Int
    n=0
    while try_move!(r, side)
        n+=1
    end
    return n
end

"""перемещает робота до упора в заданном направлении и возвращает количество сделанных шагов + рисунок"""
function numst_along_m!(r::Robot, side::HorizonSide)::Int
    n=0
    while try_move_m!(r, side)
        n+=1
    end
    return n
end

"""перемещает робота до упора в заданном направлении (диагональ) и возвращает количество сделанных шагов"""
function numst_along_dg!(r::Robot, side1::HorizonSide, side2::HorizonSide)::Int
    n=0
    while !isborder(r, side1) && !isborder(r, side2)
        move!(r, side1)
        move!(r, side2)
        n+=1
    end
    return n
end

"""перемещает робота до упора в заданном направлении (диагональ) и возвращает количество сделанных шагов + рисунок"""
function numst_along_dg_m!(r::Robot, side1::HorizonSide, side2::HorizonSide)::Int
    n=0
    while !isborder(r, side1) && !isborder(r, side2)
        move!(r, side1)
        move!(r, side2)
        putmarker!(r)
        n+=1
    end
    return n
end

"""перемещает робота в заданном направлении на заданное 
число шагов"""
function along_for!(r::Robot, side::HorizonSide, n::Int)::Nothing
    for _ in 1:n
        move!(r, side)
    end
end

"""перемещает робота в заданном направлении на заданное 
число шагов + рисунок"""
function along_for_m!(r::Robot, side::HorizonSide, n::Int)::Nothing
    for _ in 1:n
        move!(r, side)
        putmarker!(r)
    end
end

"""перемещает робота в заданном направлении (диагональ) на заданное 
число шагов"""
function along_for!(r::Robot, side1::HorizonSide, side2::HorizonSide, n::Int)::Nothing
    for _ in 1:n
        move!(r, side1)
        move!(r, side2)
    end
end

"""перемещает робота в заданном направлении (диагональ) на заданное 
число шагов + рисунок"""
function along_for_m!(r::Robot, side1::HorizonSide, side2::HorizonSide, n::Int)::Nothing
    for _ in 1:n
        move!(r, side1)
        move!(r, side2)
        putmarker!(r)
    end
end

"""движемся до перегородки, возвращаем фактическое количество сделанных до перегородки шагов"""
function along_till!(r::Robot, side::HorizonSide, n::Int)::Int
    numst=0
    while numst<=n && try_move!(r, side)
            numst+=1
    end
    return numst
end

"""противоположная сторона"""
function reverse(side::HorizonSide)::HorizonSide 
    return HorizonSide(mod(Int(side)-2,4)) 
end

"""по часовой стрелке"""
function clockwise!(side::HorizonSide)::HorizonSide
    return HorizonSide(mod(Int(side)+1,4)) 
end

"""против часовой стрелки"""
function counterclockwise!(side::HorizonSide)::HorizonSide  
    return HorizonSide(mod(Int(side)-1,4)) 
end

"""поиск стены с восточной стороны при движении север-юг змейкой"""
function sneak!(r, side)
    while !isborder(r, side)
        (isborder(r, Ost)) ? break : move!(r,side)
    end
    if isborder(r, Ost)
        my_ans = "border"
    else
        move!(r, Ost)
        my_ans = reverse(side)
    end
    return my_ans
end

"""движение, которое оставналивает маркер на поле"""
function special_move!(r::Robot,side::HorizonSide,num::Int)::Nothing
    for _ in 1:num
        if ismarker(r)
            return nothing
        end
        move!(r,side)
    end
end
