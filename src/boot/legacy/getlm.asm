
get_lm:                    ; GET LOWER MEMORY (AX = total number of KB)
        clc                ; clear carry
        int 0x12           ; bios interrupt (= request low memory size)
        jc main.halt       ; we hit an error :(
        mov [lm_size], ax  ; store ax contents in lm_size
        ret                ; return

lm_size:
        dw 0

