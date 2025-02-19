.model tiny
.code
org 100h
Start:	mov dl, 3h
	mov dh, 05h
	mov ch, 1h
	mov cl, 5h
	call DrawSymb
	
	mov ax, 4c00h
	int 21h

;======DrawSymb================================|
;Entry: DL = letter code, DH = color attribute,| 
;CL = Num of Col, CH = Num of Line	       |
;Exit: none				       |
;Destroy: BX, ES, DX			       |
;==============================================|
DrawSymb	proc
		
	mov bx, 0b800h
	mov es, bx

	mov ax, 0002h
	mul cl
	
	mov bx, dx
	mov byte ptr es:[bx], al
	mov byte ptr es:[bx+1], ah
	
	ret
	endp

end Start