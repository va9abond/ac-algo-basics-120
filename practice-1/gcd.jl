include("../inc/Utils.jl")

#= Greates Common Divisor
    1) gcd(a, b) = gcd(b, r), where a = b*q + r
    2) gcd(r, 0) = r

    NOTE We use a type T to indicate the equality a and b types
=#
function cst_gcd(a::T, b::T) where T
    # rn1, rn = a, b

    # INVARIANT gcd(a, b) = gcd(b, r), where r = mod(a, b)
    #           gcd(rn_1, rn) = gcd(rn, rn1)
    #           gcd(rn_1, rn) = gcd(rn, 0)
    while ( !iszero(b) )
        temp = b
        b = mod(a, b)
        a = temp
    end

    return a
end


#= Extended Euclidean Algorithm
    1) a,b ∈ Z
    2) a*b ≠ 0
    then ∃x,y ∈ Z: gcd(a, b) = xa + yb
=#
function cst_gcdex(a::T, b::T)::NTuple{3, T} where T
    rn, rn1 = a, b
    xn, xn1 = one(T), zero(T) # a = a*1 + b*0
    yn, yn1 = zero(T), one(T) # b = a*0 + b*1

    # INVARIANT rn = a*xn + b*yn
    #           rn1 = a*xn1 + b*yn1
    while ( !iszero(rn1) )
        qn, rn2 = divrem(rn, rn1) # rn1 = rn*qn + rn2

        rn, rn1 = rn1, rn2

        temp = xn1
        xn1 = xn - qn*xn1
        xn = temp

        temp = yn1
        yn1 = yn - qn*yn1
        yn = temp
    end

    return rn, xn, yn # gcd(a, b) = rn = a*xn + b*yn
end

function cst_gcdex(a::T, b::T)::NTuple{3, T} where T <: Real
    d, x, y = invoke(cst_gcdex, Tuple{T, T} where T <: Any, a, b)
    (d < 0) && return -d, -x, -y

    return d, x, y
end

