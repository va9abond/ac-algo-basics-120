""" Polynomials

        p(x) = ∑ᵢᵐcᵢxⁱ = c₀ + c₁⋅x¹ + … + cₘ⋅xᵐ, coeffs = [c₀, c₁, …, cₘ]

    Poly{T, X}(coeffs::AbstractVector{T}, [var = :x])

    Construct a polynomial from its coefficients `coeffs`, lowest order first,
    optionally in terms of the given variable `var` which may be a character or
    symbol.

    The usual arithmetic operators are overloaded to work with polynomials as
    well as with combinations of polynomials and scalars. However, operations
    involving two polynomials of different variables causes an error except
    those involving a constant polynomial.

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
struct Polynomial{T, X}
    coeffs::Vector{T}

    function Polynomial(coeffs::AbstractVector{T}) where T
        return Polynomial{T, :x}(coeffs)
    end

    function Polynomial{T, X}(coeffs::AbstractVector{S}) where {T, X, S}
        last_non_zero = findlast(!iszero, coeffs)

        isnothing(last_non_zero) && return new{T, X}(T[])

        cs = T[coeffs[i] for i in firstindex(coeffs):last_non_zero]
        return new{T, X}(cs)
    end

    # non-copying alternative assuming iszero(coeffs[end]) = false
    function Polynomial{T, X}(check::Val{false}, coeffs::AbstractVector{T}) where {T, X}
        new{T,X}(coeffs)
    end
end


# Poly{T, X} = Polynomial{T, X}

# faster than Polynomial(cs, X)
function _construct_poly(p::P, cs::S) where {T, X, S, P <: Polynomial{T, X}}
    PolySX = Polynomial{S, X}

    isempty(cs) && return PolySX(Val(false), cs)

    iszero(cs[end]) ? PolySX(cs) : PolySX(Val(false), cs)
    #                              ^^ non-copying CTOR
    #                 ^^ default CTOR (trim last zeros)
end

_typealias(::Type{P}) where {T, X, P <: Polynomial{T, X}} = "Polynomial"

coeffs(p::P) where {T, X, P <: Polynomial{T, X}} = p.coeffs

function Base.zero(::Type{P}) where {T, X, P <: Polynomial{T, X}}
    return Polynomial{T, X}(Val(false), T[])
end

function Base.one(::Type{P}) where {T, X, P <: Polynomial{T, X}}
    return Polynomial{T, X}(Val(false), T[one(T)])
end

function degree(p::P) where {T, X, P <: Polynomial{T, X}}
    return iszero(coeffs(p)) ? -1 : length(coeffs(c))-1
end

# evaluate p(0)
constantterm(p::P) where {T, X, P <: Polynomial{T, X}} = p(zero(T))

# is polynomial 'p' a constant
isconstant(p::P) where {T, X, P <: Polynomial{T, X}} = degree(p) <= 0

# Base.iszero(p::P) where {T, X, P <: Polynomial{T, X}} = all(iszero, values(p))::Bool

Base.all(pred, p::P) where {T, X, P <: Polynomial{T, X}} = all(pred, values(p))

Base.any(pred, p::P) where {T, X, P <: Polynomial{T, X}} = any(pred, values(p))

Base.length(p::P) where {T, X, P <: Polynomial{T, X}} = length(coeffs(p))

# Base.size(p::P) where {T, X, P <: Polynomial{T, X}} = (length(p),)

Base.eltype(p::P) where {T, X, P <: Polynomial{T, X}} = T

Base.firstindex(p::P) where {T, X, P <: Polynomial{T, X}} = firstindex(coeffs(p))

Base.lastindex(p::P) where {T, X, P <: Polynomial{T, X}} = lastindex(coeffs(p))

Base.eachindex(p::P) where {T, X, P <: Polynomial{T, X}} = eachindex(coeffs(p))


# scalar_add
function Base.:+(p::P, a::S) where {T, X, P <: Polynomial{T, X}, S <: Number}
    if (isempty(p.coeffs))
        cs = promote_type(T, S)[a]
    else
        R = typeof(c + p.coeffs[begin])
        cs = R[c for c in p.coeffs]
        cs[begin] += a
    end

    return _construct_poly(p, cs)
end


function Base.:+(p1::P1, p2::P2) where {T, X, P1 <: Polynomial{T, X},
                                        S,    P2 <: Polynomial{S, X}}
    n1, n2 = length(p1.coeffs), length(p2.coeffs)
    R = promote_type(T, S)
    PolyRX = Polynomial{R, X}

    if (n1 == n2)
        cs = R[p1.coeffs .+ p2.coeffs]
        return _construct_poly(p1, cs)
    elseif n1 > n2
        cs = R[c in p1.coeffs]
        cs[begin:n2] .+= p2.coeffs
    else
        cs = R[c in p2.coeffs]
        cs[begin:n1] .+= p1.coeffs
    end

    return PolyRX(Val(false), cs)
end


function scalar_mult(p::P, a::S) where {T, X, P <: Polynomial{T, X}, S <: Number}
    iszero(a) && return Polynomial{T, X}(Val(false), promote_type(T, S)[])
    return _construct_poly(p, [c*a for c in p.coeffs])
    # return _construct_poly( p, p.coeffs .* (c,) )
end


function scalar_mult(a::S, p::P) where {T, X, P <: Polynomial{T, X}, S <: Number}
    iszero(a) && return Polynomial{T, X}(Val(false), promote_type(T, S)[])
    return _construct_poly(p, [c*a for c in p.coeffs])
    # return _construct_poly( p, (c,) .* p.coeffs )
end


function Base.:*(p::P, q::P) where {T, X, P <: Polynomial{T, X}}
    deg_p, deg_q = degree(p), degree(q)
    cs = zeros(T, deg_p+deg_q+1)

    for i in firstindex(p) : deg_p+1
        for j in firstindex(q) : deg_q+1
            c[i+j-1] = coeffs(p)[i] * coeffs(q)[j]
        end
    end

    return Polymonial{T, X}(Val(false), cs)
end


Base.show(io::IO, p::P) where {T, X, P <: Polynomial{T, X}} = show(io, MIME("text/plain"), p)

function Base.show(io::IO, mimetype::MIME"text/plain", p::P) where {T, X, P <: Polynomial{T, X}}
    print(io, _typealias(P))
    print(io, "(")
    printpoly(io, p, mimetype)
    print(io, ")")
end

Base.print(io::IO, p::P) where {T, X, P <: Polynomial{T, X}} = printpoly(io, MIME("text/plain"), p, compact=true)

function showop(::MIME"text/plain", op)
    d = Dict(
         "*" => "*",
         "+" => " + ",
         "-" => " - ",
         "l-" => "-"
    )
    get(gd, op, "")
end


function printpoly(io::IO, p::P, mimetype::MIME"text/plain";
                   descending_powers=false,
                   var=X,
                   compact=false,
                   mulsymbol="*") where {T, X, P <: Polynomial{T, X}}

    if (isempty(coeffs(p)))
        print(io, " ")
    else
        for i in (descending_powers ? reverse(eachindex(p)) : eachindex(p))
            i == firstindex(p) && showterm0(io, coeffs(p)[i])
            i != firstindex(p) && showterm(io, coeffs(p)[i], var, i)
            i != lastindex(p)  && print(io, " + ")
        end
    end

    return nothing
end

function showterm(io::IO, pj::T, var, j) where T
    print(io, "$(pj)*$(var)^$(j)")
    return true
end

function showterm0(io::IO, pj::T) where T
    print(io, "$(pj)")
    return true
end


# printcoefficient(io::IO, pj::Any, j, mimetype) = Base.show_unquoted(io, pj, , Base.operator_precedence(:*))
# function printcoefficient(io::IO, pj::Any, j, mimetype)
# end

# show j-th term: p(x) = c0 + c1*x^1 + ... + cj*x^j + ... + cm*x^m
#                                           |______|
#                                          j-th term
# function showterm()
#     
# end

# Base.show(io::IO, p::Polynomial) = show(io, MIME("text/plain"), p)
# function Base.show(io::IO, mimetype::MIME"text/plain", p::P) where {P<:Polynomial}
#     print(io, _typealias(P))
#     print(io, "(")
#     printpoly(io, p, mimetype)
#     print(io,")")
# end

# print uses compact representation
# Base.print(io::IO, p::AbstractPolynomial) = printpoly(io, p, MIME("text/plain"), compact=true)

# function printpoly(io::IO, p::P, mimetype=MIME"text/plain"();
#                    descending_powers=false,
#                    mulsymbol="*") where {T,P<:Polynomial{T, X}}
#     first = true
#     printed_anything = false
#     for i in (descending_powers ? reverse(eachindex(p)) : eachindex(p))
#         # ioc = IOContext(io,
#         #                 :compact=>get(io, :compact, compact),
#         #                 :multiplication_symbol => get(io, :multiplication_symbol, mulsymbol)
#         #                 )
#         printed = showterm(ioc, P, p[i], var, i+offset, first, mimetype)
#         first &= !printed
#         printed_anything |= printed
#     end
#
#     printed_anything || print(io, zero(eltype(T)))
#
#     return nothing
# end


# function printpoly()
# end

# Base.show(io::IO, p::Polynomial) = show(io, MIME("text/plain"), p)

# function Base.show(io::IO, mimetype::MIME("text/plain"), p::Polynomial)
#     print(io, _typealias(P))
#     print(io, "(")
#     printpoly(io, p, mimetype)
#     print(io,")")
# end


# p(0.5)
# function (p::Polynomial)(x)
#     general_type = promote_type(eltype(coeffs), typeof(x))
#     value = zero(general_type)
#
#     for c in p.coeffs
#         value = value*x + c
#     end
#
#     return value
# end

# TODO
# - Base.copy(p::Poly{T, X}) where {T, X} = Poly{T, Var(X)}(copy(p.coeffs))
