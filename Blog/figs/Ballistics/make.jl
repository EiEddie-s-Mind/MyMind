include("../../ballistic.jl")
import .ballistic: ballistic as bs
using LinearAlgebra
using Unitful, Plots
using Interpolations


function mv0(t, v0; Δt=0.02)
    len = floor(Int, t / Δt) + 1
    rxs = Vector{Float64}(undef, len)
    rys = Vector{Float64}(undef, len)
    r(t) = (v0[1] * t, v0[2] * t - g * t^2 / 2)
    enumerate(0:Δt:t) .|> (((i, t),) -> (rxs[i], rys[i]) = r(t))
    (rxs, rys)
end

function mv1(t, v0; Δt=0.02, μ=μ)
    len = floor(Int, t / Δt) + 1
    rxs = Vector{Float64}(undef, len)
    rys = Vector{Float64}(undef, len)
    r(t) = ((1. - exp(-t * μ)) / μ * v0[1],
            (1. - exp(-t * μ)) / μ * v0[2] + g * (1. - μ * t - exp(-t * μ)) / μ^2)
    enumerate(0:Δt:t) .|> (((i, t),) -> (rxs[i], rys[i]) = r(t))
    (rxs, rys)
end

function mv2(t, v0; Δt=0.02, κ=κ)
    len = floor(Int, t / Δt) + 1
    rxs = Vector{Float64}(undef, len)
    rys = Vector{Float64}(undef, len)
    rxs[1] = rys[1] = 0.

    v = v0
    for i in 2:len
        rxs[i], rys[i] = v*Δt
        rxs[i] += rxs[i-1]
        rys[i] += rys[i-1]

        a = -κ*norm(v)*v - [0.,g]
        v += a*Δt
    end
    (rxs, rys)
end

function v2(t, v0; Δt=0.02, κ=κ)
    v = v0
    for _ in 1:floor(Int, t / Δt)+1
        a = -κ*norm(v)*v - [0.,g]
        v += a*Δt
    end
    return v
end

μ_from_κ(κ, t, v0::Vector) = log(v0[1]/v2(t,v0,κ=κ)[1]) / t


g = 9.8
κ = 1e-2
μ = μ_from_κ(κ, 2., 20*[cos(pi/4), sin(pi/4)])
bs.env(g, μ, (-pi/6,pi/3))


if abspath(PROGRAM_FILE) == @__FILE__
    # 运动轨迹
    t  = 2.
    Δt = 0.02
    θ  = pi/6
    v  = 20.
    v0 = v * [cos(θ), sin(θ)]
    rv0 = mv0(t, v0, Δt=Δt)
    rv1 = mv1(t, v0, Δt=Δt)
    rv2 = mv2(t, v0, Δt=Δt)

    movement = plot(rv0[1], rv0[2], label="no resistance")
    plot!(movement, rv1[1], rv1[2], label="linear term resistance")
    plot!(movement, rv2[1], rv2[2], label="2nd-degree term resistance")
    # title!(movement, "movement tracks")
    plot!(movement, legend=:outerbottom)
    # display(movement)
    savefig(movement, "mv_tracks.png")


    # # 水平位移对比
    # # t 相同
    # t_s = 0:Δt:t
    # y_min = rv2[1][end] - rv0[1][end]
    # y_tick = 0.5

    # compare_x_when_t = plot(t_s*u"s", (rv2[1]-rv0[1])*u"m", yticks=0:-y_tick:y_min, label="2nd-degree minus none")
    # plot!(compare_x_when_t, t_s*u"s", (rv2[1]-rv1[1])*u"m", yticks=0:-y_tick:y_min, label="2nd-degree minus linear")
    # savefig(compare_x_when_t, "compare_x_when_t.png")


    # 轨道误差对比
    # x 相同
    rv0_curve = LinearInterpolation(rv0[1], rv0[2])
    rv1_curve = LinearInterpolation(rv1[1], rv1[2])
    rv2_curve = LinearInterpolation(rv2[1], rv2[2])

    x_max = minimum([rv0, rv1, rv2] .|> (v->v[1][end]))
    x_s = range(0., x_max, 100)
    Δy_12 = [rv2_curve(x) - rv1_curve(x) for x in x_s]
    Δy_02 = [rv2_curve(x) - rv0_curve(x) for x in x_s]
    y_min = Δy_02[end]
    y_tick = 0.3

    compare_y_when_x = plot(x_s*u"m", Δy_02*u"m", yticks=0:-y_tick:y_min, label="2nd-degree minus none")
    plot!(compare_y_when_x, x_s*u"m", Δy_12*u"m", yticks=0:-y_tick:y_min, label="2nd-degree minus linear")
    savefig(compare_y_when_x, "compare_y_when_x.png")


    # 目标函数图像
    rx, ry = [5., 0.5]
    gen_target(μ) = ψ -> ry - g * (μ * rx * sec(ψ) - v * log(v / (v - μ * rx * sec(ψ)))) / (v * μ^2) - rx * tan(ψ)
    gen_line(p1, p2) = x -> (p1[2]-p2[2])/(p1[1]-p2[1]) * (x-p1[1]) + p1[2]
    x_s = -pi/2+1e-1:0.05:pi/2-1e-2
    f = gen_target(0.01)

    θ_st_min =  atan(v^2, g * rx) - atan(rx * μ, sqrt(v^2 + rx^2 * ((g / v)^2 - μ^2)))
    i = findfirst(θ -> θ>θ_st_min, x_s)
    p1 = [x_s[begin], f(x_s[begin])]
    p2 = [x_s[i], f(x_s[i])]

    target_func = plot(x_s, x_s .|> f, label=missing)
    plot!(target_func, x_s[begin:i], x_s[begin:i] .|> gen_line(p1, p2), label=missing)
    plot!(target_func, x_s, repeat([0.],length(x_s)), label=missing, lc=:black)
    savefig(target_func, "target_func.png")
end
