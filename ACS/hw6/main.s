# Тестирование макроопределений и подпрограмм обработки строк символов
.include "macrolib.s"
.include "macro-string.s"

.eqv     BUF_SIZE 10

.data
	buf1:    .space BUF_SIZE     	# Буфер для первой строки
	buf2:    .space BUF_SIZE     	# Буфер для второй строки
	empty_test_str: .asciz ""   	# Пустая тестовая строка
	short_test_str: .asciz "Hello!"     # Короткая тестовая строка
	long_test_str:  .asciz "I am long for BUF_SIZE" # Длинная тестовая строка

.text
.globl main
main:
    # Ввод строки  в буфер buf2
    la      a0 buf2
    li      a1 BUF_SIZE
    li      a7 8
    ecall

    # Вывод строки buf2
    la      a0 buf2
    li      a7 4
    ecall
    
    # Копируем buf2 в buf1
    strncpy(buf1, buf2, 4)
    
    # Вывод строки buf1 для проверки
    la      a0 buf1
    li      a7 4
    ecall
    
    print_str("\n")
    
    strncpy(empty_test_str, short_test_str, 10)
    print_str(empty_test_str)
    print_str("\n")
    
    strncpy(empty_test_str, long_test_str, 50)
    print_str(empty_test_str)
    print_str("\n")
    
    exit
