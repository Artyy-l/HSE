.include "macrolib.s"
.data
.align 2
	array: .space 64  	# Выделяем 64 байта (больше, чем надо) - это будет массив В
	arrend: 			# Граница массива
.text

# принимает число в регистре %x, кладёт |x| в регистр %y
.macro abs(%x, %y)
	bge %x, zero, positive   	# Если %x ≥ 0, переход к метке "positive"
    	neg %y, %x               # Иначе кладём -%x в %y  
    	j end_abs               # Переход к концу

	positive:
	    	mv %y, %x                # Сохраняем значение %x в %y
	
	end_abs:
.end_macro

main:	
	print_str("Введите n - количество элементов в массиве (от 1 до 10):")
	read_int(s0)
	print_str("\n")
	
	# Запишем верхнюю границу отрезка для n в t1
	li t1 10
	
	# Проверим соответствие границ
	blez s0 number_out_of_range_down
	bgt s0 t1 number_out_of_range_up
	
	print_str("Введите X - число, на которое должны делиться элементы массива (≥  1)")
	read_int(s1)
	print_str("\n")
	
	# Проверим, что X > 0
	blez s1 number_out_of_range_down
	
	la t0 array	 # Указатель на текущий элемент массива
	li s2 0		 # Счётчик i = 0 - количество считанных элементов массива А
	li s3 0		 # Счётчик j = 0 - количество элементов массива В
	j input_loop
number_out_of_range_down:
	print_str("Введённое число должно быть ≥  1")
	exit
number_out_of_range_up:
	print_str("Введённое число должно быть ≤ 10")
	exit
input_loop:
	addi s2 s2 1 	# Увеличиваем счётчик i на 1
	bgt s2 s0 init 	 # Если счётчик стал равным n - завершаем цикл ввода
	
	print_str("Введите число - элемент массива A: ")
	
	# Получаем от пользователя элемент массива
	li a7 5
	ecall
	
	abs(a0, t3)
	rem t2 t3 s1		# t2 = t3 % s1 = остаток от модуля введённого числа от деления на Х
	bgtz t2 input_loop	# если остаток не равен 0, продолжаем ввод	
	
	sw a0 (t0) 	# Записываем введённое число в массив
	addi t0 t0 4 	# Перемещаем указатель на 4 байта (размер int)
	addi s3 s3 1 	# Увеличиваем счётчик j на 1
	
	j input_loop	# Продолжаем цикл ввода элементов
init:
	la t0 array 	# Массив заполнили ⇒ указатель должен быть на первом
			# элементе массива, чтобы пройтись по нему заново
	li s2 1 		# i = 1
	j print_loop
print_loop:
	bgt s2 s3 exit		# i > j ⇒ выводим результат

	lw a0 (t0) 		# Записываем в a0 текущий элемент массива
	print_int(a0)
	print_str(" ")
	
	j next_iter
next_iter:
	addi s2 s2 1	# ++i
	addi t0 t0 4 	# двигаем указатель на 4 байта
	j print_loop
exit:
	li a7, 10
	ecall
