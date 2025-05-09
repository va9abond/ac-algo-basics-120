""" Polynomials

        p(x) = ∑ᵢᵐcᵢxⁱ = c₀ + c₁⋅x¹ + … + cₘ⋅xᵐ, coeffs = [c₀, c₁, …, cₘ]

    Polynomials in real life are
        p(x) = ∑ᵢcᵢxⁱ = c₀ + c₁⋅x¹ + … + cₘ⋅xᵐ + 0⋅xᵐ¹ + 0⋅...
        coeffs = [c₀, c₁, …, cₘ, 0, 0, …]

    Poly{T, X}(coeffs::AbstractVector{T}, [var = :x])

    Construct a polynomial from its coefficients `coeffs`, lowest order first,
    optionally in terms of the given variable `var` which may be a character or
    symbol.

    The usual arithmetic operators are overloaded to work with polynomials as
    well as with combinations of polynomials and scalars.

    Examples

    julia> Poly([1, 0, 3, 4])
    Poly(1 + 3*x^2 + 4*x^3)

    julia> Poly([1, 2, 3], :s)
    Poly(1 + 2*s + 3*s^2)

    julia> one(Poly)
    Poly(1.0)

    julia> zero(Poly)
    Poly()
"""
struct Poly{T, X}
    coeffs::Vector{T}

    function Poly{T, X}(coeffs::AbstractVector{T}) where {T, X}
        # println("ctor: Poly{T, X}(coeffs)")
        # ind the last non zero coeff (highest polymomial degree)
        last_non_zero = findlast(!iszero, coeffs)
        isnothing(last_non_zero) && return new{T, X}(T[zero(T)])

        cs = T[coeffs[i] for i in firstindex(coeffs):last_non_zero]
        return new{T, X}(cs)
    end

    function Poly(coeffs::AbstractVector{T}, var=:x) where T
        # println("ctor: Poly(coeffs, var)")
        return Poly{T, var}(coeffs)
    end

    # non-copy alternative
    function Poly{T, X}(copy::Val{false}, coeffs::AbstractVector{T}) where {T, X}
        # println("ctor: Poly{T, X}(Val{false}, coeffs)")
        @assert iszero(coeffs[end]) == false
        return new{T, X}(coeffs)
    end

end

# choose rigth constructor (default or non-copying) to create poly
function __construct_poly(cs::AbstractVector{T}, X) where T
    isempty(cs) && return Poly{T, X}(Val(false), cs)
    return iszero( cs[end] ) ? Poly{T, X}(cs) : Poly{T, X}(Val(false), cs)
end



#= Utils =#

# __typealias(::Type{P}) where {T, X, P <: Poly{T, X}} = "Poly{$T, $X}"
__typealias(::Type{P}) where {T, X, P <: Poly{T, X}} = "Poly"

coeffs(p::P)   where {T, X, P <: Poly{T, X}} = p.coeffs
__coeffs(p::P) where {T, X, P <: Poly{T, X}} = Tuple(p.coeffs)

# Base.iszero(p::P)     where {T, X, P <: Poly{T, X}} = all(iszero, values(p))
Base.copy(p::P)       where {T, X, P <: Poly{T, X}} = P(Val(false), copy(p.coeffs))
Base.length(p::P)     where {T, X, P <: Poly{T, X}} = length(p.coeffs)
Base.size(p::P)       where {T, X, P <: Poly{T, X}} = (length(p), )
Base.eltype(p::P)     where {T, X, P <: Poly{T, X}} = T
Base.firstindex(p::P) where {T, X, P <: Poly{T, X}} = firstindex(p.coeffs)
Base.lastindex(p::P)  where {T, X, P <: Poly{T, X}} = lastindex(p.coeffs)
Base.eachindex(p::P)  where {T, X, P <: Poly{T, X}} = eachindex(p.coeffs)

deg(p::P) where {T, X, P <: Poly{T, X}} = iszero(coeffs(p)) ? 0 : findlast(!iszero, coeffs(p))-1

# XXX
Base.zero(::Type{Poly{T, X}}) where {T, X} = Poly{T, X}(Val(false), T[zero(T)])
Base.one(::Type{Poly{T, X}})  where {T, X} = Poly{T, X}(Val(false), T[one(T)])
Base.iszero(p::P) where {T, X, P <: Poly{T, X}} = all(iszero, p.coeffs)

function truncate!(p::P) where {T, X, P <: Poly{T, X}}
    newlen = findlast(!iszero, p.coeffs)

    if isnothing(newlen)
        newlen = 1
    end

    resize!(p.coeffs, newlen)
end

function truncate(p::P) where {T, X, P <: Poly{T, X}}
    return Poly{T, X}(p.coeffs)
end



#= Print Poly =#

function showop(io, op)
    d = Dict(
         "*" => "*",
         "+" => " + ",
         "-" => " - ",
    )
    return print(io, get(d, op, ""))
end

function showterm0(io::IO, cj)
    print(io, cj)
    return nothing
end

