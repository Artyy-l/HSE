.include "macrolib.s"
.include "macrolib-dialog-boxes.s"
.include "macrolib-files.s"
.include "consts.s"

.global remove_newline
.global find_last_symbols
.global input_string_dialog
.global message_dialog
.global confirm_dialog

# ����է���ԧ�ѧާާ� �էݧ� ����ҧ�ѧا֧ߧڧ� ����ҧ�֧ߧڧ� ���ݧ�٧�ӧѧ�֧ݧ� �� �ӧӧ�է� �����ܧ�
# ���ѧ�ѧާ֧���:
#    a0 - �ѧէ�֧� �����ܧ� ����ҧ�֧ߧڧ� �էݧ� ���ݧ�٧�ӧѧ�֧ݧ� (null-terminated)
#    a1 - �ѧէ�֧� �ҧ��֧�� �էݧ� �ӧӧ�է�
#    a2 - �ާѧܧ�ڧާѧݧ�ߧ�� �ܧ�ݧڧ�֧��ӧ� ��ڧާӧ�ݧ�� �էݧ� ���֧ߧڧ� (�ӧܧݧ��ѧ� �٧ѧӧ֧��ѧ��ڧ� null)
# ����٧ӧ�ѧ�ѧ֧ާ�� �٧ߧѧ�֧ߧڧ�:
#    a1 - �ҧ��֧� ���է֧�اڧ� �ӧӧ֧էקߧߧ�� �����ܧ� (�ާѧܧ�ڧާ�� �է�����ڧާ�� ��ڧާӧ�ݧ��, �٧ѧӧ֧��ѧ֧��� null)
input_string_dialog:
    push(ra)                  # ������ѧߧ�֧� �ѧէ�֧� �ӧ�٧ӧ�ѧ�� �ߧ� ���֧ܧ�

    li a7 54                  # ���ڧ��֧ާߧ�� �ӧ�٧�� �էݧ� �ӧӧ�է� �����ܧ�
    ecall                    

    pop(ra)                   
    jr ra                    
    	
# Service to display a message to user
# ����է���ԧ�ѧާާ� �էݧ� ����ҧ�ѧا֧ߧڧ� ����ҧ�֧ߧڧ� ���ݧ�٧�ӧѧ�֧ݧ�
# ���ѧ�ѧާ֧���:
#    a0 - �ѧէ�֧� �����ܧ� ����ҧ�֧ߧڧ�, �ܧ������ �ҧ�է֧� ����ҧ�ѧا֧ߧ� ���ݧ�٧�ӧѧ�֧ݧ� (null-terminated)
#    a1 - the type of the message to the user, which is one of: 
#	0: error message
#	1: information message 
#	2: warning message 
#	3: question message 
#	other: plain message
# ����٧ӧ�ѧ�ѧ֧ާ�� �٧ߧѧ�֧ߧڧ�:
#    ���֧�
message_dialog:
	# ������ѧߧ�֧� �ѧէ�֧� �ӧ�٧ӧ�ѧ�� �ߧ� ���֧ܧ�	
    	push(ra)

    	# ����٧�ӧѧ֧� �էڧѧݧ�ԧ�ӧ�� ��ܧߧ�
    	li a7 55
    	ecall

    	# ���ѧҧڧ�ѧ֧� �ѧէ�֧� �ӧ�٧ӧ�ѧ�� ��� ���֧ܧ� �� �ӧ�٧ӧ�ѧ�ѧ֧�
    	pop(ra)
    	jr ra
    	
# Service to display a message to user
# ���ѧ�ѧާ֧���:
#    a0 - address of null-terminated string that is the message to user
# ����٧ӧ�ѧ�ѧ֧ާ�� �٧ߧѧ�֧ߧڧ�:
#    a0 = Yes (0), No (1), or Cancel(2)
confirm_dialog:
	# ������ѧߧ�֧� �ѧէ�֧� �ӧ�٧ӧ�ѧ�� �ߧ� ���֧ܧ�	
    	push(ra)

    	# ����٧�ӧѧ֧� �էڧѧݧ�ԧ�ӧ�� ��ܧߧ�
    	li a7 50
    	ecall

    	# ���ѧҧڧ�ѧ֧� �ѧէ�֧� �ӧ�٧ӧ�ѧ�� ��� ���֧ܧ� �� �ӧ�٧ӧ�ѧ�ѧ֧�
    	pop(ra)
    	jr ra

