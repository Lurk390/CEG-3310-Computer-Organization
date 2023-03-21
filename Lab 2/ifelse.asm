        .ORIG x3000

        NOT R1, R1          ; Take the two's compliment of R1 (1. flip bits)
        ADD R1, R1, #1      ; (2. add 1)
        ADD R0, R0, R1      ; Subtract R1 from R0
        BRz SAME            ; If result is 0, jump to SAME
        BRnp DIFF           ; If result is not 0, jump to DIFF

SAME    ADD R3, R3, #5      ; Make R3 = 5
        HALT                ; End program

DIFF    ADD R3, R3, #-5     ; Make R3 = -5
        HALT                ; End program

        .END