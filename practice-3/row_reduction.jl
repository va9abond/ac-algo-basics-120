@inline function swap!(A, B)
    @inbounds for i in eachindex(A)
        A[i], B[i] = B[i], A[i]
    end
end


"""
    Reduce a matrix A to (not reduced) row echelon form;
    if matrix A is squared the result is an upper triangular form.
"""
function reduce_down(A::AbstractMatrix; eps=1e-7)
    return reduce_down!(copy(A); eps=eps)
end

function reduce_down!(A::AbstractMatrix; eps=1e-7)
    for row in 1:size(A, 1)

        pivot, drow = findmax(abs, @view A[row:end, row])
        # isapprox(pivot, zero(eltype(A)); atol=eps) && throw("Matrix is not invertible")
        isapprox(pivot, zero(eltype(A)); atol=eps) && continue

        pr = row+drow-1 # pivot row, pivot = A[pr, pr]
        pr != row && swap!( view(A, row, :), view(A, pr, :) )
                   # swap!(@view(A[k,k:end]), @view(A[k+Δk-1,k:end]))

        for i in row+1:size(A,1)
            t = A[i,row]/A[row,row]
            @views A[i, row:end] .= A[i, row:end] .- t .* A[row, row:end]

            # if element after transforming is too small make it zero
            # foreach/map(@view A[i, row:end]) do x
            #     if isapprox(x, zero(eltype(A)); atol=eps)
            #         x = zero(eltype(A))
            #     end
            for k in row:size(A, 2)
                if isapprox(A[i,k], zero(eltype(A)); atol=eps)
                    A[i,k] = zero(eltype(A))
                end
            end
        end

    end

    return A
end


"""
    Reduce a matrix A to (not reduced) row echelon form;
    if matrix A is squared the result is an lower triangular form.
"""
function reduce_up(A::AbstractMatrix; eps=1e-7)
    return reduce_up!(copy(A); eps=eps)
end

function reduce_up!(A::AbstractMatrix; eps=1e-7)
    row = size(A, 1)
    col = size(A, 2)
    while (row >= 1) && (col >= 1)

        pivot, pivot_row = findmax(abs, @view A[begin:row, col])
        isapprox(pivot, zero(eltype(A)); atol=eps) && (col -= 1; continue)
        # TODO this ^^^ line should moves on the bottom of the matrix

        pivot_row != row && swap!( view(A, row, :), view(A, pivot_row, :) )

        for i in 1:row-1
            t = A[i,col]/A[row,col]
            @views A[i, begin:col] .= A[i, begin:col] .- t .* A[row, begin:col]

            for k in 1:col-1
                if isapprox(A[i,k], zero(eltype(A)); atol=eps)
                    A[i,k] = zero(eltype(A))
                end
            end
        end

        row -= 1
        col -= 1
    end

    return A
end


""" Reducing the matrix to a diagonal form """
function diagonal(A::AbstractMatrix; eps=1e-7)
    return diagonal!(copy(A); eps=eps)
end

# XXX smth goes wrong
function diagonal!(A::AbstractMatrix; eps=1e-7)
    size(A, 1) != size(A, 2) && throw("[ERROR] The matrix is not square")

    # Reduce down --> upper triangular form
    for row in 1:size(A, 1)

        pivot, drow = findmax(abs, @view A[row:end, row])
        isapprox(pivot, zero(eltype(A)); atol=eps) && throw("Matrix is not diagonalizable")

        pr = row+drow-1 # pivot row, pivot = A[pr, pr]
        pr != row && swap!( view(A, row, :), view(A, pr, :) )

        for i in row+1:size(A,1)
            t = A[i,row]/A[row,row]
            @views A[i, row:end] .= A[i, row:end] .- t .* A[row, row:end]

            for k in row:size(A, 2)
                if isapprox(A[i,k], zero(eltype(A)); atol=eps)
                    A[i,k] = zero(eltype(A))
                end
            end
        end

    end

    # Reduce up --> lower triangular form
    for r in reverse(1:size(A,1))

        pivot = A[r,r]
        isapprox(pivot, zero(eltype(A)); atol=eps) && throw("Matrix is not diagonalizable")

        for i in 1:r-1
            t = A[i,r]/A[r,r]
            @views A[i, begin:r] .= A[i, begin:r] .- t .* A[r, begin:r]

            for k in 1:r-1
                if isapprox(A[i,k], zero(eltype(A)); atol=eps)
                    A[i,k] = zero(eltype(A))
                end
            end
        end

    end

    return A
end

# - [ ] Rational specialization
# - [ ] reduce down by rows
# - [ ] reduce down by cols


function transform_to_steps!(A::AbstractMatrix; epsilon = 1e-7)
    @inbounds for k ∈ 1:size(A, 1)
        absval, Δk = findmax(abs, @view(A[k:end,k]))
        # (absval <= epsilon) && throw("Вырожденая матрица")
        (absval <= epsilon) && continue
        Δk > 1 && swap!(@view(A[k,k:end]), @view(A[k+Δk-1,k:end]))
        for i ∈ k+1:size(A,1)
            t = A[i,k]/A[k,k]
            @. @views A[i,k:end] = A[i,k:end] - t * A[k,k:end]
        end
    end
    return A
end


function diag()
    # A::Matrix{Float64} = [1  2  0;
    #                       0  3  0;
    #                       2 -4  2]
    A::Matrix{Float64} = [-1  2  -3;
                          -2  7  9;
                          -8  5  0]
    display(A)
    diagonal!(A)
    display(A)
end

function test(f::Function)

    A::Matrix{Float64} = [1 2 3;
                          0 5 6;
                          0 0 9]
    display(A)
    f(A)
    display(A)

    println()
    println()

    B::Matrix{Float64} = [0 0 1 0;
                          0 0 0 1;
                          1 0 0 0;
                          0 1 0 0;]
    display(B)
    f(B)
    display(B)

    println()
    println()

    C::Matrix{Float64} = [0 0 1 0;
                          1 0 0 0;
                          0 1 0 0;]
    display(C)
    f(C)
    display(C)

    println()
    println()

    D::Matrix{Float64} = [0 0 1 0;
                          1 0 0 0;
                          0 1 0 0;
                          0 0 0 0;]
    display(D)
    f(D)
    display(D)

    println()
    println()

    E::Matrix{Float64} = [1 2 3 4;
                          3 5 0 0;
                          4 8 9 0;]
    display(E)
    f(E)
    display(E)

end
