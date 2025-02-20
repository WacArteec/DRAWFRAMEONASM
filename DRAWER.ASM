.model tiny

.code
org 100h

VIDEOSEG    equ 0b800h
SCREENWIDTH equ 00a0h

Start:
    call DrawFrame

mov ax, 4c00h
int 21h

;======DrawFrame===========
;Entry: none
;Exit: none
;Destroy: none
;==========================
DrawFrame:

    push ax bx cx dx di si bp sp ds es ss

    xor cx, cx
    call InputData

    mov ah, var_Color

    mov bx, VIDEOSEG
    mov es, bx

    xor ah, ah
    lea si, clearing
    call ClearScreen

    mov si, offset style
    mov di, SCREENWIDTH
    mov cx, var_width
    call DrawLine

    mov cx, var_heigth

    midls:
        mov si, offset style
        add si, 3
        push cx
        mov cx, var_width
        add di, SCREENWIDTH
        call DrawLine
        pop cx
        loop midls

    mov si, offset style
    add si, 3
    mov cx, var_width
    add di, SCREENWIDTH
    call DrawLine
    
    mov si, offset inputeddata
    add si, 0ch
    mov cx, var_msglen
    shr var_heigth, 3
    mov bx, var_heigth
    shr var_heigth, 2
    add var_heigth, bx
    sub di, var_heigth
    add di, var_width
    call DrawMessage

    pop ss es ds sp bp si di dx cx bx ax

ret
endp

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
    mov bx, offset inputeddata

    Input:
        mov al, ds:[si]
        cmp al, ' '
        je SkipSpace
    EndInput:
        mov ds:[bx], al
        inc si
        inc bx
        inc var_msglen
    loop Input

    sub var_msglen, 0ch

    xor ax, ax
    call Atoi
    mov var_width, ax

    mov al, 4
    call Atoi
    mov var_heigth, ax

    mov al, 8
    call Atoi
    mov var_Color, al
ret

SkipSpace:
    cmp cx, 1
    je EndInput
    dec cx
    jmp Input

endp

;=============Atoi==================
;Entry: AL - Shift in message
;Exit: AX
;Assumes:
;Destroy: AX
;========================================
Atoi   proc
    push bx cx

    mov bx, offset inputeddata
    add bl, al
    inc bx

    xor ax, ax

    mov al, ds:[bx]
    sub ax, 30h
    shr ax, 1
    mov cx, ax
    shr ax, 2
    add ax, cx
    inc bx

    add al, ds:[bx]
    sub ax, 30h

    pop cx bx
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

var_msglen  dw 0
var_width   dw 10
var_heigth  dw 05
var_Color   db 05

style   db '123456789'
upline  db ''
midline db ''
lowline db ''
clearing    db ' '

inputeddata	db 100 Dup (?)

end Start