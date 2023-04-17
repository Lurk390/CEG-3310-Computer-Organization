; BEGINNING REGISTER GUIDE
; R0 is an input/output register. 
; R1 is a scratch math register.
; R2 holds the return value from FIBONACCI, which doubles as the return value for BEGINNING.
; R3 is a scratch math register. 
; R4 is the global variable pointer. DO NOT MODIFY IT ONCE IT IS SET. 
; R5 is the frame pointer. The frame pointer points to the BOTTOM of the local variables in the current frame/function. Each function has its own frame pointer, so you MUST preserve it when changing functions!
; R6 is your stack pointer. It ALWAYS points to the top of the stack. There is one stack pointer per CPU (one total for this program). To push an item to the stack, allocate space for it and then store it to that space. To pop an item off the stack, move the stack pointer past that item. It will still persist in memory, but will no longer be a member of the stack. 
; R7 is the return address. It must be preserved between functions. 
 
; ****************************************************************

.ORIG x3000

BEGINNING
;   main() function starts here
    LD R6, STACK_PTR        ;	LOAD the pointer to the bottom of the stack in R6	(R6 = x5013)
    ADD R6, R6, #-1         ;	Allocate room for your return value                 (R6 = x5012)
    ADD R5, R6, #0          ;	MAKE your frame pointer R5 point to local variables	(R5 = x5012)
    LEA R4, GLOBAL_VARS     ;	MAKE your global var pointer R4 point to globals	(R4 = ADDRESS(GLOBAL_VARS))
    LEA R0, PROMPT0         ;	LOAD the start of the string into R0
    PUTS                    ;	LOAD the prompt
    GETC                    ;	GET the character the user entered
    OUT                     ;	PRINT the character the user entered
    LD R1, ASCII_NUM        ;	LOAD the value to subtract from an ASCII number to convert to decimal
    ADD R0, R0, R1          ;	CONVERT ASCII numeric character to decimal
    ADD R1, R0, #0          ;	COPY R0 into R1 for later use
    STR R1, R6, #0          ;	STORE the decimal input to fibonacci on the stack   (R6 = x5012)
    ADD R6, R6, #-1         ;	MAKE stack pointer go back one address				(R6 = x5011)
    JSR FIBONACCI           ;	CALL FIBONACCI
    LDR R2, R5, #-1         ;	LOAD return value of FIBONACCI into R2             	(R5 = x5012)
    ADD R6, R6, #1          ;	POP input to FIBONACCI off the stack            	(R6 = x5012)
    LEA R0, PROMPT1         ;	Load the prompt into the output register
    PUTS                    ;	Print the prompt
    ADD R0, R1, #0          ;	Copy the value in R1 to R0
    LD R1, ASCII_NUM        ;	LOAD the value to subtract from an ASCII number to convert to decimal
    NOT R1, R1              ;	Do a two's complement
    ADD R1, R1, #1          ;	Second step of two's complement
    ADD R0, R0, R1          ;	CONVERT ASCII numeric character to decimal
    OUT                     ;	Print out output
    LEA R0, PROMPT2         ;	Load the prompt into the output register
    PUTS                    ;	Print the prompt
    ADD R3, R2, #0          ;	COPY R2 to R3
    AND R1, R1, #0          ;	CLEAR R1
 
; Checks the amount of tens in your ASCII digit
CHECK_10S
    ADD R1, R1, #1          ;	INCREMENT R1 to start counting the number of 10s
    ADD R3, R3, #-10        ;	SUBTRACT 10 from R3
    BRzp CHECK_10S          ;	BRANCH to CHECK_10s if R3 is non negative
    ADD R1, R1, #-1         ;	SUBTRACT 1 from R1
    BRz SKIP_PRINT10S       ;	BRANCH to SKIP_PRINT10s if there are no 10s
    ADD R0, R1, #0          ;	COPY R1 to R0 for conversion
    LD R1, ASCII_NUM        ;	LOAD the value to subtract from an ASCII number to convert to decimal
    NOT R1, R1              ;	Do a two's complement
    ADD R1, R1, #1          ;	Second step of two's complement
    ADD R0, R0, R1          ;	ADD R0 and R1 to add the amount of tens places to get the tens place digit
    OUT                     ;	PRINT the character
 
