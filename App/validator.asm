ASSUME DS:data, CS:code
data SEGMENT public 'DATA'
	EXTRN input_sequence : byte

	file_path_hexa_characters db 'hexa.txt', 0
	file_id dw ?
	bytes_read_count dw ?
	file_sequence db 23 dup(?)
	
	EXTRN EmptyStringLengthException : byte
	EXTRN InvalidStringLengthException : byte
	EXTRN InvalidHexaCharacterException : byte
	EXTRN FileException : byte
	EXTRN ImproperFileReadException : byte
	EXTRN FileOpeningException : byte
	EXTRN FileReadException : byte
	EXTRN FileCloseException : byte

	SuccessfulMsg db 'Successfully read the hexa character!$'
data ENDS
code SEGMENT public
	
EXTRN final : near
EXTRN read_input : near

PUBLIC hexa_validation 
PUBLIC empty_string_validation
PUBLIC short_string_validation

print_open_file_error:

	mov ah, 09h
	lea dx, FileOpeningException 
	int 21h

	jmp final	

print_read_file_error: 
	
	mov ah, 09h
	lea dx, FileReadException
	int 21h

	jmp final
	
print_close_file_error:
	mov ah, 09h
	lea dx, FileCloseException
	int 21h

	jmp final
	

improper_file_read:
	
	mov ah, 09h
	lea dx, ImproperFileReadException
	int 21h

	jmp final	

read_from_file:

	mov ah, 3Dh
	mov al, 00h
	lea dx, file_path_hexa_characters
	int 21h

	jc print_open_file_error

	mov file_id, ax

	mov ah, 3Fh
	mov bx, file_id
	mov cx, 23
	lea dx,  file_sequence
	int 21h

	jc print_read_file_error

	mov bytes_read_count, ax
	
	cmp ax, 0
	je improper_file_read

	mov ah, 3Eh
	mov bx, file_id
	int 21h

	jc print_close_file_error
ret

hexa_validation:
	push ax
	push bx
	push cx
	push dx
	push si
	push di

	call read_from_file
	
	mov bx, bytes_read_count ; bx := lungimea sirului citit din fisier
	mov cl, byte ptr [input_sequence + 1] ; cx := lungimea sirului dat de utilizator	
	mov ch, 0
	jcxz done ; Cand lungimea sirului dat de utilizator ajunge la 0 atunci validarea s-a terminat
	 
	mov di, OFFSET file_sequence ; DI = sirul din fisier
 	mov si, OFFSET input_sequence + 2 ; SI = sirul de la utilizator

user_sequence_loop:

	mov al, byte ptr [si]

file_sequence_loop:

	mov dl, byte ptr [di]
	cmp al, dl
	je move_next_user_sequence
	dec bx
	cmp bx, 0
	je invalid_input
	inc di
	jmp file_sequence_loop

move_next_user_sequence:
	inc si
	dec cx
	jcxz done
	mov di, OFFSET file_sequence
	mov bx, bytes_read_count
	jmp user_sequence_loop	

invalid_input:
	mov ah, 09h
	lea dx, InvalidHexaCharacterException
	int 21h
	
	
	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax

	jmp read_input

done:

	mov ah, 09h
 	lea dx, SuccessfulMsg
 	int 21h
 
 
 	mov ah, 02h
 	mov dl, 0Dh ; Character for going on to the next line
 	int 21h
 	mov dl, 0Ah ; Character for going to the start of the new line
 	int 21h
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
ret

empty_string_validation:

	push ax
	push bx
	push cx
	push dx
	push si
	push di

	
	;mov cl, byte ptr [input_sequence + 1]
	;mov ch, 0
	jcxz empty_string_case
	
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
ret
	
empty_string_case:

	mov ah, 09h
	lea dx, EmptyStringLengthException
	int 21h
	
	
	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax

	jmp read_input
ret

short_string_validation:

	push ax
	push bx
	push cx
	push dx
	push si
	push di
	
	cmp cx, 16
	jb short_string_case

	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
ret
	
short_string_case:

	mov ah, 09h
	lea dx, InvalidStringLengthException
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	
	jmp read_input	
ret


code ENDS
END
	