; REGISTER FUNCTIONALITY
; R0 - one of the registers performing the math operations in square(). Additionally, it does other things in other functions such as holding the array pointer address or holding the running total. 
; R1 - one of the registers performing the math operations in square(). It has other uses in other functions such as holding int x or holding the running total in order to do math. 
; R2 - holds the array size, which is to be negated and used as a comparator for the amount of loops we must do. In square, it also serves as a counter. 
; R3 - the counter that is used alongside the comparator. 
; R4 - ALWAYS points to global variables. Please do not change this register's value after assigning it. 
; R5 - The frame pointer. Each function has its own, so it must be saved when new functions are called. 
; R6 - The stack pointer. There is one per CPU core. It stays constant between functions. 
; R7 - holds the return address and must be saved each time a new function is called. 

; ************************************************************************************************

.ORIG x3000

    LD R6, STACK_PTR		;	LOAD the pointer to the bottom of the stack in R6	(R6 = x5013)
    ADD R6, R6, #-1			;	Allocate room for your return value 				(R6 = x5012)
    ADD R5, R6, #0			;	MAKE your frame pointer R5 point to local variables	(R5 = x5012)
    LEA R4, GLOBAL_VARS		;	MAKE your global var pointer R4 point to globals	(R4 = ADDRESS(GLOBAL_VARS))

    LEA R0, ARRAY_POINTER	;	LOAD the address of your array pointer
    STR R0, R5, #0			;	STORE pointer to array in stack						(R5 = x5012)
    ADD R6, R6, #-2			;	MAKE stack pointer go back two addresses			(R6 = x5010)

    STR R0, R6, #0			;	STORE pointer to array (input to sumOfSquares())	(R6 = x5010)
    ADD R6, R6, #-1			;	MAKE stack pointer go back one address				(R6 = x500F)

    LDR R0, R4, #0			;	LOAD MAX_ARRAY_SIZE value into R0
    STR R0, R6, #0			;	STORE MAX_ARRAY_SIZE value into stack				(R6 = x500F)

    ADD R6, R6, #-1			;	MAKE stack pointer go back one address				(R6 = x500E)
    JSR sumOfSquares		;	CALL sumOfSquares() function
    LDR R0, R5, #-4			;	LOAD return value of sumOfSquares() into R0			(R5 = x5012)

    ADD R6, R6, #1			;	POP input to sumOfSquares() off the stack			(R6 = x5010)

    STR R0, R5, #-1			;	STORE int total into stack							(R5 = x5012)
    STR R0, R5, #1			;	STORE main() return value into stack				(R5 = x5012)

    ADD R6, R6, #4			;	POP stack											(R6 = x5014)
HALT

; ************************************************************************************************

GLOBAL_VARS					;	Your global variables start here
MAX_ARRAY_SIZE	.FILL x0005	;	MAX_ARRAY_SIZE is a global variable and predefined
ARRAY_POINTER	.FILL x0002	;	ARRAY_POINTER points to the top of your array (5 elements)
				.FILL x0003
				.FILL x0005
				.FILL x0000
				.FILL x0001
STACK_PTR		.FILL x5013	;	STACK_PTR is a pointer to the bottom of the stack	(x5013)

; ************************************************************************************************