; If there's no tens place value
SKIP_PRINT10S
    ADD R3, R3, #10         ;	ADD #10 to R3
    AND R1, R1, #0          ;	CLEAR R1
 
; Checks the ones place value
CHECK_1S
    ADD R1, R1, #1          ;	ADD #1 to R1
    ADD R3, R3, #-1         ;	DECREMENT R3
    BRzp CHECK_1S           ;	BRANCH back to CHECK_1s if R3 is non negative
    ADD R0, R1, #-1         ;	DECREMENT R1 and store in R0
    LD R1, ASCII_NUM        ;	LOAD the value to subtract from an ASCII number to convert to decimal
    NOT R1, R1              ;	Do a two's complement
    ADD R1, R1, #1          ;	Second step of two's complement
    ADD R0, R0, R1          ;	CONVERT ASCII numeric character to decimal
    OUT                     ;	PRINT a character
    LEA R0, PROMPT3         ;	PRINT out the prompt
    PUTS                    ;	Print the string of characters
    STR R2, R5, #0          ;	STORE main() return value into stack			    (R5 = x5012)
    ADD R6, R6, #1          ;	POP stack										    (R6 = x5014)
    BR BEGINNING            ;	BRANCH unconditionally back to BEGINNING
    HALT                    ;	HALT the program
 
GLOBAL_VARS					;	Your global variables start here
PROMPT0 		.STRINGz	"Please enter a number n: " ;	The first prompt to print
STACK_PTR		.FILL x5013	;	STACK_PTR is a pointer to the bottom of the stack	(x5013)
ASCII_NUM		.FILL #-48	;
PROMPT1 		.STRINGz	"\nF(" ;	The second prompt
PROMPT2 		.STRINGz	") = " ;	The second prompt
PROMPT3			.STRINGz	"\n"
 
; ****************************************************************
 
; FIBONACCI REGISTER GUIDE
; R0, R1, and R2 are all multipurpose math registers. Can you figure out exactly what each one is doing?
; R3 is unused.
; R4 is the global variable pointer. DO NOT MODIFY IT ONCE IT IS SET. 
; R5 is the frame pointer. The frame pointer points to the BOTTOM of the local variables in the current frame/function. Each function has its own frame pointer, so you MUST preserve it when changing functions!
; R6 is your stack pointer. It ALWAYS points to the top of the stack. There is one stack pointer per CPU (one total for this program). To push an item to the stack, allocate space for it and then store it to that space. To pop an item off the stack, move the stack pointer past that item. It will still persist in memory, but will no longer be a member of the stack. 
; R7 is the return address. It must be preserved between functions. 
 
; ****************************************************************
 
FIBONACCI
;	Your fibonacci subroutine starts here
    ADD R6, R6, #-1         ;	Allocate room for your return value 				(R6 = x5010)
    
    STR R7, R6, #0          ;	STORE the return address in the stack				(R6 = x5010)
    ADD R6, R6, #-1         ;	MAKE stack pointer go back one address				(R6 = x500F)
    
    STR R5, R6, #0          ;	STORE R5 (previous frame pointer) in stack			(R6 = x500F)
    ADD R6, R6, #-1         ;	MAKE stack pointer go back one address				(R6 = x500E)
    
    STR R3, R6, #0          ;	STORE R3 in stack									(R6 = x500E)
    ADD R6, R6, #-1         ;	MAKE stack pointer go back one address				(R6 = x500D)
    
    STR R2, R6, #0          ;	STORE R2 in stack									(R6 = x500D)
    ADD R6, R6, #-1         ;	MAKE stack pointer go back one address				(R6 = x500C)
    
    STR R1, R6, #0          ;	STORE R1 in stack									(R6 = x500C)
    ADD R6, R6, #-1         ;	MAKE stack pointer go back one address				(R6 = x500B)
    
    STR R0, R6, #0          ;	STORE R0 in stack									(R6 = x500B)
    ADD R6, R6, #-1         ;	MAKE stack pointer go back one address				(R6 = x500A)
    
    ADD R5, R6, #0          ;	MAKE R5 point to R6									(R5 = x500A)
 
