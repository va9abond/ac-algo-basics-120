include("row_reduction.jl")

function rank(A::AbstractMatrix; eps=1e-7)

    rank = 0 # amount of non zero columns
    for row in 1:size(A, 1)

        pivot, drow = findmax(abs, @view A[row:end, row])
        isapprox(pivot, zero(eltype(A)); atol=eps) && continue
        rank += 1

        pr = row+drow-1 # pivot row, pivot = A[pr, pr]
        pr != row && swap!( view(A, row, :), view(A, pr, :) )
                   # swap!(@view(A[k,k:end]), @view(A[k+Δk-1,k:end]))

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

    return rank
end

function test()
    A::Matrix{Float64} = [37 259 481 407;
                          19 133 247 209;
                          25 175 325 275]
    display(A)
    println("rk(A): $(rank(A))") # 1

    println(); println();


    B::Matrix{Float64} = [5 2 -1 4 3;
                          1 -3 2 0 1;
                          1 4 6 -1 -1;
                          3 -2 0 4 -9]
    display(B)
    println("rk(B): $(rank(B))") # 4

    println(); println();


    C::Matrix{Float64} = [1187 401 388 166;
                          153 -998 557 -23;
                          731 233 -1303 47]
    display(C)
    println("rk(C): $(rank(C))") # 3

    println(); println();


    D::Matrix{Float64} = [  3  9  21   3 -14 -21;
                          -12 -6 -12 -12   8  14;
                            6 -3  -9   6   6   7;
                           18 15   6  18  -4 -35]
    display(D)
    println("rk(D): $(rank(D))") # 3

    println();
end
