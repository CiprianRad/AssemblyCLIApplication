ASSUME DS:data, CS:code
data SEGMENT public 'DATA'
	EXTRN input_sequence : byte           ; Buffer-ul de input

	file_path_hexa_characters db 'hexa.txt', 0 ; Fisier cu caractere permise
	file_id dw ?                          ; ID-ul fisierului deschis
	bytes_read_count dw ?                 ; Bytes cititi din fisier
	file_sequence db 23 dup(?)            ; Buffer pentru datele din fisier
	
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

read_from_file:
	mov ah, 3Dh                           ; Intrerupere DOS pentru deschidere fisier
	mov al, 00h                           ; Mod citire
	lea dx, file_path_hexa_characters
	int 21h
	jc print_open_file_error              ; Eroare daca CF e setat

	mov file_id, ax                       ; Salvam handle-ul fisierului

	mov ah, 3Fh                           ; Citire efectiva din fisier
	mov bx, file_id
	mov cx, 23
	lea dx,  file_sequence
	int 21h
	jc print_read_file_error

	mov bytes_read_count, ax              ; Retinem cat s-a citit
	
	mov ah, 3Eh                           ; Inchidem fisierul
	mov bx, file_id
	int 21h
ret

hexa_validation:
	push ax
	push bx
	push cx
	push dx
	push si
	push di

	call read_from_file                   ; Incarcam caracterele de control
	
	mov bx, bytes_read_count 
	mov cl, byte ptr [input_sequence + 1] ; Lungime text utilizator
	mov ch, 0
	jcxz done 
	 
	mov di, OFFSET file_sequence 
	mov si, OFFSET input_sequence + 2

user_sequence_loop:
	mov al, byte ptr [si]

file_sequence_loop:
	mov dl, byte ptr [di]
	cmp al, dl                            ; Verificam daca caracterul e valid
	je move_next_user_sequence
	dec bx
	cmp bx, 0
	je invalid_input                      ; Caracter nepermis gasit
	inc di
	jmp file_sequence_loop

move_next_user_sequence:
	inc si
	dec cx
	jcxz done
	mov di, OFFSET file_sequence          ; Resetam cautarea in fisier
	mov bx, bytes_read_count
	jmp user_sequence_loop	

invalid_input:
	mov ah, 09h                           ; Afisam eroarea de caractere
	lea dx, InvalidHexaCharacterException
	int 21h
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	jmp read_input
ret

done:
	mov ah, 09h                           ; Validare reusita
	lea dx, SuccessfulMsg
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
	jcxz empty_string_case                ; Verificam daca sirul e vid
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
	cmp cx, 16                            ; Cerinta: minim 16 caractere
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