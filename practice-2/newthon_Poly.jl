include("../practice-1/Poly.jl")


function newthon(p::P, x0; atolf=1e-8, atolx=1e-8, nmax_iter=20) where {T, X, P <: Poly{T, X}}
    # x0 - начальное приближение корня функции f(x)
    # Пока не выполнено условие остановки итеративно приближаемся к значению корня функции

    iter = 0
    xn = x0
    xn_1 = x0
    while (iter < nmax_iter)
        pxn_1, dpxn_1 = gorner(p, xn_1)
        isless( abs(pxn_1), atolf ) && break

        xn = xn_1 - pxn_1/dpxn_1

        isless( abs(xn_1 - xn), atolx ) && break
        xn_1 = xn
        iter += 1
    end

    iter == nmax_iter && printstyled("[INFO] iter == nmax_iter\n", color:red)

    return xn
end

p = Poly([1.0, 1.0, 1.0, 1.0])
x0 = 0.0
println("p(x) = ", p)
println("\tnewthon(...) = $(newthon(p, x0))")
println()
