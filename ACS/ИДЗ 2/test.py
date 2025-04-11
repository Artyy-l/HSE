def y(a, b, x):
    return a * x + b * (x ** 5) / 5


def integral(func, a, b, begin, end) -> float:
    return func(a, b, end) - func(a, b, begin)


def main():
    precision = 0.0001
    a = float(input("Введите действительное число a: "))
    b = float(input("Введите действительное число b: "))
    begin = float(input("Введите действительное число begin - начало отрезка: "))
    end = float(input(f"Введите действительное число end - конец отрезка (не меньше begin + {precision}): "))
		print("-" * 100)
		
    if begin + precision > end:
        print(f"begin + {precision} > end, неверно введённые данные")
        return

    print(f"Интеграл равен: {integral(y, a, b, begin, end)}")
    return


main()
