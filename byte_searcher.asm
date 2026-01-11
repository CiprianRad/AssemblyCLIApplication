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

	mov dx, 0                       ; Registru pentru maximul local
	mov cx, binary_sequence_count
	shr cx, 1                       ; Lungimea sirului
	mov si, OFFSET binary_sequence

find_byte: 
	mov number_of_1_bits, 0
	mov al, byte ptr [si]
	mov bx, 8                       ; Verificam toti cei 8 biti
	
repeat_shifting:
	rol al , 1                      ; Rotire la stanga
	jc increment_counter
	dec bx
	cmp bx, 0
	je move_next_byte
	jmp repeat_shifting

increment_counter:
	inc number_of_1_bits            ; Am gasit un bit de 1
	dec bx
	cmp bx, 0
	je move_next_byte
	jmp repeat_shifting

move_next_byte:
	cmp dl, number_of_1_bits        ; Comparam cu maximul gasit anterior
	jbe change_information

return_from_change:
	inc si
	dec cx
	jcxz finished_searching
	jmp find_byte

change_information:
	mov dl, number_of_1_bits        ; Actualizam noul maxim
	mov ax, binary_sequence_count
	shr ax, 1
	sub ax, cx                      ; Calculam pozitia curenta
	mov position_of_byte, ax
	mov al, byte ptr [si]
	mov byte_with_most_1_bits, al
	jmp return_from_change

finished_searching:
	mov number_of_1_bits, dl        ; Salvam rezultatul final
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
ret

code ENDS
END