.include "macrolib.s"
.data
	sum:    	       .double 	0.0       # Итоговая сумма интеграла
	precision:      .double 	0.0001 	  # Точность
.text

# считывает вещественное число с клавиатуры и записывает его в регистр %x
.macro read_double(%x)
	li a7, 7           # Системный вызов для чтения double
    	ecall
    	fmv.d %x, fa0        # Копируем значение из f0 в регистр %x
.end_macro

# печатает число типа double из регистра %x
.macro print_double(%x)
	li a7, 3
    	fmv.d fa0, %x       # Копируем значение из регистра %x в f12 для печати
    	ecall
.end_macro

# сохраняет в регистр %z максимум из двух double'ов в регистрах %x и %y
.macro max(%x, %y, %z)
	flt.d t0, %x, %y       # Сравниваем %x и %y. t0 = 1, if %x < %y
    	fmv.d %z, %x           # Если t0 = 0, тозаписываем %x в %z
    	beqz t0, end          # Если %x >= %y (t0 = 0), пропускаем следующую инструкцию
    	fmv.d %z, %y           # Если %x < %y, записываем %x в %z
end:                          # Метка конца макроса
.end_macro

# считает значение y = %a + %b * (%x)⁴ и записывает в %y (all are double's)
.macro calc_y(%a, %b, %x, %y)
    	fmul.d ft0, %x, %x       # ft0 = %x * %x
    	fmul.d ft1, ft0, ft0     # ft1 = (%x)² * (%x)² = (%x)⁴
    	fmul.d ft2, %b, ft1      # ft2 = %b * (%x)⁴
    	fadd.d %y, %a, ft2       # %y = %a + %b * (%x)⁴
.end_macro


main:	
	print_str("Введите действительное число a: ")
	read_double(fs1)
	
	print_str("Введите действительное число b: ")
	read_double(fs2)
	
	print_str("Введите действительное число begin - начало отрезка: ")
	read_double(fs3)
	
	print_str("Введите действительное число end - конец отрезка (не меньше begin + 0.0001): ")
	read_double(fs4)
	
	# просто для красоты
	print_str("---------------------------------------------------------------------------------\n")
	
	# проверим, выполнено ли begin + 0.0001 <= end
	fld     fs5 precision t0		# Загружаем precision в fs5
	fadd.d   ft2 fs3 fs5		# ft2 = begin + precision
	fge.d 	t1 fs4 ft2		# t1 = 1 if end >= begin + precision, else t0 = 0

	# Если end < begin + precision
	beqz t1 incorrect_segment
	
	fld fs10 sum t0 			# Загружаем sum в fs10
	j loop
	
incorrect_segment:
	print_str("begin + 0.0001 > end, неверно введённые данные")
	exit
	
loop:
	# проверим, выполнено ли current + 0.0001 <= end
	fadd.d   ft2 fs3 fs5		# ft2 = current + precision
	fge.d 	t1 fs4 ft2		# t1 = 1 if end >= current + precision, else t0 = 0

	# Если end < current + precision
	beqz t1 print_result
	
	# Считаем значения функции на концах отрезка прямоугольника
	calc_y(fs1, fs2, fs3, fs6)	# fs6 = a + b * current⁴
	fadd.d   ft3 fs3 fs5		# ft3 = current + precision
	calc_y(fs1, fs2, ft3, fs7)	# fs7 = a + b * (current + precision)⁴
	
	# Площадь большего прямоугольника
	max(fs6, fs7, fs8)		# fs8 - наибольшое значение
	fmul.d fs9 fs8 fs5			# площадь fs9 = fs8 * precision

  # Обновление суммы
  fadd.d fs10, fs10, fs9
	j next_iter

next_iter:
	fadd.d   fs3 fs3 fs5		# fs3 = current + precision
	j loop

print_result:
	print_str("Интеграл равен: ")
	print_double(fs10)
	print_str("\n")
	j exit

exit:
	li a7, 10
	ecall
