include("mireaalgoslib.jl")

using HorizonSideRobots
r=Robot(animate=true)

"""крест"""
function kross!(r)
    for i in (Nord, Ost, Sud, West)
        a=numst_along_m!(r, i)
        along_for_m!(r, reverse(i), a)
    end
end

"""периметр"""
function perimeter!(r)
    a=numst_along!(r, Sud)
    b=numst_along!(r, West)
    for i in (Nord, Ost, Sud, West)
        along_m!(r, i)
    end
    along_for!(r, Nord, a)
    along_for!(r, Ost, b)
end

"""все поле закрашено"""
function full!(r)
    a=numst_along!(r, Sud)
    b=numst_along!(r, West)
    s=West
    while !isborder(r, Nord)
        putmarker!(r)
        s=reverse(s)
        along_m!(r, s)
        move!(r, Nord)
    end
    putmarker!(r)
    along_m!(r, reverse(s))
    along!(r, West)
    along!(r, Sud)
    along_for!(r, Nord, a)
    along_for!(r, Ost, b)
end

"""косой крест"""
function k_kross!(r)
    for i in ((Nord, Ost), (Nord, West), (Sud, West), (Sud, Ost))
        s1, s2 = i[1], i[2]
        a=numst_along_dg_m!(r, s1, s2)
        along_for_m!(r, reverse(s1), reverse(s2), a)
    end
end

"""двойной периметр"""
function double_perimeter!(r)
    a=numst_along!(r, Sud)
    b=numst_along!(r, West)
    a1=numst_along!(r, Sud)
    for i in (Nord, Ost, Sud, West)
        along_m!(r, i)
    end
    side=Nord
        while side!="border"
        side = sneak!(r, side)
    end
    for i in (Nord, Ost, Sud, West)
        a=i
        while isborder(r, counterclockwise!(a) )
            putmarker!(r)
            move!(r, i)
        end
        putmarker!(r)
        move!(r, counterclockwise!(a) )
    end
    along_for!(r, Nord, a1)
    along_for!(r, Ost, b)
    along_for!(r, Nord, a)
end

"""поиск прохода"""
function find_hole!(r::Robot)::Nothing
    side = Ost 
    n=0
    while isborder(r,Nord)
        n+=1
        along_for!(r,side,n)
        side=reverse(side)
    end 
end

"""поиск маркера на поле"""
function spiral!(r::Robot)::Nothing
    steps = 1
    side = Nord
    while ismarker(r)==false
        for _ in 1:2
            special_move!(r,side,steps)
            side=counterclockwise!(side)
        end
        steps += 1
    end
end

"""шахматное поле"""
function chess_field!(r)
    flaf=true
    """смена true/false"""
    function numsteps_along!(r::Robot, side::HorizonSide, flag::Bool)::Tuple
        numst=0
        while !isborder(r, side)
            move!(r, side)
            flag=!flag
            numst+=1
        end
        return (numst, flag)
    end
    
    """проверяем, чем является юго-западная клетка - true/false"""
    function move_w_s_corner!(r::Robot)::Tuple
        numsteps_nord=numsteps_along!(r, Sud, true)
        to_south=numsteps_nord[1]
        flagg=numsteps_nord[2]
        numsteps_west=numsteps_along!(r, West, flagg)
        to_west=numsteps_west[1]
        flagg2=numsteps_west[2]
        return (to_south, to_west, flagg2)
    end
    """шахматная раскраска поля солгасно true/false"""
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
    """процесс закрашивания"""
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
            d=reverse(d)
        end
        mark_line!(r, d, flg)
        along!(r, West)
        along!(r, Sud)
        along_for!(r, Ost, to_east)
        along_for!(r, Nord, to_nord)
    end
    p!(r)
end

