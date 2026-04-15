ASSUME DS:data, CS:code
data SEGMENT PUBLIC 'DATA'
	EXTRN binary_sequence : byte
	EXTRN binary_sequence_count : word
	
	C dw 0
	PUBLIC C
data ENDS

code SEGMENT PUBLIC

PUBLIC make_C_word

make_C_word:

	push ax
	push bx
	push cx
	push dx
	push si

	call make_first_4_bits
	call make_bits_4_to_7
	call make_final_bits

	pop si
	pop dx
	pop cx
	pop bx
	pop ax
ret


make_first_4_bits:

	push ax
	push bx
	push cx
	push si

	mov cx, binary_sequence_count 
	shr cx, 1
	mov si, OFFSET binary_sequence
	
	mov al, byte ptr [si]
	shl al, 4
	shr al, 4 ; equivalently: and al, 0Fh

move_to_last_byte:
	inc si
	dec cx	
	cmp cx, 1
	je arrived_to_last_byte
	jmp move_to_last_byte 
	
arrived_to_last_byte:
	mov bl, byte ptr [si]
	shr bl, 4
	XOR al, bl
	mov ah, 0 ; ax := 000 + (xor result)h
	OR C, ax

	pop si
	pop cx
	pop bx
	pop ax
ret


make_bits_4_to_7:
	
	push ax
	push bx
	push cx
	push si

	mov cx, binary_sequence_count 
	shr cx, 1
	mov si, OFFSET binary_sequence

	mov al, byte ptr [si]
	and al, 00111100b

move_next_byte:
	inc si
	dec cx
	jcxz finished_bytes_4_to_7
	mov bl, byte ptr [si]
	and bl, 00111100b
	or al, bl
	jmp move_next_byte

finished_bytes_4_to_7:

	shl al, 2
	mov ah, 0
	OR C, ax
	
	pop si
	pop cx
	pop bx
	pop ax
	
ret

make_final_bits:
	push ax
	push bx
	push cx
	push dx
	push si

	mov cx, binary_sequence_count 
	shr cx, 1
	mov si, OFFSET binary_sequence
	
	mov al, byte ptr [si]	
	mov ah, 0

	mov bx, 0

add_next_byte:
	inc si
	dec cx
	jcxz finished_last_bytes
	mov bl, byte ptr [si]
	add ax, bx
	jmp add_next_byte

finished_last_bytes:
	mov dx, 0 ; dx:ax := the sum of the bytes
	mov bx, 256
	div bx ; dx := remainder, which is between 0 and 255, therefore it is in dl
	shl dx, 8
	OR C, dx

	pop si
	pop dx
	pop cx
	pop bx
	pop ax

ret

code ENDS
END