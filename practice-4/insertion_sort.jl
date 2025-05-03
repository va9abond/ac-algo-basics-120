function insertion_sort!(v::Vector{T}) where T
    @inbounds begin
        for i in firstindex(v)+1:lastindex(v)

            j = i-1
            vi = v[i]
            while j >= firstindex(v) && (vi < v[j])
                v[j+1] = v[j]
                j -= 1
            end
            v[j+1] = vi

        end
    end

    return v
end

