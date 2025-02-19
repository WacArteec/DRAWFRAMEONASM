.model tiny

heart   = 03h
pink    = 05h
space	= 20h

.code
org 100h
Start:
    mov dl, 00h
    mov dh, 05h

    mov cx, 10h
    mov si, heart
    line:
        call DrawSymb
        inc dl
        loop line

    
mov ax, 4c00h
int 21h

;======DrawSymb================================
;Entry: DL = Num of Col, DH = Num of Line, SI - Symbol	       
;Exit: none				       
;Destroy: BX, ES, DX, DI, SI		       
;==============================================
DrawSymb    proc

	mov al, 50h
	mul dh
	mov di, ax
	
	mov al, 02h
	mul dl
	add ax, di
	add ax, di

	mov bx, 0b800h
	mov es, bx
	mov bx, ax
	mov byte ptr es:[bx], si
	mov byte ptr es:[bx+1], pink

    ret
    endp



end Start