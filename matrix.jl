using LinearAlgebra # Подключаем стандартный пакет LinearAlgebra для работы с матрицами и векторами

# Функция, реализующая обратный ход алгоритма Гаусса
function gaussian_elimination_backward(A::AbstractMatrix, b::AbstractVector)
    n = size(A, 1) # Получаем размерность матрицы A по вертикали (количество строк)

    x = copy(b) # Копируем вектор b в вектор x (решение СЛАУ)

    # Цикл обратного хода алгоритма Гаусса
    for i in n:-1:1
        x[i] = (x[i] - sum(A[i, i+1:n] .* x[i+1:n])) )/ A[i,i] # Вычисляем i-й элемент вектора x (решения)
    end

    return x # Возвращаем вектор x (решение СЛАУ)
end

# Функция, генерирующая случайную треугольную матрицу заданного размера
function generate_random_triangular_matrix(n::Int)
    A = randn(n, n) # Генерируем квадратную матрицу размера nxn, заполненную случайными числами с плавающей точкой

    # Преобразуем матрицу A в верхнюю треугольную матрицу
    for i in 1:n-1
        for j in (i+1):n
            A[i, j] = 0.0
        end
    end

    return A # Возвращаем сгенерированную треугольную матрицу A
end

# Функция, реализующаю приведение матрицы к ступенчатому виду
function to_row_echelon_form(A::AbstractMatrix)
    n, m = size(A) # Получаем размеры матрицы A

    # Цикл приведения матрицы к ступенчатому виду
    for i in 1:n-1
        max_index = findmax(abs.(A[i:n, i])))[2] + i - 1 # Находим индекс строки с максимальным по модулю элементом в i-м столбце

        if A[max_index, i] == 0.0
            error("The matrix is singular or not square") # Выводим сообщение об ошибке, если матрица является вырожденной или не квадратной
        end

        A[[i, max_index], :] = A[[max_index, i], :] # Меняем местами строки с индексами i и max_index
        A[i, :] /= A[i, i] # Делим все элементы i-й строки на элемент в i-м столбце этой строки (нормализуем строку)

        # Вычитаем из строк с индексами от (i+1) до n нормализованную i-ю строку, умноженную на соответствующий элемент в i-м столбце
        for j in (i+1):n
            A[j, :] -= A[j, i] * A[i, :]
        end
    end

    return A # Возвращаем матрицу в ступенчатом виде
end

# Функция, реализующая метод Гаусса решение СЛАУ для произвольной невырожденной матрицы
function gaussian_elimination_solve(A::AbstractMatrix, b::AbstractVector)
    Augmented = hcat(A, b) # Объединяем матрицу A и вектор b в одну матрицу (расширенную матрицу)
    REF = to_row_echelon_form(Augmented) # Приводим расширенную матрицу к ступенчатому виду
    x = zeros(size(A,1)) # Инициализируем вектор x (решение СЛАУ) нулями

    # Находим решение СЛАУ методом обратной подстановки
    for i in 1:size(A,1)
        x[i] = REF[i,end]
    end

    return x # Возвращаем вектор x (решение СЛАУ)
end

# Функция, возвращающая ранг произвольной прямоугольной матрицы
function matrix_rank(A::AbstractMatrix)
    REF = to_row_echelon_form(A) # Приводим матрицу к ступенчатому виду
    rank = 0 # Инициализируем ранг матрицы

    # Находим ранг матрицы
    for i in 1(REF,1)
        if REF[i,i] != 0.0
        rank += 1
        end
    end
        
        return rank # Возвращаем ранг матрицы
end
# Функция, возвращающая определитель произвольной квадратной матрицы
function matrix_determinant(A::AbstractMatrix)
    det = 1.0 # Инициализируем определитель матрицы
    REF = to_row_echelon_form(A) # Приводим матрицу к ступенчатому виду

    # Находим определитель матрицы
    for i in 1:size(REF,1)
        det *= REF[i,i]
    end

    return det # Возвращаем определитель матрицы
end

# Тестируем функцию gaussian_elimination_backward на случайных треугольных матрицах большого размера
n = 1000 # Задаем размерность матрицы
A = generate_random_triangular_matrix(n) # Генерируем треугольную матрицу
b = randn(n) # Генерируем вектор b (правая часть СЛАУ)

x = gaussian_elimination_backward(A, b) # Находим решение СЛАУ методом обратного хода алгоритма Гаусса
r = A*x - b # Вычисляем вектор невязки (разность между левой и правой частями СЛАУ)
residual_norm = norm(r) # Вычисляем норму вектора невязки

println("Residual norm: $residual_norm") # Выводим норму вектора невязки на экран

