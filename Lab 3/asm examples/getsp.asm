;	Main program to test the subroutine GETSP
;	This program simply prompts for two strings and
;	displays them back using PUTSP
; -------------------------------------------------------------------------

	.ORIG	x3000

;	Set up the user stack:
	LD	R6, STKBASE
	
;	Prompt for the first string:
	LEA	R0, PRMPT1
	PUTS

;	Call GETS to get first string:
	LEA	R0, STRNG1
	ADD	R6, R6, #-1	; Push the address to store the string at
	STR	R0, R6, #0
	JSR	GETSP		; Call GETSP
	ADD	R6, R6, #2	; Clean up (pop parameter & return value)

;	Prompt for second string:
	LEA	R0, PRMPT2
	PUTS

;	Call GETS to get second string:
	LEA	R0, STRNG2
	ADD	R6, R6, #-1	; Push the second address
	STR	R0, R6, #0
	JSR	GETSP		; Call GETSP
	ADD	R6, R6, #2	; Clean up

;	Output both strings:
	LEA	R0, OUT1	; First string...
	PUTS
	LEA	R0, STRNG1
	PUTSP
	LD	R0, LF		; Print a linefeed
	OUT
	LEA	R0, OUT2	; Second string.
	PUTS
	LEA	R0, STRNG2
	PUTSP

	HALT

;	GLOBAL VARIABLES
;	----------------
STKBASE	.FILL		xFDFF		; The bottom of the stack will be xFDFF
LF	.FILL		x0A		; A linefeed character
STRNG1	.BLKW		80		; Room for 158 characters (packed) + NULL
STRNG2	.BLKW		80		; Room for 158 characters (packed) + NULL
PRMPT1	.STRINGZ	"Please enter the first string: "
PRMPT2	.STRINGZ	"Please enter the second string: "
OUT1	.STRINGZ	"The first string was: "
OUT2	.STRINGZ	"The second string was: "

;=====================================================================================
; Place your GETSP subroutine here:
;=====================================================================================
; Subroutine GETSP
;  Paramters:  Address - the address to store the string at
;
;  Returns:    Nothing
;
;  Local variables
;   Offset	Description
;	 0	Callee-saved register R0
;	-1	Callee-saved register R1
;       etc...
;-------------------------------------------------------------------------------------

GETSP	RET
	.END
