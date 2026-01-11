ASSUME DS:data, CS:code
data SEGMENT PUBLIC 'DATA'
	EXTRN binary_sequence_count : word
	EXTRN binary_sequence : byte
data ENDS

code SEGMENT public

PUBLIC sort_sequence

sort_sequence:
	push ax
	push bx
	push cx
	push dx
	push si
	push di

	mov bx, binary_sequence_count 
	shr bx, 1                       ; Lungimea reala a sirului
	
	cmp bx, 1
	je sort_finished 
	mov si, OFFSET binary_sequence

repeat_sort:
	mov al, byte ptr [si]           ; Elementul de referinta
	mov di, si
	mov cx, bx 

compare_next:
	dec cx
	jcxz move_next_element
	inc di
	mov dl, byte ptr [di]
	cmp al, dl                      ; Comparatie pentru sortare
	jb exchange_elements
	jmp compare_next

move_next_element:
	mov byte ptr [si], al
	dec bx
	cmp bx, 1
	jbe sort_finished
	inc si
	jmp repeat_sort 

exchange_elements:
	xchg al, dl                     ; Interschimbam valorile
	mov byte ptr [di], dl 
	jmp compare_next
	 
sort_finished:
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
ret

code ENDS
END