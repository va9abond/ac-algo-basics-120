using BenchmarkTools
include("../inc/Random.jl")
include("selection_sort.jl")

TESTS = [1, 2, 3, 4, 10, 100, 1000, 10000]
test_no = 1

for test in TESTS
    global test_no

    println("=== TEST $(test_no), size: $(test) ===")
    bound = div(test, 2) + 1
    # println(test)

    vec = generate_vector_rand(0, -bound:bound, test)
    println("sorted: $(Base.issorted(vec))")
    selection_sort!(vec)
    println("sorted: $(Base.issorted(vec))")

    println()
    vec = generate_vector_rand(0, -bound:bound, test)
    println("sorted: $(Base.issorted(vec))")
    x_selection_sort!(vec)
    println("sorted: $(Base.issorted(vec))")

    println()
    println()
    test_no += 1
end