;;;;;;
 
    LDR R0, R5, #8          ;	LOAD input from stack								(R5 = x500A)
    ADD R1, R0, #-1         ;	CHECK if input = 1
    BRz END_ALL_CASES       ;	BRANCH if zero to END_ALL_CASES
    ADD R0, R0, #1          ;	ADD 1 to R0
    ADD R0, R0, #-1         ;	CHECK if input = 0
    BRz END_ALL_CASES       ;	BRANCH if zero to END_ALL_CASES
    
    ADD R0, R0, #-1         ;	CALCULATE n-1
    STR R0, R6, #0          ;	STORE input to fibonacci(n-1) on stack				(R6 = x500A)
    ADD R6, R6, #-1         ;	MAKE stack pointer go back one address				(R6 = x5009)
    JSR FIBONACCI           ;	JUMP subroutine to FIBONACCI
    LDR R1, R5, #-1         ;	LOAD return value into R1							(R5 = x500A)
    ADD R6, R6, #1          ;	POP input to F(n-1)									(R6 = x500A)
    
    ADD R0, R0, #-1         ;	CALCULATE n-1-1 (n-2)	
    STR R0, R6, #0          ;	STORE input to fibonacci(n-2) on stack				(R6 = x500A)
    ADD R6, R6, #-1         ;	MAKE stack pointer go back one address				(R6 = x5009)
    JSR FIBONACCI           ;	JUMP subroutine to FIBONACCI
    LDR R2, R5, #-1         ;	LOAD return value into R2							(R5 = x500A)
    ADD R6, R6, #1          ;	POP input to F(n-2)									(R6 = x500A)
    
    ADD R0, R1, R2          ;	ADD R1 + R2 -> R0, aka F(n-1) + F(n-2) -> R0
 
END_ALL_CASES
    STR R0, R5, #7          ;	STORE return (R0) into return value on stack		(R5 = x500A)
    
    ADD R6, R5, #0          ;	MAKE stack pointer go to end of frame				(R6 = x500A)
    
    ADD R6, R6, #1          ;	MAKE stack pointer go forward one address			(R6 = x500B)
    LDR R0, R6 #0           ;	RESTORE R0 to value stored on stack					(R6 = x500B)
    
    ADD R6, R6, #1          ;	MAKE stack pointer go forward one address			(R6 = x500C)
    LDR R1, R6 #0           ;	RESTORE R1 to value stored on stack					(R6 = x500C)
    
    ADD R6, R6, #1          ;	MAKE stack pointer go forward one address			(R6 = x500D)
    LDR R2, R6 #0           ;	RESTORE R2 to value stored on stack					(R6 = x500D)
    
    ADD R6, R6, #1          ;	MAKE stack pointer go forward one address			(R6 = x500E)
    LDR R3, R6 #0           ;	RESTORE R3 to value stored on stack					(R6 = x500E)
    
    ADD R6, R6, #1          ;	MAKE stack pointer go forward one address			(R6 = x500F)
    LDR R5, R6 #0           ;	RESTORE R5 to value stored on stack					(R6 = x500F)
    
    ADD R6, R6, #1          ;	MAKE stack pointer go forward one address			(R6 = x5010)
    LDR R7, R6 #0           ;	RESTORE R7 to value stored on stack					(R6 = x5010)
    
    ADD R6, R6, #1          ;	POP stack											(R6 = x5011)

RET
 
.END