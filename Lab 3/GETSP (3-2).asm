;	Main program to test the subroutine GETSP
;	This program simply prompts for two strings and
;	displays them back using PUTSP
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
	JSR	GETSP		; Call GETSP
	ADD	R6, R6, #2	; Clean up (pop parameter & return value)
 
;	Prompt for second string:
	LEA	R0, PRMPT2 ; Loads the address of PRMPT2
	PUTS
 
;	Call GETS to get second string:
	LEA	R0, STRNG2 ; Loads the address of STRNG2
	ADD	R6, R6, #-1	; Push the second address to store the string at
	STR	R0, R6, #0
	JSR	GETSP		; Call GETSP
	ADD	R6, R6, #2	; Clean up (pop parameter & return value)
 
;	Output both strings:
	LEA	R0, OUT1	; First string...
	PUTS
	LEA	R0, STRNG1
	PUTSP
	LD	R0, LF		; Print a linefeed
	OUT             ; Write character to console (TRAP x21)
	LEA	R0, OUT2	; Second string.
	PUTS
	LEA	R0, STRNG2
	PUTSP
 
	HALT            ; We are done
 
;	GLOBAL VARIABLES
;	----------------
STKBASE	.FILL		xFDFF		; The bottom of the stack will be xFDFF
LF		.FILL		x0A		; A linefeed character. Change this to x0D if you are using UNIX desktop sim
PRMPT1	.STRINGZ	"Please enter the first string: "
PRMPT2	.STRINGZ	"Please enter the second string: "
OUT1	.STRINGZ	"The first string was: "
OUT2	.STRINGZ	"The second string was: "
CLU     .FILL x00FF			; Clear upper byte of a value in a register
CLL     .FILL xFF00			; Clear lower byte of a value in a register
STRNG1	.BLKW		#80		; Room for 79 characters (unpacked) + NULL
STRNG2	.BLKW		#80		; Room for 79 characters (unpacked) + NULL
 
; Professor's notes: 
;=====================================================================================
; Place your GETSP subroutine below the notes:
;=====================================================================================
; Subroutine GETSP
;  Parameters:  Address - the address to store the string at
;
;  Returns:    Nothing
;
;  Local variables
;   Offset	Description
;	 0	Callee-saved register R0
;	-1	Callee-saved register R1
;------------------------------------------------------------------------------------- 
 
; TA's notes below. These are not steps, but rather information provided to clarify the process. 
; PLEASE NOTE: The implementation of PUTSP on the websim is bugged. You MUST use the desktop sim for this part! Otherwise, your message will be missing every other character. 
; ************************************************************************************
 
; REGISTER CONTENTS
; R0 holds the characters we read one by one. It also serves as a counter of the amount of remaining left shifts to perform in the last third of the loop. 
; R1 holds a sentinel value (a value to look for that triggers an operation); specifically a newline x0A (x0D on UNIX), for the first two-thirds of the loop. For the last third, it is the register performing the bit shift steps. 
; R2 holds the current address in memory we are writing the string to.
; R3 and R4 are placeholder registers for packing the two characters; R3 holds the second character and R4 holds the first character. 
; R5 is the frame pointer. It allows us to have a fixed address for that subroutine to reference. There can be up to one frame pointer per subroutine. 
; R6 is the stack pointer. Each address stores 1 word (two bytes). Each CPU core has one stack pointer. 
; R7 holds the program value from where we originally called JSR so we can return there (the return address)
 
; Return value: the value we are going to return to the calling address. To allocate space we need to do Stack Pointer = Stack Pointer - 1. 
; Return address: the memory address we originally JSR from. 
 
; ************************************************************************************
 
; PACKED STRING EXPLANATION
; A string compatible with the PUTS function is 1 character per memory address. 
; However, since ASCII characters are 8 bits in size, we end up wasting 8 bits of space per memory address (since memory values are always 2 bytes/1 word per address). 
; In order to more efficiently use memory space, we can pack 2 characters together into one address in memory. 
; PUTSP expects an array of words of these packed characters. Specifically, in second character/first character pairs. 
; For example, "cats" would be stored as |ac||st| and "cat" would be stored as |ac||0t|, where 0 is a null character
; In C, we can achieve this with the following expression: 
; (((C2 & 0x00FF) << 8) & 0xFF00) | (C1 & 0x00FF)
; For this lab, you will be implementing this algorithm. 
 
