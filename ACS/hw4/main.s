.data
	info_input_num: .asciz "Введите n - количество элементов в массиве (от 1 до 10): "
	info_input_elem: .asciz "Введите число - элемент массива: "
	info_sum_is: .asciz "Сумма введённых элементов равна: "
	info_out_of_range_down: .asciz "Количество элементов должно быть ≥  1"
	info_out_of_range_up: .asciz "Количество элементов должно быть ≤ 10"
	info_overflow: .asciz "Произошло переполнение.\n"
	info_last_sum: .asciz "Сумма до переполнения равна: "
	info_counter: .asciz "Чисел было просуммировано: "
	new_line: .asciz "\n"
.align 2
	array: .space 64  	# Выделяем 64 байта (больше, чем надо)
	arrend: 			# Граница массива
.text

main:	
	# Выводим сообщение о необходимости ввода
	li a7 4
	la a0 info_input_num
	ecall
	
	# Получаем n от пользователя и сохраняем в t2
	li a7 5
	ecall
	mv t2 a0
	
	# Переводим каретку на новую строку
	li a7 4
	la a0 new_line
	ecall
	
	# Запишем верхнюю границу отрезка для n в s1
	li s1 10
	
	# Проверим соответствие границ
	blez t2 number_out_of_range_down
	bgt t2 s1 number_out_of_range_up
	
	li s2 0 		# флаг для положительного переполнения
	li s3 0 		# флаг для отрицательного переполнения
	li s4 1 		# будем хранить константу 1 для вычитания
	
	la t0 array	 # Указатель на текущий элемент массива
	li t1 1		 # Счётчик i = 1
	j input_loop
number_out_of_range_down:
	li a7 4
	la a0 info_out_of_range_down
	ecall
	j exit
number_out_of_range_up:
	li a7 4
	la a0 info_out_of_range_up
	ecall
	j exit
input_loop:
	bgt t1 t2 init 	 # Если счётчик стал равным n - завершаем цикл ввода
	
	# Выводим сообщение для пользователя о необходимости ввести число
	li a7 4
	la a0 info_input_elem
	ecall
	
	# Получаем от пользователя элемент массива
	li a7 5
	ecall
	
	sw a0 (t0) 	# Записываем введённое число в массив
	addi t0 t0 4 	# Перемещаем указатель на 4 байта (размер int)
	addi t1 t1 1 	# Увеличиваем счётчик i на 1
	j input_loop	# Продолжаем цикл ввода элементов
init:
	la t0 array 	# Массив заполнили ⇒ указатель должен быть на первом
			# элементе массива, чтобы пройтись по нему заново
	li t1 1 		# i = 1
	li t3 0 		# В регистре t3 будем хранить сумму элементов, изначально она равна 0
	j sum_loop
sum_loop:
	bgt t1 t2 print_result 	# i > n ⇒ выводим результат

	lw a0 (t0) 		# Записываем в a0 текущий элемент массива
	
	mv t4 t3 		# Перемещаем текущую сумму t3 в t4
	add t3 t3 a0 		# Добавляем в сумму текущий элемент массива
	
	
	sgt s2 t4 t3		# Если старая сумма t4 > новой суммы t3 - возможно,
	 			# случилось положительное переполнение, s2 = 1
	bnez s2 check_num_bigger_than_zero # Если s2 = 1, проверяем, был ли последний добавленный элемент > 0
	 			
	slt s3 t4 t3		# Если старая сумма t4 < новой суммы t3 - возможно, 
				# случилось отрицательное переполнение, s3 = 1
	bnez s3 check_num_less_than_zero # Если s3 = 1, проверяем, был ли последний добавленный элемент < 0
	
	j next_iter
next_iter:
	addi t1 t1 1	# ++i
	addi t0 t0 4 	# двигаем указатель на 4 байта
	j sum_loop
print_result:
	# Выводим сумму
	li a7 4
	la a0 info_sum_is
	ecall
	
	li a7 1
	mv a0 t3 	# итоговая сумма лежала в t3
	ecall
	
	li a7 4
	la a0 new_line
	ecall
	
	j exit
check_num_bigger_than_zero:
	bgtz a0 error	# a0 > 0 ⇒ переходим в error
	li s2 0		# иначе устанавливаем флаг s2 = 0
	j next_iter
check_num_less_than_zero:
	bltz a0 error	# a0 < 0 ⇒ переходим в error
	li s3 0		# иначе устанавливаем флаг s3 = 0
	j next_iter
error:
	# Выводим информацию о переполнении
	li a7 4
	la a0 info_overflow
	ecall
	
	# Выводим последнюю корректную сумму - она лежит в t4
	la a0 info_last_sum
	ecall
	
	li a7 1
	mv a0 t4
	ecall
	
	li a7 4
	la a0 new_line
	ecall
	
	# Выводим количество просуммированных элементов
	la a0 info_counter
	ecall
	
	sub t1 t1 s4	# мы насчитали на один элемент больше, поэтому вычитаем 1 (--i)
	li a7 1
	mv a0 t1
	ecall 
	
	li a7 4
	la a0 new_line
	ecall
	
	j exit		# всё что нужно вывели, можем завершить программу
exit:
	li a7 10
	ecall
