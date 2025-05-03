struct Sorted{T}
    vector::Vector{T}

    function Sorted(cont::AbstractVector{T}) where T
        if Base.issorted(cont) == false
            error("[ERROR] Sorted: cont must be sorted")
        end

        return new{T}(collect(cont))
    end

    function Sorted(cont::Vector{T}) where T
        if Base.issorted(cont) == false
            error("[ERROR] Sorted: cont must be sorted")
        end

        return new{T}(copy(cont))
    end

    Sorted(check::Val{false}, cont::Vector{T}) where T = new{T}(cont)

end

Base.print(v::Sorted) = Base.print(v.vector)
Base.println(v::Sorted) = Base.println(v.vector)
Base.firstindex(v::Sorted) = Base.firstindex(v.vector)
Base.lastindex(v::Sorted) = Base.lastindex(v.vector)
Base.eachindex(v::Sorted) = Base.eachindex(v.vector)
Base.getindex(v::Sorted, i::Int) = Base.getindex(v.vector, i)
Base.length(v::Sorted) = Base.length(v.vector)
Base.eltype(v::Sorted) = Base.eltype(v.vector)

function Issorted(
        v::AbstractVector;
        lt=isless,
        by=identity,
        rev::Bool=false,
    )

    comp = rev ? (a, b) -> lt(b, a) : lt

    issorted = true
    step = Int(div(length(v), 2))
    while step >= 1

        for i in firstindex(v):lastindex(v)-step
            if comp( by(v[i]), by(v[i+step]) ) == false
                issorted = false
                break
            end
        end

        !issorted && break
        step = Int(div(step, 2))
    end

    return issorted
end

Base.in(item::T, vector::Sorted{T}) where T = Base.insorted(item, vector)

function Base.insorted(
        x::T, v::Sorted{T};
        by=identity,
        lt=isless,
        rev::Bool=false,
    ) where T

    comp = rev ? (a, b) -> lt(b, a) : lt

    left  = firstindex(v)
    right = lastindex(v)
    while (left <= right)
        mid = left + Int(div(right-left, 2))

        if isequal( by(v[mid]), by(x) )
            return true
        elseif comp( by(v[mid]), by(x) )
            left = mid+1
        else
            right = mid-1
        end

    end

    return false
end

vec = [i for i in reverse(0:4:64)]
println("vec: $vec")
println()

println("is sorted vec: $(Issorted(vec))")
println("is sorted reverse(vec): $(Issorted(reverse(vec)))")
println("is reversed-sorted vec: $(Issorted(vec, rev=true))")
println()

s = Sorted(reverse(vec))
println("s: $s")
println()

println("is 20 in s: $(insorted(20, s))")
println("is 21 in s: $(insorted(21, s))")