; ************************************************************************************
 
; LOOP TERMINATION CONDITIONS 
; If our first character is a line break, write a zero to the current position in the string and then branch to done. 
; If our second character is a line break, we will write the contents of R4 and then branch to done. This second failure condition will occur in the L2C subroutine. 
 
; ************************************************************************************
 
; Things in parentheses are explanations, NOT additional steps. 
 
;-------------------------------------------------------------------------------------
; START YOUR CODE HERE
; The stack pointer will initially point to xFDFE
; Try drawing the below as a picture of a stack using the addresses provided.
 
; The steps for the main GETSP subroutine are similar to the GETS subroutine in Part 1
 
GETSP	ADD R6, R6, #-1		; Decrement R6 by #-1 (to allocate a word to store a return value) (R6: xFDFD)
		ADD R6, R6, #-1		; Decrement R6 by #-1 (this moves to push R7, our return address, onto the stack) (R6: xFDFC)
		STR R7, R6, #0		; Store contents of R7 at the address of R6 + #0 (to save a copy of the return address)
		ADD R6, R6, #-1		; Decrement R6 by #-1 again (this action allocates space to push R5, the previous functions's frame pointer, onto the stack) (R6: xFDFB)
		STR R5, R6, #0		; Store contents of R5 at the address of R6 + #0 (store previous frame pointer)
		ADD R5, R6, #-1		; Decrement R6 by #-1 and store into R5 (this sets up a new frame pointer)  (R5: xFDFA)
		ADD R6, R6, #-5		; Decrement R6 by #-5 (this allocates space for local variables) (R6: xFDF6)
		STR R0, R5, #0		; Store contents of R0 at the memory address of R5 + #0 (In memory: xFDFA)
		STR R1, R5, #-1		; Store contents of R1 at the memory address of R5 + #-1 (In memory: xFDF9)
		STR R2, R5, #-2		; Store contents of R2 at the memory address of R5 + #-2 (In memory: xFDF8)
		STR R3, R5, #-3		; Store contents of R3 at the memory address of R5 + #-3 (In memory: xFDF7)
		STR R4, R5, #-4		; Store contents of R4 at the memory address of R5 + #-4 (In memory: xFDF6)
		LDR R2, R5, #4		; Load from memory address R5 + #4 and put contents into R2. (This step gets the address parameter.) (In memory: xFDFE)
 
; LOOP reads in up to two characters, pack them into a single word, and store them in memory. 
LOOP    ; NOTE: Packed characters are of the form:
		; (((C2 & 0x00FF) << 8) & 0xFF00) | (C1 & 0x00FF)
		GETC				; Get character using GETC function call
		OUT					; Print the character using the OUT function call
			
		; Check for a linefeed using the following steps: 
		AND R1, R1, #0		; Clear R1
		ADD R1, R1, #-10	; Decrement R1 by #-10 (#-13 on UNIX)
		ADD R1, R1, R0		; Compare R1 and R0 and store the result in R1 (If they are equal, R1 will be 0)
		BRnp L2C			; Branch IF NONZERO ONLY to the L2C subroutine
		STR R1, R2, #0		; Store contents of R1 at the memory address of R2 + #0 (else, we will have a line break if we do not branch)
		BR DONE				; Unconditionally branch to DONE
	
