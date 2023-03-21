        .ORIG x3000

        AND R0, R0, #0  ; Clear R0

LOOP    ADD R0, R0, #-2 ; Subtract 2 from R0
        ADD R1, R0, #10 ; Add 10 to R0 and store result in R1
        BRz #2          ; If R1 is zero, end
        BR LOOP         ; Otherwise continue looping

        .END