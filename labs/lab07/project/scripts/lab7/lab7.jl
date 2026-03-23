using DifferentialEquations, Plots, LaTeXStrings
gr()

N0 = 5          # начальное число знающих о салоне (в момент открытия)
N = 1000        # общее число потенциальных клиентов в районе
tspan = (0.0, 60.0)  # временной промежуток (дни)

println("\n" * "="^60)
println("Модель распространения рекламы: Салон красоты")
println("="^60)
println("N0 = $N0  (начальное число знающих клиентов)")
println("N = $N    (общее число потенциальных клиентов)")

println("\n" * "="^60)
println("Задание 1: График распространения рекламы")
println("="^60)

α₁_const = 0.055   # интенсивность платной рекламы (постоянная)
α₂_const = 0.0018  # интенсивность сарафанного радио (постоянная)

function advertising!(du, u, p, t)
    α₁, α₂, N_max = p
    n = u[1]
    du[1] = (α₁ + α₂ * n) * (N_max - n)
end

u0 = [Float64(N0)]
params_base = (α₁_const, α₂_const, N)

prob_base = ODEProblem(advertising!, u0, tspan, params_base)
sol_base = solve(prob_base, saveat=0.1)

t_vals = sol_base.t
n_vals = [u[1] for u in sol_base.u]

plot1 = plot(t_vals, n_vals,
             label="n(t) - число знающих клиентов",
             xlabel="Время t (дни)", ylabel="Число клиентов",
             title="Распространение рекламы о салоне красоты",
             linewidth=2, color=:blue)
hline!(plot1, [N], label="N = $N (потенциальный рынок)",
       color=:red, linestyle=:dash, linewidth=1.5)

display(plot1)

println("\n" * "="^60)
println("Задание 2: Сравнение эффективности рекламной кампании")
println("="^60)

α₁_dominant = 0.1
α₂_dominant = 0.002

α₁_weak = 0.02
α₂_weak = 0.008

params_dominant = (α₁_dominant, α₂_dominant, N)
prob_dominant = ODEProblem(advertising!, u0, tspan, params_dominant)
sol_dominant = solve(prob_dominant, saveat=0.1)
n_dominant = [u[1] for u in sol_dominant.u]

params_weak = (α₁_weak, α₂_weak, N)
prob_weak = ODEProblem(advertising!, u0, tspan, params_weak)
sol_weak = solve(prob_weak, saveat=0.1)
n_weak = [u[1] for u in sol_weak.u]

plot2 = plot(title="Сравнение эффективности рекламной кампании",
             xlabel="Время t (дни)", ylabel="Число знающих клиентов",
             legend=:bottomright, linewidth=2)

plot!(plot2, t_vals, n_dominant,
      label="α₁ = $α₁_dominant, α₂ = $α₂_dominant (α₁ > α₂)", color=:blue)
plot!(plot2, t_vals, n_weak,
      label="α₁ = $α₁_weak, α₂ = $α₂_weak (α₁ < α₂)", color=:green)
hline!(plot2, [N], label="N = $N", color=:red, linestyle=:dash, linewidth=1.5)

display(plot2)

println("\n" * "="^60)
println("Задание 3: Момент максимальной скорости роста")
println("="^60)

speed = [ (α₁_const + α₂_const * n) * (N - n) for n in n_vals ]

max_speed, idx_max = findmax(speed)
t_max_speed = t_vals[idx_max]
n_at_max_speed = n_vals[idx_max]

plot3 = plot(t_vals, speed,
             label="dn/dt - скорость распространения",
             xlabel="Время t (дни)", ylabel="Скорость роста",
             title="Скорость распространения информации",
             linewidth=2, color=:purple)

vline!(plot3, [t_max_speed], label="Максимальная скорость: t = $(round(t_max_speed, digits=2)) дн.",
       color=:red, linestyle=:dash, linewidth=1.5)

display(plot3)

println("\nРезультаты анализа скорости роста:")
println("Максимальная скорость распространения: $(round(max_speed, digits=2)) клиентов/день")
println("Время достижения максимальной скорости: $(round(t_max_speed, digits=2)) дней")
println("Количество знающих клиентов в этот момент: $(round(n_at_max_speed, digits=0)) из $N")

println("\n" * "="^60)
println("Задание 4: Только платная реклама (α₂ = 0)")
println("="^60)

α₁_only = 0.055
α₂_only = 0.0

params_only_paid = (α₁_only, α₂_only, N)
prob_only_paid = ODEProblem(advertising!, u0, tspan, params_only_paid)
sol_only_paid = solve(prob_only_paid, saveat=0.1)
n_only_paid = [u[1] for u in sol_only_paid.u]

plot4 = plot(t_vals, n_only_paid,
             label="n(t) - только платная реклама",
             xlabel="Время t (дни)", ylabel="Число знающих клиентов",
             title="Распространение рекламы (только платная)",
             linewidth=2, color=:orange)
