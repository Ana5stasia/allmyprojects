function valdiff(f::Function, x::T) where T
    y=f(Dual{T}(x, 1))
    return y.a, y.b
end

function valdiff(p::Polynomial{T}, x, ::Type{Dual}) where T
    t=0
    for i=1:length(p.c)
        f(z)=z^(length(p.c)-i)
        t+=p.c[i]*valdiff(f, x)[2]
    end
    return t
end



function newton(r::Function, x; epsilon = 1e-8, num_max = 10) #1 задача
    dx = r(x)
    x += dx 
    k=1
    while abs(dx) > epsilon && k < num_max
        dx = r(x) 
        x += dx
        k += 1
    end
    abs(dx) > epsilon && @warn("Требуемая точность не достигнута")
    return x
end

function Base.abs(x::Vector{T}) where T 
    return norm(x)
end

#2 задача
#аналитически
u(x)=(cos(x)-x)/(sin(x)+1)
newton(u, 0.5)
#дуальные
p(x)=(cos(x)-x)
s(x)=-p(x)/(valdiff(p, x)[2])
newton(s, 0.5)
#h
t(x)=-p(x)/((p(x+1e-8)-p(x))/(1e-8))
newton(t, 0.5)

#3 задача
function root(p::Polynomial{T}, start_value::T, tool) where T
    v(x)=-(p(x)/((valdiff(p, x, Dual)[1])))
    newton(v, start_value, tool)
end

#4 задача
function Iakobi(t::Float64, y::Float64)
    x=[t, y]
    f(x)=-inv([2*x[1] 2x[2]; 3*(x[1])^2*x[2] (x[1])^3])*[(x[1])^2+(x[2])^2-2.5; (x[1])^3*x[2]-1]
    newton(f, x)
end

f1(x)=x[1]^2+x[2]^2-2.5
f2(x) = x[1]^3*x[2]-1.0

diff(f::Function, x) = valdiff(f,x)[2]
x_0=[1.0, 1.0]

newton(x_0) do x
    f1x₁(x)=diff(x₁->f1([x₁, x[2]]), x[1])
    f1x₂(x)=diff(x₂->f1([x[1], x₂]), x[2])
    f2x₁(x)=diff(x₁->f2([x₁, x[2]]), x[1])
    f2x₂(x)=diff(x₂->f2([x[1], x₂]), x[2])
    -inv([diff(x₁->f1([x₁, x[2]]), x[1]) diff(x₂->f1([x[1], x₂]), x[2]); diff(x₁->f2([x₁, x[2]]), x[1]) diff(x₂->f2([x[1], x₂]), x[2])])*[x[1]^2+x[2]^2-2; x[1]^3*x[2]-1]
end



#5 задача
function logar(x::T, a::T; ε=1e-8) where T 
    if a<1
        a=1/a
        return -log(x, a)
    end
    return log(x, a)
end

function log(x::T, a::T; ε=1e-8) where T
    z=x; t=1.0; y=0.0
#ИНВАРИАНТ: x = z^t * a^y
    while z < 1/a || z > a || t > ε
        if z < 1/a
            z *= a # это перобразование направлено на достижения условия окончания цикла
            y -= t # тогда необходимрсть этого преобразования следует из инварианта цикла
        elseif z > a
            z /= a # это перобразование направлено на достижения условия окончания цикла
            y += t # тогда необходимрсть этого преобразования следует из инварианта цикла
        elseif t > ε
            t /= 2 # это перобразование направлено на достижения условия окончания цикла
            z *= z # тогда необходимрсть этого преобразования следует из инварианта цикла
        end
    end
    return y
end


function cosinus(n::Integer, x) #6 задача
    cosinus=0.0
    a=1.0
    xx=x*x
    for k in 1:n+1
        cosinus+=a
        a=(-1)*a*xx/((2k)*(2k-1))
    end
    return cosinus
end

function cosinus(x) #7 задача
    cosinus=1.0
    a=-x^2/2
    xx=x*x
    k=1
    while cosinus+a != cosinus
        cosinus+=a
        a=-a*xx/((2k+2)*(2k+1))
        k+=1
    end
    return cosinus
end

function exponenta(x::T) where T#8 задача
    e=zero(T)
    a=one(T)
    k=1
    while e+a != e
        e+=a
        a=x*a/k
        k+=1
    end
    return e
end

function J(x, a) #9 задача
    j=1/factorial(a)*(x/2)^(a)
    b=-1/factorial(1+a)*(x/2)^(2+a)
    m=1
    while j+b!=j
        j+=b
        b=-b/((m+1)*(m+a+1))*(x/2)^2
        m+=1
    end
    return j
end

using Plots
xx = BigFloat(0):0.01:170
yy = J.(xx, 0)
# Tочка здесь означает, что функция должна быть применена к каждому
# элементу вхоного массива (или, как в данном случае, - диапазона)
# В результатте получается массив значений функции (в данном случае - синуса.


g=plot(xx, yy) # создается объект p
yy = J.(xx, 1)
plot!(g, xx, yy)
yy = J.(xx, 2)
plot!(g, xx, yy) # в объект p добавляется еще один график
display(g)



J0(x)=J(x, 0) #10 задача
newton(J0, 14.93)
