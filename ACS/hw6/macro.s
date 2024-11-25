.macro strncpy (%dest, %src, %n)
	la a0, %dest
	la a1, %src
	li a2, %n
	jal _strncpy
.end_macro
