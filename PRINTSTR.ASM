.model tiny
.code
org 100h

Start:

    mov di, offset message
    call StrLength

    mov si, offset message
    mov di, 200h
    mov ah, 05h

    mov bx, 0b800h
    mov es, bx

    call PrintMsg

    mov ax, 4c00h
    int 21h

;=========PrintMsg==========
;Entry: AH - color
;       CX - length of message
;       SI - addr of message
;       ES:DI - addr line beginning
;Exit: none
;Assumes: DF = 0, ES = 0b800h
;Destroy: CX
;===========================

PrintMsg proc
    
    PrintStr:
        lodsb
        stosw
    loop PrintStr

ret
endp

;===StrLength===
;Entry: DI - addr of string
;Exit: CX - length of string
;Assumes: ES = 0
;Destroy: AL, DI
;===============
StrLength   proc

    mov al, '$'
    xor cx, cx
    dec cx

    repne scasb
    neg cx
    dec cx
ret
endp

.data
message db 'Hello$'

end Start