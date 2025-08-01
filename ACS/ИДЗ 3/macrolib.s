#------------------------------------------------------------------------------------------------
# Конвертация строки в натуральное число
# Параметры:
#    %reg_string - регистр с адресом строки
#    %reg_int - регистр для хранения результата
.macro string_to_int (%reg_string, %reg_int)
	    li t0 0                   	# t0 будет хранить итоговое число (инициализация в 0)
	    li t1 10                  	# t1 = 10, для умножения при обработке следующей цифры
	
	convert_loop:  
	    lb t2 (%reg_string)      	# Загрузка текущего символа строки в t2
	    beq t2 zero conversion_done  # Если символ = 0 (null terminator), завершить
	
	    addi t2 t2 -48            	# Преобразование символа ASCII в числовое значение
	    blt t2 zero conversion_error # Если t2 < 0, ошибка
	    bge t2 t1 conversion_error   # Если t2 >= 10, ошибка
	
	    mul t0 t0 t1              	# Умножение текущего числа на 10
	    add t0 t0 t2              	# Добавление текущей цифры
	
	    addi %reg_string %reg_string 1 	# Переход к следующему символу
	    j convert_loop             	# Повтор цикла
	
	conversion_done:
	    mv %reg_int t0            	# Сохранение результата в %reg_int
	    j conversion_exit          	# Переход к завершению
	
	conversion_error:
	    li %reg_int -1            	# Устанавливаем -1 в случае ошибки
	
	conversion_exit:
.end_macro


#------------------------------------------------------------------------------------------------
# Параметры:
#    %address - адрес строки
.macro remove_newline (%address)
	# Сохраняем адрес строки на стеке
	addi sp sp -4
	sw %address 0(sp)
	
	# Переходим в подпрограмму
	jal ra remove_newline
	
	# Восстанавливаем стек
	addi sp sp 4
.end_macro

#------------------------------------------------------------------------------------------------
# Ввод строки в буфер заданного размера с заменой перевода строки нулем
# %strbuf - адрес буфера
# %size - целая константа, ограничивающая размер вводимой строки
.macro str_get(%strbuf, %size)
    la      a0 %strbuf
    li      a1 %size
    li      a7 8
    ecall
    push(s0)
    push(s1)
    push(s2)
    li	s0 '\n'
    la	s1	%strbuf
next:
    lb	s2  (s1)
    beq s0	s2	replace
    addi s1 s1 1
    b	next
replace:
    sb	zero (s1)
    pop(s2)
    pop(s1)
    pop(s0)
.end_macro

#================================================================================================
# Макросы для работы с системными вызовами
#================================================================================================

#------------------------------------------------------------------------------------------------
# Печать содержимого регистра как целого
.macro print_int (%x)
	li a7, 1
	mv a0, %x
	ecall
.end_macro

#------------------------------------------------------------------------------------------------
 .macro print_imm_int (%x)
 li a7, 1
 li a0, %x
 ecall
 .end_macro

#------------------------------------------------------------------------------------------------
# Ввод целого числа с консоли в регистр a0
.macro read_int_a0
   li a7, 5
   ecall
.end_macro

#------------------------------------------------------------------------------------------------
# Ввод целого числа с консоли в указанный регистр,
# исключая регистр a0
.macro read_int(%x)
   push	(a0)
   li a7, 5
   ecall
   mv %x, a0
   pop	(a0)
.end_macro

#------------------------------------------------------------------------------------------------
# Ввод символа с консоли в указанный регистр,
# исключая регистр a0
.macro read_char(%x)
   push	(a0)
   li a7, 12
   ecall
   mv %x, a0
   pop	(a0)
.end_macro

#------------------------------------------------------------------------------------------------
# Печать строковой константы, ограниченной нулевым символом
.macro print_str(%x)
   .data
str:
   .asciz %x
   .align 2     # Выравнивание памяти. Возможны данные размером в слово
   .text
   push (a0)
   li a7, 4
   la a0, str
   ecall
   pop	(a0)
.end_macro

#------------------------------------------------------------------------------------------------
# Печать строки по адресу
.macro print_str_addr(%reg)
   	push(a0)
   	mv a0, %reg
	li 	a7 4
   	ecall
   	pop(a0)
.end_macro

#------------------------------------------------------------------------------------------------
.macro print_char(%x)
   li a7, 11
   li a0, %x
   ecall
.end_macro

#------------------------------------------------------------------------------------------------
# Печать перевода строки
.macro newline
   print_char('\n')
.end_macro

#------------------------------------------------------------------------------------------------
# Завершение программы
.macro exit
    li a7, 10
    ecall
.end_macro

#------------------------------------------------------------------------------------------------
# Сохранение заданного регистра на стеке
.macro push(%x)
	addi	sp, sp, -4
	sw	%x, (sp)
.end_macro

#------------------------------------------------------------------------------------------------
# Выталкивание значения с вершины стека в регистр
.macro pop(%x)
	lw	%x, (sp)
	addi	sp, sp, 4
.end_macro

#------------------------------------------------------------------------------------------------
# считывает вещественное число с клавиатуры и записывает его в регистр %x
.macro read_double(%x)
	li a7, 7           # Системный вызов для чтения double
    	ecall
    	fmv.d %x, fa0        # Копируем значение из f0 в регистр %x
.end_macro

#------------------------------------------------------------------------------------------------
# печатает число типа double из регистра %x
.macro print_double(%x)
	li a7, 3
    	fmv.d fa0, %x       # Копируем значение из регистра %x в f12 для печати
    	ecall
.end_macro

#------------------------------------------------------------------------------------------------
# сохраняет в регистр %z максимум из двух double'ов в регистрах %x и %y
.macro max(%x, %y, %z)
	flt.d t0, %x, %y       # Сравниваем %x и %y. t0 = 1, if %x < %y
    	fmv.d %z, %x           # Если t0 = 0, тозаписываем %x в %z
    	beqz t0, end          # Если %x >= %y (t0 = 0), пропускаем следующую инструкцию
    	fmv.d %z, %y           # Если %x < %y, записываем %x в %z
end:                          # Метка конца макроса
.end_macro
