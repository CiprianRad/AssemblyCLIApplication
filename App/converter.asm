ASSUME DS:data, CS:code
data SEGMENT public 'DATA'
	binary_sequence db 100 dup(?)
	PUBLIC binary_sequence
	
	binary_sequence_count dw 0
	PUBLIC binary_sequence_count

	EXTRN input_sequence
	EXTRN LargeStringException
	EXTRN InsufficientHexaCharacterException
	EXTRN InvalidNumberOfBytesException
data ENDS

code SEGMENT public

PUBLIC convert_to_binary
	
EXTRN read_input : near

convert_to_binary:

	mov binary_sequence_count, 0

	push ax
	push bx
	push cx
	push dx
	push si
	push di
	
	mov cl, byte ptr [input_sequence + 1]
	mov ch, 0
	
	mov si, OFFSET input_sequence + 2
	mov di, OFFSET binary_sequence
	
insertion:
	
	mov al, byte ptr [si]
	cmp al, ' '
	je space_case
	cmp al, '9'
	jbe digit_case
	cmp al, 'F'
	jbe capital_letter_case
	cmp al, 'f'
	jbe lower_letter_case 

lower_letter_case:
	;sub al, 87
	sub al, 'a'
	add al, 10
	mov byte ptr [di], al
	inc di
	inc binary_sequence_count
	inc si	
	dec cx
	jcxz count_verification
	jmp insertion

capital_letter_case:
	;sub al, 55
	sub al, 'A'
	add al, 10
	mov byte ptr [di], al
	inc di
	inc binary_sequence_count
	inc si	
	dec cx
	jcxz count_verification
	jmp insertion

digit_case:
	sub al, '0'
	mov byte ptr [di] , al
	inc di
	inc binary_sequence_count
	inc si
	dec cx
	jcxz count_verification
	jmp insertion

space_case:
	inc si
	dec cx
	jcxz count_verification
	jmp insertion

count_verification:
	cmp binary_sequence_count, 32
	ja large_string_error
	cmp binary_sequence_count, 16
	jb insufficient_hexa_error
	mov ax, binary_sequence_count
	mov bl, 2
	div bl ; al = cat, ah = rest
	cmp ah, 0
	jne number_of_bytes_error

	; code to convert the sequence into the right version of the sequence
		
	mov si, OFFSET binary_sequence
	mov di, OFFSET binary_sequence
	mov cx, binary_sequence_count

concatenate_binary_sequence:

	mov al, byte ptr [si]
	shl al, 4 
	mov bl, byte ptr [si] + 1
	or al, bl
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

number_of_bytes_error:
	mov ah, 09h
	lea dx, InvalidNumberOfBytesException
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
		
large_string_error:

	mov ah, 09h
	lea dx, LargeStringException
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

insufficient_hexa_error:

	mov ah, 09h
	lea dx, InsufficientHexaCharacterException
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