sumOfSquares
    ADD R6, R6, #-1			;	Allocate room for your return value relative to R6	(R6 = x500D)

    STR R7, R6, #0          ;	STORE the return address in the stack 				(R6 = x500D)
    ADD R6, R6, #-1         ;	MAKE stack pointer go back one address             	(R6 = x500C)

    STR R5, R6, #0          ;	STORE R5 (previous frame pointer) in stack			(R6 = x500C)
    ADD R6, R6, #-1         ;	MAKE stack pointer go back one address				(R6 = x500B)

    STR R3, R6, #0          ;	STORE R3 in stack									(R6 = x500B)
    ADD R6, R6, #-1         ;	MAKE stack pointer go back one address				(R6 = x500A)

    STR R2, R6, #0          ;	STORE R2 in stack									(R6 = x500A)
    ADD R6, R6, #-1         ;	MAKE stack pointer go back one address				(R6 = x5009)

    STR R1, R6, #0          ;	STORE R1 in stack									(R6 = x5009)
    ADD R6, R6, #-1         ;	MAKE stack pointer go back one address				(R6 = x5008)

    STR R0, R6, #0          ;	STORE R0 in stack									(R6 = x5008)
    ADD R6, R6, #-1         ;	MAKE stack pointer go back one address				(R6 = x5007)

    ADD R5, R6, #0          ;	MAKE frame pointer point to local variables			(R5 = x5007)
    ADD R6, R6, #-2         ;	MAKE stack pointer point to top of stack			(R6 = x5005)

    LDR R2, R5, #8          ;	LOAD input from main() (arraySize) into R2  		(R5 = x5007)
    AND R3, R3, #0          ;	CLEAR R3 to use as counter
    
    STR R3, R5, #0          ;	STORE counter = 0 value into stack					(R5 = x5007)
    STR R3, R5, #-1         ;	STORE sum = 0 value into stack						(R5 = x5007)

    NOT R2, R2              ;	NEGATE R2 for BRANCH checking
    ADD R2, R2, #1

WHILE_LOOP					;	START of while loop
    ADD R1, R2, R3          ;	CHECK if we should stop looping, i.e. counter > arraySize
    BRz DONE                ;   Branch to DONE if these conditions are met

    LDR R0, R5, #9          ;	LOAD array pointer into R0          				(R5 = x5007)
    ADD R0, R3, R0          ;	ADD counter + array address into R0 to get value at index
    LDR R0, R0, #0          ;	LOAD value at the current array address into R0
         
    STR R0, R5, #-2         ;	STORE value from array in stack (int x) 			(R5 = x5007)
    
    ADD R6, R6, #-1         ;	MAKE stack pointer go back one address				(R6 = x5004)
    JSR square              ;	CALL square()
    LDR R0, R5, #-3          ;	LOAD return value of square() into R0		    	(R5 = x5007)
    LDR R1, R5, #-1         ;	LOAD current running sum into R1				    (R5 = x5007)
    ADD R0, R0, R1          ;	ADD current running sum to return value of squares()
    STR R0, R5, #-1         ;	STORE new sum into stack        					(R5 = x5007)
    ADD R3, R3, #1          ;	ADD 1 to counter
    STR R3, R5, #0          ;	STORE counter into stack							(R5 = x5007)
    BR WHILE_LOOP           ;   Branch unconditionally back to WHILE_LOOP

DONE
    LDR R0, R5, #-1         ;	LOAD int sum into R0								(R5 = x5007)
    STR R0, R5, #7          ;	STORE int sum into return value on stack            (R5 = x5007)

    ADD R6, R6, #2          ;	MAKE stack pointer go to end of frame		        (R6 = x5007)

    ADD R6, R6, #1          ;	MAKE stack pointer go forward one address			(R6 = x5008)
    LDR R0, R6, #0          ;	RESTORE R0 to value stored on stack		            (R6 = x5008)

    ADD R6, R6, #1          ;	MAKE stack pointer go forward one address			(R6 = x5009)
    LDR R1, R6, #0          ;	RESTORE R1 to value stored on stack					(R6 = x5009)

    ADD R6, R6, #1          ;	MAKE stack pointer go forward one address			(R6 = x500A)
    LDR R2, R6, #0          ;	RESTORE R2 to value stored on stack					(R6 = x500A)

    ADD R6, R6, #1          ;	MAKE stack pointer go forward one address			(R6 = x500B)
    LDR R3, R6, #0          ;	RESTORE R3 to value stored on stack					(R6 = x500B)

    ADD R6, R6, #1          ;	MAKE stack pointer go forward one address			(R6 = x500C)
    LDR R5, R6, #0          ;	RESTORE R5 to value stored on stack					(R6 = x500C)

    ADD R6, R6, #1          ;	MAKE stack pointer go forward one address			(R6 = x500D)
    LDR R7, R6, #0          ;	RESTORE R7 to value stored on stack					(R6 = x500D)

    ADD R6, R6, #2          ;	POP stack	                                        (R6 = x500F)

