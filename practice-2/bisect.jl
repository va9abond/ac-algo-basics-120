""" Метод бисекции
Поиск корня на _интеравале_ (a, b) с помощью дихотомии -
деления отрезка пополам.

Необходимое условие на функцию f:
    . Непрерывность на интервале (a, b)
"""
function bisect(f::Function, a=0.0, b=1.0; atolf=1e-8, atolx=1e-8, nmax_iter=20)
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

    println("iter == nmax_iter")
    return nothing
end

function is_equal_signs(x::T, y::T)::Int where { T <: Number }
    x_sign(x) == x_sign(y) && return 1
    return 0
end

function xsign(x::T)::Int where { T <: Number }
    isless(x, zero(T)) && return -1
    return 1
end
