.include "macrolib.s"
.include "macrolib-dialog-boxes.s"
.include "macrolib-files.s"
.include "consts.s"

.data
    	buffer: .space 10240          # �����֧� �էݧ� ���ѧߧ֧ߧڧ� ��֧ܧ��� (10 �ܧҧѧۧ� = 10 * 1024 �ҧѧۧ�)
    	number_buffer: .space 8        # �����֧� �էݧ� ���ѧߧ֧ߧڧ� ��ڧ�ݧ� �� �ӧڧէ� �����ܧ�
    	msg_input_file: .asciz "���ӧ֧էڧ�� �ߧѧ٧ӧѧߧڧ� �ӧ��էߧ�ԧ� ��ѧۧݧ�: "
    	msg_output_file: .asciz "���ӧ֧էڧ�� �ߧѧ٧ӧѧߧڧ� �ӧ���էߧ�ԧ� ��ѧۧݧ�: "
    	msg_enter_N: .asciz "���ӧ֧էڧ�� ��ڧ�ݧ� N: "
    	msg_error: .asciz "�����ڧ٧��ݧ� ���ڧҧܧ� ���� ��ѧҧ��� �� ��ѧۧݧ��\n"
    	msg_Yes_No: .asciz "����ӧ֧��� ���ݧ��֧ߧߧ�� �էѧߧߧ�� �� �ܧ�ߧ��ݧ�?"

.text
.global main

main:
    	# ���ӧ�� �ߧѧ٧ӧѧߧڧ� �ӧ��էߧ�ԧ� ��ѧۧݧ�
    	input_string_dialog(msg_input_file, buffer, PATH_SIZE)
    	mv a0 a1           	# ����٧ӧ�ѧ� �ѧէ�֧�� �ҧ��֧�� �� ��֧ԧڧ��� a0
    	li a1 100

    	# ���էѧݧ�֧� ��ڧާӧ�� �ߧ�ӧ�� �����ܧ� �ڧ� �ߧѧ٧ӧѧߧڧ� �ӧ��էߧ�ԧ� ��ѧۧݧ�
    	la t0 buffer
    	remove_newline t0

	# ����ܧ��ӧѧ֧� �ӧ��էߧ�� ��ѧۧ� �էݧ� ���֧ߧڧ�
	open(buffer, READ_ONLY)
    	
    	# �����ӧ֧��֧� ����֧�ߧ���� ���ܧ���ڧ� �ӧ��էߧ�ԧ� ��ѧۧݧ�
    	li t0 -1
    	beq a0 t0 error_exit

    	# ������ѧߧ�֧� �է֧�ܧ�ڧ���� �ӧ��էߧ�ԧ� ��ѧۧݧ�
    	mv s0 a0

    	# ���ӧ�� �ߧѧ٧ӧѧߧڧ� �ӧ���էߧ�ԧ� ��ѧۧݧ�
    	input_string_dialog(msg_output_file, buffer, PATH_SIZE)

    	# ���էѧݧ�֧� ��ڧާӧ�� �ߧ�ӧ�� �����ܧ� �ڧ� �ߧѧ٧ӧѧߧڧ� �ӧ���էߧ�ԧ� ��ѧۧݧ�
    	la t0 buffer
    	remove_newline t0

    	# ����ܧ��ӧѧ֧� �ӧ���էߧ�� ��ѧۧ�
    	open(buffer, WRITE_ONLY)

    	# �����ӧ֧��֧� ����֧�ߧ���� ���ܧ���ڧ� �ӧ���էߧ�ԧ� ��ѧۧݧ�
    	li t0 -1
    	beq a0 t0 error_exit

    	# ������ѧߧ�֧� �է֧�ܧ�ڧ���� �ӧ���էߧ�ԧ� ��ѧۧݧ�
    	mv s1 a0

    	# ���ӧ�� ��ڧ�ݧ� N
    	input_string_dialog(msg_enter_N, number_buffer, NUMBER_SIZE)
    	mv a0 a1           	# ����٧ӧ�ѧ� �ѧէ�֧�� �ҧ��֧�� �� ��֧ԧڧ��� a0
    	li a1 100

    	# ���էѧݧ�֧� ��ڧާӧ�� �ߧ�ӧ�� �����ܧ� �ڧ� ���է����ܧ�
    	la t0 number_buffer
    	remove_newline(t0)
    	
    	# ����ߧӧ֧��ڧ��֧� �����ܧ� �� ��ڧ�ݧ�
    	la t4 number_buffer
    	string_to_int(t4, s10)

    	# ����ҧ�� Yes/No �էݧ� �ӧ�ӧ�է� �էѧߧߧ�� �� �ܧ�ߧ��ݧ�
    	mv a1 a0
    	confirm_dialog(msg_Yes_No)
    	mv s11 a0           	# ���֧�֧ߧ��ڧ� �ӧ�ҧ�� ���ݧ�٧�ӧѧ�֧ݧ� �� ��֧ԧڧ��� s11
    	mv a0 a1           	# ����٧ӧ�ѧ� �ѧէ�֧�� �ҧ��֧�� �� ��֧ԧڧ��� a0

    	# ���ߧڧ�ڧѧݧڧ٧ڧ��֧� ���֧��ڧܧ�
    	li s2 0            	# ���ҧ�ڧ� ���֧��ڧ� �����ڧ�ѧߧߧ�� �ҧѧۧ�
    	li s3 0            	# ���ާ֧�֧ߧڧ� �� �ҧ��֧��
    	li t6 10240        	# ���ѧܧ�ڧާѧݧ�ߧ�� ��ѧ٧ާ֧� ��ѧۧݧ� (10 ����)

