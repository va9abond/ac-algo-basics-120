#= Description
    A mini-library responsible for creating and running tests.
=============#


TEST_NO = 1


# struct Test{T, F1, F2} where {T,F1, F2}
#     test_no::UInt
#     test_name::String
#     test_result::Bool
#     test_data::T
#     test_func::F1
#     test_checker::F2
# end

function run_test(
         func::Function,
         inspector::Function,
         data...;
         print_data=true,
         print_expected=true,
         print_expected_debug=false,
         print_recieved=true
         # print_compact=Val{true}
    )
    global TEST_NO

    if (print_expected_debug)
        io = IOBuffer()
        expected = inspector(data...; debug_mode=true, io)
    else
        expected = inspector(data...)
    end
    recieved = func(data...)
    test_result = isequal(expected, recieved)

    print("Test $TEST_NO ")
    printstyled(String(Symbol(func)); color=:yellow)
    if (test_result == true)
        printstyled(" [ PASSED ]"; bold=true, color=:green)
    else
        printstyled(" [ FAILED ]"; bold=true, color=:red)
    end
    print('\n')

    print_data           && println("Data: ", data)
    print_expected       && println("Expected: ", expected)
    print_expected_debug && println(String(take!(io)))
    print_recieved       && println("Recieved: ", recieved)
    println("Time: ", "Not provided")

    TEST_NO += 1
end


# function run_test(
#          func::Function,
#          inspector::Function,
#          data...;
#          print_data=true,
#          print_expected=true,
#          print_expected_debug=false,
#          print_recieved=true,
#          # print_compact=Val{false}
#     )
#     global TEST_NO
#
#     TEST_NO == 1 && println("========================================")
#
#     printstyled("> "; color=:yellow)
#     print("Test $TEST_NO ")
#
#     if (print_expected_debug == true)
#         io = IOBuffer()
#         expected = inspector(data...; debug_mode=true, io)
#     else
#         expected = inspector(data...)
#     end
#
#     recieved = func(data...)
#     test_result = isequal(expected, recieved)
#
#     if (test_result == true)
#         printstyled("[ PASSED ]"; bold=true, color=:green)
#     else
#         printstyled("[ FAILED ]"; bold=true, color=:red)
#     end
#     print('\n')
#
#     printstyled("> "; color=:yellow)
#     println("Data\n", data)
#     print('\n')
#
#     printstyled("> "; color=:yellow)
#     println("Expected\n", expected)
#     print_expected_debug && print(String(take!(io)))
#     print('\n')
#
#     printstyled("> "; color=:yellow)
#     println("Recieved\n", recieved)
#     print('\n')
#
#     printstyled("> "; color=:yellow)
#     println("Time: ", "Not provided")
#
#     TEST_NO += 1
#     println("========================================")
# end


function run_test(
         func::Function,
         answer::T,
         data...;
         print_data=true,
         print_expected=true,
         print_recieved=true
    ) where T <: Number
end


function run_assert(
    val::T,
    ans::T
    ) where T
    global TEST_NO

    assert_result = isequal(val, ans)

    print("Assert $TEST_NO ")
    if (assert_result == true)
        printstyled("[ PASSED ]"; bold=true, color=:green)
    else
        printstyled("[ FAILED ]"; bold=true, color=:red)
    end
    print('\n')
end