function showterm(io::IO, cj, var, j)
    print(abs(cj))
    showop(io, "*")
    print("$(var)^$(j)")
    return nothing
end

function printpoly(io::IO, p::P; var=X) where {T, X, P <: Poly{T, X}}
    isempty(coeffs(p)) && return nothing

    for i in eachindex(p)
        i == firstindex(p) && showterm0(io, coeffs(p)[i])
        i != firstindex(p) && showterm(io, coeffs(p)[i], var, i-1)
        i != lastindex(p)  && showop(io, isless(coeffs(p)[i+1], zero(T)) ? "-" : "+")
    end

    return nothing
end

function Base.show(io::IO, p::P) where {T, X, P <: Poly{T, X}}
    print(io, __typealias(P))
    print(io, "(")
    printpoly(io, p)
    print(io, ")")
end

Base.print(io::IO, p::P) where {T, X, P <: Poly{T, X}} = printpoly(io, p; var=X)



#= Arithmetic =#

function Base.:+(p::P, a::S) where {T, X, P <: Poly{T, X}, S <: Number}
    if (isempty(p.coeffs))
        cs = promote_type(T, S)[a]
    else
        promoted_t = typeof(p.coeffs[begin] + a)
        cs = promoted_t[c for c in p.coeffs]
        cs[begin] += a
    end

    return __construct_poly(cs, X)
end

function Base.:+(p1::P1, p2::P2) where {T, X, P1 <: Poly{T, X},
                                        R,    P2 <: Poly{R, X}}
    promoted_t = promote_type(T, R)
    n1, n2 = length(p1), length(p2)

    if (n1 == n2)
        @views cs = p1.coeffs .+ p2.coeffs
        return __construct_poly(cs, X)
    elseif (n1 > n2)
        cs = promoted_t[c for c in p1.coeffs]
        cs[begin:n2] .+= p2.coeffs
    else
        cs = promoted_t[c for c in p2.coeffs]
        cs[begin:n1] .+= p1.coeffs
    end

    return Poly{promoted_t, X}(Val(false), cs)
end

function Base.:-(p::P) where {T, X, P <: Poly{T, X}}
    return Poly{T, X}(Val(false), -copy(p.coeffs))
end

function Base.:-(p::P, a::S) where {T, X, P <: Poly{T, X}, S <: Number}
    return p + (-a)
end

function Base.:-(a::S, p::P) where {T, X, P <: Poly{T, X}, S <: Number}
    return a + (-p)
end

function Base.:-(p1::P1, p2::P2) where {T, X, P1 <: Poly{T, X},
                                        R,    P2 <: Poly{R, X}}
    return p1 + (-p2)
end

function scalar_mult(p::P, a::S) where {T, X, P <: Poly{T, X}, S <: Number}
    promoted_t = promote_type(T, S)

    iszero(a) && return Poly{promoted_t, X}(Val(false), promoted_t[])
    return __construct_poly(promoted_t[c*a for c in p.coeffs], X)
end

function scalar_mult(a::S, p::P) where {T, X, P <: Poly{T, X}, S <: Number}
    promoted_t = promote_type(T, S)

    iszero(a) && return Poly{promoted_t, X}(Val(false), promoted_t[])
    return __construct_poly(promoted_t[c*a for c in p.coeffs], X)
end

function Base.:*(p1::P, p2::P) where {T, X, P <: Poly{T, X}}
    cs = zeros(T, length(p1)+length(p2)-1)

    for i in eachindex(p1)
        for j in eachindex(p2)
            cs[i+j-1] += p1.coeffs[i] * p2.coeffs[j]
        end
    end

    return Poly{T, X}(Val(false), cs)
end



"""
                f = g*q + r,
        deg(r) = 0 or deg(r) < deg(g)

deg(f) = deg(g) + deg(q) ==> deg(q) = deg(f) - deg(g)
"""
function Base.divrem(f::P, g::P) where {T, X, P <: Poly{T, X}}
    deg_q = deg(f) - deg(g)

    if deg_q < 0
        # q = 0, r = f;
        # f = g*0 + f
        return zero(P), copy(f)
    else
        deg_g = deg(g)
        deg_fk = deg(f)

        q = zeros(T, deg_q+1)
        fk = copy(f.coeffs)
        @inbounds while deg_fk >= deg_g
            t = fk[deg_fk+1] / g.coeffs[end]

            deg_qk = deg_fk - deg_g
            q[deg_qk + 1] = t

            @views fk[deg_fk+1-deg_g:deg_fk+1] .-= t .* g.coeffs

            iszero(fk) && break
            deg_fk = findlast(!iszero, fk)-1
        end

        return Poly{T,X}(Val(false), q), __construct_poly(fk, X)
        #      ^ div                     ^ rem
    end
end

function Base.div(f::P, g::P) where {T, X, P <: Poly{T, X}}
    return divrem(f, g)[1]
end

function Base.rem(f::P, g::P) where {T, X, P <: Poly{T, X}}
    return divrem(f, g)[2]
end

Base.mod(f::P, g::P) where {T, X, P <: Poly{T, X}} = rem(f, g)
