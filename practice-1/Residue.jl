include("gcd.jl")

struct Residue{M, T}
    rem::T

    function Residue{M}(x::T) where T  # <: Integer
        @assert typeof(M) == T 
        return new{M,T}(mod(x, M))
    end

    # function Residue{M}(x::T) where T <: AbstractFloat
    #     error("[ERROR]: denied T <: AbstractFloat")
    # end

    function Residue{M}(check::Val{false}, x::T) where T
        return new{T, M}(x)
    end

end

function construct_residue(M::T, x::T) where T
    return Residue{M}(false, x)
end

function Base. +=(lhs::T, rhs::T) where {M, T <: Residue{T, M}}
    return Residue{M}(lhs.rem + rhs.rem)
end

function Base. +=(lhs::T, rhs::S) where {S, M, T <: Residue{T, M}}
    return Residue{M}(lhs.rem + rhs)
end

function Base. +(lhs::Residue{T,M}, rhs::Residue{T,M}) where {T, M}
    return Residue{M}(lhs.rem + rhs.rem)
end

function Base. -(lhs::Residue{T,M}, rhs::Residue{T,M}) where {T, M}
    return Residue{M}(lhs.rem - rhs.rem)
end

function inverse(x::Residue{T,M}) where {T, M}
    gcd, u, v = cst_gcdx(x, M) # gcd(x, M) = gcd = x*u + M*v
    if (gcd != one(T))
        # error("[ERROR]: reminder is irreversible")
        return nothing
    else
        return Residue{M}(u)
    end
end
