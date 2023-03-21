        .ORIG x3000

        ADD R3, R3, #1          ; Increment R3 by #1
        LD R1, Y		; Load the value of Y (the exponent) into R1 (Y counter)
        BRz DONE		; If zero, branch to the label DONE (we have a zero power)
        
EXPO    AND R2, R2, #0	        ; And R2 with zero (this clears the register)
        LD R0, X		; Load the value of X (the base) into R0 (X counter)
        BRp MULT		; Branch if nonzero to MULT (we have a nonzero base, and want to skip the zero case)
        AND R3, R3, #0	        ; And R3 and zero (this handles the zero case)
        BRz DONE		; Branch if zero to DONE (skip the nonzero steps)
        z
MULT     ADD R2, R3, R2         ; Add R3 and R2 and store in R2 (this will perform the addition step for multiplication)
        ADD R0, R0, #-1	        ; Increment R0 by #-1 and store in R0
        BRp MULT		; Branch only if positive back to MULT (repeat addition)

        ADD R3, R2, #0	        ; Copy the value in R2 to R3 (what command can we use to do that?)
        ADD R1, R1, #-1	        ; Increment R1 by #-1 and store in R1
        BRp EXPO		; Branch if positive back to EXPO (repeat multiplication)

DONE    HALT   			; Halt execution

X       .FILL x9    	        ; Base, can be any non-negative 16 bit value
Y       .FILL x4   		; Exponent, can be any non-negative 16 bit value

        .END