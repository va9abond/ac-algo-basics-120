include("../inc/Utils.jl")


function selection_sort!(v::Vector{T}) where T
    swaps = 0

    @inbounds begin
        for i in eachindex(v)
            pos_min = i
            for j in i+1:lastindex(v)
                pos_min = (v[j] < v[pos_min]) ? j : pos_min
            end

            (i != pos_min) && (swap(v, i, pos_min); (swaps += 1))
        end
    end

    # println("selection sort, swaps: $(swaps)")
    return v
end

function x_selection_sort!(v::Vector{T}) where T
    swaps = 0

    upper_bound = lastindex(v)
    i = firstindex(v)
    @inbounds while (i < upper_bound)
        swapped = false
        pos_min = i
        for j in i:upper_bound-1
            (v[j] > v[j+1]) && (swapped = true) && (swap(v, j, j+1); (swaps += 1))
            pos_min = (v[j] < v[pos_min]) ? j : pos_min
        end

        (i != pos_min) && (swap(v, i, pos_min); (swaps += 1))
        (!swapped) && break

        upper_bound -= 1
        i += 1
    end

    # println("x-selection sort, swaps: $(swaps)")
    return v
end
