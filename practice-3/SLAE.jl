include("row_reduction.jl")

""" Solve the System of Linear Algebraic Equations AX = B."""
function solve(A::AbstractMatrix, B::AbstractMatrix)
    size(B, 2) != 1 && throw("[ERROR] Matrix B must be a column vector")
    size(A, 1) != size(B, 1) && throw("[ERROR] The sizes of the matrices A and B are not consistent")

    # reduce down A|B
    AB = hcat(A,B)
    rkA = 0
    for row in 1:size(A, 1)-1

        pivot, drow = findmax(abs, @view A[row:end, row])
        isapprox(pivot, zero(eltype(A)); atol=eps) && continue
        rkA += 1

        pr = row+drow-1 # pivot row, pivot = A[pr, pr]
        pr != row && swap!( view(A, row, :), view(A, pr, :) )

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

    n = size(A, 2) # columns (amount of variables)
    rkAB = findlast(!iszero, @view B[begin:end, 1])
    if rkA < rkAB
        throw("SLAE has no solutions")
        # return nothing
        # return Vector{eltype(A)}(undef, n)
    end
    # vvv rkA = rkAB

    if rkA == n
        X = zeros(eltype(A), n, 1)

        for i in reverse(1:n)
            X[i] = (
                    B[i]-sum(
                             @views AB[i, i:end] .* X[i:end]
                             )
                   ) / AB[i,i]

            if isapprox(X[i], zero(eltype(A)); atol=eps)
                X[i] = zero(eltype(A))
            end
        end

        return X

    else
        

        # infinitely many solutions

    end

    # fsr = zeros(eltype(AB), n)
    fsr = Dict()
    


    return fsr
end
