function newton(delta::Function, x0; atol=1e-8, nmax_iter=20)
    # x0 - начальное приближение корня функции f(x)

    n = 0
    x = x0
    dx = delta(x)

    while (n < nmax_iter) && (abs(dx) > atol)
        x += dx
        dx = delta(x)
        n += 1
    end

    if (n == nmax_iter)
        @warn "The maximum number of iterations ($nmax_iter) has been reached"
        return nothing
    end

    return x
end


x0 = 4.0
println("f(x) = x^2 - 17, df(x) = 2x, x0 = $x0")
delta(x) = -(x^2-17)/(2*x)
println("\tnewton(...) = $(newton(delta, x0))")
println()

x0 = 6.0
println("f(x) = x^2 - 17, df(x) = 2x, x0 = $x0")
delta(x) = -(x^2-17)/(2x)
println("\tnewton(...) = $(newton(delta, x0))")
println()

x0 = 3.0
println("f(x) = x^2 - 17, df(x) = 2x, x0 = $x0")
delta(x) = -(x^2-17)/(2x)
println("\tnewton(...) = $(newton(delta, x0))")
println()

x0 = 0.0
println("f(x) = x^3 + x - 2, df(x) = 3x^2 + 1, x0 = $x0")
delta(x) = -(x^3+x-2)/(3x^2+1)
println("\tnewton(...) = $(newton(delta, x0))")
println()

x0 = pi
println("f(x) = cos(x) - x, df(x) = -sin(x) - 1, x0 = $x0")
delta(x) = -(cos(x)-x)/(-sin(x)-1)
println("\tnewton(...) = $(newton(delta, x0))")
println()
