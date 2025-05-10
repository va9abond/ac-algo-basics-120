""" Метод бисекции
Поиск корня на _интеравале_ (a, b) с помощью дихотомии -
деления отрезка пополам.

Необходимое условие на функцию f:
    . Непрерывность на интервале (a, b)
"""
function bisect(f::Function, a=0.0, b=1.0; atolf=1e-8, atolx=1e-8, nmax_iter=40)
    interval_size = abs(a - b)
    m = a + interval_size / 2
    niter = 0

    while (niter < nmax_iter && isless(atolx, interval_size))
        fm = f(m)
        isapprox(fm, zero(Float64); atol=atolf) && return m

        if (xsign(f(a)) == xsign(fm)) # go right interval
            a, b = m, b
        else # go left interval
            a, b = a, m
        end
        interval_size /= 2
        m = a + interval_size

        niter += 1
    end

    printstyled("[INFO] iter == nmax_iter\n"; color=:red)
    return nothing
end

function is_equal_signs(x::T, y::T)::Int where { T <: Number }
    xsign(x) == xsign(y) && return 1
    return 0
end

function xsign(x::T)::Int where { T <: Number }
    isless(x, zero(T)) && return -1
    return 1
end

println("sin(x) on I=[-1.0, 1.0], x = $(bisect(sin, -1.0, 1.0))")
println("cos(x) on I=[-1.0, 2.0], x = $(bisect(cos, -1.0, 2.0))")
println("2x^2 + 3x - 2 = (x-1/2)(2x+4) on I=[0.0, 1.0], x = $(bisect(x->2x^2+3x-2, 0.0, 1.0))")
println("2x^2 + 3x - 2 = (x-1/2)(2x+4) on I=[-5.0, -1.0], x = $(bisect(x->2x^2+3x-2, -5.0, -1.0))")
println("2x^2 + 3x - 2 = (x-1/2)(2x+4) on I=[-10.0, -1.0], x = $(bisect(x->2x^2+3x-2, -10.0, -1.0; nmax_iter=150))")
println("sin(x) on I=[pi/2, 3pi/2], x = $(bisect(sin, pi/2, 3pi/2))")
