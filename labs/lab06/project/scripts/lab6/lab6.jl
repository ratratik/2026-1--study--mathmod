using DifferentialEquations, Plots, LaTeXStrings
gr()

println("\n" * "="^60)
println("СЦЕНАРИЙ А: I(0) ≤ I* (эпидемия не начинается сразу)")
println("="^60)

α_A = 0.01      # коэффициент заболеваемости
β_A = 0.02      # коэффициент выздоровления
N_A = 2000      # общая численность популяции
I_star_A = 200  # критическое число инфицированных

I0_A = 100      # I(0) = 100 ≤ I* = 200
R0_A = 0        # начальное количество с иммунитетом
S0_A = N_A - I0_A - R0_A  # S0 = 1900

println("Параметры модели:")
println("α = $α_A  (коэффициент заболеваемости)")
println("β = $β_A  (коэффициент выздоровления)")
println("N = $N_A  (общая численность популяции)")
println("I* = $I_star_A  (критическое число инфицированных)")

println("\nНачальные условия:")
println("S(0) = $S0_A  (восприимчивые)")
println("I(0) = $I0_A  (инфицированные)")
println("R(0) = $R0_A  (с иммунитетом)")
println("I(0) = $I0_A ≤ I* = $I_star_A → эпидемия не начинается")

function epidemic!(du, u, p, t)
    α, β, I_star = p
    S, I, R = u

    if I > I_star
        du[1] = -α * S
        du[2] =  α * S - β * I
    else
        du[1] = 0.0
        du[2] = -β * I
    end
    du[3] = β * I
end

tspan_A = (0.0, 200.0)
u0_A = [S0_A, I0_A, R0_A]
params_A = (α_A, β_A, I_star_A)

prob_A = ODEProblem(epidemic!, u0_A, tspan_A, params_A)
sol_A = solve(prob_A, saveat=0.5)

t_A = sol_A.t
S_A = [u[1] for u in sol_A.u]
I_A = [u[2] for u in sol_A.u]
R_A = [u[3] for u in sol_A.u]

println("\n" * "="^60)
println("СЦЕНАРИЙ Б: I(0) > I* (эпидемия начинается)")
println("="^60)

α_B = 0.01      # коэффициент заболеваемости
β_B = 0.02      # коэффициент выздоровления
N_B = 2000      # общая численность популяции
I_star_B = 100  # критическое число инфицированных

I0_B = 300      # I(0) = 300 > I* = 100
R0_B = 0        # начальное количество с иммунитетом
S0_B = N_B - I0_B - R0_B  # S0 = 1700

println("Параметры модели:")
println("α = $α_B  (коэффициент заболеваемости)")
println("β = $β_B  (коэффициент выздоровления)")
println("N = $N_B  (общая численность популяции)")
println("I* = $I_star_B  (критическое число инфицированных)")

println("\nНачальные условия:")
println("S(0) = $S0_B  (восприимчивые)")
println("I(0) = $I0_B  (инфицированные)")
println("R(0) = $R0_B  (с иммунитетом)")
println("I(0) = $I0_B > I* = $I_star_B → эпидемия начинается")

tspan_B = (0.0, 200.0)
u0_B = [S0_B, I0_B, R0_B]
params_B = (α_B, β_B, I_star_B)

prob_B = ODEProblem(epidemic!, u0_B, tspan_B, params_B)
sol_B = solve(prob_B, saveat=0.5)

t_B = sol_B.t
S_B = [u[1] for u in sol_B.u]
I_B = [u[2] for u in sol_B.u]
R_B = [u[3] for u in sol_B.u]

plot_A = plot(title="Сценарий А: I(0) ≤ I*",
              xlabel="Время t", ylabel="Численность особей",
              legend=:right, linewidth=2)

plot!(plot_A, t_A, S_A, label="S(t) - восприимчивые", color=:blue)
plot!(plot_A, t_A, I_A, label="I(t) - инфицированные", color=:red)
plot!(plot_A, t_A, R_A, label="R(t) - с иммунитетом", color=:green)

hline!(plot_A, [I_star_A], label="I* - критический уровень",
       color=:black, linestyle=:dash, linewidth=1.5)

plot_B = plot(title="Сценарий Б: I(0) > I*",
              xlabel="Время t", ylabel="Численность особей",
              legend=:right, linewidth=2)

plot!(plot_B, t_B, S_B, label="S(t) - восприимчивые", color=:blue)
plot!(plot_B, t_B, I_B, label="I(t) - инфицированные", color=:red)
plot!(plot_B, t_B, R_B, label="R(t) - с иммунитетом", color=:green)

hline!(plot_B, [I_star_B], label="I* - критический уровень",
       color=:black, linestyle=:dash, linewidth=1.5)

display(plot(plot_A, plot_B, layout=(1,2), size=(1200,500)))

println("\n" * "="^60)
println("Дополнительный анализ: влияние порогового значения I*")
println("="^60)

N_analysis = 2000
I0_analysis = 200
R0_analysis = 0
S0_analysis = N_analysis - I0_analysis - R0_analysis
α_analysis = 0.01
β_analysis = 0.02

I_star_values = [150, 200, 250]
labels = ["I* = 150 (I0 > I*)", "I* = 200 (I0 = I*)", "I* = 250 (I0 < I*)"]
colors = [:red, :green, :blue]

plot_I_comparison = plot(title="Влияние порогового значения I* на динамику инфицированных",
                         xlabel="Время t", ylabel="I(t) - инфицированные",
                         legend=:topright, linewidth=2)

for (I_star, label, color) in zip(I_star_values, labels, colors)
    params_comp = (α_analysis, β_analysis, I_star)
    prob_comp = ODEProblem(epidemic!, [S0_analysis, I0_analysis, R0_analysis], tspan_A, params_comp)
    sol_comp = solve(prob_comp, saveat=0.5)
    I_comp = [u[2] for u in sol_comp.u]
    plot!(plot_I_comparison, t_A, I_comp, label=label, color=color)
end

display(plot_I_comparison)

println("\n" * "="^60)
println("Анализ результатов")
println("="^60)

println("\nСценарий А (I(0) ≤ I*):")
println("• Эпидемия не начинается, так как начальное число инфицированных не превышает порог")
println("• Инфицированные особи только выздоравливают: dI/dt = -β·I")
println("• Число инфицированных экспоненциально убывает до нуля")
println("• Восприимчивые особи не заражаются, так как dS/dt = 0")
println("• Популяция постепенно переходит в состояние с иммунитетом (R растет за счет выздоровления)")

println("\nСценарий Б (I(0) > I*):")
println("• Эпидемия начинается, так как порог превышен")
println("• Сначала число инфицированных растет за счет заражения восприимчивых")
println("• Достигается пик эпидемии, после чего число инфицированных снижается")
println("• Восприимчивые особи активно заражаются, S(t) убывает")
println("• Формируется коллективный иммунитет, R(t) растет")
println("• В итоге эпидемия затухает, I(t) → 0")

println("\nКлючевые выводы:")
println("1. Пороговое значение I* играет критическую роль в развитии эпидемии")
println("2. Если I(0) ≤ I*, эпидемия не распространяется (карантинные меры эффективны)")
println("3. Если I(0) > I*, начинается эпидемический процесс")
println("4. В модели учитывается, что больные изолированы до превышения порога I*")
println("5. После превышения порога начинается активное распространение инфекции")
