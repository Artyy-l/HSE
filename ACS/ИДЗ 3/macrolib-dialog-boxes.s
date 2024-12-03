#================================================================================================
# Макросы для работы с диалоговыми окнами
#================================================================================================

#------------------------------------------------------------------------------------------------
# Вызов диалогового окна для получения строки
# от пользователя
# Параметры:
#    %message - адрес строки сообщения для пользователя (null-terminated)
#    %buffer - адрес буфера для сохранения ввода
#    %symbols_count - максимальное количество символов для чтения (включая завершающий null)
.macro input_string_dialog(%message, %buffer, %symbols_count)
    	la a0 %message          	# Передаем адрес сообщения в a0
    	la a1 %buffer         	# Передаем адрес буфера в a1
    	li a2 %symbols_count
    	jal ra input_string_dialog
.end_macro

#------------------------------------------------------------------------------------------------
# Вызов диалогового окна для вывода сообщения
# Параметры:
#    %message - адрес строки сообщения, которое будет отображено пользователю (null-terminated)
#    %type - the type of the message to the user, which is one of: 
#	0: error message
#	1: information message 
#	2: warning message 
#	3: question message 
#	other: plain message
.macro message_dialog(%message, %type)
    	la a0 %message          # Передаем адрес сообщения в a0
    	li a1 %type         	# Передаем тип окна в a1
    	jal ra message_dialog
.end_macro

#------------------------------------------------------------------------------------------------
# Вызов диалогового окна для выбора Yes/No
# Параметры:
#    %message - address of null-terminated string that is the message to user
.macro confirm_dialog(%message)
    	la a0 %message          # Передаем адрес сообщения в a0
    	jal ra confirm_dialog
.end_macro
