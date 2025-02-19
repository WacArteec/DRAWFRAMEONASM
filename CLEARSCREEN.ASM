.model tiny
.code
org 100h

Start:

    mov bx, 0b800h
    mov es, bx
    xor ah, ah
    lea si, clearing
    call ClearScreen

mov ax, 4c00h
int 21h

;=====ClearScreen========
;Entry: AH - color
;       SI - addr of str of space
;Exit: none
;Assumes: DF = 0, ES = 0b800h
;Destroy: DI, AL, CX, SI
;========================
ClearScreen:

    xor di, di
    lodsb
    mov cx, 0fa0h
    rep stosw

ret
endp

.data
clearing    db ' '

end Start