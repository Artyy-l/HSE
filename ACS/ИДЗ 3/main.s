.include "macrolib.s"
.include "macrolib-dialog-boxes.s"
.include "macrolib-files.s"
.include "consts.s"

.data
    	buffer: .space 10240          # Буфер для хранения текста (10 кбайт = 10 * 1024 байт)
    	number_buffer: .space 8        # Буфер для хранения числа в виде строки
    	msg_input_file: .asciz "Введите название входного файла: "
    	msg_output_file: .asciz "Введите название выходного файла: "
    	msg_enter_N: .asciz "Введите число N: "
    	msg_error: .asciz "Произошла ошибка при работе с файлом\n"
    	msg_Yes_No: .asciz "Вывести полученные данные в консоль?"

.text
.global main

main:
    	# Ввод названия входного файла
    	input_string_dialog(msg_input_file, buffer, PATH_SIZE)
    	mv a0 a1           	# Возврат адреса буфера в регистр a0
    	li a1 100

    	# Удаляем символ новой строки из названия входного файла
    	la t0 buffer
    	remove_newline t0

	# Открываем входной файл для чтения
	open(buffer, READ_ONLY)
    	
    	# Проверяем успешность открытия входного файла
    	li t0 -1
    	beq a0 t0 error_exit

    	# Сохраняем дескриптор входного файла
    	mv s0 a0

    	# Ввод названия выходного файла
    	input_string_dialog(msg_output_file, buffer, PATH_SIZE)

    	# Удаляем символ новой строки из названия выходного файла
    	la t0 buffer
    	remove_newline t0

    	# Открываем выходной файл
    	open(buffer, WRITE_ONLY)

    	# Проверяем успешность открытия выходного файла
    	li t0 -1
    	beq a0 t0 error_exit

    	# Сохраняем дескриптор выходного файла
    	mv s1 a0

    	# Ввод числа N
    	input_string_dialog(msg_enter_N, number_buffer, NUMBER_SIZE)
    	mv a0 a1           	# Возврат адреса буфера в регистр a0

    	# Удаляем символ новой строки из подстроки
    	la t0 number_buffer
    	remove_newline(t0)
    	
    	# Конвертируем строку в число
    	la t4 number_buffer
    	string_to_int(t4, s10)

    	# Выбор Yes/No для вывода данных в консоль
    	mv a1 a0
    	confirm_dialog(msg_Yes_No)
    	mv s11 a0           	# Переносим выбор пользователя в регистр s11
    	mv a0 a1           	# Возврат адреса буфера в регистр a0

    	# Инициализируем счетчики
    	li s2 0            	# Общий счетчик прочитанных байт
    	li s3 0            	# Смещение в буфере

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
    	blt a0 zero error_exit

    	# Если a0 == 0, достигнут конец файла
    	beq a0 zero end_read_loop

    	# Обновляем счетчики
    	add s2 s2 a0      	# s2 = s2 + a0 (общее количество прочитанных байт)
    	add s3 s3 a0      	# s3 = s3 + a0 (смещение в буфере)

    	# Переходим к следующей итерации
    	j read_loop

end_read_loop:
    	# Вызываем подпрограмму поиска подстроки
    	la a0 buffer            # Адрес текста
    	mv a1 s2             	# Длина текста
    	mv a2 s10		# N
    	mv a3 s1             	# Дескриптор выходного файла
    	mv a4 s11		# Выбор Yes/No (0 / 1)
    	jal ra find_last_symbols

    	# Закрываем файлы
    	close(s0)
    	close(s1)
    	exit

error_exit:
    	# Выводим сообщение об ошибке и завершаем программу
    	message_dialog(msg_error, 0)
    	exit
