# https://github.com/va9abond/ProgrammingManual_part2/blob/main/lecture_2_3.md#%D0%B0%D0%BB%D0%B3%D0%BE%D1%80%D0%B8%D1%82%D0%BC-%D0%B2%D1%8B%D1%87%D0%B8%D1%81%D0%BB%D0%B5%D0%BD%D0%B8%D1%8F-%D0%BB%D0%BE%D0%B3%D0%B0%D1%80%D0%B8%D1%84%D0%BC%D0%B0-%D1%87%D0%B8%D1%81%D0%BB%D0%B0-%D0%B1%D0%B5%D0%B7-%D0%B8%D1%81%D0%BF%D0%BE%D0%BB%D1%8C%D0%B7%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D1%8F-%D1%80%D0%B0%D0%B7%D0%BB%D0%BE%D0%B6%D0%B5%D0%BD%D0%B8%D1%8F-%D0%BB%D0%BE%D0%B3%D0%B0%D1%80%D0%B8%D1%84%D0%BC%D0%B8%D1%87%D0%B5%D1%81%D0%BA%D0%BE%D0%B9-%D1%84%D1%83%D0%BD%D0%BA%D1%86%D0%B8%D0%B8-%D0%B2-%D1%81%D1%82%D0%B5%D0%BF%D0%B5%D0%BD%D0%BD%D0%BE%D0%B9-%D1%80%D1%8F%D0%B4

# y' = log_a(x), |y' - y| <= eps
# d = y' - y
# a^y * z^t = x

# log_a(x)
function xlog(a, x; eps=10e-8)
    z = x
    t = 1
    y = 0

    # INVARIANT: a^y * z^t = x | a^0 * x^1 = x
    while z > a || z < 1/a || t > eps
        if z > a
            z /= a
            y += t
        elseif z < 1/a
            z *= a
            y -= t
        else
            t /= 2
            z *= z
        end
    end

    return y
end

println("log_2(8) = $(xlog(2, 8))")
println("log_3(81) = $(xlog(3, 81))")
println("log_4(16) = $(xlog(4, 16))")
println("log_5(5) = $(xlog(5, 25))")
println("log_5(0.20) = $(xlog(5, 0.20))")
println("log_5(0.04) = $(xlog(5, 0.04))")
