
print:
        .loop:
        lodsb
        or al, al
        jz .done

        mov ah, 0xE
        mov bh, 0x0
        int 0x10
        jmp .loop

        .done:
        ret

reset_cursor:
        ; get cursor position
        mov ah, 0x03
        int 0x10

        ; reset cursor position
        mov dl, 0
        mov ah, 0x02
        mov bh, 0
        int 0x10
        ret

reset_cursor_total:
        mov ah, 0x02
        mov dh, 0
        mov dl, 0
        ret

reset_screen:
        mov ah, 0
        mov al, 0x03
        int 0x10
        ret

