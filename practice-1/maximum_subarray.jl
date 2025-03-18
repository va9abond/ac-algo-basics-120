include("../inc/Utils.jl")


#= max_tail_v1
    Рассмотрим вспомогательную функцию. В ней оптимизироваться будет только
    нижний предел суммы, верхний всегда будет равен N.
=#
function max_tail_v1(vec::Vector{T}) where T
    sum_max = typemin(T)
    pos_max = 0

    sum, pos = zero(T), lastindex(vec)
    while (pos > 0)
        sum += vec[pos]

        pos_max = pos*(sum > sum_max) + pos_max*(sum <= sum_max)
        sum_max = max(sum, sum_max)

        pos -= 1
    end

    return sum_max, pos_max
end


#= max_tail_v2
    Другая реализация функции max_tail, предложенная преподавателем.

    ЗАМЕЧАНИЕ: если первый элемент массива меньше нуля и величина sum_max
    инициализированна значением typemin(T), то при сложении этих элементов
    произойдет переполнение переменной sum_max
=#
function max_tail_v2(vec::Vector{T}) where T
    if (isempty(vec))
        return 0, typemin(T)
    end

    sum_max = typemin(T)
    pos_max = 1

    for (pos, val) in enumerate(vec)
        pos_max = pos*(sum_max+val < val) + pos_max*(sum_max+val >= val)
        sum_max = max(sum_max+val, val)
        # println("pos = ", pos, " sum_max+val = ", sum_max+val)
    end

    return sum_max, pos_max
end


#= max_tail_inspector
    Наивная в реализации функция. Необходима для проверки других
    функций max_tail_v*
=#
function max_tail_inspector(vec::Vector; debug_mode=false, io=stdout)
    sum_max = zero(eltype(vec))
    pos_max = typemin(eltype(vec))

    for pos in eachindex(vec)
        sum = Base.sum(vec[pos:end])

        if (sum >= sum_max)
            sum_max = sum
            pos_max = pos
        end

        debug_mode && println(io, "[DEBUG] ($pos)$sum")
    end

    return sum_max, pos_max
end


#= max_subarray_sum_v1
    Функция, находящая подпоследовательность с максимальной суммой

    ЗАМЕЧАНИЕ: алгоритм, не работает, если в векторе есть отрицательные
    элементы и тип T целочесленный. Причина тому переполнение max_tail+v
=#
function max_subarray_sum_v1(vec::Vector{T}) where T
    if (!isempty(vec))
        max_segm = max_tail = typemin(T)

        for v in vec
            max_tail = max(max_tail+v, v)
            max_segm = max(max_segm, max_tail)
        end

        return max_segm
    end # ^^^ most likely case

    return typemin(T)
end


function max_subarray_sum_v2(
        vec::Vector{T}; debug_mode=false, io=stdout
    ) where T
    if (!isempty(vec))
        debug_mode && send_debug_info(io, "vector is not empty")

        sum, sum_max = zero(T), typemin(T)
        debug_mode && send_debug_info(io, "sum = $sum, sum_max = $sum_max")

        for v in vec
            sum += v
            debug_mode && send_debug_info(io, "v = $v, sum = $sum")
            sum_max = max(sum, sum_max)
            sum = max(sum, zero(T))
            debug_mode && send_debug_info(io, "sum = $sum, sum_max = $sum_max")
        end

        return sum_max
    end # ^^^ most likely case

    debug_mode && send_debug_info(io, "vector is empty")
    return Nothing
end


function max_subarray_sum_v3(vec::Vector{T}) where T
end


function max_subarray_sum_inspector(A::Vector; debug_mode=false, io=stdout)
    sum_max = typemin(eltype(A))
    i_, j_ = 0, 0

    for i in eachindex(A), j in i:lastindex(A)
        ij_sum = Base.sum(A[i:j])

        if (sum_max < ij_sum)
            sum_max, i_, j_ = ij_sum, i, j
        end

        debug_mode && println(io, "[DEBUG] sum A[$i:$j] = $ij_sum")
    end

    debug_mode && println(io, "[DEBUG] max subarray A[$i_:$j_] = $sum_max")

    return sum_max
end
