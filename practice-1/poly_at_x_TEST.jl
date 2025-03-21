include("../inc/TestManager.jl")
include("../inc/Random.jl")
include("poly_at_x.jl")


TESTS = [ (1, 1), (9, 2), (-2, 3), (-4, 4), (23, 5), (7, 6) ]

function run_all_tests(debug_mode=false)

    (1 == 1) && RUN_TESTS(poly_at_x, poly_at_x_inspector, debug_mode)
    (1 == 1) && RUN_TESTS(poly_derived_at_x, poly_derived_at_x_inspector, debug_mode)

end

function RUN_TESTS(func::Function, inspector::Function, debug_mode)
    newline() = print('\n')
    global TESTS

    for (seed, len) in TESTS
        run_test(
            func,
            inspector,
            generate_vector_rand(seed, -20:20, len), 1;
            print_func_debug=debug_mode,
            print_inspector_debug=debug_mode,
        )
        newline()
    end
end
