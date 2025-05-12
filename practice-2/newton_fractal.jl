using GLMakie
using Colors

include("Dual.jl")


function newton(f::Function, x0; atolf=1e-8, atolx=1e-8, nmax_iter=100)
    iter = 0
    xn = x0
    xn_1 = x0
    while (iter < nmax_iter)
        fxn_1, dfxn_1 = valdiff(f, xn_1)
        isless( abs(fxn_1), atolf ) && break

        xn = xn_1 - fxn_1/dfxn_1

        isless( abs(xn_1 - xn), atolx ) && break
        xn_1 = xn
        iter += 1
    end

    # iter == nmax_iter && printstyled("[INFO] iter == nmax_iter\n", color=:red)

    iter == nmax_iter && return nothing
    return xn

end


function show_matrix(size_x=500, size_y=500; atol=1e-8)

    z1, z2, z3 = [exp(2im * pi*k/3) for k in 0:2]
    plot = zeros(RGB{Float64}, size_x, size_y)

    xmin, xmax = -3, 3
    ymin, ymax = -3, 3
    for i in 1:size(plot, 1)
        for j in 1:size(plot, 2)

            x = xmin + (xmax - xmin) * (j - 1) / (size_x - 1)
            y = ymin + (ymax - ymin) * (i - 1 ) / (size_y - 1 )

            z0 = ComplexF64(x, y)
            z = newton(x -> (x^3 - 1), z0)

            if isapprox(z, z1; atol=atol)
            # if abs(z - z1) < 0.3
                # plot[i,j] = RGB(0.237, 0.106, 0.90)
                plot[i,j] = RGBA(0.1, 0.0, 0.0, 1.0)
            elseif isapprox(z, z2; atol=atol)
                # plot[i,j] = RGB(0.244, 0.241, 0.187)
                plot[i,j] = RGBA(0.0, 0.1, 0.0, 1.0)
            elseif isapprox(z, z3; atol=atol)
                plot[i,j] = RGBA(0.0, 0.0, 0.1, 1.0)
                # plot[i,j] = RGB(0.155, 0.193, 0.188)
            else
                plot[i,j] = RGBA(1.0, 1.0, 1.0, 1.0)
            end
        end
    end

    fig = Figure(; size=(size_x,size_y))
    ax = Axis(fig[1,1]; aspect=DataAspect())
    image!(ax, plot)
end