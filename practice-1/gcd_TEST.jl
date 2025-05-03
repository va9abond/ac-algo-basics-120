include("../inc/TestManager.jl")
include("../inc/Random.jl")
include("gcd.jl")

TESTS = [
         (0,    0),  # 1
         (1,    0),  # 2
         (11,   31), # 3
         (100,  0),  # 4
         (100,  1),  # 5
         (193,  17), # 6
         (294,  44), # 7
         (299,  299),# 8
         (312,  99), # 9
         (210,  84), # 10
         (3200, 88), # 11
]

function run_all_tests(debug_mode=false)

    (1 == 1) && RUN_TESTS(cst_gcd, gcd)
    (1 == 1) && RUN_TESTS(cst_gcdex, gcdx)

end

function RUN_TESTS(func::Function, inspector::Function)
    newline() = print('\n')
    global TESTS

    for (test_no, test) in enumerate(TESTS)
        a, b = test[1], test[2]
        ans1 = func(a, b)
        ans2 = inspector(a, b)

        printstyled("Test $test_no"; color=:yellow, bold=true)
        if (ans1 == ans2)
            printstyled(" [PASSED]\n"; bold=true, color=:green)
        else
            printstyled(" [FAILED]\n"; bold=true, color=:red)
        end

        println("a = $a, b = $b ")
        println("$(String(Symbol(func))): $ans1")
        println("$(String(Symbol(inspector))): $ans2")
        newline()
    end
end
