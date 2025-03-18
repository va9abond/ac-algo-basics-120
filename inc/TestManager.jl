#=
    Description
    A mini-library responsible for creating and running tests
=#

TEST_NO = 1

function run_test(
         func::Function,
         inspector::Function,
         data...;
         comp=isequal,
         print_data=true,
         print_expected=true,
         print_inspector_debug=false,
         print_recieved=true,
         print_func_debug=false
    )
    global TEST_NO

    if (print_inspector_debug)
        inspector_debug_buf = IOBuffer()
        expected = inspector(data...; debug_mode=true, io=inspector_debug_buf)
    else
        expected = inspector(data...)
    end

    if (print_func_debug)
        func_debug_buf = IOBuffer()
        recieved = func(data...; debug_mode=true, io=func_debug_buf)
    else
        recieved = func(data...)
    end

    # test_result = comp(expected, recieved)
    test_result = length(expected) == length(recieved)
    if (test_result)
        for i in eachindex(expected)
            test_result = comp(expected[i], recieved[i])
            !test_result && break
        end
    end

    printstyled("Test $TEST_NO "; color=:yellow)
    printstyled(String(Symbol(func)); color=:blue)
    if (test_result == true)
        printstyled(" [PASSED]"; bold=true, color=:green)
    else
        printstyled(" [FAILED]"; bold=true, color=:red)
    end
    print('\n')

    print_data            && (printstyled("Data: "; color=:yellow), println(data))
    print_expected        && (printstyled("Expected: "; color=:yellow), println(expected))
    print_inspector_debug && println(String(take!(inspector_debug_buf)))
    print_recieved        && (printstyled("Recieved: "; color=:yellow), println(recieved))
    print_func_debug      && println(String(take!(func_debug_buf)))
    # println("Time: ", "Not provided")

    TEST_NO += 1
end


function run_assert(
    val::T,
    ans::T
    ) where T
    global TEST_NO

    assert_result = isequal(val, ans)

    printstyled("Assert $TEST_NO "; color=:yellow)
    if (assert_result == true)
        printstyled("[PASSED]"; bold=true, color=:green)
    else
        printstyled("[FAILED]"; bold=true, color=:red)
    end
    print('\n')
end
