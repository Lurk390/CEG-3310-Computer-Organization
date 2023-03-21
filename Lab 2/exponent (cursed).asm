        .ORIG x3000

        LD R2, X
        LD R4, X
        LD R5, Y
        LD R6, X

        ADD R5, R5, #-1     ; Subtract exponent by 1
        BRn ZERO            ; If result is negative (exponent is 0), jump to ZERO
        BRz ONE             ; If result is 0 (exponent is 1), jump to ONE

LOOP    BRz FIN

MULT    BRz EXPO            ; If multiplier counter is 0 jump to EXPO
        ADD R3, R3, R2      ; Add base (R2) to running sum total (R3)
        ADD R4, R4, #-1     ; Decrement multiplier counter (R4) by 1
        BR MULT             ; Jump to MULT

EXPO    ADD R4, R6, #-1     ; Exponent loops an extra time, so subtract by 1
        ADD R2, R3, #0      ; Copy multiplication result into base
        ADD R5, R5, #-1     ; Subtract exponent by 1
        BR LOOP             ; Jump back up to LOOP

ZERO    LD R3, Z            ; Load 1 into result register (R3)
        BR FIN              ; Jump to end

ONE     LD R3, X            ; Load base into result register (R3)               
        BR FIN              ; Jump to end

FIN

X       .FILL #9            ; Base
Y       .FILL #0            ; Exponent
Z       .FILL #1            ; Constant number 1

        .END