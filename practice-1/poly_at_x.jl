#= Polynomials
if p(x) = ∑ᵢᵐcᵢxⁱ = c₀ + c₁⋅x¹ + … + cₘ⋅xᵐ then coeffs are [c₀, c₁, …, cₘ]
=#


include("../inc/Utils.jl")


"""
Вид многочлена в виде строки
"""
# TODO asc/desc print order
function show(cs::Vector{T}; var = :x) where T <: Number
    isempty(cs) && error("ERROR: show: coefficients vector is empty")

    p::String = string()
    for i in reverse(eachindex(cs))
        i == firstindex(cs)+1 && break

        if (!iszero(cs[i]))
            @inbounds p *= "$(cs[i])*$var^$i + "
        end
    end
    p *= string(first(cs))

    return p
end


"""
Вычисление значения многочлена в точке в лоб
"""
function poly_at_x_inspector(coeffs::Vector, x; debug_mode=false, io=stdout)
    value_type = promote_type(eltype(coeffs), typeof(x))
    debug_mode && send_debug_info(io, "p(x) = ", show(coeffs; var=:x))
    debug_mode && send_debug_info(io, "promoted type: $value_type")

    value = zero(value_type)
    x_pow = one(value_type)

    for c in coeffs
        value += c * x_pow
        x_pow *= x
    end

    return value
end


"""
Вычисление производной многочлена
"""
function poly_derived(cs::Vector{T}; debug_mode=false, io=stdout) where T
    debug_mode && send_debug_info(io, "p(x) = ", show(cs; var=:x))

    len = length(cs)

    len == 1 && return zeros(T, 1)

    cs_derived = zeros( promote_type(T, Int64), len )
    debug_mode && send_debug_info(io, "promoted type: $(promote_type(T, Int64))")
    for i in firstindex(cs):lastindex(cs)-1
        cs_derived[i] = cs[i+1]*i
    end

    n_end = findlast(!iszero, cs)
    debug_mode && send_debug_info(io,
      "p'(x) = ",
      show(cs_derived[firstindex(cs_derived):n_end-1]; var=:x)
    )
    return cs_derived[ firstindex(cs_derived):n_end-1 ]
end


"""
Вычисление многочлена в точке с помощью схемы Горнера
"""
function poly_at_x(coeffs::Vector, x; debug_mode=false, io=stdout)
    value_type = promote_type(eltype(coeffs), typeof(x))

    debug_mode && send_debug_info(io, "p(x) = ", show(coeffs; var=:x))
    debug_mode && send_debug_info(io, "promoted type: $value_type")

    value = zero(value_type)

    for c in reverse(coeffs)
        value = value*x + c
        # value = fma(value, x, c) # T <: Real
    end

    return value
end


"""
Вычисление значения многочлена и его производной в точке с помощью схемы Горнера
"""
function poly_derived_at_x(coeffs::Vector, x; debug_mode=false, io=stdout)
    value_type = promote_type(eltype(coeffs), typeof(x))

    debug_mode && send_debug_info(io, "p(x) = ", show(coeffs; var=:x))
    debug_mode && send_debug_info(io, "promoted type: $value_type")

    value = zero(value_type)
    value_derived = zero(value_type)

    for c in reverse(coeffs)
        value_derived = value_derived*x + value
        value = value*x + c
    end

    # value = reduce(*x + c, coeffs, init=zero(value_type))
    # value_derived = reduce( coeffs, init=zero(value_type))

    return value, value_derived
end

"""
Вычисление многочлена и его производной в точке в лоб
"""
function poly_derived_at_x_inspector(coeffs::Vector, x; debug_mode=false, io=stdout)
    debug_mode && send_debug_info(io, "p(x) = ", show(coeffs; var=:x))
    debug_mode && send_debug_info(io, "p'(x) = ", show(poly_derived(coeffs); var=:x))

    return poly_at_x(coeffs, x), poly_at_x(poly_derived(coeffs), x)
end
