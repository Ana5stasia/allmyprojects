#Дуальные числа или (гипер)комплексные числа параболического типа — гиперкомплексные числа вида a + bε, где a и b - вещественные числа, а ε- абстрактный элемент, квадрат которого равен нулю, но сам он нулю не равен.
#Создание пользовательского типа данных. {T} - T — это параметр типа для структуры Dual.
struct Dual{T}
    a::T
    b::T
end
#Переопределение арифметических действий
function Base.:+(x::Dual{T}, y::Dual{T}) where T
    return Dual{T}(x.a+y.a, (x.b+y.b))
end
function Base.:-(x::Dual{T}, y::Dual{T}) where T
    return Dual{T}(x.a-y.a, (x.b-y.b))
end
function Base.:*(x::Dual{T}, y::Dual{T}) where T
    return Dual{T}(x.a*y.a, (x.b*y.a+x.a*y.b))
end
function Base.:/(x::Dual{T}, y::Dual{T}) where T
    return Dual{T}(x.a/y.a, ((x.b*y.a+x.a*y.b)/y.a^2))
end

# Функция для вывода в консоль
function Base.show(io::IO, x::Dual{T}) where T
    print(io, string(x.a, " + ", x.b, 'ε'))
end

# Функция корня n-ой степени
function n_sqrt(x, n)
    return x^(1/n)
end

# Функция корня n-ой степени для дуального числа
function dual_sqrt(x::Dual{T}, n::Int) where T
    return Dual{T}(n_sqrt(x.a, n),  x.b/(n*n_sqrt(x.a^(n-1), n)))
end

Base. sin(x::Dual{T}) where T = Dual{T}(sin(x.a), x.b*cos(x.a))
Base. cos(x::Dual{T}) where T = Dual{T}(cos(x.a), (-1)*x.b*sin(x.a))
Base. tan(x::Dual{T}) where T = Dual{T}(tan(x.a), x.b*(1/(cos(x.a))^2))
Base. cot(x::Dual{T}) where T = Dual{T}(cot(x.a), x.b*(-1/(sin(x.a))^2))
Base. asin(x::Dual{T}) where T = Dual{T}(asin(x.a), x.b*(1/sqrt(1-x^2)))
Base. acos(x::Dual{T}) where T = Dual{T}(acos(x.a), x.b*(-1/(sqrt(1-x^2))))
Base. atan(x::Dual{T}) where T = Dual{T}(atan(x.a), x.b*(1/(1+x^2)))
function acot(x::Dual{T}) where T 
    return Dual{T}(1/atan(x.a), x.b*(-1/(1+x^2)))
end
Base. exp(x::Dual{T}) where T = Dual{T}(exp^x.a, x.b*exp^x.a)
Base. log(x::Dual{T}) where T = Dual{T}(log(x.a), x.b*(1/(x.a)))
Base. log2(x::Dual{T}) where T = Dual{T}(log(2, x.a), x.b*(1/(x.a*log(2))))
Base. log10(x::Dual{T}) where T = Dual{T}(log(10, x.a), x.b*(1/(x.a*log(10))))
Base. log(s::AbstractFloat, x::Dual{T}) where T = Dual{T}(log(s, x.a), x.b*(1/(x.a*log(s))))

#Пример использования
x=Dual(4, 24)
y=Dual(2, 3)
println("x = ", x)
println("y = ", y)
println("x + y = ", x+y)
println("x - y = ", x-y)
println("x * y = ", x*y)
println("x / y = ", x/y)
println("square(y) = ", dual_sqrt(y, 2))