read_loop:
    	# �����ڧ�ݧ�֧� �ܧ�ݧڧ�֧��ӧ� ����ѧӧ�ڧ��� �ҧѧۧ� �էݧ� ���֧ߧڧ�
    	li t0 10240
    	sub t0 t0 s2      	# t0 = 10240 - s2 (����ѧӧ�ڧ֧�� �ҧѧۧ��)

    	# t0 == 0 => �է���ڧԧߧ�� �ާѧܧ�ڧާѧݧ�ߧ�� ��ѧ٧ާ֧�, �٧ѧӧ֧��ѧ֧� ���֧ߧڧ�
    	beq t0 zero end_read_loop

    	# �����֧է֧ݧ�֧�, ��ܧ�ݧ�ܧ� �ҧѧۧ� ��ڧ�ѧ�� �� ��֧ܧ��֧� �ڧ�֧�ѧ�ڧ�
    	li t1 512
    	blt t0 t1 set_bytes_to_read
    	mv t2 t1         	# bytes_to_read = 512
    	j update_values
set_bytes_to_read:
    	mv t2 t0         	# bytes_to_read = ����ѧӧ�ڧ֧�� �ҧѧۧ��
update_values:
    	# �����ѧߧѧӧݧڧӧѧ֧� �ѧէ�֧� �٧ѧ�ڧ�� �� �ҧ��֧� �� ���֧��� ��ާ֧�֧ߧڧ�
    	la t3 buffer
    	add a1 t3 s3      	# a1 = buffer + s3

    	# �����ѧߧѧӧݧڧӧѧ֧� �ܧ�ݧڧ�֧��ӧ� �ҧѧۧ� �էݧ� ���֧ߧڧ�
    	mv a2 t2         	# a2 = bytes_to_read

	# ���ڧ�ѧ֧�
	read(s0, a1, a2)

    	# �����ӧ֧��֧� �ߧ� ���ڧҧܧ� ���֧ߧڧ�
    	blt a0 zero error_exit

    	# ����ݧ� a0 == 0, �է���ڧԧߧ�� �ܧ�ߧ֧� ��ѧۧݧ�
    	beq a0 zero end_read_loop

    	# ���ҧߧ�ӧݧ�֧� ���֧��ڧܧ�
    	add s2 s2 a0      	# s2 = s2 + a0 (��ҧ�֧� �ܧ�ݧڧ�֧��ӧ� �����ڧ�ѧߧߧ�� �ҧѧۧ�)
    	add s3 s3 a0      	# s3 = s3 + a0 (��ާ֧�֧ߧڧ� �� �ҧ��֧��)

    	# ���֧�֧��էڧ� �� ��ݧ֧է���֧� �ڧ�֧�ѧ�ڧ�
    	j read_loop

end_read_loop:
    	# ����٧�ӧѧ֧� ���է���ԧ�ѧާާ� ���ڧ�ܧ� ���է����ܧ�
    	la a0 buffer            # ���է�֧� ��֧ܧ���
    	mv a1 s2             	# ���ݧڧߧ� ��֧ܧ���
    	mv a2 s10		# N
    	mv a3 s1             	# ���֧�ܧ�ڧ���� �ӧ���էߧ�ԧ� ��ѧۧݧ�
    	mv a4 s11		# ����ҧ�� Yes/No (0 / 1)
    	jal ra find_last_symbols

    	# ���ѧܧ��ӧѧ֧� ��ѧۧݧ�
    	close(s0)
    	close(s1)
    	exit

error_exit:
    	# ����ӧ�էڧ� ����ҧ�֧ߧڧ� ��� ���ڧҧܧ� �� �٧ѧӧ֧��ѧ֧� ����ԧ�ѧާާ�
    	message_dialog(msg_error, 0)
    	exit