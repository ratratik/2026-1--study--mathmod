using DifferentialEquations
using Plots

a1 = 0.4

b1 = 0.8

c1 = 0.5

h1 = 0.7

function P1(t)
    return sin(t) + 1
end

function Q1(t)
    return cos(t) + 1
end

x0_1 = 20000.0

y0_1 = 9000.0

u0_1 = [x0_1, y0_1]

function regular_war!(du, u, p, t)
    x, y = u
    du[1] = -a1 * x - b1 * y + P1(t)
    du[2] = -c1 * x - h1 * y + Q1(t)
end

t0_1 = 0.0

tmax_1 = 1.0

tspan_1 = (t0_1, tmax_1)

prob1 = ODEProblem(regular_war!, u0_1, tspan_1)

sol1 = solve(prob1, Tsit5(), saveat = 0.05)

plot(sol1,
     vars = (0, 1),           # (0,1) означает: по оси X — время, по оси Y — первая переменная
     label = "x(t) — армия X", # подпись для легенды
     lw = 2,                   # толщина линии
     color = :blue,            # цвет линии
     title = "Модель 1: боевые действия между регулярными войсками",
     xlabel = "Время t",
     ylabel = "Численность армии")

plot!(sol1,
      vars = (0, 2),           # (0,2) означает: по оси X — время, по оси Y — вторая переменная
      label = "y(t) — армия Y",
      lw = 2,
      color = :red)

plot!(grid = true)

display(plot!())

a2 = 0.1

b2 = 0.3

c2 = 0.002

h2 = 0.05

function P2(t)
    return 5.0
end

function Q2(t)
    return 2.0
end

x0_2 = 1000.0

y0_2 = 300.0

u0_2 = [x0_2, y0_2]

function mixed_war!(du, u, p, t)
    x, y = u
    du[1] = -a2 * x - b2 * y + P2(t)
    du[2] = -c2 * x * y - h2 * y + Q2(t)
end

tmax_2 = 10.0
tspan_2 = (0.0, tmax_2)

prob2 = ODEProblem(mixed_war!, u0_2, tspan_2)

sol2 = solve(prob2, Tsit5(), saveat = 0.1)

plot(sol2,
     vars = (0, 1),
     label = "x(t) — регулярная армия",
     lw = 2,
     color = :blue,
     title = "Модель 2: регулярные войска против партизан",
     xlabel = "Время t",
     ylabel = "Численность")

plot!(sol2,
      vars = (0, 2),
      label = "y(t) — партизанский отряд",
      lw = 2,
      color = :green)

plot!(grid = true)

display(plot!())

a3 = 0.02

b3 = 0.001

c3 = 0.001

h3 = 0.02

function P3(t)
    return 1.0
end

function Q3(t)
    return 1.0
end

x0_3 = 500.0

y0_3 = 400.0

u0_3 = [x0_3, y0_3]

function partisan_war!(du, u, p, t)
    #Извлечение текущих численностей
    x, y = u
    du[1] = -a3 * x - b3 * x * y + P3(t)
    du[2] = -h3 * y - c3 * x * y + Q3(t)
end

tmax_3 = 20.0
tspan_3 = (0.0, tmax_3)

prob3 = ODEProblem(partisan_war!, u0_3, tspan_3)

sol3 = solve(prob3, Tsit5(), saveat = 0.2)

plot(sol3,
     vars = (0, 1),
     label = "x(t) — партизаны X",
     lw = 2,
     color = :blue,
     title = "Модель 3: партизанские отряды друг против друга",
     xlabel = "Время t",
     ylabel = "Численность")

plot!(sol3,
      vars = (0, 2),
      label = "y(t) — партизаны Y",
      lw = 2,
      color = :orange)

plot!(grid = true)

display(plot!())
