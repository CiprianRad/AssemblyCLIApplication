ASSUME DS:data, CS:code
data SEGMENT public 'DATA'
	binary_sequence db 100 dup(?)         ; Buffer pentru secventa convertita in bytes
	PUBLIC binary_sequence
	
	binary_sequence_count dw 0            ; Contor pentru numarul de cifre hexa valide
	PUBLIC binary_sequence_count

	EXTRN input_sequence : byte           ; String-ul brut citit de la tastatura
	EXTRN LargeStringException : byte     ; Mesaj eroare pentru sir prea lung
	EXTRN InsufficientHexaCharacterException : byte ; Eroare pentru sir sub 16 caractere
	EXTRN InvalidNumberOfBytesException : byte ; Eroare daca numarul de caractere e impar
data ENDS

code SEGMENT public

PUBLIC convert_to_binary
	
EXTRN read_input : near

convert_to_binary:
	mov binary_sequence_count, 0          ; Resetam contorul la fiecare apel al procedurii

	push ax
	push bx
	push cx
	push dx
	push si
	push di
	
	mov cl, byte ptr [input_sequence + 1] ; Luam lungimea sirului introdus de utilizator
	mov ch, 0
	
	mov si, OFFSET input_sequence + 2     ; Sarim peste header-ul buffer-ului de input
	mov di, OFFSET binary_sequence        ; Destinatia unde salvam valorile numerice
	
insertion:
	mov al, byte ptr [si]
	cmp al, ' '                           ; Verificam si ignoram spatiile
	je space_case
	cmp al, '9'                           ; Verificam daca avem o cifra (0-9)
	jbe digit_case
	cmp al, 'F'                           ; Verificam daca avem litera mare (A-F)
	jbe capital_letter_case
	cmp al, 'f'                           ; Verificam daca avem litera mica (a-f)
	jbe lower_letter_case 

lower_letter_case:
	sub al, 'a'                           ; Convertim litera mica in valoare numerica
	add al, 10                            ; Ajustam pentru a obtine intervalul 10-15
	mov byte ptr [di], al
	inc di
	inc binary_sequence_count             ; Incrementam numarul de nibbles procesati
	inc si	
	dec cx
	jcxz count_verification
	jmp insertion

capital_letter_case:
	sub al, 'A'                           ; Convertim litera mare in valoare numerica
	add al, 10                            ; Ajustam pentru intervalul 10-15
	mov byte ptr [di], al
	inc di
	inc binary_sequence_count
	inc si	
	dec cx
	jcxz count_verification
	jmp insertion

digit_case:
	sub al, '0'                           ; Convertim caracterul '0'-'9' in cifra 0-9
	mov byte ptr [di] , al
	inc di
	inc binary_sequence_count
	inc si
	dec cx
	jcxz count_verification
	jmp insertion

space_case:
	inc si                                ; Trecem peste spatiu
	dec cx
	jcxz count_verification
	jmp insertion

count_verification:
	; Verificam daca secventa respecta cerintele de lungime
	cmp binary_sequence_count, 32         ; Maxim 32 caractere permise
	ja large_string_error
	cmp binary_sequence_count, 16         ; Minim 16 caractere permise
	jb insufficient_hexa_error
	
	mov ax, binary_sequence_count
	mov bl, 2
	div bl                                ; Verificam daca avem un numar par de cifre
	cmp ah, 0
	jne number_of_bytes_error

	; Combinam cate doua cifre hexa intr-un singur byte
	mov si, OFFSET binary_sequence
	mov di, OFFSET binary_sequence
	mov cx, binary_sequence_count

concatenate_binary_sequence:
	mov al, byte ptr [si]                 ; Prima cifra devine partea superioara (high)
	shl al, 4 
	mov bl, byte ptr [si] + 1             ; A doua cifra devine partea inferioara (low)
	or al, bl                             ; Lipim cele doua jumatati intr-un byte complet
	mov byte ptr [di], al
	inc si
	inc si
	inc di
	dec cx
	dec cx
	jcxz finish_binary_sequence
	jmp concatenate_binary_sequence

finish_binary_sequence:
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
ret

; Tratarea erorilor si afisarea exceptiilor corespunzatoare
number_of_bytes_error:
	mov ah, 09h
	lea dx, InvalidNumberOfBytesException
	int 21h
	jmp error_handler
		
large_string_error:
	mov ah, 09h
	lea dx, LargeStringException
	int 21h
	jmp error_handler

insufficient_hexa_error:
	mov ah, 09h
	lea dx, InsufficientHexaCharacterException
	int 21h

error_handler:
	mov ah, 02h	
	mov dl, 0Dh                           ; Linie noua (Carriage Return)
	int 21h
	mov dl, 0Ah                           ; Linie noua (Line Feed)
	int 21h
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	jmp read_input                        ; Ne intoarcem la citirea datelor
ret

code ENDS
END