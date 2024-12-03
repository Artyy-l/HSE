.include "macrolib.s"
.include "macrolib-dialog-boxes.s"
.include "macrolib-files.s"
.include "consts.s"

.data
	buffer: .space 10240            # Буфер для хранения текста (10 КБ)
         number_buffer: .space 8          # Буфер для хранения числа в виде строки

# Массивы названий файлов
input_filenames:
        .asciz "../test/input1.txt\0"
        .asciz "../test/input2.txt\0"
        .asciz "../test/input3.txt\0"
        .asciz "../test/input4.txt\0"
        .asciz "../test/input5.txt\0"

output_filenames:
        .asciz "../test/output1.txt\0"
        .asciz "../test/output2.txt\0"
        .asciz "../test/output3.txt\0"
        .asciz "../test/output4.txt\0"
        .asciz "../test/output5.txt\0"

msg_enter_N: .asciz "Введите число N: "
msg_error: .asciz "Произошла ошибка при работе с файлом\n"
num_tests: .word 5              # Количество тестов

.text
.global main_test

main_test:
        # Ввод числа N
    	input_string_dialog(msg_enter_N, number_buffer, NUMBER_SIZE)
    	mv a0 a1           	# Возврат адреса буфера в регистр a0

    	# Удаляем символ новой строки из подстроки
    	la t0 number_buffer
    	remove_newline(t0)
    	
    	# Конвертируем строку в число
    	la t4 number_buffer
    	string_to_int(t4, s10)
init:
        # Инициализируем счетчик тестов
        li s5 0              # s5 = текущий тест (0..4)
        lw s6 num_tests      # s6 = общее количество тестов
test_loop:
        bge s5 s6 end_tests  # Если s5 >= s6, завершаем тесты

        # Получаем адрес имени входного файла
        la t2 input_filenames
        li t4 0
loop_input_filename:
        beq t4 s5 get_input_filename
        addi t4 t4 1
        addi t2 t2 12     # Смещение на 12 байт (размер строки с '\0')
        j loop_input_filename
get_input_filename:
        mv a0 t2            # a0 = адрес имени входного файла

        # Открываем входной файл
        li a1 0
        li a7 1024
        ecall
        li a4 -1
        beq a0 a4 error
        mv s0 a0            # Файловый дескриптор входного файла

        # Счетчики для чтения файла
        li s2 0               # Общий счетчик прочитанных байт
        li s3 0               # Смещение в буфере
read_loop:
    	# Вычисляем количество оставшихся байт для чтения
    	li t0 MAX_FILE_SIZE
    	sub t0 t0 s2      	# t0 = 10240 - s2 (оставшиеся байты)

    	# t0 == 0 => достигнут максимальный размер, завершаем чтение
    	beq t0 zero end_read_loop

    	# Определяем, сколько байт читать в текущей итерации
    	li t1 BUFF_SIZE
    	blt t0 t1 set_bytes_to_read
    	mv t2 t1         	# bytes_to_read = 512
    	j update_values
set_bytes_to_read:
    	mv t2 t0         	# bytes_to_read = оставшиеся байты
update_values:
    	# Устанавливаем адрес записи в буфер с учетом смещения
    	la t3 buffer
    	add a1 t3 s3      	# a1 = buffer + s3

    	# Устанавливаем количество байт для чтения
    	mv a2 t2         	# a2 = bytes_to_read

	# Читаем
	read(s0, a1, a2)

    	# Проверяем на ошибки чтения
    	blt a0 zero error

    	# Если a0 == 0, достигнут конец файла
    	beq a0 zero end_read_loop

    	# Обновляем счетчики
    	add s2 s2 a0      	# s2 = s2 + a0 (общее количество прочитанных байт)
    	add s3 s3 a0      	# s3 = s3 + a0 (смещение в буфере)

    	# Переходим к следующей итерации
    	j read_loop

end_read_loop:
	close(s0)
	
	# Если размер файла превышает 10 КБ, завершаем программу
        li t5 10240
        bgt s2 t5 error
        
        # Получаем адрес имени выходного файла
        la t2 output_filenames
        li t4 0
loop_output_filename:
        beq t4 s5 get_output_filename
        addi t4 t4 1
        addi t2 t2 13    # Смещение на 13 байт (размер строки с '\0')
        j loop_output_filename
get_output_filename:
        mv a0 t2            # a0 = адрес имени выходного файла
        
        # Открываем выходной файл
        li a1 1
        li a7 1024
        ecall
        li a4 -1
        beq a0 a4 error
        mv s1 a0            # Сохраняем дескриптор выходного файла
        
        # Вызываем подпрограмму поиска подстроки
    	la a0 buffer            # Адрес текста
    	mv a1 s2             	# Длина текста
    	mv a2 s10		# N
    	mv a3 s1             	# Дескриптор выходного файла
    	li a4 1			# Выбор Yes/No --> No
    	jal ra find_last_symbols
    	
    	# Увеличиваем счетчик тестов
        addi s5 s5 1
        j test_loop
error:
    	# Выводим сообщение об ошибке и завершаем программу
    	message_dialog(msg_error, 0)
end_tests:
    	exit
