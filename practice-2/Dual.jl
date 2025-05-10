"""
    Dual numbers
"""
struct Dual{T <: Real}
    a::T
    b::T

    # function Dual{T}(a::T, b::T) where T
    #     return new{T}(a, b)
    # end
    #
    # function Dual(a::T, b::T) where T
    #     return new{T}(a, b)
    # end
    #
    # function Dual(a::T) where T
    #     return new{T}(a, zero(T))
    # end

end

function promote(x::T, y::S) where {T, S}
    promoted_t = promote_type(T, S)
    return (convert(promoted_t, x), convert(promoted_t, y))
end

Base.convert(::Type{Dual{T}}, x::Dual) where T = Dual{T}(x.a, x.b)
Base.convert(::Type{Dual{T}}, x::S) where {T, S <: Real} = Dual{T}(x, zero(x))

Base.promote_rule(::Type{Dual{T}}, ::Type{Dual{S}}) where {T, S} = Dual{promote_type(T, S)}
Base.promote_rule(::Type{Dual{T}}, ::Type{S}) where {T, S <: Real} = Dual{promote_type(T, S)}



Base.zero(::Type{Dual{T}}) where T = Dual(zero(T), zero(T))
Base.one(::Type{Dual{T}}) where T = Dual(one(T), zero(T))



Base.:+(d1::D, d2::D) where {T, D <: Dual{T}} = Dual(d1.a + d2.a, d1.b + d2.b)
Base.:+(x::Dual, y::Real) = +(promote(x, y)...)
Base.:+(x::Real, y::Dual) = +(promote(x, y)...)

Base.:-(d::Dual) = Dual(-d.a, -d.b)
Base.:-(d1::D, d2::D) where {T, D <: Dual{T}} = d1 + (-d2)
Base.:-(d::Dual, s::Real) = -(promote(d, s)...)
Base.:-(s::Real, d::Dual) = -(promote(d, s)...)

Base.:*(d1::D, d2::D) where {T, D <: Dual{T}} = Dual(d1.a * d2.a, d1.b*d2.a + d1.a*d2.b)
Base.:*(d::Dual, s::Real) = *(promote(d, s)...)
Base.:*(s::Real, d::Dual) = *(promote(d, s)...)

Base.:/(d1::D, d2::D) where {T, D <: Dual{T}} = Dual(d1.a / d2.a, (d1.b*d2.a - d1.a*d2.b)/(d2.a*d2.a))
Base.:/(d::D, s::S) where {T, D <: Dual{T}, S <: Real} = /(promote(d, s)...)
Base.:/(s::S, d::D) where {T, D <: Dual{T}, S <: Real} = /(promote(d, s)...)

Base.sin(d::D) where {T, D <: Dual{T}} = Dual(sin(d.a), cos(d.b))
Base.cos(d::D) where {T, D <: Dual{T}} = Dual(cos(d.a), -sin(d.b))
Base.tan(d::D) where {T, D <: Dual{T}} = Dual( tan(d.a), 1/(cos(d.b)*cos(d.b)) )
Base.cot(d::D) where {T, D <: Dual{T}} = Dual( cot(d.a), 1/(-sin(d.b)*sin(d.b)) )

Base.exp(d::D) where {T, D <: Dual{T}} = Dual( exp(d.a), exp(d.a)*d.b ) # XXX ??
Base.log(d::D) where {T, D <: Dual{T}} = Dual( log(d.a), d.b/d.a )

Base.:^(d::D, n::Int) where {T, D <: Dual{T}} = Dual( d.a^n, d.b * n*d.a^(n-1) )


f(x) = 3 + x*log(x^2)
df(x) = log(x^2) + 2
x = 5

println("f(x) = ", f(x))
println("df(x) = ", df(x))

# d = Dual(3.0, 0.0) + Dual(5.0, 1.0) * log(Dual(5.0, 1.0)^2)
# println("d.a = $(d.a)")
# println("d.b = $(d.b)")

d = Dual(5.0, 1.0)
println("f(d) = $(f(d))")



function valdiff(f::Function, x::T) where T <: Real
    x = Dual(x, one(x))
    d = f(x)
    return d.a, d.b
end


function newthon(f::Function, x0; atolf=1e-8, atolx=1e-8, nmax_iter=20)
    iter = 0
    xn = x0
    xn_1 = x0
    while (iter < nmax_iter)
        fxn_1, dfxn_1 = valdiff(f, xn_1)
        isless( abs(fxn_1), atolf ) && break

        xn = xn_1 - fxn_1/dfxn_1

        isless( abs(xn_1 - xn), atolx ) && break
        xn_1 = xn
        iter += 1
    end

    iter == nmax_iter && printstyled("[INFO] iter == nmax_iter\n", color:red)

    return xn
end

x0 = 4.0
println("f(x) = x^2 - 17, x0 = $x0")
println("\tnewthon(...) = $(newthon(x->x^2-17, x0))")
println()
