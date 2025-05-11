using GLMakie
using Colors

function bessel(x::T, α::Int64; atol=1e-8, nmax_iter=100) where T <: Union{Float32, Float64}
    J = zero(promote_type(T, big(Int64)))

    K = x*x / 4

    m = 0
    j = ((x/2)^α) / big(factorial(α)) # J (m = 0)
    while m < nmax_iter
        J += j
        m += 1

        j *= (-K) * ( 1 / (m*(m+α)) )
        # j = -j*K/m/(m+α)
        isless(abs(j), atol) && break
    end

    return J
end

function test()
    x_range = range(0, 40, length=700)

    J₀ = bessel.(x_range, 0)
    J₁ = bessel.(x_range, 1)
    J₂ = bessel.(x_range, 2)
    J₃ = bessel.(x_range, 3)

    figure = Figure()
    ax = Axis(figure[1,1], title="Bessel Function", xlabel="x", ylabel="Jₐ(x)")

    lines!(ax, x_range, J₀, color=:red,    linewidth=2, linestyle=:solid,   label="J₀")
    lines!(ax, x_range, J₁, color=:blue,   linewidth=2, linestyle=:dash,    label="J₁")
    lines!(ax, x_range, J₂, color=:green,  linewidth=2, linestyle=:dot,     label="J₂")
    lines!(ax, x_range, J₃, color=:purple, linewidth=2, linestyle=:dashdot, label="J₃")

    axislegend(ax,
              title="Legend: Jₐ",
              labelsize=20,
              framevisible=true
    )
    display(figure)
end
