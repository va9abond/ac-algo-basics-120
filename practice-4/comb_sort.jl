function comb_sort!(v::Vector{T}; factor=1.247) where T
    step = length(v) - 1
    while (step >= 1)
        for i in firstindex(v):lastindex(v)-step
            v[i] > v[i+step] && swap(v, i, i+step)
        end
        step = Int(floor(step/factor))
    end
end
