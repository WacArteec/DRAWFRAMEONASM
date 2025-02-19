.model tiny
.code
org 100h

Start: 	mov ah, 09h
	mov dx, offset string
	int 21h

	mov ax, 4c00h
	int 21h

.data
string	db 'Kak nastroenie?$'

end	Start