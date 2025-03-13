include("../inc/TestManager.jl")
include("../inc/Random.jl")


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

    sum_max = 0 # typemin(T), first(vec)
    pos_max = 1

    for (pos, val) in enumerate(vec)
        pos_max = pos*(sum_max+val < val) + pos_max*(sum_max+val >= val)
        sum_max = max(sum_max+val, val)
        # println("pos = ", pos, " sum_max+val = ", sum_max+val)
    end

    return sum_max, pos_max
end


#= max_tail
    Наиболее наивная в реализации функция. Необходима для проверки других
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

        debug_mode && println(io, "[DEBUG]: ($pos)$sum")
    end

    return sum_max, pos_max
end


#= max_subarray_sum
    Функция, находящая подпоследовательность с максимальной суммой
=#
function max_subarray_sum(vec::Vector{T}) where T
    if (!isempty(vec))
        max_segm = max_tail = 0 # typemin(T)

        for v in vec
            max_tail = max(max_tail+v, v)
            max_segm = max(max_segm, max_tail)
        end

        return max_segm
    end # ^^^ most likely case

    return typemin(T)
end


function max_subarray_sum_inspector(A::Vector; debug_mode=false, io=stdout)
    sum_max = typemin(eltype(A))
    i_, j_ = 0, 0

    for i in eachindex(A), j in i+1:lastindex(A)
        ij_sum = Base.sum(A[i:j])

        if (sum_max < ij_sum)
            sum_max, i_, j_ = ij_sum, i, j
        end

        debug_mode && println(io, "[DEBUG]: sum A[$i:$j] = $ij_sum")
    end

    debug_mode && println(io, "[DEBUG]: max subarray A[$i_:$j_] = $sum_max")

    return sum_max
end


#=
    Test max_tail_v1
=#
newline() = print('\n')

run_test(
     max_tail_v1,
     max_tail_inspector,
     generate_vector_rand(3, -20:20, 15);
     print_expected_debug=false,
)
newline()

run_test(
     max_tail_v1,
     max_tail_inspector,
     generate_vector_rand(8, -20:20, 15);
     print_expected_debug=false,
)
newline()

run_test(
     max_tail_v1,
     max_tail_inspector,
     generate_vector_rand(7, -20:20, 15);
     print_expected_debug=false,
)
newline()

run_test(
     max_tail_v1,
     max_tail_inspector,
     generate_vector_rand(11, -20:20, 15);
     print_expected_debug=false,
)
newline()

run_test(
     max_tail_v1,
     max_tail_inspector,
     generate_vector_rand(4, 0:20, 15);
     print_expected_debug=false,
)
newline()


#=
    Test max_tail_v2
=#
newline() = print('\n')

run_test(
     max_tail_v2,
     max_tail_inspector,
     generate_vector_rand(3, -20:20, 15);
     print_expected_debug=false,
)
newline()

run_test(
     max_tail_v2,
     max_tail_inspector,
     generate_vector_rand(8, -20:20, 15);
     print_expected_debug=false,
)
newline()

run_test(
     max_tail_v2,
     max_tail_inspector,
     generate_vector_rand(7, -20:20, 15);
     print_expected_debug=false,
)
newline()

run_test(
     max_tail_v2,
     max_tail_inspector,
     generate_vector_rand(11, -20:20, 15);
     print_expected_debug=true,
)
newline()

run_test(
     max_tail_v2,
     max_tail_inspector,
     generate_vector_rand(4, 0:20, 15);
     print_expected_debug=false,
)
newline()


#=
    Test max_subarray_sum
=#
newline() = print('\n')

run_test(
     max_subarray_sum,
     max_subarray_sum_inspector,
     generate_vector_rand(3, -20:20, 15);
     print_expected_debug=false,
)
newline()

run_test(
     max_subarray_sum,
     max_subarray_sum_inspector,
     generate_vector_rand(8, -20:20, 15);
     print_expected_debug=false,
)
newline()

run_test(
     max_subarray_sum,
     max_subarray_sum_inspector,
     generate_vector_rand(7, -20:20, 15);
     print_expected_debug=false,
)
newline()

run_test(
     max_subarray_sum,
     max_subarray_sum_inspector,
     generate_vector_rand(11, -20:20, 15);
     print_expected_debug=false,
)
newline()

run_test(
     max_subarray_sum,
     max_subarray_sum_inspector,
     generate_vector_rand(4, 0:20, 15);
     print_expected_debug=false,
)
newline()
