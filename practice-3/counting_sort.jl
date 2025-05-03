function counting_sort!(v::Vector{Int64})
    min = findmin(v)[1]
    max = findmax(v)[1]
    size, shift = max-min+1, min

    MAX_SIZE = 200000
    (size > MAX_SIZE) && return nothing

    buffer = zeros(Int64, size)
    for val in v
        @inbounds buffer[val-shift+1] += 1
    end


    # open("logs", "w") do log
    #     println(log, sort(v))
    #     println(log)
    #     println(log, "min: $(min), max: $(max), size = $(size)")
    #
    #     for (val, count) in enumerate(buffer)
    #         println(log, "[$(val)]: $(count)")
    #     end
    #
    #     println(log)
    # end

    i = firstindex(v)
    for (val, count) in enumerate(buffer)
        for _ in 1:count
            @inbounds v[i] = val + (shift-1)
            i += 1
        end
    end

    return v
end
