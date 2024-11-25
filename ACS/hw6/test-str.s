# Тестирование макроопределений и подпрограмм обработки строк символов
.include "macro-syscalls.m"
.include "macro-string.m"

.eqv     BUF_SIZE 10

    .data
buf1:    .space BUF_SIZE     # Буфер для первой строки
buf2:    .space BUF_SIZE     # Буфер для второй строки
empty_test_str: .asciz ""   # Пустая тестовая строка
short_test_str: .asciz "Hello!"     # Короткая тестовая строка
long_test_str:  .asciz "I am long for BUF_SIZE" # Длинная тестовая строка

    .text
.globl main
main:
    # Ввод строки 1 в буфер
    la      a0 buf1
    li      a1 BUF_SIZE
    li      a7 8
    ecall
    # Тестовый вывод строки 1
    la      a0 buf1
    li      a7 4
    ecall
    # Ввод строки 2 в буфер
    la      a0 buf2
    li      a1 BUF_SIZE
    li      a7 8
    ecall
    # Тестовый вывод строки 2
    la      a0 buf2
    li      a7 4
    ecall

	##################################################################
	print_str ("Тестирование сравнения строк\n")
	##################################################################
	
    # Сравнение строк в буферах
    strcmp(buf1, buf2)
    #la      a0 buf1
    #la      a1 buf2
    #jal     strcmp
    # Вывод результата сравнения
    li      a7 1
    ecall
    # Перевод строки
    li      a0 '\n'
    li      a7 11
    ecall

    # Сравнение с пустой строкой
    strcmp(empty_test_str, short_test_str)
    #la      a0 empty_test_str
    #la      a1 short_test_str
    #jal     strcmp
    # Вывод результата сравнения
    li      a7 1
    ecall
    # Перевод строки
    li      a0 '\n'
    li      a7 11
    ecall

    # Сравнение короткой строки с собой
    strcmp(short_test_str, short_test_str)
    #la      a0 short_test_str
    #la      a1 short_test_str
    #jal     strcmp
    # Вывод результата сравнения
    li      a7 1
    ecall
    # Перевод строки
    li      a0 '\n'
    li      a7 11
    ecall

    # Сравнение длинной	строки с короткой
    strcmp(long_test_str, short_test_str)
    #la      a0 long_test_str
    #la      a1 short_test_str
    #jal     strcmp
    # Вывод результата сравнения
    li      a7 1
    ecall
    # Перевод строки
    li      a0 '\n'
    li      a7 11
    ecall

	##################################################################
	print_str ("Тестирование вычисление длины строки, ограниченной нулем\n")
	##################################################################

    # Вычисление длины для вводимой строки
    strlen(buf1)
    #la      a0 buf1
    #jal     strlen
    # Вывод счетчика
    li      a7 1
    ecall
    # Перевод строки
    li      a0 '\n'
    li      a7 11
    ecall

    # Вычисление длины для пустой строки
    strlen(empty_test_str)
    #la      a0 empty_test_str
    #jal     strlen
    # Вывод счетчика
    li      a7 1
    ecall
    # Перевод строки
    li      a0 '\n'
    li      a7 11
    ecall

    # Вычисление длины для короткой	строки
    strlen(short_test_str)
    #la      a0 short_test_str
    #jal     strlen
    # Вывод счетчика
    li      a7 1
    ecall
    # Перевод строки
    li      a0 '\n'
    li      a7 11
    ecall

    # Вычисление длины для длинной	строки
    strlen(long_test_str)
    #la      a0 long_test_str
    #jal     strlen
    # Вывод счетчика
    li      a7 1
    ecall
    # Перевод строки
    li      a0 '\n'
    li      a7 11
    ecall

	##################################################################
	print_str ("Тестирование вычисление длины строки, ограниченной нулем и буфером\n")
	##################################################################

    # Вычисление длины для пустой строки
    strnlen(empty_test_str, BUF_SIZE)
    #la      a0 empty_test_str
    #li      a1 BUF_SIZE
    #jal     strnlen
    # Вывод счетчика
    li      a7 1
    ecall
    # Перевод строки
    li      a0 '\n'
    li      a7 11
    ecall

    # Вычисление длины для короткой	строки
    strnlen(short_test_str, BUF_SIZE)
    #la      a0 short_test_str
    #li      a1 BUF_SIZE
    #jal     strnlen
    # Вывод счетчика
    li      a7 1
    ecall
    # Перевод строки
    li      a0 '\n'
    li      a7 11
    ecall

    # Вычисление длины для длинной	строки
    strnlen(long_test_str, BUF_SIZE)
    #la      a0 long_test_str
    #li      a1 BUF_SIZE
    #jal     strnlen
    # Вывод счетчика
    li      a7 1
    ecall
    # Перевод строки
    newline
    #li      a0 '\n'
    #li      a7 11
    #ecall

    # Завершение программы
    exit
    #li      a7 10
    #ecall
