include("gcd.jl")
include("Poly.jl")


function run_all_tests()
    gcd_test1()
    gcd_test2()
    gcd_test3()
    gcd_test4()
    gcd_test5()
    gcd_test6()
end

function gcd_test1() # deg f < deg g | f = g*0 + f
    f = Poly{Float64, :x}([2, 3, 1.0])
    g = Poly{Float64, :x}([1, 0, 0, 1.0])

    d = cst_gcd(f, g)

    println("Got: d = ", d)
    println("Want: d = ", Poly([7, 7.0]))
end

function gcd_test2() # deg f = deg g | f = g*1 + (3x+1)
    f = Poly{Float64, :x}([-2.0, 1, -2, 1])
    g = Poly{Float64, :x}([2, -3, 1.0])

    d = cst_gcd(f, g)

    println("Got: d = ", d)
    println("Want: d = ", Poly([-4, 2.0]))
end

function gcd_test3() # deg f > deg g | f = g*(x^2+x+4) + 0
    f = Poly{Float64, :x}([2, -5.0, 0, 2, 2, 4, 1])
    g = Poly{Float64, :x}([-2.0, 3, 1])

    d = cst_gcd(f, g)

    println("Got: d = ", d)
    println("Want: d = ", Poly([-2.0, 3, 1]))
end

function gcd_test4() # deg f > deg g | f = g*x + 1
    f = Poly{Float64, :x}([1, 1, 1.0])
    g = Poly{Float64, :x}([1, 1.0])

    d = cst_gcd(f, g)

    println("Got: d = ", d)
    println("Want: d = ", Poly([1.0]))
end

function gcd_test5()
    f = Poly{Float64, :x}([-2.0, -2, 4])
    g = Poly{Float64, :x}([1.0])

    d = cst_gcd(f, g)

    println("Got: d = ", d)
    println("Want: d = ", Poly([1.0]))
end

function gcd_test6()
    f = Poly{Float64, :x}([4.0])
    g = Poly{Float64, :x}([2.0])

    d = cst_gcd(f, g)

    println("Got: d = ", d)
    println("Want: d = ", Poly([2.0]))
end
