include("../inc/Random.jl")
include("../inc/Utils.jl")


#= Loop Invariant
    k, m, l
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    |  |  |  |  |  |  |  |  |  |  |  |  |  |  |  |
    +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
     1  2  3  4  5  6  7  8  9  10 11 12 13 14 15

    | v[i] < P  |v[i] = P|    ???    |  v[i] > P |
    +-----------+--------+-----------+-----------+
    |1         k|k+1    l|l+1       m|m+1       n|

    Invariant:
        v[begin:k] < pv
        v[k+1  :l] = pv
        v[l+1  :m] = unsorted
        v[m+1:end] > pv
=#

function partition!(v, pv_pos)
    pv = v[pv_pos] # median element
    k = firstindex(v)-1
    for pos in eachindex(v)

        if (v[pos] <= pv)
            k += 1
            swap(v, k, pos)
        end

    end

    m = k+1
    while (m <= lastindex(v) && v[m] == pv)
        m += 1
    end

    return k, m
end

function quick_sort!(v)
    (length(v) < 2) && return v

    pv = v[begin + div(end-begin, 2)] # median element
    k = firstindex(v)-1
    for pos in eachindex(v)

        if (v[pos] <= pv)
            k += 1
            swap(v, k, pos)
        end

    end

    m = k+1
    while (m <= lastindex(v) && v[m] == pv)
        m += 1
    end

    quick_sort!( view(v, firstindex(v):k) )
    quick_sort!( view(v, m:lastindex(v) ) )

    return v
end

function quick_sort!(v)
    (length(v) < 2) && return v

    pv = v[rand(firstindex(v):lastindex(v))]

    k = firstindex(v)-1
    l = firstindex(v)-1
    m = lastindex(v)
    while (m > l)
        pos = l+1

        if (v[pos] == pv)
            l += 1
        elseif (v[pos] > pv)
            m -= 1
            swap(v, pos, m)
        else # v[pos] < pv
            k += 1
            l += 1
            swap(v, k, l)
        end
    end

    quick_sort!( view(v, firstindex(v):k) )
    quick_sort!( view(v, m+1:lastindex(v) ) )

    return v
end


vec = generate_vector_rand(1, 1:30, 15)
println(vec')
k, m = partition!(vec, lastindex(vec))
println("k: $k, m: $m")
println(vec')
println(vec[begin:k]')
println(vec[m:end]')
# quick_sort!(vec)
# println(vec'," sorted: $(Base.issorted(vec))")
