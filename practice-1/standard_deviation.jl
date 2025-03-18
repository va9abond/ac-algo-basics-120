include("../inc/Utils.jl")


function standard_deviation_inspector(
        vec::Vector{T}; debug_mode=false, io=stdout
    ) where T

    sum = Base.sum(vec; init=zero(T))
    len = length(vec)
    mean = sum / len
    std_dev2 = Base.sum(v->(v-mean)^2, vec) / len

    debug_mode && send_debug_info(io, "sum = $sum, len = $len, mean = $mean")
    # debug_mode && send_debug_info(io, map(v->(v-mean)^2, vec))
    # debug_mode && send_debug_info(io, Base.sum(map(v->(v-mean)^2, vec)))

    return (
            Base.sqrt(std_dev2),
            mean
           )
end


# F(a₁,..., aₘ) --> (sigma, mean)
function standard_deviation_v1(
        vec::Vector{T}; debug_mode=false, io=stdout
    ) where T
    sum1 = sum2 = zero(T)
    len = zero(UInt64)

    for a in vec      # |
        sum1  += a    # | Inductive expansion of F
        sum2  += a^2  # | G(a₁,..., aₘ) --> (sum₁, sum₂, len)
        len += 1      # |
    end               # |

    mean = sum1/len

    debug_mode && send_debug_info(io, "sum1 = $sum1, sum2 = $sum2, len = $len, mean = $mean")

    # A = (a₁,..., aₘ)
    # F(a₁,..., aₘ) = P(G(a₁,..., aₘ)) = P( op(G(a₁,..., a\_{m-1}), aₘ) )
    return (sqrt(sum2/len - mean^2), mean)
end


function standard_deviation_v2(
        vec::Vector{T}; debug_mode=false, io=stdout
    ) where T

    sum1  = reduce(+, vec, init=zero(T))
    sum2  = reduce(+, map(v->v^2, vec), init=zero(T))
    # len = reduce(x->1, +, vec, init=zero(UInt64))
    # len = UInt64{ sizeof(vec)/sizeof(T) }
    len = length(vec)
    mean = sum1/len

    debug_mode && send_debug_info(io, "sum1 = $sum1, len = $len, mean = $mean, sum2 = $sum2")

    return (sqrt(sum2/len - mean^2), mean)
end


function standard_deviation(m_array)
    s1 = s2 = zero(eltype(vector))
    len = zero(UInt64)

    for A in m_array
        s1 .+= A   # @. s1 += A
        s2 .+= A^2 # @. s2 += A^2
        len += 1
    end

    # @. (sqrt(s2/len - (s1/len)^2), s1/len)
    return (sqrt.(s2./len .- (s1./len).^2), s1./len)
end
