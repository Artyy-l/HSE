# Печать содержимого регистра как целого
.macro print_int (%x)
	li a7, 1
	mv a0, %x
	ecall
.end_macro

 .macro print_imm_int (%x)
 li a7, 1
 li a0, %x
 ecall
 .end_macro

# Ввод целого числа с консоли в регистр a0
.macro read_int_a0
   li a7, 5
   ecall
.end_macro

# Ввод целого числа с консоли в указанный регистр,
# исключая регистр a0
.macro read_int(%x)
   push	(a0)
   li a7, 5
   ecall
   mv %x, a0
   pop	(a0)
.end_macro

.macro print_str_imm(%x)
   .data
str:
   .asciz %x
   .text
   push (a0)
   li a7, 4
   la a0, str
   ecall
   pop	(a0)
.end_macro

.macro print_str(%x)
	  la      a0 %x
    li      a7 4
    ecall
.end_macro

.macro print_char(%x)
   li a7, 11
   li a0, %x
   ecall
.end_macro

# Завершение программы
.macro exit
    li a7, 10
    ecall
.end_macro

# Сохранение заданного регистра на стеке
.macro push(%x)
	addi	sp, sp, -4
	sw	%x, (sp)
.end_macro

# Выталкивание значения с вершины стека в регистр
.macro pop(%x)
	lw	%x, (sp)
	addi	sp, sp, 4
.end_macro

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
