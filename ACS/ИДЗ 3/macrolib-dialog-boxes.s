#================================================================================================
# ���ѧܧ���� �էݧ� ��ѧҧ��� �� �էڧѧݧ�ԧ�ӧ�ާ� ��ܧߧѧާ�
#================================================================================================

#------------------------------------------------------------------------------------------------
# ����٧�� �էڧѧݧ�ԧ�ӧ�ԧ� ��ܧߧ� �էݧ� ���ݧ��֧ߧڧ� �����ܧ�
# ��� ���ݧ�٧�ӧѧ�֧ݧ�
# ���ѧ�ѧާ֧���:
#    %message - �ѧէ�֧� �����ܧ� ����ҧ�֧ߧڧ� �էݧ� ���ݧ�٧�ӧѧ�֧ݧ� (null-terminated)
#    %buffer - �ѧէ�֧� �ҧ��֧�� �էݧ� �����ѧߧ֧ߧڧ� �ӧӧ�է�
#    %symbols_count - �ާѧܧ�ڧާѧݧ�ߧ�� �ܧ�ݧڧ�֧��ӧ� ��ڧާӧ�ݧ�� �էݧ� ���֧ߧڧ� (�ӧܧݧ��ѧ� �٧ѧӧ֧��ѧ��ڧ� null)
.macro input_string_dialog(%message, %buffer, %symbols_count)
    	la a0 %message          	# ���֧�֧էѧ֧� �ѧէ�֧� ����ҧ�֧ߧڧ� �� a0
    	la a1 %buffer         	# ���֧�֧էѧ֧� �ѧէ�֧� �ҧ��֧�� �� a1
    	li a2 %symbols_count
    	jal ra input_string_dialog
.end_macro

#------------------------------------------------------------------------------------------------
# ����٧�� �էڧѧݧ�ԧ�ӧ�ԧ� ��ܧߧ� �էݧ� �ӧ�ӧ�է� ����ҧ�֧ߧڧ�
# ���ѧ�ѧާ֧���:
#    %message - �ѧէ�֧� �����ܧ� ����ҧ�֧ߧڧ�, �ܧ������ �ҧ�է֧� ����ҧ�ѧا֧ߧ� ���ݧ�٧�ӧѧ�֧ݧ� (null-terminated)
#    %type - the type of the message to the user, which is one of: 
#	0: error message
#	1: information message 
#	2: warning message 
#	3: question message 
#	other: plain message
.macro message_dialog(%message, %type)
    	la a0 %message          # ���֧�֧էѧ֧� �ѧէ�֧� ����ҧ�֧ߧڧ� �� a0
    	li a1 %type         	# ���֧�֧էѧ֧� ��ڧ� ��ܧߧ� �� a1
    	jal ra message_dialog
.end_macro

#------------------------------------------------------------------------------------------------
# ����٧�� �էڧѧݧ�ԧ�ӧ�ԧ� ��ܧߧ� �էݧ� �ӧ�ҧ��� Yes/No
# ���ѧ�ѧާ֧���:
#    %message - address of null-terminated string that is the message to user
.macro confirm_dialog(%message)
    	la a0 %message          # ���֧�֧էѧ֧� �ѧէ�֧� ����ҧ�֧ߧڧ� �� a0
    	jal ra confirm_dialog
.end_macro