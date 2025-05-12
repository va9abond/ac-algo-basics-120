using GLMakie
using Colors

function bessel(x::T, α::Int64) where T <: Number
    J, j = zero(T), zero(T)

    K = x*x / 4
    j = ((x/2)^α) / factorial(α) # J (m = 0)
    m = 0
    while J != (J+=j)
        m += 1
        j = -j*K/m/(m+α)
    end

    return J
end

function test()
    x_range = range(0.0, 50, length=700)

    # x_range = range(BigFloat(0.0), 50, length=700)
    # setprecision(BigFloat, 3000)

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
