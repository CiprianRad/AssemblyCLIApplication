ASSUME DS:data, CS:code
data SEGMENT PUBLIC 'DATA'
	EXTRN binary_sequence : byte          ; Secventa de bytes prelucrata
	EXTRN binary_sequence_count : word    ; Lungimea secventei
	
	C dw 0                                ; Cuvantul rezultat pe 16 biti
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

	call make_first_4_bits                ; Construieste primii 4 biti ai lui C
	call make_bits_4_to_7                 ; Construieste bitii 4-7
	call make_final_bits                  ; Construieste octetul superior

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
	shr cx, 1                             ; Impartim la 2 pentru numarul de bytes
	mov si, OFFSET binary_sequence
	
	mov al, byte ptr [si]                 ; Primul byte din secventa
	shl al, 4
	shr al, 4                             ; Izolam nibble-ul inferior (AND 0Fh)

move_to_last_byte:
	inc si
	dec cx	
	cmp cx, 1                             ; Avansam pana la ultimul byte
	je arrived_to_last_byte
	jmp move_to_last_byte 
	
arrived_to_last_byte:
	mov bl, byte ptr [si]                 ; Luam ultimul byte
	shr bl, 4                             ; Izolam nibble-ul superior
	XOR al, bl                            ; XOR intre extremele secventei
	mov ah, 0 
	OR C, ax                              ; Punem rezultatul in bitii 0-3 ai lui C

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
	and al, 00111100b                     ; Masca pentru bitii din mijloc

move_next_byte:
	inc si
	dec cx
	jcxz finished_bytes_4_to_7
	mov bl, byte ptr [si]
	and bl, 00111100b
	or al, bl                             ; Combinam bitii din toata secventa
	jmp move_next_byte

finished_bytes_4_to_7:
	shl al, 2                             ; Mutam pe pozitiile 4-7
	mov ah, 0
	OR C, ax                              ; Adaugam in cuvantul C
	
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
	mov ah, 0                             ; AX va retine suma

add_next_byte:
	inc si
	dec cx
	jcxz finished_last_bytes
	mov bl, byte ptr [si]
	add ax, bx                            ; Adunam bytes pentru suma finala
	jmp add_next_byte

finished_last_bytes:
	mov dx, 0 
	mov bx, 256
	div bx                                ; Calculam suma modulo 256
	shl dx, 8                             ; Mutam restul in octetul superior
	OR C, dx                              ; Finalizam C

	pop si
	pop dx
	pop cx
	pop bx
	pop ax
ret

code ENDS
END