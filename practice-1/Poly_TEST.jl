include("Poly.jl")


function test0()
    p1 = Poly([1, 0, 3, 4], :s) # Poly(1 + 3*x^2 - 4*x^3)
    # XXX println("p1 = $p1")
    println("p1 = ", p1)

    p2 = Poly([1, 2, 3], :s) # Poly(1 - 2*s + 3*s^2)
    println("p2 = ", p2)

    p3 = p1 + 5
    println("p3 = p1 + 5 = ", p3)

    p4 = p1 + p2
    println("p4 = p1 + p2 = ", p4)

    p5 = p1 * p2
    println("p5 = p1 * p2 = ", p5)

    p6 = scalar_mult(2, p5)
    println("p6 = scalar_mult(2, p5) = ", p6)

    p7 = copy(p6)
    println("p7 = copy(p6) = ", p7)

    p7.coeffs[1] = 0.0
    println("p7.coeffs[1] = 0.0, p7 = ", p7)
    println("p6 = ", p6)

    println("one(Poly) = ", one(Poly{Int, :x}))

    println("zero(Poly) = ", zero(Poly{Float64, :x}))
end

function test1()
    f = Poly{Float64, :x}([8, 18, 10, 5, 1.0])
    g = Poly{Float64, :x}([2, 4, 1.0])

    println("f = ", f)
    println("g = ", g)

    q, r = divrem(f, g)

    println("f = g*q + r")

    println("Got: q = ", q)
    println("Got: r = ", r)

    println("Want: q = ", Poly{Float64, :x}([4.0, 1, 1]))
    println("Want: r = ", Poly{Float64, :x}([0.0]))
end

function test2()
    f = Poly{Float64, :x}([6, 11, 6, 1.0])
    g = Poly{Float64, :x}([1, 1.0])

    println("f = ", f)
    println("g = ", g)

    q, r = divrem(f, g)

    println("f = g*q + r")

    println("Got: q = ", q)
    println("Got: r = ", r)

    println("Want: q = ", Poly{Float64, :x}([6.0, 5, 1]))
    println("Want: r = ", Poly{Float64, :x}([0.0]))
end

function test3()
    f = Poly{Float64, :x}([-4.0, 6, 0, -3, 1])
    g = Poly{Float64, :x}([-1, 1.0])

    println("f = ", f)
    println("g = ", g)

    q, r = divrem(f, g)

    println("f = g*q + r")

    println("Got: q = ", q)
    println("Got: r = ", r)

    println("Want: q = ", Poly{Float64, :x}([4.0, -2, -2, 1]))
    println("Want: r = ", Poly{Float64, :x}([0.0]))
end

function test4()
    f = Poly{Float64, :x}([-42.0, 0, -12, 1])
    g = Poly{Float64, :x}([-3.0, 1])

    println("f = ", f)
    println("g = ", g)

    q, r = divrem(f, g)

    println("f = g*q + r")

    println("Got: q = ", q)
    println("Got: r = ", r)

    println("Want: q = ", Poly{Float64, :x}([-27.0, -9, 1]))
    println("Want: r = ", Poly{Float64, :x}([-123.0]))
end
