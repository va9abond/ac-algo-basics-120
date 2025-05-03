include("../inc/Utils.jl")


function merge_sort!(v::Vector{T}) where T
    """ Recursion Stop Condition """
    (length(v) <= 1) && return v

    left_first = firstindex(v) # left half first index
    right_last = lastindex(v)  # right half last index
    left_last  = left_first + div(length(v)-1, 2) # left half last index | mid

    """ Splitting """
    # left =  merge_sort!(view(v, left_first  : left_last))
    # right = merge_sort!(view(v, left_last+1 : right_last))
    left  = merge_sort!(v[left_first  : left_last]) # slice v[...] is a copy
    right = merge_sort!(v[left_last+1 : right_last]) # slice v[...] is a copy

    """ Merging """
    # v = merge(left, right)
    i = firstindex(left)
    j = firstindex(right)
    k = firstindex(v)
    @inbounds while (i <= lastindex(left) && j <= lastindex(right))
        if (left[i] < right[j])
            v[k] = left[i]
            i += 1
        else
            v[k] = right[j]
            j += 1
        end
        k += 1
    end

    @inbounds begin
        if (i <= lastindex(left))
            while (i <= lastindex(left))
                v[k] = left[i]
                i += 1
                k += 1
            end
        else
            while (j <= lastindex(right))
                v[k] = right[j]
                j += 1
                k += 1
            end
        end
    end

    return v
end

function merge(a::Vector{T}, b::Vector{T}) where T
    v = Vector{T}(undef, length(a)+length(b))

    i = firstindex(a)
    j = firstindex(b)
    k = firstindex(v)

    @inbounds while (i <= lastindex(a) && j <= lastindex(b))
        if (a[i] < b[j])
            v[k] = a[i]
            i += 1
        else
            v[k] = b[j]
            j += 1
        end
        k += 1
    end

    @inbounds begin
        if (i <= lastindex(a))
            # append!(v, view(a, i:lastindex(a)))
            while (i <= lastindex(a))
                v[k] = a[i]
                i += 1
                k += 1
            end
        else
            # append!(v, view(b, j:lastindex(b)))
            while (j <= lastindex(b))
                v[k] = b[j]
                j += 1
                k += 1
            end
        end
    end

    return v
end

""" Non recursive version of Merge Sort """
# function merge_sort(v::Vector{T}) where T
# end
