.include "macrolib.s"
.include "macrolib-dialog-boxes.s"
.include "macrolib-files.s"
.include "consts.s"

.global remove_newline
.global find_last_symbols
.global input_string_dialog
.global message_dialog
.global confirm_dialog

# Подпрограмма для отображения сообщения пользователю и ввода строки
# Параметры:
#    a0 - адрес строки сообщения для пользователя (null-terminated)
#    a1 - адрес буфера для ввода
#    a2 - максимальное количество символов для чтения (включая завершающий null)
# Возвращаемое значение:
#    a1 - буфер содержит введённую строку (максимум допустимых символов, завершается null)
input_string_dialog:
    push(ra)                  # Сохраняем адрес возврата на стеке

    li a7 54                  # Системный вызов для ввода строки
    ecall                    

    pop(ra)                   
    jr ra                    
    	
# Service to display a message to user
# Подпрограмма для отображения сообщения пользователю
# Параметры:
#    a0 - адрес строки сообщения, которое будет отображено пользователю (null-terminated)
#    a1 - the type of the message to the user, which is one of: 
#	0: error message
#	1: information message 
#	2: warning message 
#	3: question message 
#	other: plain message
# Возвращаемое значение:
#    Нет
message_dialog:
	# Сохраняем адрес возврата на стеке	
    	push(ra)

    	# Вызываем диалоговое окно
    	li a7 55
    	ecall

    	# Забираем адрес возврата со стека и возвращаем
    	pop(ra)
    	jr ra
    	
# Service to display a message to user
# Параметры:
#    a0 - address of null-terminated string that is the message to user
# Возвращаемое значение:
#    a0 = Yes (0), No (1), or Cancel(2)
confirm_dialog:
	# Сохраняем адрес возврата на стеке	
    	push(ra)

    	# Вызываем диалоговое окно
    	li a7 50
    	ecall

    	# Забираем адрес возврата со стека и возвращаем
    	pop(ra)
    	jr ra

# Подпрограмма удаления символа новой строки
# Параметры:
#    4(sp) - адрес строки
# Возвращаемое значение: 
#    Нет
remove_newline:
	push(ra)
	
	# Восстанавливаем значение адреса строки из стека
	lw t1 4(sp)
remove_newline_loop:
    	lb t2 (t1)
    	beqz t2 remove_newline_end
    	li t3 10  	# Код символа новой строки
    	beq t2 t3 remove_newline_found
    	addi t1 t1 1
    	j remove_newline_loop
remove_newline_found:
    	sb zero (t1)
remove_newline_end:
    	pop(ra)
    	jr ra 		# Выходим из подпрограммы

# Подпрограмма для записи последних N символов строки в файл
# Параметры:
#    a0 - адрес текста
#    a1 - длина текста
#    a2 - N (количество символов)
#    a3 - дескриптор выходного файла
# Возвращаемое значение:
#    Нет
find_last_symbols:
    push(ra)                 # Сохранение адреса возврата

    mv s3 a0                # Адрес текста
    mv s4 a1                # Длина текста
    mv s5 a2                # N (количество символов для записи)
    mv s8 a3                # Дескриптор выходного файла
    mv s7 a4		   # Выбор Yes/No (0 / 1)

    blt s4 s5 use_full_text # Если N > длины строки, записать всю строку

    sub s6 s4 s5            # Начальный индекс: длина - N
    add s3 s3 s6            # Указатель = начало последних N символов
    mv s6 s5                # Размер записи равен N
    j write_to_file        # Перейти к записи в файл

use_full_text:
    mv s6 s4                # Если N > длины строки, записываем всю строку

write_to_file:
    write_addr(s8, s3, s6)     	# Запись в файл
    
    beqz s7 write_to_console 	# Если s7 == 0, вывод в консоль
    j end_subroutine

write_to_console:
    li t0 1
    write_addr(t0, s3, s6)    # Вывод в консоль (дескриптор stdout = 1)

end_subroutine:
    pop(ra)
    jr ra                           
