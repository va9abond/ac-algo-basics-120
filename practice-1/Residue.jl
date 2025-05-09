include("gcd.jl")

# XXX Нужен ли здесь тип T. Ведь такой же тип имеет модуль M
struct Residue{M, T}
    rem::T

    function Residue{M}(x::T) where {M, T}
        # XXX А точно ли типы M и T должны совпадать? Как тогда сделать кольцо
        #     многочленов Z5[x]? Здесь же модуль это 5, а остаток это многочелен
        @assert typeof(M) == T
        return new{M, T}(mod(x, M))
    end

    function Residue{M}(check::Val{false}, x::T) where {M, T}
        return new{M, T}(x)
    end

end

function Base.:+(r1::R, r2::R) where {M, T, R <: Residue{M, T}}
    return Residue{M}(r1.rem + r2.rem)
end

function Base.:-(r1::R, r2::R) where {M, T, R <: Residue{M, T}}
    return Residue{M}(r1.rem - r2.rem)
end

function inverse(x::Residue{M, T}) where {M, T}
    gcd, u, v = cst_gcdx(x, M) # gcd(x, M) = gcd = x*u + M*v
    if (gcd != one(T))
        # error("[ERROR]: reminder is irreversible")
        return nothing
    else
        return Residue{M}(u)
    end
end
