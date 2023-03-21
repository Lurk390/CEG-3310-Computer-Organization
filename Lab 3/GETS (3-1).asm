;	Main program to test the subroutine GETS
;	This program simply prompts for two strings and
;	displays them back using PUTS
; -------------------------------------------------------------------------
 
	.ORIG	x3000
 
;	Set up the user stack:
	LD	R6, STKBASE ; Sets up the stack by loading the base address into R6
 
;	Prompt for the first string:
	LEA	R0, PRMPT1 ; Loads the address of PRMPT1 into R0
	PUTS
 
;	Call GETS to get first string:
	LEA	R0, STRNG1 ; Loads the address of STRNG1
	ADD	R6, R6, #-1	; Push the address to store the string at
	STR	R0, R6, #0
	JSR	GETS		; Call GETS
	ADD	R6, R6, #2	; Clean up (pop parameter & return value)
 
;	Prompt for second string:
	LEA	R0, PRMPT2 ; Loads the address of PRMPT2
	PUTS
 
;	Call GETS to get second string:
	LEA	R0, STRNG2 ; Loads the address of STRNG2
	ADD	R6, R6, #-1	; Push the second address to store the string at
	STR	R0, R6, #0
	JSR	GETS		; Call GETS
	ADD	R6, R6, #2	; Clean up (pop parameter & return value)
 
;	Output both strings:
	LEA	R0, OUT1	; First string...
	PUTS
	LEA	R0, STRNG1
	PUTS
	LD	R0, LF		; Print a linefeed
	OUT             ; Write character to console (TRAP x21)
	LEA	R0, OUT2	; Second string.
	PUTS
	LEA	R0, STRNG2
	PUTS
 
	HALT            ; We are done
 
;	GLOBAL VARIABLES
;	----------------
STKBASE	.FILL		xFDFF		; The bottom of the stack will be xFDFF
LF		.FILL		x0A			; A linefeed character
STRNG1	.BLKW		#80			; Room for 79 characters (unpacked) + NULL
STRNG2	.BLKW		#80			; Room for 79 characters (unpacked) + NULL
PRMPT1	.STRINGZ	"Please enter the first string: "
PRMPT2	.STRINGZ	"Please enter the second string: "
OUT1	.STRINGZ	"The first string was: "
OUT2	.STRINGZ	"The second string was: "
 
; Professor's notes: 
;=====================================================================================
; Place your GETS subroutine below the notes: 
;=====================================================================================
; Subroutine GETS
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
 
; TA's notes below. These are not steps, but rather information provided to clarify the process. 
; ************************************************************************************
; Reference the included picture of a stack using the addresses provided. 
 
; R0 holds the characters we read one by one.
; R1 holds a sentinel value (a value to look for that triggers an operation); specifically a newline x0A. NOTE: If you are working with the UNIX desktop sim (Mac, Linux, Chrome OS, etc) please use x0D instead!
; R2 holds the current address in memory we are writing the string to. 
; R3 and R4 are unused. 
; R5 is the frame pointer. It allows us to have a fixed address for that subroutine to reference. There can be up to one frame pointer per subroutine. 
; R6 is the stack pointer. Each address stores 1 word (two bytes). Each CPU core has one stack pointer. 
; R7 holds the program value from where we originally called JSR so we can return there (the return address)
; Return value: the value we are going to return to the calling address. To allocate space we need to do Stack Pointer = Stack Pointer - 1. 
; Return address: the memory address we originally JSR from. 
 
; Things in parentheses are explanations, NOT additional steps. 
;-------------------------------------------------------------------------------------
; START YOUR CODE HERE
; The stack pointer will initially point to xFDFE
; Try drawing the below as a picture of a stack using the addresses provided.
 
GETS	ADD R6, R6, #-1		; Decrement R6 by #-1 (to allocate a word to store a return value) (R6: xFDFD)
		ADD R6, R6, #-1		; Decrement R6 by #-1 (this moves to push R7, our return address, onto the stack) (R6: xFDFC)
		STR R7, R6, #0		; Store contents of R7 at the address of R6 + #0 (to save a copy of the return address)
		ADD R6, R6, #-1		; Decrement R6 by #-1 again (this action pushes R5, the previous functions's frame pointer, onto the stack) (R6: xFDFB)
		STR R5, R6, #0		; Store contents of R5 at the address of R6 + #0
		ADD R5, R6, #-1		; Decrement R6 by #-1 and store in R5 (this sets up a new frame pointer)  (R5: xFDFA)
		ADD R6, R6, #-3		; Decrement R6 by #-3 (this allocates space for local variables) (R6: xFDF8)
		STR R0, R5, #0		; Store contents of R0 at the memory address of R5 + #0 (In memory: xFDFA)
		STR R1, R5, #-1		; Store contents of R1 at the memory address of R5 + #-1 (In memory: xFDF9)
		STR R2, R5, #-2		; Store contents of R2 at the memory address of R5 + #-2 (In memory: xFDF8)
		LDR R2, R5, #4		; Load from memory address R5 + #4 and put contents into R2. (This step gets the address parameter.) (In memory: xFDFE)
 
LOOP	GETC				; Get character using GETC function call
		OUT					; Print the character using the OUT function call
	
		; Check for a linefeed using the following steps: 
		AND R1, R1, #0		; Clear R1
		ADD R1, R1, #-10	; Decrement R1 by #-10 (#-13 on the UNIX desktop sim)
		ADD R1, R1, R0		; Compare R1 and R0 and store the result in R1 (If they are equal, R1 will be 0)
		BRz DONE			; Branch to DONE if zero (if not the program will continue down)
	
		; If the result is not zero, do the following steps: 
		STR R0, R2, #0		; Store the character in R0 at the address of R2 + #0
		ADD R2, R2, #1		; Increment R2 by #1
		BR LOOP				; Unconditional branch back to loop
 
DONE    AND R1, R1, #0	; Clear R1
		STR R1, R2, #0	; Store contents of R1 at the address of R2 + #0. (This adds the null character to the end of the string)
	
		; CLEAN UP STEPS
		; Undoes the function stack. We do this to restore the registers and CPU state to before our function was called. The only side effect that remains after RET is the return value and anything after it. 
		LDR R0, R5, #0		; Load from memory address of R5 + #0 and put contents into R0 (to restore the callee-saved registers) (In memory: xFDFA)
		LDR R1, R5, #-1		; Load from memory address of R5 + #-1 and put contents into R1 (In memory: xFDF9)
		LDR R2, R5, #-2		; Load from memory address of R5 + #-2 and put contents into R2 (In memory: xFDF8)
		ADD R6, R5, #1		; Increment R5 by #1 and store in R6. (This pops the local variables off the stack.)
		LDR R5, R6, #0		; Load from memory address of R6 + #0 and put contents into R5. (This restores the contents of R5 back to the original state)
		ADD R6, R6, #1		; Increment R6 by #1 (This pops off main's frame pointer since R5 was restored) (R6: xFDFB)
		LDR R7, R6, #0		; Load from memory address of R6 + #0 and put the contents into R7. (This restores the return address)
		ADD R6, R6, #1		; Increment R6 by #1 (This pops off the return address since R7 was restored) (R6: xFDFC)
		RET 				; Return to caller
	.END