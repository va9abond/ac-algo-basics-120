include("../inc/Utils.jl")

function shell_sort!(v::Vector{T}) where T

    size = length(v)
    step = Int(floor(size/2))
    while (step >= 1)
        @inbounds begin

            #= Insertion Sort (??) =#
            for i in firstindex(v)+step:lastindex(v)
                j = i-step
                vi = v[i]
                while (j >= firstindex(v) && vi < v[j])
                    v[j+step] = v[j]
                    j -= step
                end
                #= (j+step != i) && =# v[j+step] = vi
            end

            step = Int(floor(step/2))
        end
    end

end
