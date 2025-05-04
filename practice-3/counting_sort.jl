function counting_sort!(v::Vector{Int64})
    min, max = extrema(v)
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


function test()
    vec = [3, 11, 21, 19, 28, 6, 24, 24, 21, 6, 18, 14, 10, 1, 18]
    println("vec: $(vec')")
    println("is sorted: $(Base.issorted(vec))")
    println()

    counting_sort!(vec)
    println("vec: $(vec')")
    println("is sorted: $(Base.issorted(vec))")
end
