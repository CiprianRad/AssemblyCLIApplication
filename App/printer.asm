ASSUME DS:data, CS:code
data SEGMENT PUBLIC 'DATA'
	EXTRN binary_sequence_count : word
	EXTRN binary_sequence : byte
	
	EXTRN position_of_byte : word
	EXTRN byte_with_most_1_bits : byte
	EXTRN number_of_1_bits : byte

	EXTRN C : word

	SequencePrinterMessage db 'The sequence is: $'
	BytePositionMessage db 'The position of the byte with the highest number of 1 bits is: $'
	NumberOfOneBitsMessage db 'The number of 1 bits is: $'
	ByteWithMostOneBitMessage db 'The byte with the highest number of 1 bits is: $'
	
	CWordPrinterMessage db 'The word C is: $'

	BinarySequencePrinterMsg db 'The sequence in binary format is: $'
data ENDS

code SEGMENT public

PUBLIC print_hex_digit

PUBLIC sequence_printer
PUBLIC sequence_printer_binary

PUBLIC number_of_one_bit_printer
PUBLIC position_of_byte_printer
PUBLIC byte_with_most_one_bit_printer

PUBLIC Word_C_printer



print_hex_digit:
 	cmp bl, 10
 	jb digit
 	add bl, 'A' - 10
 	jmp output
digit:
 	add bl, '0'
output:
 	mov dl, bl
 	mov ah, 02h
 	int 21h
ret

print_decimal_word_from_ax:

	push ax
	push bx
	push cx
	push dx
	push si
	push di	
  
    	mov bx, 10
	mov cx, 0

get_digits_to_print:
	
	mov dx, 0           
	div bx 
	push dx
	inc cx
	cmp ax, 0
	jne get_digits_to_print

print_decimal:
	pop dx
	add dl, '0'
	mov ah, 02h
	int 21h

	dec cx
	jnz print_decimal

	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax

ret


Word_C_printer:
	
	push ax
	push bx
	push cx
	push dx
	push si
	push di

	mov ah, 09h
	lea dx, CWordPrinterMessage
	int 21h

	mov bx, C
	mov cx, 16

print_bits:
	shl bx, 1
	jc print_one
	mov dl, '0'
	jmp print_and_move_next

print_one:
	mov dl, '1'

print_and_move_next:
	mov ah, 02h
	int 21h
	dec cx 
	jcxz finished_printing_bits
	jmp print_bits
finished_printing_bits:
	mov ah, 02h	
	mov dl, 0Dh ; Carriage Return
	int 21h
	mov dl, 0Ah ; Line Feed
	int 21h
	
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
ret
	


position_of_byte_printer:
	push ax
	push bx
	push cx
	push dx
	push si
	push di

	mov ah, 09h
	lea dx, BytePositionMessage
	int 21h

	mov ax, position_of_byte 
	call print_decimal_word_from_ax
	
	
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
	

byte_with_most_one_bit_printer:
	push ax
	push bx
	push cx
	push dx
	push si
	push di

	mov ah, 09h
	lea dx, ByteWithMostOneBitMessage
	int 21h
	
	mov al, byte_with_most_1_bits

	; print high nibble
	mov bl, al
	shr bl, 4
	call print_hex_digit
	
	mov al, byte_with_most_1_bits
	; print low nibble
	mov bl, al
	and bl, 0Fh
	call print_hex_digit


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

number_of_one_bit_printer:

	push ax
	push bx
	push cx
	push dx
	push si
	push di

	mov ah, 09h
	lea dx, NumberOfOneBitsMessage
	int 21h

	mov ah, 02h
	mov dl, number_of_1_bits
	add dl, '0'
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

sequence_printer_binary:

	push ax
	push bx
	push cx
	push dx
	push si
	push di

	mov ah, 09h
	lea dx, BinarySequencePrinterMsg
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h
	
	
	mov cx, binary_sequence_count
	shr cx, 1
	mov si, OFFSET binary_sequence

binary_print_loop:
	mov al, byte ptr [si]
	push ax
	call print_bits_from_byte
	pop ax

	mov dl, ' '
	mov ah, 02h
	int 21h

	inc si
	dec cx
	jcxz binary_sequence_printer_finished
jmp binary_print_loop

print_bits_from_byte:

	push ax
	push bx
	push cx
	push dx

	mov bx, 8

printing_bits_from_byte_loop:
	
	shl al, 1
	jc print_one_bit
	mov dl, '0'
	
	jmp do_print
	
	;mov ah, 02h
	;int 21h
	;dec bx
	;cmp bx, 0
	;je finished_printing_binary_byte
	;jmp printing_bits_from_byte_loop

print_one_bit:

	mov dl, '1'
	
	;mov ah, 02h
	;int 21h
	;dec bx
	;cmp bx, 0
	;je finished_printing_binary_byte
	;jmp printing_bits_from_byte_loop

do_print:
	push ax
	mov ah, 02h
	int 21h
	pop ax
	dec bx
	jnz printing_bits_from_byte_loop

finished_printing_binary_byte:

	pop dx
	pop cx
	pop bx
	pop ax
ret

binary_sequence_printer_finished:
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
	

sequence_printer:
	
	push ax
	push bx
	push cx
	push dx
	push si
	push di

	mov ah, 09h
	lea dx, SequencePrinterMessage
	int 21h
	
	
	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	mov cx, binary_sequence_count
	shr cx, 1
	mov si, OFFSET binary_sequence

print_loop:
	mov al, [si]

	; print high nibble
	mov bl, al
	shr bl, 4
	call print_hex_digit
	
	mov al, [si]
	; print low nibble
	mov bl, al
	and bl, 0Fh
	call print_hex_digit

	; print space
	mov dl, ' '
	mov ah, 02h
	int 21h

	inc si
	dec cx
	jcxz sequence_printer_finished
jmp print_loop

sequence_printer_finished:

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



code ENDS
END
