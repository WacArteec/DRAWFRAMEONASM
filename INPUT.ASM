.model tiny
.code
org 100h

Start:
	mov si, 80h
    mov cl, ds:[si]
    inc si
    mov bx, offset string

    Input:
        mov al, ds:[si]
        mov ds:[bx], al
        inc si
        inc bx
    loop Input

    mov ax, '$'
    mov ds:[bx], ax

	mov ax, 09h
	mov dx, offset output
	int 21h

mov ax, 4c00h
int 21h

.data
string	db 100 Dup (?)
output  db 'huy$'


end	Start