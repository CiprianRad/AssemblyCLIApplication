ASSUME DS:data, CS:code
data SEGMENT PUBLIC 'DATA'
	EXTRN binary_sequence : byte
	EXTRN binary_sequence_count : word
	
	sum_counter db 0
data ENDS

code SEGMENT PUBLIC

PUBLIC rotate_bytes_from_sequence

rotate_bytes_from_sequence:

	push ax
	push bx
	push cx
	push si


	mov bx, binary_sequence_count 
	shr bx, 1
	mov si, OFFSET binary_sequence



rotate_byte:
	mov sum_counter, 0
	mov al, byte ptr [si]
	call compute_sum_first_2_bits_from_al
	mov cl, sum_counter
	rol al, cl
	mov byte ptr [si], al
	inc si
	dec bx
	cmp bx, 0
	je rotating_finished
	jmp rotate_byte

rotating_finished:
	pop si
	pop cx
	pop bx
	pop ax
ret

	

compute_sum_first_2_bits_from_al:
	
	push ax
	push bx

	mov bl, 2
	
get_sum:
	ror al, 1
	jc increment_sum_counter
	jmp check_bit_counter

increment_sum_counter:
	inc sum_counter

check_bit_counter:
	dec bx
	cmp bx, 0
	jne get_sum

finished_computing_sum:

	pop bx
	pop ax
ret
		
code ENDS
END