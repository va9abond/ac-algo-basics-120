function newton(delta::Function, x0; atolf=1e-8, atolx=1e-8, nmax_iter=20)
    # x0 - начальное приближение корня функции f(x)
    # Пока не выполнено условие остановки итеративно приближаемся к значению корня функции

    iter = 0
    xn = x0
    xn_1 = x0
    while (iter < nmax_iter)
        # fxn_1 = f(xn_1)
        isless( abs(fxn_1), atolf ) && break

        xn = xn_1 - delta(xn_1)

        isless( abs(xn_1 - xn), atolx ) && break
        xn_1 = xn
        iter += 1
    end

    iter == nmax_iter && printstyled("[INFO] iter == nmax_iter\n", color=:red)

    return xn
end

function delta(f::Function, df::Function, )

x0 = 4.0
println("f(x) = x^2 - 17, df(x) = 2x, x0 = $x0")
println("\tnewton(...) = $(newton(x->x^2-17, x->2x, x0))")
println()

x0 = 6.0
println("f(x) = x^2 - 17, df(x) = 2x, x0 = $x0")
println("\tnewton(...) = $(newton(x->x^2-17, x->2x, x0))")
println()

x0 = 3.0
println("f(x) = x^2 - 17, df(x) = 2x, x0 = $x0")
println("\tnewton(...) = $(newton(x->x^2-17, x->2x, x0))")
println()

x0 = 0.0
println("f(x) = x^3 + x - 2, df(x) = 3x^2 + 1, x0 = $x0")
println("\tnewton(...) = $(newton(x->x^3+x-2, x->3x^2+1, x0))")
println()

x0 = pi/4
println("f(x) = cos(x) - x, df(x) = -sin(x) - 1, x0 = $x0")
println("\tnewton(...) = $(newton(x->cos(x)-x, x->-sin(x)-1, x0))")
println()
