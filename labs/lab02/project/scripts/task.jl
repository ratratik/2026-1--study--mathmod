# # Лабораторная работа №2, вариант 52
# ## Преследование браконьерской лодки катером береговой охраны

using Plots

# ## Исходные данные

k = 17.4          # начальное расстояние между катером и лодкой, км
n = 4.9           # отношение скоростей (катер/лодка)
a = sqrt(n^2 - 1) # параметр спирали ≈ 4.797

# ## Расстояния, на которых катер переходит к спиральному движению
x1 = k / (n + 1)   # случай 1 (движение к полюсу)
x2 = k / (n - 1)   # случай 2 (проход через полюс)

println("x1 = $x1 км, x2 = $x2 км")

# ## Выбранные направления движения лодки
φ1 = π/3           # 60°
φ2 = 4π/3          # 240°

# ## Точки встречи
r1_meet = x1 * exp(φ1 / a)
r2_meet = x2 * exp((φ2 - π) / a)

println("Точка встречи в случае 1: r = $r1_meet км, θ = $φ1 рад")
println("Точка встречи в случае 2: r = $r2_meet км, θ = $φ2 рад")

# # Построение траектории для случая 1
# Прямолинейный участок: от начальной точки (k, 0) до (x1, 0)
θ_line1 = 0.0
r_line1 = range(x1, k, length=100)  # от меньшего к большему (движение к полюсу)
x_line1 = r_line1 .* cos(θ_line1)
y_line1 = r_line1 .* sin(θ_line1)

# Спиральный участок: от θ = 0 до φ1
θ_spiral1 = range(0, φ1, length=200)
r_spiral1 = x1 * exp.(θ_spiral1 / a)
x_spiral1 = r_spiral1 .* cos.(θ_spiral1)
y_spiral1 = r_spiral1 .* sin.(θ_spiral1)

# Траектория лодки: луч под углом φ1 от 0 до r1_meet
r_boat1 = range(0, r1_meet, length=100)
x_boat1 = r_boat1 .* cos(φ1)
y_boat1 = r_boat1 .* sin(φ1)

# # Построение траектории для случая 2
# Первый прямолинейный участок: от (k, 0) до полюса (0, 0)
r_line2a = range(0, k, length=100)  # от 0 до k (движение к полюсу)
x_line2a = r_line2a .* cos(0)
y_line2a = r_line2a .* sin(0)

# Второй прямолинейный участок: от полюса до (x2, π)
r_line2b = range(0, x2, length=100)
x_line2b = r_line2b .* cos(π)   # cos(π) = -1
y_line2b = r_line2b .* sin(π)   # sin(π) = 0

# Спиральный участок: от θ = π до φ2
θ_spiral2 = range(π, φ2, length=200)
r_spiral2 = x2 * exp.((θ_spiral2 .- π) / a)
x_spiral2 = r_spiral2 .* cos.(θ_spiral2)
y_spiral2 = r_spiral2 .* sin.(θ_spiral2)

# Траектория лодки: луч под углом φ2 от 0 до r2_meet
r_boat2 = range(0, r2_meet, length=100)
x_boat2 = r_boat2 .* cos(φ2)
y_boat2 = r_boat2 .* sin(φ2)

# # Визуализация для 1го случая
p1 = plot(title="Случай 1: катер движется к полюсу (θ₀=0)", aspect_ratio=:equal)
plot!(p1, x_line1, y_line1, label="Прямолинейный участок катера", color=:blue, linewidth=2)
plot!(p1, x_spiral1, y_spiral1, label="Спиральный участок катера", color=:green, linewidth=2)
plot!(p1, x_boat1, y_boat1, label="Траектория лодки (φ=60°)", color=:red, linewidth=2)
scatter!(p1, [x1], [0], label="Начало спирали", color=:blue, markershape=:circle)
scatter!(p1, [x_boat1[end]], [y_boat1[end]], label="Точка встречи", color=:black, markershape=:star)
xlabel!("x, км")
ylabel!("y, км")

# # Визуализация для 2го случая

p2 = plot(title="Случай 2: катер проходит через полюс (θ₀=π)", aspect_ratio=:equal)
plot!(p2, x_line2a, y_line2a, label="Прямолинейный участок к полюсу", color=:blue, linewidth=2)
plot!(p2, x_line2b, y_line2b, label="Прямолинейный участок от полюса", color=:cyan, linewidth=2)
plot!(p2, x_spiral2, y_spiral2, label="Спиральный участок катера", color=:green, linewidth=2)
plot!(p2, x_boat2, y_boat2, label="Траектория лодки (φ=240°)", color=:red, linewidth=2)
scatter!(p2, [-x2], [0], label="Начало спирали", color=:cyan, markershape=:circle)
scatter!(p2, [x_boat2[end]], [y_boat2[end]], label="Точка встречи", color=:black, markershape=:star)
xlabel!("x, км")
ylabel!("y, км")

# Отображение обоих графиков

plot(p1, p2, layout=(1,2), size=(1000,500))
savefig("trajectories.png")