# Тестируем функцию gaussian_elimination_backward на матрицах с элементами различных типов
A_float = Float64.(A) # Преобразуем матрицу A в матрицу с элементами типа Float64
b_float = Float64.(b) # Преобразуем вектор b в вектор с элементами типа Float64
x_float = gaussian_elimination_backward(A_float, b_float) # Находим решение СЛАУ для матрицы с элементами типа Float64
r_float = A_float*x_float - b_float # Вычисляем вектор невязки для матрицы с элементами типа Float64
residual_norm_float = norm(r_float) # Вычисляем норму вектора невязки для матрицы с элементами типа Float64

println("Residual norm (Float64): $residual_norm_float") # Выводим норму вектора невязки для матрицы с элементами типа Float64 на экран

A_bigfloat = BigFloat.(A) # Преобразуем матрицу A в матрицу с элементами типа BigFloat
b_bigfloat = BigFloat.(b) # Преобразуем вектор b в вектор с элементами типа BigFloat
x_bigfloat = gaussian_elimination_backward(A_bigfloat, b_bigfloat) # Находим решение СЛАУ для матрицы с элементами типа BigFloat
r_bigfloat = A_bigfloat*x_bigfloat - b_bigfloat # Вычисляем вектор невязки для матрицы с элементами типа BigFloat
residual_norm_bigfloat = norm(r_bigfloat) # Вычисляем норму вектора невязки для матрицы с элементами типа BigFloat

println("Residual norm (BigFloat): $residual_norm_bigfloat") # Выводим норму вектора невязки для матрицы с элементами типа BigFloat на экран

A_rational = Rational{Int64}.(A) # Преобразуем матрицу A в матрицу с элементами типа Rational{Int64}
b_rational = Rational{Int64}.(b) # Преобразуем вектор b в вектор с элементами типа Rational{Int64}
x_rational = gaussian_elimination_backward(A_rational, b_rational) # Находим решение СЛАУ для матрицы с элементами типа Rational{Int64}
r_rational = A_rational*x_rational - b_rational # Вычисляем вектор невязки для матрицы с элементами типа Rational{Int64}
residual_norm_rational = norm(r_rational) # Вычисляем норму вектора невязки для матрицы с элементами типа Rational{Int64}

println("Residual norm (Rational{Int64}): $residual_norm_rational") # Выводим норму вектора невязки для матрицы с элементами типа Rational{Int64} на экран
# Тестируем производительность функции gaussian_elimination_solve на матрицах большого размера
n = 1000 # Задаем размерность матрицы
A = randn(n, n) # Генерируем квадратную матрицу размера nxn, заполненную случайными числами с плавающей точкой
b = randn(n) # Генерируем вектор b (правая часть СЛАУ)

@time gaussian_elimination_solve(A, b) # Замеряем время выполнения функции gaussian_elimination_solve и выводим результат на экран

using BenchmarkTools # Подключаем пакет BenchmarkTools для более точного замера времени выполнения

@btime gaussian_elimination_solve($A, $b) # Замеряем время выполнения функции gaussian_elimination_solve с помощью пакета BenchmarkTools и выводим результат на экран

# Тестируем функции matrix_rank и matrix_determinant на матрицах большого размера
n = 1000 # Задаем размерность матрицы
A = randn(n, n) # Генерируем квадратную матрицу размера nxn, заполненную случайными числами с плавающей точкой

matrix_rank_A = matrix_rank(A) # Находим ранг матрицы A с помощью функции matrix_rank
matrix_rank_A_linear_algebra = rank(A) # Находим ранг матрицы A с помощью стандартной функции rank из пакета LinearAlgebra

println("Matrix rank: $matrix_rank_A") # Выводим ранг матрицы A, найденный с помощью функции matrix_rank, на экран
println("Matrix rank (LinearAlgebra): $matrix_rank_A_linear_algebra") # Выводим ранг матрицы A, найденный с помощью стандартной функции rank, на экран

matrix_determinant_A = matrix_determinant(A) # Находим определитель матрицы A с помощью функции matrix_determinant
matrix_determinant_A_linear_algebra = det(A) # Находим определитель матрицы A с помощью стандартной функции det из пакета LinearAlgebra

println("Matrix determinant: $matrix_determinant_A") # Выводим определитель матрицы A, найденный с помощью функции matrix_determinant, на экран
println("Matrix determinant (LinearAlgebra): $matrix_determinant_A_linear_algebra") # Выводим определитель матрицы A, найденный с помощью стандартной функции det, на экран

cond_num_A = cond(A) # Находим число обусловленности матрицы A с помощью стандартной функции cond из пакета LinearAlgebra
println("Condition number: $cond_num_A") # Выводим число обусловленности матрицы A на экран
