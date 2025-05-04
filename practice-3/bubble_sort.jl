function bubble_sort!(
        v::Vector{T};
        comp::Function=isless,
        by=identity,
        order=:Forward # | :Forward | :Reverse |
    ) where T

    upper_bound = lastindex(v)-1
    sorted = false
    while (firstindex(v) < upper_bound)
        @inbounds for i in firstindex(v):upper_bound
            comp(by(v[i+1]), by(v[i])) && @inbounds begin
                temp   = v[i+1]
                v[i+1] = v[i]
                v[i]   = temp

                sorted = true
            end
        end

        !sorted && break
        sorted = false

        upper_bound -= 1
    end

    order == :Forward && return v
    return reverse!(v)
end

function bubble_sort(
        v::Vector{T};
        comp=isless,
        by=identity,
        order=:Forward
    ) where T
    return bubble_sort!(copy(v); comp=comp, by=by, order=order)
end

function bubble_sort_perm!(
        v::Vector{T};
        comp::Function=isless,
        by=identity,
        order=:Forward # | :Forward | :Reverse |
    ) where T

    upper_bound = lastindex(v)-1
    perm = collect(firstindex(v):lastindex(v))
    sorted = false
    while (firstindex(v) < upper_bound)
        @inbounds begin
            for i in firstindex(v):upper_bound
                comp(by(v[i+1]), by(v[i])) && @inbounds begin
                    temp   = v[i+1]
                    v[i+1] = v[i]
                    v[i]   = temp

                    sorted = true
                    perm[i], perm[i+1] = perm[i+1], perm[i]
                end
            end
        end

        !sorted && break
        sorted = false

        upper_bound -= 1
    end

    order == :Forward && return perm
    return reverse!(perm)
end

function bubble_sort_perm(
        v::Vector{T};
        comp::Function=isless,
        by=identity,
        order=:Forward # | :Forward | :Reverse |
    ) where T
    return bubble_sort_perm!(copy(v); comp=comp, by=identity, order=order)
end

function permutate_vector(v::Vector{T}, inds::Vector{Int64}) where T
    assert(length(v) == length(inds))
    return [v[i] for i in inds]
end

function test()
    v  = [8, 0, 1, 3, 2, 7, 4, 5, 9, 6]
    vn = [-8, 0, -10, 3, -20, 7, 4, 5, 9, 6]

    println(v)
    println(vn)
    println()

    println(bubble_sort(v))
    println(bubble_sort(v; order=:Reverse))
    println(bubble_sort(vn; by=abs))
    println()

    inds = bubble_sort_perm(v)
    println(inds)
    println(permutate_vector(v, inds))
end
