def y(a, b, x) -> float:
    return a + b * x ** 4


def main():
    precision = 0.0001
    a = float(input("Введите действительное число a: "))
    b = float(input("Введите действительное число b: "))
    begin = float(input("Введите действительное число begin - начало отрезка: "))
    end = float(input(f"Введите действительное число end - конец отрезка (не меньше begin + {precision}): "))

    if begin + precision > end:
        print(f"begin + {precision} > end, неверно введённые данные")
        return

    current = begin
    summa = 0.0
    while current + precision <= end:
        summa += precision * max(y(a, b, current), y(a, b, current + precision))
        current += precision
    print(f"Интеграл равен: {summa}")
    return


main()
