using HorizonSideRobots
r=Robot(animate=true)

fuction alongg!(r::Robot,side::HorizonSide,q::Integer)::Nothing
    for i in 1:q
    move!(r,side)
    
end
function find_hole(r::Robot)::Nothing
    side = Ost 
    n=0
    while isborder(r,Nord)
        n+=1
        alongg!(r,side,n)
        side=inverse!(side)
    end 
    move!(r,Nord)
    alongg!(r,side,n)
end
