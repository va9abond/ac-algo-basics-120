include("../inc/TestManager.jl")
include("../inc/Random.jl")
include("maximum_subarray.jl")


newline() = print('\n')


function run_all_tests(debug_mode=true)

    (1 == 1) && run_tests_max_tail_v1(debug_mode)
    (1 == 1) && run_tests_max_tail_v2(debug_mode)
    (1 == 1) && run_tests_max_subarray_sum_v1(false)
    (1 == 1) && run_tests_max_subarray_sum_v2(true)

end


function run_tests_max_tail_v1(debug_mode)
    run_test(
         max_tail_v1,
         max_tail_inspector,
         generate_vector_rand(3, -20:20, 15);
         print_inspector_debug=debug_mode,
    )
    newline()

    run_test(
         max_tail_v1,
         max_tail_inspector,
         generate_vector_rand(8, -20:20, 15);
         print_inspector_debug=debug_mode,
    )
    newline()

    run_test(
         max_tail_v1,
         max_tail_inspector,
         generate_vector_rand(7, -20:20, 15);
         print_inspector_debug=debug_mode,
    )
    newline()

    run_test(
         max_tail_v1,
         max_tail_inspector,
         generate_vector_rand(11, -20:20, 15);
         print_inspector_debug=debug_mode,
    )
    newline()

    run_test(
         max_tail_v1,
         max_tail_inspector,
         generate_vector_rand(4, 0:20, 15);
         print_inspector_debug=debug_mode,
    )
    newline()
end

function run_tests_max_tail_v2(debug_mode)
    run_test(
         max_tail_v2,
         max_tail_inspector,
         generate_vector_rand(3, -20:20, 15);
         print_inspector_debug=debug_mode,
    )
    newline()

    run_test(
         max_tail_v2,
         max_tail_inspector,
         generate_vector_rand(8, -20:20, 15);
         print_inspector_debug=debug_mode,
    )
    newline()

    run_test(
         max_tail_v2,
         max_tail_inspector,
         generate_vector_rand(7, -20:20, 15);
         print_inspector_debug=debug_mode,
    )
    newline()

    run_test(
         max_tail_v2,
         max_tail_inspector,
         generate_vector_rand(11, -20:20, 15);
         print_inspector_debug=debug_mode,
    )
    newline()

    run_test(
         max_tail_v2,
         max_tail_inspector,
         generate_vector_rand(4, 0:20, 15);
         print_inspector_debug=debug_mode,
    )
    newline()
end

function run_tests_max_subarray_sum_v1(debug_mode)
    run_test(
         max_subarray_sum_v1,
         max_subarray_sum_inspector,
         generate_vector_rand(3, -20:20, 15);
         print_inspector_debug=debug_mode,
    )
    newline()

    run_test(
         max_subarray_sum_v1,
         max_subarray_sum_inspector,
         generate_vector_rand(8, -20:20, 15);
         print_inspector_debug=debug_mode,
    )
    newline()

    run_test(
         max_subarray_sum_v1,
         max_subarray_sum_inspector,
         generate_vector_rand(7, -20:20, 15);
         print_inspector_debug=debug_mode,
    )
    newline()

    run_test(
         max_subarray_sum_v1,
         max_subarray_sum_inspector,
         generate_vector_rand(11, -20:20, 15);
         print_inspector_debug=debug_mode,
    )
    newline()

    run_test(
         max_subarray_sum_v1,
         max_subarray_sum_inspector,
         generate_vector_rand(4, 0:20, 15);
         print_inspector_debug=debug_mode,
    )
    newline()
end

function run_tests_max_subarray_sum_v2(debug_mode)
    run_test(
         max_subarray_sum_v1,
         max_subarray_sum_inspector,
         generate_vector_rand(3, -20:20, 15);
         print_inspector_debug=debug_mode,
    )
    newline()

    run_test(
         max_subarray_sum_v1,
         max_subarray_sum_inspector,
         generate_vector_rand(8, -20:20, 15);
         print_inspector_debug=debug_mode,
    )
    newline()

    run_test(
         max_subarray_sum_v1,
         max_subarray_sum_inspector,
         generate_vector_rand(7, -20:20, 15);
         print_inspector_debug=debug_mode,
    )
    newline()

    run_test(
         max_subarray_sum_v1,
         max_subarray_sum_inspector,
         generate_vector_rand(11, -20:20, 15);
         print_inspector_debug=debug_mode,
    )
    newline()

    run_test(
         max_subarray_sum_v1,
         max_subarray_sum_inspector,
         generate_vector_rand(4, 0:20, 15);
         print_inspector_debug=debug_mode,
    )
    newline()
end

function run_tests_max_subarray_sum_v2(debug_mode)
    run_test(
         max_subarray_sum_v2,
         max_subarray_sum_inspector,
         generate_vector_rand(3, -20:20, 15);
         print_inspector_debug=debug_mode,
         print_func_debug=debug_mode,
    )
    newline()

    run_test(
         max_subarray_sum_v2,
         max_subarray_sum_inspector,
         generate_vector_rand(8, -20:20, 15);
         print_inspector_debug=debug_mode,
         print_func_debug=debug_mode,
    )
    newline()

    run_test(
         max_subarray_sum_v2,
         max_subarray_sum_inspector,
         generate_vector_rand(7, -20:20, 15);
         print_inspector_debug=debug_mode,
         print_func_debug=debug_mode,
    )
    newline()

    run_test(
         max_subarray_sum_v2,
         max_subarray_sum_inspector,
         generate_vector_rand(11, -20:20, 15);
         print_inspector_debug=debug_mode,
         print_func_debug=debug_mode,
    )
    newline()

    run_test(
         max_subarray_sum_v2,
         max_subarray_sum_inspector,
         generate_vector_rand(4, 0:20, 15);
         print_inspector_debug=debug_mode,
         print_func_debug=debug_mode,
    )
    newline()

    run_test(
         max_subarray_sum_v2,
         max_subarray_sum_inspector,
         generate_vector_rand(4, -20:0, 10);
         print_inspector_debug=debug_mode,
         print_func_debug=debug_mode,
    )
    newline()

    run_test(
         max_subarray_sum_v2,
         max_subarray_sum_inspector,
         generate_vector_rand(1, -20:0, 10);
         print_inspector_debug=debug_mode,
         print_func_debug=debug_mode,
    )
    newline()
end
