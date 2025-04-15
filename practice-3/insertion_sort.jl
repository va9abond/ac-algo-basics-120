function insertion_sort!(
        v::Vector{T};
        comp::Function=isless,
        by=identity,
        order=:Forward # | :Forward | :Reverse |
    ) where T

    @inbounds begin
        for i in firstindex(v)+1:lastindex(v)
            j = i-1
            vi = v[i]

            while j >= firstindex(v) && comp(by(vi), by(v[j]))
                v[j+1] = v[j]
                j -= 1
            end

            v[j+1] = vi
        end
    end

    (order == :Forward) && return v
    return reverse!(v)
end

function insertion_sort(
        v::Vector{T};
        comp::Function=isless,
        by=identity,
        order=:Forward # | :Forward | :Reverse |
    ) where T
    return insertion_sort!(copy(v); comp=comp, by=by, order=order)
end

function main()
    v  = [8, 0, 1, 3, 2, 7, 4, 5, 9, 6]
    vn = [-8, 0, -10, 3, -20, 7, 4, 5, 9, 6]

    println(v)
    println(vn)
    println()

    println(insertion_sort(v))
    println(insertion_sort(v; order=:Reverse))
    println(insertion_sort(vn; by=abs))
    println()
end
