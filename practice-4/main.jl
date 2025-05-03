using BenchmarkTools
include("../inc/Random.jl")
include("bubble_sort.jl")
include("cocktail_sort.jl")
include("insertion_sort.jl")
include("merge_sort.jl")
include("selection_sort.jl")
include("comb_sort.jl")
include("shell_sort.jl")
include("counting_sort.jl")

TEST_SIZES = [10, 1000, 10000, 100000, 1000000]

function run_test(sorter::Function, size::Int)
    vec = generate_vector_rand(0, -1000:1000, size)

    print("vector size = ")
    printstyled("$(size)"; color=:yellow)
    print(", ")

    print("before ")
    print_check(vec)
    print(", ")

    sorter(vec)

    print("after ")
    print_check(vec)
    println()
end

function print_check(vec::Vector{T}) where T
    issorted = Base.issorted(vec)

    (issorted)  && printstyled("sorted"; color=:green)
    (!issorted) && printstyled("unsorted"; color=:red)

    return nothing
end


(1 == 0) && run_test(bubble_sort!, 1000)
(1 == 0) && run_test(cocktail_sort!, 1000)
(1 == 0) && run_test(insertion_sort!, 1000)
(1 == 0) && run_test(merge_sort!, 1000)
(1 == 0) && run_test(selection_sort!, 1000)
(1 == 0) && run_test(x_selection_sort!, 1000)
(1 == 0) && run_test(comb_sort!, 1000)
(1 == 0) && run_test(shell_sort!, 1000)

(1 == 0) && run_test(counting_sort!, 1000)




# vec = generate_vector_rand(0, -1000:1000, 1000)
# @benchmark bubble_sort!(vec)
# vec = generate_vector_rand(0, -1000:1000, 1000)
# @benchmark counting_sort!(vec)


# vec = generate_vector_rand(1, 1:30, 15)
# print(vec')
# print_check(vec);println()
# shell_sort!(vec)
# print(vec')
# print_check(vec)
# println()


# @benchmark bubble_sort!(
#     generate_vector_rand(0, -1000:1000, 1000)
#     )


# @xmemory sort(vec)
# @xbenchmark sort(vec)
# @xmemory sort(vec)
# @xbenchmark sort(vec)
