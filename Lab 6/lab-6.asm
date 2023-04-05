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
;	Your main() function starts here
    LD R6, STACK_PTR        ;	LOAD the pointer to the bottom of the stack in R6 (HINT: Use STACK_PTR for this!)	(R6 = x5013)
    ADD R6, R6, #-1         ;	Allocate room for your return value 	(HINT: Move the stack pointer back to allocate space.)			(R6 = x5012)
    ADD R5, R6, #0          ;	MAKE your frame pointer R5 point to local variables	(HINT: We are setting up the frame pointer for BEGINNING. Which register do we initialize R5 relative to?) (R5 = x5012)
    LEA R4, GLOBAL_VARS     ;	MAKE your global var pointer R4 point to globals	(R4 = ADDRESS(GLOBAL_VARS))
    LEA R0, PROMPT0         ;	LOAD the start of the string into R0 (HINT: We can use PROMPT0 for this! And, which load do we use for printing text: LD, LDI, LDR, or LEA? Think about it!)
    PUTS                    ;	PRINT the prompt (HINT: It's a Trap! But which one? Note the difference between prompt and output!)
    GETC                    ;	GET the character the user entered (HINT: It's a Trap! But which one?)
    OUT                     ;	PRINT the character the user entered (HINT: It's a Trap! But which one?)
    LD R1, ASCII_NUM        ;	LOAD the value to subtract from an ASCII number to convert to decimal (HINT: Use R1 to hold the value since R0 is already in use. We can use ASCII_NUM to initialize it.)
    ADD R0, R0, R1          ;	CONVERT ASCII numeric character to decimal (HINT: Which register is the ASCII character held in? Which register is the conversion value held in? And which register of those two should we place our result in?)
    ADD R1, R0, #0          ;	COPY R0 into R1 for later use (HINT: How did we copy in previous labs? There's no MOV command.)
    STR R1, R6, #0          ;	STORE the decimal input to fibonacci on the stack	(HINT: The value stored will be located in the destination register from the previous step.) (R6 = x5012)
    ADD R6, R6, #-1         ;	MAKE stack pointer go back one address				(R6 = x5011)
    JSR FIBONACCI           ;	CALL FIBONACCI (HINT: FIBONACCI is NOT a trap but a user function. How do we call user functions?)
    LDR R2, R5, #-1         ;	LOAD return value of FIBONACCI into R2	(HINT: We start here after we return from FIBONACCI. Which register do we want to use to load the return value into R2? R5 or R6?)			(R5 = x5012)
    ADD R6, R6, #1          ;	POP input to FIBONACCI off the stack (HINT: Remember that the stack pointer is ALWAYS the top of the stack. If SP goes below a value, that value is no longer part of the stack (although it still remains in memory). Knowing this, how do we pop input off of the stack?) 				(R6 = x5012)
    LEA R0, PROMPT1         ;	Load the prompt into the output register (HINT: Load PROMPT1 into your output register. Which output register did we use for printing PROMPT0?)
    PUTS                    ;	Print the prompt (HINT: It's a Trap! But which one?)
    ADD R0, R1, #0          ;	Copy the value in R1 to R0
    LD R1, ASCII_NUM        ;	LOAD the value to subtract from an ASCII number to convert to decimal (HINT: Use R1 to hold the value since R0 is already in use. We can use ASCII_NUM to initialize it.)
    NOT R1, R1              ;	Do a two's complement (HINT: Do a two's complement for this step. Please note that a two's complement is two commands: A negate and an add #1!)
    ADD R1, R1, #1          ;	Second step of two's complement
    ADD R0, R0, R1          ;	CONVERT ASCII numeric character to decimal (HINT: Which register is the ASCII character held in? Which register is the conversion value held in? And which register of those two should we place our result in?)
    OUT                     ;	Print out output (HINT: It's a Trap! But which one?)
    LEA R0, PROMPT2         ;	Load the prompt into the output register (HINT: Load PROMPT2 into your output register. Which output register did we use for printing PROMPT0?)
    PUTS                    ;	Print the prompt (HINT: It's a Trap! But which one?)
    ADD R3, R2, #0          ;	COPY R2 to R3
    AND R1, R1, #0          ;	CLEAR R1
 
; Checks the amount of tens in your ASCII digit (REMEMBER: You will be getting out two characters. For example, if we enter a one, we'd get out x31. To convert to decimal, we subtract ASCII zero and then, if there's a tens place value, strip it down to a digit so we can print it.)
CHECK_10S
    ADD R1, R1, #1          ;	INCREMENT R1 to start counting the number of 10s
    ADD R3, R3, #-10        ;	SUBTRACT 10 from R3
    BRzp CHECK_10S          ;	BRANCH to CHECK_10s if R3 is non negative
    ADD R1, R1, #-1         ;	SUBTRACT 1 from R1
    BRz SKIP_PRINT10S       ;	BRANCH to SKIP_PRINT10s if there are no 10s  (HINT: If there are no tens, then what is the branch condition?)
    ADD R0, R1, #0          ;	COPY R1 to R0 for conversion
    LD R1, ASCII_NUM        ;	LOAD the value to subtract from an ASCII number to convert to decimal (HINT: Use R1 to hold the value since R0 is already in use. We can use ASCII_NUM to initialize it.)
    NOT R1, R1              ;	Do a two's complement (HINT: Do a two's complement for this step. Please note that a two's complement is two commands: A negate and an add #1!)
    ADD R1, R1, #1          ;	Second step of two's complement
    ADD R0, R0, R1          ;	ADD R0 and R1 to add the amount of tens places to get the tens place digit
    OUT                     ;	PRINT the character (HINT: It's a Trap! But which one?)
 
; If there's no tens place value
SKIP_PRINT10S
    ADD R3, R3, #10         ;	ADD #10 to R3 (HINT: This is a failsafe to keep the value from going negative.)
    AND R1, R1, #0          ;	CLEAR R1
 
;	Checks the ones place value
CHECK_1S
    ADD R1, R1, #1          ;	ADD #1 to R1 (HINT: This indicates we have at least a 1 value.)
    ADD R3, R3, #-1         ;	DECREMENT R3 (HINT: R3 is your counter.)
    BRzp CHECK_1S           ;	BRANCH back to CHECK_1s if R3 is non negative
    ADD R0, R1, #-1         ;	DECREMENT R1 and store in R0 (HINT: This is because the CHECK_1s will overshoot by one.)
    LD R1, ASCII_NUM        ;	LOAD the value to subtract from an ASCII number to convert to decimal (HINT: Use R1 to hold the value since R0 is already in use. We can use ASCII_NUM to initialize it.)
    NOT R1, R1              ;	Do a two's complement (HINT: Do a two's complement for this step. Please note that a two's complement is two commands: A negate and an add #1!)
    ADD R1, R1, #1          ;	Second step of two's complement
    ADD R0, R0, R1          ;	CONVERT ASCII numeric character to decimal (HINT: Which register is the ASCII character held in? Which register is the conversion value held in? And which register of those two should we place our result in?)
    OUT                     ;	PRINT a character (HINT: It's a Trap! But which one?)
    LEA R0, PROMPT3         ;	PRINT out the prompt (HINT: Use PROMPT3 for this, as well as the same load command and register you used in previous steps.)
    PUTS                    ;	Print the string of characters (HINT: It's a Trap! But which one?)
    STR R2, R5, #0          ;	STORE main() return value into stack (HINT: Use R2 for this!)				(R5 = x5012)
    ADD R6, R6, #1          ;	POP stack (HINT: Draw a picture of the stack. How many variables do we have to pop off the stack in order to return R6 to its starting location?)											(R6 = x5014)
    BR BEGINNING            ;	BRANCH unconditionally back to BEGINNING
    HALT                    ;	HALT the program (HINT: It's a Trap! But which one?)
 
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
    
    STR R7, R6, #0          ;	STORE the return address in the stack	(HINT: What register is the return address held in? Do we do this operation relative to the stack pointer or the frame pointer?)			(R6 = x5010)
    ADD R6, R6, #-1         ;	MAKE stack pointer go back one address				(R6 = x500F)
    
    STR R5, R6, #0          ;	STORE R5 (previous frame pointer) in stack	(HINT: We are currently storing the frame pointer for BEGINNING in the stack so that when we RET back to it, the frame pointer is preserved. Once this store is done, we can modify R5 again.)		(R6 = x500F)
    ADD R6, R6, #-1         ;	MAKE stack pointer go back one address				(R6 = x500E)
    
    STR R3, R6, #0          ;	STORE R3 in stack									(R6 = x500E)
    ADD R6, R6, #-1         ;	MAKE stack pointer go back one address				(R6 = x500D)
    
    STR R2, R6, #0          ;	STORE R2 in stack									(R6 = x500D)
    ADD R6, R6, #-1         ;	MAKE stack pointer go back one address				(R6 = x500C)
    
    STR R1, R6, #0          ;	STORE R1 in stack									(R6 = x500C)
    ADD R6, R6, #-1         ;	MAKE stack pointer go back one address				(R6 = x500B)
    
    STR R0, R6, #0          ;	STORE R0 in stack									(R6 = x500B)
    ADD R6, R6, #-1         ;	MAKE stack pointer go back one address				(R6 = x500A)
    
    ADD R5, R6, #0          ;	MAKE R5 point to R6		(HINT: Now your stack pointer will point at the bottom of FIBONACCI's local variables. What is the offset relative to R6?)							(R5 = x500A)
 
;;;;;;
 
    LDR R0, R5, #8          ;	LOAD input from stack	(HINT: Which register will input go in? Where is the input located on the stack relative to the frame pointer?)							(R5 = x500A)
    ADD R1, R0, #-1         ;	CHECK if input = 1	(HINT: We can use R1 as a compare register. What value should it hold?)
    BRz END_ALL_CASES       ;	BRANCH if zero to END_ALL_CASES
    ADD R0, R0, #1          ;	ADD 1 to R0
    ADD R0, R0, #-1         ;	CHECK if input = 0	(HINT: What value is in the input register right now? What do whe have to do to make it zero?)
    BRz END_ALL_CASES       ;	BRANCH if zero to END_ALL_CASES
    
    ADD R0, R0, #-1         ;	CALCULATE n-1	(HINT: First general case. What value is in the input register right now? How do we make it equal to (n-1)?)
    STR R0, R6, #0          ;	STORE input to fibonacci(n-1) on stack		(HINT: We are storing ON THE STACK. Which register holds input? Where is the stack pointer right now?)		(R6 = x500A)
    ADD R6, R6, #-1         ;	MAKE stack pointer go back one address				(R6 = x5009)
    JSR FIBONACCI           ;	JUMP subroutine to FIBONACCI
    LDR R1, R5, #-1         ;	LOAD return value into R1							(R5 = x500A)
    ADD R6, R6, #1          ;	POP input to F(n-1)									(R6 = x500A)
    
    ADD R0, R0, #-1         ;	CALCULATE n-1-1 (n-2)	(HINT: second general case. What value is in the input register right now? How do we make it equal to (n-2)?)
    STR R0, R6, #0          ;	STORE input to fibonacci(n-2) on stack		(HINT: We are storing ON THE STACK. Which register holds input? Where is the stack pointer right now?)		(R6 = x500A)
    ADD R6, R6, #-1         ;	MAKE stack pointer go back one address				(R6 = x5009)
    JSR FIBONACCI           ;	JUMP subroutine to FIBONACCI
    LDR R2, R5, #-1         ;	LOAD return value into R2	(HINT: Which register do we load relative to? Where is the return value in memory relative to where this register is pointing?)						(R5 = x500A)
    ADD R6, R6, #1          ;	POP input to F(n-2)									(R6 = x500A)
    
    ADD R0, R1, R2          ;	ADD R1 + R2 -> R0, aka F(n-1) + F(n-2) -> R0
 
END_ALL_CASES
    STR R0, R5, #7          ;	STORE return (R0) into return value on stack	(HINT: Where is the return value for FIBONACCI relative to the frame pointer? Draw a picture of the stack and count the steps between the two.)	(R5 = x500A)
    
    ADD R6, R5, #0          ;	MAKE stack pointer go to end of frame	(HINT: Which register are we MODIFYING, R5 or R6? The other will serve as the source.)			(R6 = x500A)
    
    ADD R6, R6, #1          ;	MAKE stack pointer go forward one address			(R6 = x500B)
    LDR R0, R6 #0           ;	RESTORE R0 to value stored on stack			(HINT: Do we use stack or frame pointer for this? It will be the same one as your loads.)		(R6 = x500B)
    
    ADD R6, R6, #1          ;	MAKE stack pointer go forward one address			(R6 = x500C)
    LDR R1, R6 #0           ;	RESTORE R1 to value stored on stack					(R6 = x500C)
    
    ADD R6, R6, #1          ;	MAKE stack pointer go forward one address			(R6 = x500D)
    LDR R2, R6 #0           ;	RESTORE R2 to value stored on stack					(R6 = x500D)
    
    ADD R6, R6, #1          ;	MAKE stack pointer go forward one address			(R6 = x500E)
    LDR R3, R6 #0           ;	RESTORE R3 to value stored on stack					(R6 = x500E)
    
    ADD R6, R6, #1          ;	MAKE stack pointer go forward one address			(R6 = x500F)
    LDR R5, R6 #0           ;	RESTORE R5 to value stored on stack			(HINT: This will restore the previous frame pointer from BEGINNING.)		(R6 = x500F)
    
    ADD R6, R6, #1          ;	MAKE stack pointer go forward one address			(R6 = x5010)
    LDR R7, R6 #0           ;	RESTORE R7 to value stored on stack		(HINT: This will restore the return address for the previous function.)			(R6 = x5010)
    
    ADD R6, R6, #1          ;	POP stack		(HINT: What is left to pop off the stack at this point? Move the SP forward that many locations.)									(R6 = x5011)

RET
 
.END