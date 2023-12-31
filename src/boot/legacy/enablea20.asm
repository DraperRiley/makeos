enable_a20:
        pushf
        push si
        push di
        push ds
        push es
        cli

        mov ax, 0x0000
        mov ds, ax
        mov si, 0x0500

        not ax
        mov es, ax
        mov di, 0x0510

        mov al, [ds:si]
        mov byte [.BufferBelowMB], al
        mov al, [es:di]
        mov byte [.BufferOverMB], al

        mov ah, 1
        mov byte [ds:si], 0
        mov byte [es:di], 1
        mov al, [ds:si]
        cmp al, [es:di]
        jne .exit
        dec ah

        .exit:
        mov al, [.BufferBelowMB]
        mov [ds:si], al
        mov al, [.BufferOverMB]
        mov [es:di], al
        shr ax, 8
        sti
        pop es
        pop ds
        pop di
        pop si
        popf
        ret

        .BufferBelowMB: db 0
        .BufferOverMB: db 0