RET

; ************************************************************************************************
 
square
    ADD R6, R6, #-1         ;	Allocate 1 word for your return value 				(R6 = x5003)

    STR R7, R6, #0          ;	STORE the return address in the stack	            (R6 = x5003)
    ADD R6, R6, #-1         ;	MAKE stack pointer go back one address				(R6 = x5002)

    STR R5, R6, #0          ;	STORE R5 (sumOfSquares()'s stack pointer) in stack	(R6 = x5002)
    ADD R6, R6, #-1         ;	MAKE stack pointer go back one address				(R6 = x5001)

    STR R3, R6, #0          ;	STORE R3 in stack									(R6 = x5001)
    ADD R6, R6, #-1         ;	MAKE stack pointer go back one address				(R6 = x5000)

    STR R2, R6, #0          ;	STORE R2 in stack									(R6 = x5000)
    ADD R6, R6, #-1         ;	MAKE stack pointer go back one address				(R6 = x4FFF)

    STR R1, R6, #0          ;	STORE R1 in stack									(R6 = x4FFF)
    ADD R6, R6, #-1         ;	MAKE stack pointer go back one address				(R6 = x4FFE)

    STR R0, R6, #0          ;	STORE R0 in stack									(R6 = x4FFE)
    ADD R6, R6, #-1         ;	MAKE stack pointer go back one address				(R6 = x4FFD)

    ADD R5, R6, #0          ;	MAKE frame pointer point to local vars		        (R5 = x4FFD)

    AND R0, R0, #0          ;	CLEAR R0 for calculations
    STR R0, R5, #0          ;	STORE product = 0 into stack						(R5 = x4FFD)

    LDR R1, R5, #8          ;	LOAD int x into R1 for multiplication				(R5 = x4FFD)

    ADD R2, R1, #0          ;	COPY int x into R2 for multiplication

MULTIPLY_LOOP
    ADD R0, R1, R0          ;	ADD R1 + R0 to keep running total of multiplication
    ADD R2, R2, #-1         ;	SUBTRACT 1 from R2 to keep track of loop
    BRp MULTIPLY_LOOP       ;   Keep branching back to MULTIPLY loop as long as we are greater than zero

    STR R0, R5, #0          ;	STORE multiplication into int product on stack		(R5 = x4FFD)
    STR R0, R5, #7          ;	STORE multiplication into return value on stack	    (R5 = x4FFD)

    ; CLEAN UP STEPS: These steps restore the stack back to the way it was when sumOfSquares() executed. 
    ADD R6, R6, #1          ;	MAKE stack pointer go forward one address			(R6 = x4FFE)
    LDR R0, R6, #0          ;	RESTORE R0 to value stored on stack					(R6 = x4FFE)

    ADD R6, R6, #1          ;	MAKE stack pointer go forward one address			(R6 = x4FFF)
    LDR R1, R6, #0          ;	RESTORE R1 to value stored on stack					(R6 = x4FFF)

    ADD R6, R6, #1          ;	MAKE stack pointer go forward one address			(R6 = x5000)
    LDR R2, R6, #0          ;	RESTORE R2 to value stored on stack					(R6 = x5000)

    ADD R6, R6, #1          ;	MAKE stack pointer go forward one address			(R6 = x5001)
    LDR R3, R6, #0          ;	RESTORE R3 to value stored on stack					(R6 = x5001)

    ADD R6, R6, #1          ;	MAKE stack pointer go forward one address			(R6 = x5002)
    LDR R5, R6, #0          ;	RESTORE R5 to value stored on stack					(R6 = x5002)

    ADD R6, R6, #1          ;	MAKE stack pointer go forward one address			(R6 = x5003)
    LDR R7, R6, #0          ;	RESTORE R7 to value stored on stack					(R6 = x5003)

    ADD R6, R6, #2          ;	POP stack											(R6 = x5005)

RET

.END
