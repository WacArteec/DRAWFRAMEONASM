.model tiny

.code
org 100h
Start:
    xor cx, cx
    call InputData
    mov al, 4h
    call InputCX
    mov ah, cl

    mov bx, 0b800h
    mov es, bx

    ;xor ah, ah
    ;lea si, clearing
    ;call ClearScreen

    mov si, offset upline
    mov di, 00a0h
    xor al, al
    call InputCX
    call DrawLine

    mov al, 2h
    call InputCX

    midls:
        mov si, offset midline
        push cx
        xor al, al
        call InputCX
        add di, 00a0h
        call DrawLine
        pop cx
        loop midls

    mov si, offset lowline
    xor al, al
    call InputCX
    add di, 00a0h
    call DrawLine
    
    xor al, al
    dec al
    call InputCX
    call DrawMessage

mov ax, 4c00h
int 21h

;=====ClearScreen========
;Entry: AH - color
;       SI - addr of str of space
;Exit: none
;Assumes: DF = 0, ES = 0b800h
;Destroy: DI, AL, CX, SI
;========================
ClearScreen proc

    xor di, di
    lodsb
    mov cx, 0fa0h
    rep stosw

ret
endp

;========DrawLine=================
;Entry: AH - color
;SI - addr of style str
;CX - line length-2
;ES:DI - addr line beginning
;Exit: none
;Assumes: DF = 0
;Destroy: CX, AL, SI
;=================================
DrawLine    proc

    push di

    lodsb
    stosw

    lodsb
    rep stosw

    lodsb
    stosw

    pop di

ret
endp

;========DrawMessage=================
;Entry: AH - color
;SI - addr of message
;CX - length of message
;ES:DI - addr line beginning
;Exit: none
;Assumes: DF = 0
;Destroy: CX, AL, SI
;====================================
DrawMessage    proc

    push di

    DrawMsg:
        lodsb
        stosw
    loop DrawMsg

    pop di

ret
endp

;=============InputData==================
;Entry: none
;Exit: input string in buffer
;Assumes:CX = 0
;Destroy: SI, CX, BX, AL
;========================================
InputData   proc
	mov si, 80h
    mov cl, ds:[si]
    mov bx, offset message

    Input:
        mov al, ds:[si]
        cmp al, ' '
        je SkipSpace
    EndInput:
        mov ds:[bx], al
        inc si
        inc bx
    loop Input
ret

SkipSpace:
    cmp cx, 1
    je EndInput
    dec cx
    jmp Input

endp

;=============InputCX==================
;Entry: AL - Shift in message
;Exit: CX
;Assumes:
;Destroy: CX, AL
;========================================
InputCX   proc
    push bx

    mov bx, offset message
    add bl, al
    inc bx

    mov cl, ds:[bx]
    sub cx, 30h
    shr cx, 3
    add cx, cx
    add cx, cx
    inc bx

    add cl, ds:[bx]
    sub cx, 30h

    pop bx
ret
endp

;===StrLength===
;Entry: DI - addr of string
;Exit: CX - length of string
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

upline  db ''
midline db ''
lowline db ''
clearing    db ' '

message	db 100 Dup (?)

end Start