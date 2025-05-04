include("row_reduction.jl")

function det(triangular::Val{true}, M::AbstractMatrix; eps=1e-7)

    det = one(eltype(M))
    for i in 1:size(M,1)
        det *= M[i,i]
    end

    if isapprox(det, zero(eltype(M)); atol=eps)
        return zero(eltype(M))
    end

    return det
end

function det(M::AbstractMatrix; eps=1e-7)
    size(M, 1) != size(M, 2) && throw("[ERROR] The matrix is not square")

    # reduce down
    swaps = 0
    A = copy(M)
    for row in 1:size(A, 1)

        pivot, drow = findmax(abs, @view A[row:end, row])
        isapprox(pivot, zero(eltype(A)); atol=eps) && return zero(eltype(M)) # found zero-column

        pr = row+drow-1 # pivot row, pivot = A[pr, pr]
        if pr != row
            swap!( view(A, row, :), view(A, pr, :) )
            # swap!(@view(A[k,k:end]), @view(A[k+Δk-1,k:end]))
            swaps += 1
        end

        for i in row+1:size(A,1)
            t = A[i,row]/A[row,row]
            @views A[i, row:end] .= A[i, row:end] .- t .* A[row, row:end]

            # if element after transforming is too small make it zero
            for k in row:size(A, 2)
                if isapprox(A[i,k], zero(eltype(A)); atol=eps)
                    A[i,k] = zero(eltype(A))
                end
            end
        end

    end

    det = one(eltype(A))
    for i in 1:size(A,1)
        det *= A[i,i]
    end

    if isapprox(det, zero(eltype(A)); atol=eps)
        return zero(eltype(M))
    end

    # return det * (-1)^swaps # which faster?
    return iseven(swaps) ? det : -det
end

function test()
    A::Matrix{Float64} = [3 3 3;
                          4 5 6;
                          7 8 9]
    display(A)
    println("det(A): $(det(A))") # 0
    println(); display(reduce_down(A))

    println(); println()

    B::Matrix{Float64} = [0  0 3;
                          1 10 6;
                          14 8 1]
    display(B)
    println("det(B): $(det(B))") # -396
    println(); display(reduce_down(B))

    println(); println()

    C::Matrix{Float64} = [0 -7 11;
                          2  9 33;
                          1  8  4]
    display(C)
    println("det(C): $(det(C))") # -98
    println(); display(reduce_down(C))

    println(); println()
end
