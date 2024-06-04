function bubble_sort!(vector)
    # Функция сортирует вектор по месту, изменяя его, с использованием
    n = length(vector) # алгоритма сортировки пузырьком.
    for i in 1:n-1
        for j in 1:n-i
            if vector[j] > vector[j+1]
                vector[j], vector[j+1] = vector[j+1], vector[j]
            end
        end
    end
    return vector
end

function insertion_sort!(vector)
    # Функция сортирует вектор по месту, изменяя его, с использованием
    n = length(vector) # алгоритма сортировки вставками.
    for i in 2:n
        key = vector[i]
        j = i - 1
        while j > 0 && vector[j] > key
            vector[j+1] = vector[j]
            j -= 1
        end
        vector[j+1] = key
    end
    return vector
end
function comb_sort!(vector)
    # Функция сортирует вектор по месту, изменяя его, с использованием
    n = length(vector) # алгоритма сортировки "расческой".
    gap = n
    shrink_factor = 1.3
    swapped = true

    while gap > 1 || swapped
        gap = gap > 1 ? floor(Int, gap / shrink_factor) : 1
        swapped = false

        for i in 1:n-gap
            if vector[i] > vector[i+gap]
                vector[i], vector[i+gap] = vector[i+gap], vector[i]
                swapped = true
            end
        end
    end

    return vector
end
using BenchmarkTools

n = 10^6
vector = rand(n)

@btime bubble_sort!($(copy(vector))) )
@btime insertion_sort!($(copy(vector))) )
@btime comb_sort!($(copy(vector))) )
@btime sort!($(copy(vector))) )
function shell_sort!(vector)
    # Функция сортирует вектор по месту, изменяя его, с использованием
    n = length(vector) # алгоритма сортировки Шелла.
    gaps = shell_gaps(n)

    for gap in gaps
        for i in 1:n-gap
            if vector[i] > vector[i+gap]
                vector[i], vector[i+gap] = vector[i+gap], vector[i]
            end
        end
    end

    return vector
end

function shell_gaps(n)
    # Функция генерирует массив промежутков (gaps) для алгоритма сортировки
    gaps = [1] # Шелла.
    while gaps[end] < n
        push!(gaps, 3 * gaps[end] + 1)
    end
    return gaps[end-1:-1:1]
end
using BenchmarkTools

n = 10^6
vector = rand(n)

@btime bubble_sort!($(copy(vector))) )
@btime insertion_sort!($(copy(vector))) )
@btime comb_sort!($(copy(vector))) )
@btime shell_sort!($(copy(vector))) )
@btime sort!($(copy(vector))) )
function merge_sort!(vector)
    # Функция сортирует вектор по методу слияния.
    if length(vector) <= 1
        return vector
    end

    mid = div(length(vector), 2)
    left = merge_sort!(copy(vector[1:mid]) )
    right = merge_sort!(copy(vector[mid+1:end]) )

    merge!(vector, left, right)
    return vector
end

function merge!(vector, left, right)
    # Функция слияния двух отсортированных векторов left и right в один
    i = 1 # отсортированный вектор vector.
    j = 1
    k = 1

    while i <= length(left) && j <= length(right)
        if left[i] <= right[j]
            vector[k] = left[i]
            i += 1
        else
            vector[k] = right[j]
            j += 1
        end
        k += 1
    end

    while i <= length(left)
        vector[k] = left[i]
        i += 1
        k += 1
    end

    while j <= length(right)
        vector[k] = right[j]
        j += 1
        k += 1
    end
end
using BenchmarkTools

n = 10^6
vector = rand(n)

@btime bubble_sort!($(copy(vector))) )
@btime insertion_sort!($(copy(vector))) )
@btime comb_sort!($(copy(vector))) )
@btime shell_sort!($(copy(vector))) )
@btime merge_sort!($(copy(vector))) )
@btime sort!($(copy(vector))) )
function quick_sort!(vector, left=1, right=length(vector))
    # Функция сортирует вектор по методу Хоара (QuickSort).
    if left < right
        pivot = partition(vector, left, right)
        quick_sort!(vector, left, pivot-1)
        quick_sort!(vector, pivot+1, right)
    end
    return vector
end

function partition(vector, left, right)
    # Функция разделения вектора на две части относительно опорного
    pivot = vector[right] # элемента (pivot) с использованием алгоритма Хоара.
    i = left
    for j in left:right-1
        if vector[j] <= pivot
            vector[i], vector[j] = vector[j], vector[i]
            i += 1
        end
    end
    vector[i], vector[right] = vector[right], vector[i]
    return i
end
using BenchmarkTools

n = 10^6
vector = rand(n)

@btime bubble_sort!($(copy(vector))) )
@btime insertion_sort!($(copy(vector))) )
@btime comb_sort!($(copy(vector))) )
@btime shell_sort!($(copy(vector))) )
@btime merge_sort!($(copy(vector))) )
@btime quick_sort!($(copy(vector))) )
@btime sort!($(copy(vector))) )
using BenchmarkTools

