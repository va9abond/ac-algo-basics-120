function counting_sort!(v::Vector{Int64})
    min = findmin(v)[1]
    max = findmax(v)[1]
    size = max-min+1

    max_size = 1000
    size > max_size && return nothing

    counters = zeros(Int64, size)
    for val in v
        counters[val] += 1
    end

    i = firstindex(v)
    for (j, counter) in enumerate(counters)
        for k in 1:counter
            v[i] = j
            i += 1
        end
    end

    return v
    # v  = [8, 0, 1, 3, 2, 7, 4, 5, 9, 6]
end

function counting_sort(v::Vector{Int64})
    return counting_sort!(copy(v))
end

function main()
    v  = [8, 9, 6, 11, 1, 3, 1, 2, 1, 7, 8, 4, 7, 5, 9, 6]
    println(v)

    println()

    println(counting_sort(v))
end