# ����է���ԧ�ѧާާ� ��էѧݧ֧ߧڧ� ��ڧާӧ�ݧ� �ߧ�ӧ�� �����ܧ�
# ���ѧ�ѧާ֧���:
#    4(sp) - �ѧէ�֧� �����ܧ�
# ����٧ӧ�ѧ�ѧ֧ާ�� �٧ߧѧ�֧ߧڧ�: 
#    ���֧�
remove_newline:
	push(ra)
	
	# �������ѧߧѧӧݧڧӧѧ֧� �٧ߧѧ�֧ߧڧ� �ѧէ�֧�� �����ܧ� �ڧ� ���֧ܧ�
	lw t1 4(sp)
remove_newline_loop:
    	lb t2 (t1)
    	beqz t2 remove_newline_end
    	li t3 10  	# ����� ��ڧާӧ�ݧ� �ߧ�ӧ�� �����ܧ�
    	beq t2 t3 remove_newline_found
    	addi t1 t1 1
    	j remove_newline_loop
remove_newline_found:
    	sb zero (t1)
remove_newline_end:
    	pop(ra)
    	jr ra 		# ������էڧ� �ڧ� ���է���ԧ�ѧާާ�

# ����է���ԧ�ѧާާ� �էݧ� �٧ѧ�ڧ�� ����ݧ֧էߧڧ� N ��ڧާӧ�ݧ�� �����ܧ� �� ��ѧۧ�
# ���ѧ�ѧާ֧���:
#    a0 - �ѧէ�֧� ��֧ܧ���
#    a1 - �էݧڧߧ� ��֧ܧ���
#    a2 - N (�ܧ�ݧڧ�֧��ӧ� ��ڧާӧ�ݧ��)
#    a3 - �է֧�ܧ�ڧ���� �ӧ���էߧ�ԧ� ��ѧۧݧ�
# ����٧ӧ�ѧ�ѧ֧ާ�� �٧ߧѧ�֧ߧڧ�:
#    ���֧�
find_last_symbols:
    push(ra)                 # ������ѧߧ֧ߧڧ� �ѧէ�֧�� �ӧ�٧ӧ�ѧ��

    mv s3 a0                # ���է�֧� ��֧ܧ���
    mv s4 a1                # ���ݧڧߧ� ��֧ܧ���
    mv s5 a2                # N (�ܧ�ݧڧ�֧��ӧ� ��ڧާӧ�ݧ�� �էݧ� �٧ѧ�ڧ��)
    mv s8 a3                # ���֧�ܧ�ڧ���� �ӧ���էߧ�ԧ� ��ѧۧݧ�
    mv s7 a4		   # ����ҧ�� Yes/No (0 / 1)

    blt s4 s5 use_full_text # ����ݧ� N > �էݧڧߧ� �����ܧ�, �٧ѧ�ڧ�ѧ�� �ӧ�� �����ܧ�

    sub s6 s4 s5            # ���ѧ�ѧݧ�ߧ�� �ڧߧէ֧ܧ�: �էݧڧߧ� - N
    add s3 s3 s6            # ���ܧѧ٧ѧ�֧ݧ� = �ߧѧ�ѧݧ� ����ݧ֧էߧڧ� N ��ڧާӧ�ݧ��
    mv s6 s5                # ���ѧ٧ާ֧� �٧ѧ�ڧ�� ��ѧӧ֧� N
    j write_to_file        # ���֧�֧ۧ�� �� �٧ѧ�ڧ�� �� ��ѧۧ�

use_full_text:
    mv s6 s4                # ����ݧ� N > �էݧڧߧ� �����ܧ�, �٧ѧ�ڧ��ӧѧ֧� �ӧ�� �����ܧ�

write_to_file:
    write_addr(s8, s3, s6)     	# ���ѧ�ڧ�� �� ��ѧۧ�
    
    beqz s7 write_to_console 	# ����ݧ� s7 == 0, �ӧ�ӧ�� �� �ܧ�ߧ��ݧ�
    j end_subroutine

write_to_console:
    li t0 1
    write_addr(t0, s3, s6)    # ����ӧ�� �� �ܧ�ߧ��ݧ� (�է֧�ܧ�ڧ���� stdout = 1)

end_subroutine:
    pop(ra)
    jr ra                           