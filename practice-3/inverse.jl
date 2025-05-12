function inverse(M::AbstractMatrix)

    size(M, 1) != size(M, 2) && throw("[ERROR] The matrix is not square")

    I = zeros(eltype(M), size(M))
    for i in 1:size(M, 1)
        I[i,i] = one(eltype(M))
    end

    A = copy(M)
    #= Forward Gauss–Jordan elimination =#
    for row in 1:size(A, 1)

        pivot, drow = findmax(abs, @view A[row:end, row])
        isapprox(pivot, zero(eltype(A)); atol=eps) && throw("Matrix is not invertible")

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

    Check the diagonal! function

    return 
end
