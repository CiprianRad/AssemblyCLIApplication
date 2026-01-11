ASSUME DS:data, CS:code
data SEGMENT public 'DATA'

data ENDS
code SEGMENT public

PUBLIC final 


EXTRN run : near

start:
	mov ax, data
	mov ds, ax
	call run
	
final:
	mov ax, 4C00H
	int 21h
code ENDS
END start


	