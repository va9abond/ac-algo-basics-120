function bubble_sort!(v::Vector{T}) where T
    upper_bound = lastindex(v)-1
    swapped = false

    while (firstindex(v) < upper_bound)
        @inbounds for i in firstindex(v):upper_bound
            (v[i+1] < v[i]) && @inbounds begin
                temp   = v[i+1]
                v[i+1] = v[i]
                v[i]   = temp

                swapped = true
            end
        end

        (!swapped) && break
        swapped = false

        upper_bound -= 1
    end

    return v
end
