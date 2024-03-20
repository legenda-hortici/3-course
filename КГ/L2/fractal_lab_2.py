import matplotlib.pyplot as plt
from matplotlib.widgets import Button
from math import cos, sin, pi

# Функция для преобразования строки в соответствии с правилами
def apply_rules(input_string):
    output_string = ""
    for char in input_string:
        if char == 'F':
            output_string += 'F+F+F++++F+F+F'
        else:
            output_string += char
    return output_string

# Функция для построения фрактала
def draw_fractal(axiom, rules, iterations):
    fractal = axiom
    for _ in range(iterations):
        fractal = apply_rules(fractal)
    return fractal

# Функция для отображения фрактала
def display_fractal(iterations):
    axiom = 'F++++F'
    rules = {'F': 'F+F+F++++F+F+F'}

    ax.clear()  # Очистка текущего графического окна

    x, y = 0, 0
    x_values, y_values = [x], [y]
    angle = 0

    fractal = draw_fractal(axiom, rules, iterations)
    for char in fractal:
        if char == 'F':
            x_new = x + cos(angle)
            y_new = y - sin(angle)
            x_values.extend([x, x_new])
            y_values.extend([y, y_new])
            x, y = x_new, y_new
        elif char == '+':
            angle += pi / 4

    ax.plot(x_values, y_values, 'k', linewidth=0.5)  # Установка тонкости линии
    ax.axis('equal')
    ax.axis('off')
    ax.set_title(f'Итерация {iterations}')
    plt.draw()

def next_iteration(event):
    global current_iterations
    if current_iterations < 5:
        current_iterations += 1
        display_fractal(current_iterations)

def previous_iteration(event):
    global current_iterations
    if current_iterations > 1:
        current_iterations -= 1
        display_fractal(current_iterations)

current_iterations = 1

fig, ax = plt.subplots()
plt.subplots_adjust(bottom=0.2)
display_fractal(current_iterations)

# Создание кнопки для выполнения следующей итерации
ax_next_button = plt.axes([0.7, 0.05, 0.2, 0.1])
next_button = Button(ax_next_button, 'Следующая')
next_button.on_clicked(next_iteration)

# Создание кнопки для выполнения предыдущей итерации
ax_prev_button = plt.axes([0.5, 0.05, 0.2, 0.1])
prev_button = Button(ax_prev_button, 'Предыдущая')
prev_button.on_clicked(previous_iteration)

plt.show()