; L2C (LOOP Second Character) is similar to LOOP, but with 3 new steps at the beginning. It handles the second character in the packed character pair given that the first character is not a line break. 
L2C
		ADD R4, R0, #0		; Copy the value in R0 into R4 (R4 serves as a temp register for the first character)
		LD R1, CLU			; Load CLU variable into R1 (HINT: CLU and CLL are variables so you can load them directly)
		AND R4, R4, R1		; Bitwise AND R4 with R1, and place the result into R4. (This will AND the upper half of R4 with zero, and clear them out, while the lower byte will be preserved.) 
	
		GETC				; Get character using GETC function call
		OUT					; Print the character using the OUT function call
	
		; Check for a linefeed using the following steps: 
		AND R1, R1, #0		; Clear R1
		ADD R1, R1, #-10	; Add R1 and #-10 (#-13 on UNIX) and store the result in R1
		ADD R1, R1, R0		; Add R1 and R0 and store the result in R1 (Comparison. If they are equal, R1 will be 0)
		BRnp LPC			; Branch IF NONZERO ONLY to the LPC subroutine
		STR R4, R2, #0		; Store contents of R4 at the memory address of R2 + #0 (This will store the packed form of one character + a null character at our current position)
		BR DONE				; Unconditionally branch to DONE
 
; LPC (LOOP Pack Characters) packs the two characters together, performing the algorithm shown in the notes (assuming NEITHER is a line break)
LPC     ADD R3, R0, #0		; Copy the character from R0 into R3
		LD R1, CLU			; Load CLU variable into R1
		AND R3, R1, R3		; Bitwise AND R3 with R1 and store into R3. (This will AND the upper half of R3 with zero, and clear them out, while the lower byte will be preserved.) 
		AND R0, R0, #0		; Clear R0
		ADD R0, R0, #8		; Add R0 and #8 and store in R0 (this initializes our "shift counter" to x0008)
		ADD R1, R3, #0		; Copy R3 back into R1
 
; LS (LOOP Shift) is a loop that will repeat 8 times, shifting R1 left by 1 binary place value each iteration        
LS      ADD R1, R1, R1		; Add R1 to itself (this will LEFT SHIFT the contents of R1 by 1 binary place value; please familiarize yourself with shifting and binary place values)
		ADD R0, R0, #-1		; Decrement R0 by #-1 (this decrements the shift counter by 1)
		BRp LS				; Branch while positive back to LS (while we still have a positive value in the counter, we need to keep shifting)
	
		ADD R3, R1, #0		; Copy R1 into R3
		LD R1, CLL			; Load CLL variable into R1
		AND R3, R3, R1		; Bitwise AND R3 with R1 and store into R3. (This will AND the lower half of R3 with zero, and clear them out, while the upper byte will be preserved. Because we've shifted left, we've MOVED the contents from the lower byte to the upper byte!)
		ADD R4, R3, R4		; Add R3 and R4 and store into R4 (packing the characters together)
		STR R4, R2, #0		; Store the contents of R4 at the memory address of R2 + #0 (writes the packed character to the current place in the string)
		ADD R2, R2, #1		; Increment R2 by #1 (incrementing our string pointer by 1)
		BR LOOP				; Branch unconditionally back to loop
 
DONE    ; CLEAN UP STEPS
		; Undoes the function stack. We do this to restore the registers and CPU state to before our function was called. The only side effect that remains after RET is the return value and anything after it. 
		LDR R0, R5, #0		; Load from memory address of R5 + #0 and put contents into R0 (to restore the callee-saved registers) (In memory: xFDFA)
		LDR R1, R5, #-1		; Load from memory address of R5 + #-1 and put contents into R1 (In memory: xFDF9)
		LDR R2, R5, #-2		; Load from memory address of R5 + #-2 and put contents into R2 (In memory: xFDF8)
		LDR R3, R5, #-3		; Load from memory address of R5 + #-3 and put contents into R3 (In memory: xFDF7)
		LDR R4, R5, #-4		; Load from memory address of R5 + #-4 and put contents into R4 (In memory: xFDF6)
		ADD R6, R5, #1		; Increment R5 by #1 and store in R6. (This pops the local variables off the stack.)
		LDR R5, R6, #0		; Load from memory address of R6 + #0 and put contents into R5. (This restores the contents of R5 back to the original state)
		ADD R6, R6, #1		; Increment R6 by #1 (This pops off main's frame pointer since R5 was restored) (R6: xFDFB)
		LDR R7, R6, #0		; Load from memory address of R6 + #0 and put the contents into R7. (This restores the return address)
		ADD R6, R6, #1		; Increment R6 by #1 (This pops off the return address since R7 was restored) (R6: xFDFC)
		RET 				; Return to caller
	.END