hline!(plot4, [N], label="N = $N", color=:red, linestyle=:dash, linewidth=1.5)

display(plot4)

println("\n" * "="^60)
println("Задание 5: Только \"сарафанное радио\" (α₁ = 0)")
println("="^60)

α₁_word_of_mouth = 0.0
α₂_word_of_mouth = 0.005

params_only_word = (α₁_word_of_mouth, α₂_word_of_mouth, N)
prob_only_word = ODEProblem(advertising!, u0, tspan, params_only_word)
sol_only_word = solve(prob_only_word, saveat=0.1)
n_only_word = [u[1] for u in sol_only_word.u]

plot5 = plot(title="Сравнение различных стратегий рекламы",
             xlabel="Время t (дни)", ylabel="Число знающих клиентов",
             legend=:bottomright, linewidth=2)

plot!(plot5, t_vals, n_vals,
      label="Комбинированный: α₁ = $α₁_const, α₂ = $α₂_const", color=:blue)
plot!(plot5, t_vals, n_only_paid,
      label="Только платная реклама: α₁ = $α₁_only, α₂ = 0", color=:orange)
plot!(plot5, t_vals, n_only_word,
      label="Только сарафанное радио: α₁ = 0, α₂ = $α₂_word_of_mouth", color=:green)
hline!(plot5, [N], label="N = $N", color=:red, linestyle=:dash, linewidth=1.5)

display(plot5)

println("\n" * "="^60)
println("Дополнительный анализ: Сравнение с логистической кривой")
println("="^60)

r_logistic = 0.5
α₁_logistic = 0.0
α₂_logistic = r_logistic / N

params_logistic = (α₁_logistic, α₂_logistic, N)
prob_logistic = ODEProblem(advertising!, u0, tspan, params_logistic)
sol_logistic = solve(prob_logistic, saveat=0.1)
n_logistic = [u[1] for u in sol_logistic.u]

plot6 = plot(t_vals, n_logistic,
             label="Логистическая кривая (α₁ = 0, α₂ = r/N)",
             xlabel="Время t (дни)", ylabel="Число знающих клиентов",
             title="Логистическая модель распространения информации",
             linewidth=2, color=:magenta)
hline!(plot6, [N], label="N = $N", color=:red, linestyle=:dash, linewidth=1.5)

display(plot6)

println("\n" * "="^60)
println("АНАЛИЗ РЕЗУЛЬТАТОВ")
println("="^60)

println("\n1. Влияние коэффициентов α₁ и α₂:")
println("   • α₁ (платная реклама) - обеспечивает быстрый старт, линейный рост на начальном этапе")
println("   • α₂ (сарафанное радио) - создает эффект самовозрастания, ускоряет рост по мере увеличения числа знающих")

println("\n2. Сравнение стратегий:")
println("   • При α₁ > α₂: быстрый начальный рост, затем плавное насыщение")
println("   • При α₁ < α₂: медленный старт, но затем более крутой подъем благодаря эффекту виральности")

println("\n3. Максимальная скорость роста:")
println("   • Достигается при n = N/2 (половина потенциального рынка)")
println("   • В нашем примере: t = $(round(t_max_speed, digits=2)) дней")
println("   • Это момент наибольшей эффективности рекламной кампании")

println("\n4. Только платная реклама (α₂ = 0):")
println("   • Уравнение принимает вид: dn/dt = α₁·(N - n)")
println("   • Это модель Мальтуса с насыщением")
println("   • Решение: n(t) = N - (N - N₀)·exp(-α₁·t)")

println("\n5. Только сарафанное радио (α₁ = 0):")
println("   • Уравнение принимает вид: dn/dt = α₂·n·(N - n)")
println("   • Это логистическое уравнение")
println("   • Решение: n(t) = N / (1 + (N/N₀ - 1)·exp(-α₂·N·t))")

println("\n6. Практические рекомендации:")
println("   • На начальном этапе важна платная реклама для быстрого старта")
println("   • После достижения критической массы (≈30-50% рынка) сарафанное радио становится доминирующим")
println("   • Оптимальная стратегия: сочетание обоих каналов распространения")

plot_all = plot(title="Сравнение всех моделей распространения рекламы",
                xlabel="Время t (дни)", ylabel="Число знающих клиентов",
                legend=:bottomright, linewidth=2)

plot!(plot_all, t_vals, n_vals, label="Комбинированный", color=:blue)
plot!(plot_all, t_vals, n_only_paid, label="Только платная", color=:orange)
plot!(plot_all, t_vals, n_only_word, label="Только сарафанное радио", color=:green)
plot!(plot_all, t_vals, n_logistic, label="Логистическая", color=:magenta, linestyle=:dash)
hline!(plot_all, [N], label="N", color=:red, linestyle=:dash, linewidth=1.5)

display(plot_all)
