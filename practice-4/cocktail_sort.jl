function swap(v::Vector{T}, i, j) where T
    @inbounds begin
        temp = v[i]
        v[i] = v[j]
        v[j] = temp
    end

    return nothing
end

# Bidirectional Bubble Sort (Shaker Sort or Cocktail Sort)
function cocktail_sort!(v::Vector{T}) where T
    lower_bound = firstindex(v)
    upper_bound = lastindex(v)
    swapped = false

    while (lower_bound < upper_bound)
        begin # v[--->]
            for i in lower_bound:upper_bound-1
                (v[i] > v[i+1]) && (swapped = true) && swap(v, i, i+1)
            end
        end
        (!swapped) && break
        upper_bound -= 1

        begin # v[<---]
            for i in reverse(lower_bound+1:upper_bound)
                (v[i] < v[i-1]) && (swapped = true) && swap(v, i, i-1)
            end
        end
        (!swapped) && break
        lower_bound += 1
    end

    return v
end
