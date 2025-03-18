include("../inc/TestManager.jl")
include("../inc/Random.jl")
include("standard_deviation.jl")


newline() = print('\n')

TEST_DATA_SET = [ ]
for seed in [3, 49, 1, 38, -2]
    push!(TEST_DATA_SET, generate_vector_rand(seed, 0:20, 20))
end

COMP(x, y) = isapprox(x,y; atol=1e-6)


function run_all_tests(debug_mode=true)
    1 == 1 && run_test_standard_deviation_v1(debug_mode)
    1 == 1 && run_test_standard_deviation_v2(debug_mode)
end


function run_test_standard_deviation_v1(debug_mode)
    for data in TEST_DATA_SET
        run_test(
                 standard_deviation_v1,
                 standard_deviation_inspector,
                 data;
                 comp=COMP,
                 print_inspector_debug=debug_mode,
                 print_func_debug=debug_mode,
                )
        newline()
    end
end

function run_test_standard_deviation_v2(debug_mode)
    for data in TEST_DATA_SET
        run_test(
                 standard_deviation_v2,
                 standard_deviation_inspector,
                 data;
                 comp=COMP,
                 print_inspector_debug=debug_mode,
                 print_func_debug=debug_mode,
                )
        newline()
    end
end
