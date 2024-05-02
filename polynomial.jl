#Создание пользовательского типа данных. {T} - T — это параметр типа для структуры Polynomial.
#Параметры типа позволяют создавать обобщенные (параметризованные) типы, которые могут работать с различными типами данных. 
#В данном случае T является параметром типа, который будет заменен конкретным типом при создании объектов типа Polynomial (Int, Float).
#T для структуры обычно берется из типа элементов, которые передается в конструктор структуры.
struct Polynomial{T}
    coefficients::Vector{T}
end

#T может быть любым типом, но этот тип должен соответствовать определенным условиям, указанным после where
#The reason you need to add the where {T} at the end of your function signature is that A is a parametric type with parameter T. If you leave only the A{T}, the function assumes you creating an instance of type A with parameter T, but T has not yet been defined. By adding the where {T}, you let the constructor know that T will be passed to the function as a parameter when it is called, not when it is defined.

#enumerate() используется для создания объекта, который проходит по итерируемому контейнеру (например, массиву или диапазону) и возвращает пары индекса и значения элемента в контейнере.
#Функция zero(T) в Julia возвращает "нулевое" значение для типа T.
#В языке программирования Julia функция zeros() используется для создания массива (вектора или матрицы) из нулей.

#Функция для вычисления значения многочлена в точке x
function evaluate(p::Polynomial{T}, x::T) where T
    result = zero(T)
    for (i, coef) in enumerate(p.coefficients)
        result += coef * x^(i-1)
    end
    return result
end

# Переопределение оператора * для умножения многочленов
function Base.:*(p1::Polynomial{T}, p2::Polynomial{T}) where T
    deg1 = length(p1.coefficients) - 1
    deg2 = length(p2.coefficients) - 1
    result_deg = deg1 + deg2
    result_coeffs = zeros(T, result_deg + 1)

    for i in 0:deg1
        for j in 0:deg2
            result_coeffs[i + j + 1] += p1.coefficients[i + 1] * p2.coefficients[j + 1]
        end
    end
    return Polynomial{T}(result_coeffs)
end

#Функция get() в языке программирования Julia используется для получения значения по ключу из словаря. Словари в Julia - это коллекции, которые ассоциируют ключи с соответствующими значениями.

#Переопределение оператора + для сложения многочленов
function Base.:+(p1::Polynomial{T}, p2::Polynomial{T}) where T
    deg1 = length(p1.coefficients) - 1
    deg2 = length(p2.coefficients) - 1
    result_deg = max(deg1, deg2)
    result_coeffs = zeros(T, result_deg + 1)

    for i in 0:result_deg
        result_coeffs[i + 1] += get(p1.coefficients, i + 1, zero(T)) + get(p2.coefficients, i + 1, zero(T))
    end
    # get(откуда берем, ключ, значение по дефолту)
    return Polynomial{T}(result_coeffs)
end

# Переопределение оператора / для деления многочленов
function Base.:/(p1::Polynomial{T}, p2::Polynomial{T}) where T
    deg_p1 = length(p1.coefficients) - 1
    deg_p2 = length(p2.coefficients) - 1

    if deg_p2 < 0
        throw(ArgumentError("Делитель не может быть нулевым полиномом"))
    end

    if deg_p1 < deg_p2
        return Polynomial{T}([zero(T)]), copy(p1)
    end

    quotient_coeffs = zeros(T, deg_p1 - deg_p2 + 1)

    for i = deg_p1:-1:deg_p2
        if p1.coefficients[i + 1] != zero(T)
            # Найдем коэффициент частного
            quotient_coeffs[i - deg_p2 + 1] = p1.coefficients[i + 1] / p2.coefficients[deg_p2 + 1]

            # Вычитаем из делимого полученное частное, умноженное на делитель
            for j = 0:deg_p2
                p1.coefficients[i - j + 1] -= quotient_coeffs[i - deg_p2 + 1] * p2.coefficients[deg_p2 - j + 1]
            end
        end
    end

    return Polynomial{T}(quotient_coeffs), Polynomial{T}(p1.coefficients[1:min(length(p1.coefficients), deg_p2)])
end

# Переопределение оператора - для вычитания многочленов
function Base.:-(p1::Polynomial{T}, p2::Polynomial{T}) where T
    deg1 = length(p1.coefficients) - 1
    deg2 = length(p2.coefficients) - 1
    result_deg = max(deg1, deg2)
    result_coeffs = zeros(T, result_deg + 1)

    for i in 0:result_deg
        result_coeffs[i + 1] += get(p1.coefficients, i + 1, zero(T)) - get(p2.coefficients, i + 1, zero(T))
    end

    return Polynomial{T}(result_coeffs)
end

# Функция для вывода в консоль многочлена в виде строки
function Base.show(io::IO, p::Polynomial{T}) where T
    #IO в языке программирования Julia представляет собой абстрактный тип для ввода-вывода данных. 
    terms = [string(coef, "x^", i-1) for (i, coef) in enumerate(p.coefficients) if coef != zero(T)]
    terms=reverse(terms)
    joined_terms=""
    for i in terms
        if i[1]=='-'
            joined_terms*= " - "*i[2:end]
        else
            joined_terms*= " + "*i
        end
    end
    if isempty(joined_terms)
        println(io, "0")
    elseif isequal(joined_terms[2], '+')
        #Функция isequal в языке программирования Julia используется для сравнения двух объектов на равенство. 
        println(io, joined_terms[3:end-3])
    else
        println(io, joined_terms[2:end-3])
    end
end

#Функция вычисления производной
function derivative(p::Polynomial{T}) where T
    deg1=length(p.coefficients)-1
    degg=zeros(deg1)
    if deg1==0
        return Polynomial([zero(T)])
    end
    for i in 1:(deg1)
        degg[i]=p.coefficients[i+1]*i
    end
    return Polynomial{T}(degg)
end

# Пример использования
poly1 = Polynomial([1.0, 2.0, 3.0])  # представляет многочлен 1 + 2x + 3x^2
poly2 = Polynomial([4.0, 5.0, 6.0])  # представляет многочлен 4 + 5x + 6x^2

println("poly1 = ", poly1)
println("poly2 = ", poly2)
println("poly1 + poly2 = ", poly1 + poly2)
println("poly1 - poly2 = ", poly1 - poly2)
println("poly1 * poly2 = ", poly1 * poly2)
quotient, remainder = poly1 / poly2
println("poly1 / poly2 = ", quotient, " с остатком ", remainder)
println("derivative(poly1) = ", derivative(poly1))
println("derivative(poly2) = ", derivative(poly2))


x_value = 2.0
println("evaluate(poly1, $x_value) = ", evaluate(poly1, x_value))
println("evaluate(derivative(poly1), $x_value) = ", evaluate(derivative(poly1), x_value))
println("evaluate(derivative(poly2), $x_value) = ", evaluate(derivative(poly2), x_value))