"""счет горизонтальных перегородок"""
function count_horiz_borders!(r)

    """проверка, закончилась ли перегородка или нет + подсчет перегородок"""
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

    """процесс подсчета горизонтальных перегородок"""
    function count!(r::Robot)::Int
        numsteps_west=numst_along!(r, West)
        numsteps_sud=numst_along!(r, Sud)
        my_ans = 0
        border_now = false
        side = Ost
        while !isborder(r, Nord)
            while !isborder(r, side)
                my_ans, border_now = find_special!(r, my_ans, border_now, Nord)
                move!(r,side)
            end
            my_ans, border_now = find_special!(r, my_ans, border_now, Nord)
    
            side = reverse(side)
            move!(r, Nord)
        end
        along_for!(r, Nord, numsteps_sud)
        along_for!(r, Ost, numsteps_west)
        
        return my_ans
    end
    count!(r)
end

"""счет горизонтальных перегородок с разрывом больше 2 клеток"""
function count_horiz_simple_borders!(r::Robot)::INt
    function num_borders!(r, side)
        state = 0 
        num_borders = 0
    
        while try_move!(r, side)
            if state == 0
                if isborder(r, Nord)
                    state = 1
                end
            elseif state == 1
                if !isborder(r, Nord)
                    state = 2
                end
            else 
                if !isborder(r, Nord)
                    state = 0
                    num_borders += 1
                end
            end
        end
        return num_borders
    end
    total = 0
    while !isborder(r, Nord)
        num_borders!(r, Ost)
        while !isborder(r, West)
            move!(r, West)
        end
        move!(r, Nord)
        total += num_borders
    end
    return total
end

"""рекурсия до упора + маркер"""
function marklim!(r::Robot,side::HorizonSide)::Nothing
    if isborder(r,side)
        putmarker!(r)
    else
        move!(r,side)
        marklim!(r,side)
        move!(r,side)
    end 
end 

"""удаление на дистанцию вдвое больше"""
function req_halfdist(r::Robot, side::HorizonSide)
    r=r
    side=side
    function halfdist!(r, side)
        if !isborder(r, side)
            move!(r, side)
            no_delayed_action!(r, side)
            move!(r, reverse(side))
            move!(r, reverse(side))
            move!(r, reverse(side))
        end
    end
    
    function no_delayed_action!(r,side)
        if !isborder(r, side)
            move!(r, side)
            halfdist!(r, side)
        end
    end
end

"""Симметрия относительно перегородки"""
function simmetric_position(r::Robot, side::HorizonSide)::Nothing
    r=r
    side=side
    function to_simmetric_position(r, side)
        if isborder(r, side)
            tolim!(r, reverse(side))
        else
            move!(r,side)
            to_simmetric_position(r, side)
            move!(r,side)
        end
    end

    function tolim!(r, side)
        if !isborder(r, side)
            move!(r,side)
            tolim!(r, side)
        end
    end
end

"""удаление на дистанцию вдвое меньше"""
function req_halfdist_r(r::Robot, side::HorizonSide)::Nothing
    r=r
    side=side
    function halfdist!(r, side)
        if !isborder(r, side)
            move!(r, side)
            no_delayed_action!(r, side)
            move!(r, reverse(side))
        end
    end
    
    function no_delayed_action!(r,side)
        if !isborder(r, side)
            move!(r, side)
            halfdist!(r, side)
        end
    end
end

"""рекурсия шахматного поля с установки маркера"""
function req_chess1(r::Robot, side::HorizonSide)::Nothing
    r=r
    side=side
    function chess!(r, side)
        if !isborder(r, side)
            move!(r, side)
            putmarker!(r)
            chess2!(r, side)
        end
    end
    
    function chess2!(r, side)
        if !isborder(r, side)
            move!(r, side)
            chess!(r, side)
        end
    end
end

"""рекурсия шахматного поля без установки маркера"""
function req_chess2(r::Robot, side::HorizonSide)::Nothing
    r=r
    side=side
    function chess!(r, side)
        if !isborder(r, side)
            putmarker!(r)
            move!(r, side)
            chess2!(r, side)
        end
        putmarker!(r)
    end
    
    function chess2!(r, side)
        if !isborder(r, side)
            move!(r, side)
            chess!(r, side)
        end
    end
end
