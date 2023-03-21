        .ORIG x3000

        AND R3, R3, #0  ; Clear R3
        AND R0, R0, #0  ; Clear R0
        LD R1, MAX      ; Load the value of MAX into R1 (maximum amount of iterations)
        NOT R1, R1      ; Take the two's compliment of R1 (1. flip bits)
        ADD R1, R1, #1  ; (2. add 1)

LOOP    ADD R3, R3, #5  ; Add #5 to R3 (result)
        ADD R0, R0, #1  ; Increment R0 (loop iteration counter)
        ADD R2, R1, R0  ; Add R1 and R0 and put the result in R2 (Since we did a 2's complement on R1, we are essentially subtracting R1 from R0)
        BRn LOOP        ; Branch if negative back to LOOP (this means that R1 > R0 and we need to keep looping)

MAX     .FILL x5

        .END