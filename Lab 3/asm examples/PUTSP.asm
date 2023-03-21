	.ORIG x3000
	LEA	R0, HI
	PUTSP
	HALT
HI	.FILL	x6548	; eH
	.FILL	x6C6C	; ll
	.FILL	x206F	; <sp>o
	.FILL	x6F57	; oW
	.FILL	x6C72	; lr
	.FILL	x0064	; d (NOTE: low-order byte)
	.FILL	x0000	; NULL
	.END