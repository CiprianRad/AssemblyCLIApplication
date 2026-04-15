ASSUME DS:data, CS:code
data SEGMENT PUBLIC 'DATA'

	number_of_1_bits db 0
	byte_with_most_1_bits db ?
	position_of_byte dw ?

	PUBLIC number_of_1_bits 
	PUBLIC byte_with_most_1_bits 
	PUBLIC position_of_byte 
	
	EXTRN binary_sequence_count : word
	EXTRN binary_sequence : byte

data ENDS

code SEGMENT PUBLIC

PUBLIC find_byte_with_most_1_bits

find_byte_with_most_1_bits:
	
	push ax
	push bx
	push cx
	push dx
	push si
	push di

	mov dx, 0 ;  reset for comparison with bit counter

	mov cx, binary_sequence_count
	shr cx, 1 ; cx := lungimea sirului
	
	mov si, OFFSET binary_sequence

find_byte: 
	mov number_of_1_bits, 0
	mov al, byte ptr [si]
	mov bx, 8
	
repeat_shifting:
	rol al , 1
	jc increment_counter
	dec bx
	cmp bx, 0
	je move_next_byte
	jmp repeat_shifting

increment_counter:
	inc number_of_1_bits
	dec bx
	cmp bx, 0
	je move_next_byte
	jmp repeat_shifting

move_next_byte:
	cmp dl, number_of_1_bits
	jbe change_information

return_from_change:
	inc si
	dec cx
	jcxz finished_searching
	jmp find_byte

change_information:
	mov dl, number_of_1_bits

	;mov position_of_byte, binary_sequence_count
	;shr position_of_byte, 1
	;sub position_of_byte, cx 

	;mov byte_with_most_1_bits, byte ptr [si]

	mov ax, binary_sequence_count
	shr ax, 1
	sub ax, cx
	mov position_of_byte, ax

	mov al, byte ptr [si]
	mov byte_with_most_1_bits, al
	
	jmp return_from_change

finished_searching:
	mov number_of_1_bits, dl
	
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
ret

code ENDS
END