function median(vector)
    # Функция вычисления медианы массива с использованием алгоритма Хоара.
    n = length(vector)
    if n % 2 == 0
        return (select(vector, n/2) + select(vector, n/2+1)) / 2
    else
        return select(vector, (n+1)/2)
    end
end

function select(vector, k)
    # Функция выбора k-го элемента из массива vector с использованием
    left = 1 # алгоритма Хоара.
    right = length(vector)
    while left < right
        pivot = partition(vector, left, right)
        if pivot == k
            return vector[k]
        elseif pivot < k
            left = pivot + 1
        else
            right = pivot - 1
        end
    end
    return vector[k]
end

function partition(vector, left, right)
    # Функция разделения вектора на две части относительно опорного
    pivot = vector[right] # элемента (pivot) с использованием алгоритма Хоара.
    i = left
    for j in left:right-1
        if vector[j] <= pivot
            vector[i], vector[j] = vector[j], vector[i]
            i += 1
        end
    end
    vector[i], vector[right] = vector[right], vector[i]
    return i
end
function heap_sort!(vector)
    # Функция сортирует вектор по методу пирамидальной сортировки (HeapSort).
    n = length(vector)
    for i in floor(Int, n/2):-1:1
        sift_down(vector, i, n)
    end
    for i in n:-1:1
        vector[i], vector[1] = vector[1], vector[i]
        sift_down(vector, 1, i-1)
    end
    return vector
end

function sift_down(vector, i, n)
    # Функция просеивания элемента вниз по пирамиде.
    max_index = i
    left_child = 2 * i
    right_child = 2 * i + 1
    if left_child <= n && vector[left_child] > vector[max_index]
        max_index = left_child
    end
    if right_child <= n && vector[right_child] > vector[max_index]
        max_index = right_child
    end
    if max_index != i
        vector[i], vector[max_index] = vector[max_index], vector[i]
        sift_down(vector, max_index, n)
    end
end
function counting_sort!(vector, k)
    # Функция сортирует вектор по методу подсчета (Counting Sort) за линейное
    n = length(vector) # время. Аргумент k - максимальное значение элемента в векторе.
    count = zeros(Int, k+1)
    for i in 1:n
        count[vector[i]+1] += 1
    end
    for i in 2:k+1
        count[i] += count[i-1]
    end
    result = zeros(eltype(vector), n)
    for i in 1:n
        result[count[vector[i]+1]] -= 1
        vector[i] = result[count[vector[i]+1]]
    end
    return vector
end
function binary_search(vector, x)
    # Функция быстрого поиска элемента x в отсортированном массиве vector с
    left = 1 # использованием алгоритма бинарного поиска.
    right = length(vector)
    while left <= right
        mid = floor(Int, (left + right) / 2)
        if vector[mid] == x
            return mid
        elseif vector[mid] < x
            left = mid + 1
        else
            right = mid - 1
        end
    end
    return -1
end
function sort_columns_by_std_dev!(matrix)
    # Функция сортирует столбцы матрицы в порядке не убывания среднего
    m, n = size(matrix) # квадратичного отклонения их элементов.
    std_devs = zeros(n)
    for j in 1:n
        sum_x = 0.0
        sum_x2 = 0.0
        for i in 1:m
            x = matrix[i, j]
            sum_x += x
            sum_x2 += x * x
        end
        mean = sum_x / m
        std_devs[j] = sqrt(sum_x2 / m - mean * mean)
    end
    perm = sortperm(std_devs)
    matrix[:, :] = matrix[:, perm]
    return matrix
end
function sort_columns_by_std_dev!(matrix)
    # Функция сортирует столбцы матрицы в порядке не убывания среднего
    m, n = size(matrix) # квадратичного отклонения их элементов.
    columns = [view(matrix, :, j) for j in 1:n]
    function by_std_dev(c1, c2)
        sum_x1 = 0.0
        sum_x21 = 0.0
        for i in 1:m
            x = c1[i]
            sum_x1 += x
            sum_x21 += x * x
        end
        mean1 = sum_x1 / m
        std_dev1 = sqrt(sum_x21 / m - mean1 * mean1)
        sum_x2 = 0.0
        sum_x22 = 0.0
        for i in 1:m
            x = c2[i]
            sum_x2 += x
            sum_x22 += x * x
        end
        mean2 = sum_x2 / m
        std_dev2 = sqrt(sum_x22 / m - mean2 * mean2)
        return std_dev1 <= std_dev2
    end
    sort!(columns, by=by_std_dev)
    matrix[:, :] = hcat(columns...)
    return matrix
end
using BenchmarkTools

m = 10^3
n = 10^3
matrix = rand(m, n)

@btime sort_columns_by_std_dev!($(copy(matrix))) )
@btime sort_columns_by_std_dev!($(copy(matrix))) )
