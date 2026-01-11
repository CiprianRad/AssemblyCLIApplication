ASSUME DS:data, CS:code
data SEGMENT public 'DATA'
	input_sequence db 100, ? , 100 dup(?)
	PUBLIC input_sequence
	InputMessage db 'Please insert an even number of at least 16 hexa characters (space allowed): $'

	WelcomeToTheAppMsg db 'Welcome to the Assembly Application! $'
	ContinueOperationMsg db 'Press any key to continue: $'
	
	InputProcessingMsg db 'Processing sequence... $'
	InputConversionMsg db 'Converting from hexa to binary... $'
	
	ChooseAnOptionMsg db 'Choose one of the following options: $'
	
	OptionOneMsg db '1. Print the sequence introduced $'
	
	OptionTwoMsg db '2. Sort the sequence introduced $'
	OptionTwoProcessingMsg db 'Sorting sequence... $'
	OptionTwoFinishedMsg db 'Sequence successfully sorted! $'
	
	OptionThreeMsg db '3. Calculate the word C $'
	OptionThreeProcessingMsg db 'Calculating word C... $'
	OptionThreeFinishedMsg db 'Word C successfully calculated! $'
	
	OptionFourMsg db '4. Rotate the elements in the sequence $'
	OptionFourProcessingMsg db 'Rotating elements... $'
	OptionFourFinishedMsg db 'Elements successfully rotated! $'

	OptionFiveMsg db '5. Find the byte with the highest number of 1 bits (at least 4 bits 1) $'
	OptionFiveProcessingMsg db 'Searching for the byte... $'
	OptionFiveFinsihedMsg db 'Byte found! $'
	
	NotEnoughOneBitsMsg db 'The byte does not have more than 3 bits equal to 1. Choose one of the following options $'
	NotEnoughOneBitsOptionOne db '1. Introduce some other sequence of hexa characters $'
	NotEnoughOneBitsOptionTwo db '2. Go back to the option menu $'
	NotEnoughOneBitOptionThree db '3. Show the byte anyway $'

	OptionSixMsg db '6. Introduce the sequence of hexa characters again $'
	
	ExitingApplicationMsg db '0. Exit application $'
	ExitingAppProcessingMsg db 'Cleaning out. Exiting app... $'
	SafeExitMsg db 'Are you sure you want to exit app? $'
	SafeExitOptionOneMsg db '1.YES! $'
	SafeExitOptionTwoMsg db '2.NO! $'
	
	SequencePrintingOptionsMsg db 'How would you like to print the sequence? $'
	SequencePrintingOptionOneMsg db '1. Print in hexa format $'
	SequencePrintingOptionTwoMsg db '2. Print in binary format $'

	InvalidOptionMsg db 'The option you choose is not valid! Choose only from the options given! $'

	EXTRN number_of_1_bits : byte
	
data ENDS

code SEGMENT PUBLIC

PUBLIC read_input

EXTRN hexa_validation : near
EXTRN empty_string_validation : near
EXTRN short_string_validation : near

EXTRN convert_to_binary : near

EXTRN sort_sequence : near

EXTRN sequence_printer : near

EXTRN number_of_one_bit_printer : near
EXTRN position_of_byte_printer : near
EXTRN byte_with_most_one_bit_printer : near
EXTRN find_byte_with_most_1_bits : near

EXTRN make_C_word : near
EXTRN Word_C_printer : near

EXTRN rotate_bytes_from_sequence : near
EXTRN sequence_printer_binary : near

PUBLIC run

run PROC
	push ax
	push bx
	push cx
	push dx
	push si
	push di	

	mov ah, 09h
	lea dx, WelcomeToTheAppMsg
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h


	mov ah, 09h
	lea dx, ContinueOperationMsg
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	mov ah, 08h
	int 21h
	mov ax, 0
	
read_input:
	
	mov ah, 09h
	lea dx, InputMessage
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	mov ah, 0Ah
	mov dx, OFFSET input_sequence
	int 21h	

	mov cl, byte ptr [input_sequence + 1]
	mov ch, 0

	mov ah, 09h
	lea dx, InputProcessingMsg
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	
	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h


	call empty_string_validation
	call short_string_validation
	call hexa_validation


	mov ah, 09h
	lea dx, InputConversionMsg
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h
	
	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	call convert_to_binary


print_menu:
	
	mov ah, 09h
	lea dx, ChooseAnOptionMsg
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h


	mov ah, 09h
	lea dx, OptionOneMsg
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h


	mov ah, 09h
	lea dx, OptionTwoMsg
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h



	mov ah, 09h
	lea dx, OptionThreeMsg
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h



	mov ah, 09h
	lea dx, OptionFourMsg
	int 21h


	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	mov ah, 09h
	lea dx, OptionFiveMsg
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h


	mov ah, 09h
	lea dx, OptionSixMsg
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h


	mov ah, 09h
	lea dx, ExitingApplicationMsg 
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h


	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h


	mov ah, 08h
	int 21h

	cmp al, '1'
	jne skip_option_one
	jmp option_one

skip_option_one:

	cmp al, '2'
	jne skip_option_two
	jmp option_two

skip_option_two:

	cmp al, '3'
	jne skip_option_three
	jmp option_three

skip_option_three:

	cmp al, '4'
	jne skip_option_four
	jmp option_four

skip_option_four:

	cmp al, '5'
	jne skip_option_five
	jmp option_five

skip_option_five:

	cmp al, '6'
	jne skip_option_six
	jmp read_input

skip_option_six:

	cmp al, '0'
	jne skip_exit_option
	jmp exit_app

skip_exit_option:
	jmp invalid_option

option_one:

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h
	
	mov ah, 09h
	lea dx, SequencePrintingOptionsMsg 
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	mov ah, 09h
	lea dx, SequencePrintingOptionOneMsg
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	mov ah, 09h
	lea dx, SequencePrintingOptionTwoMsg 
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	
	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	
	mov ah, 08h
	int 21h

	cmp al, '1'
	je print_in_hexa_format
	cmp al, '2'
	je print_in_binary_format
	jmp invalid_sequence_printing_option

print_in_hexa_format:
	
	call sequence_printer

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h
	jmp print_menu

print_in_binary_format:

	call sequence_printer_binary
	
	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h
	jmp print_menu

invalid_sequence_printing_option:


	mov ah, 09h
	lea dx, InvalidOptionMsg 
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h
jmp option_one


option_two:

	mov ah, 09h
	lea dx, OptionTwoProcessingMsg
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	call sort_sequence

	mov ah, 09h
	lea dx, OptionTwoFinishedMsg
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	
	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h
	
	mov ah, 09h
	lea dx, SequencePrintingOptionsMsg 
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	mov ah, 09h
	lea dx, SequencePrintingOptionOneMsg
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	mov ah, 09h
	lea dx, SequencePrintingOptionTwoMsg 
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	
	mov ah, 08h
	int 21h

	cmp al, '1'
	jne skip_option_two_option_one

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h
	
	jmp print_in_hexa_format

skip_option_two_option_one:

	cmp al, '2'
	jne skip_option_two_option_two
	

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	jmp print_in_binary_format

skip_option_two_option_two:

	jmp invalid_sequence_printing_option


option_three:


	mov ah, 09h
	lea dx, OptionThreeProcessingMsg 
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h


	call make_C_word

	mov ah, 09h
	lea dx, OptionThreeFinishedMsg
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	
	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	call Word_C_printer 

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h
jmp print_menu

option_four:

	mov ah, 09h
	lea dx, OptionFourProcessingMsg
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	call rotate_bytes_from_sequence

	mov ah, 09h
	lea dx, OptionFourFinishedMsg
	int 21h
	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h
	
	mov ah, 09h
	lea dx, SequencePrintingOptionsMsg 
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	mov ah, 09h
	lea dx, SequencePrintingOptionOneMsg
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	mov ah, 09h
	lea dx, SequencePrintingOptionTwoMsg 
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	
	mov ah, 08h
	int 21h

	cmp al, '1'
	jne skip_option_four_option_one
	

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	jmp print_in_hexa_format

skip_option_four_option_one:

	cmp al, '2'
	jne skip_option_four_option_two
	

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	jmp print_in_binary_format

skip_option_four_option_two:

	jmp invalid_sequence_printing_option

option_five:

	mov ah, 09h
	lea dx, OptionFiveProcessingMsg
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	call find_byte_with_most_1_bits

	mov ah, 09h
	lea dx, OptionFiveFinsihedMsg
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	cmp number_of_1_bits, 4
	jb not_enough_bits_one

print_the_byte_anyway:

	call byte_with_most_one_bit_printer
	call number_of_one_bit_printer
	call position_of_byte_printer

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	jmp print_menu
	

not_enough_bits_one:
	
	
	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	mov ah, 09h
	lea dx, NotEnoughOneBitsMsg
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	
	mov ah, 09h
	lea dx, NotEnoughOneBitsOptionOne
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	
	mov ah, 09h
	lea dx, NotEnoughOneBitsOptionTwo
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

		
	mov ah, 09h
	lea dx, NotEnoughOneBitOptionThree
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	mov ah, 08h
	int 21h
	
	cmp al, '1'
	jne skip_not_enough_bits_option_one
	
	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h
	
	jmp read_input

skip_not_enough_bits_option_one:

	cmp al, '2'
	jne skip_not_enough_bits_option_two
		
	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	jmp print_menu

skip_not_enough_bits_option_two:

	cmp al, '3'
	jne skip_not_enough_bits_option_three

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	jmp print_the_byte_anyway

skip_not_enough_bits_option_three:

	mov ah, 09h
	lea dx, InvalidOptionMsg 
	int 21h
	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h
jmp not_enough_bits_one

invalid_option:

	mov ah, 09h
	lea dx, InvalidOptionMsg 
	int 21h
	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h
	
	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	jmp print_menu


exit_app:
	
	mov ah, 09h
	lea dx, SafeExitMsg
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	mov ah, 09h
	lea dx, SafeExitOptionOneMsg
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	mov ah, 09h
	lea dx, SafeExitOptionTwoMsg
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	
	mov ah, 08h
	int 21h

	cmp al, '1'
	je exit_app_safely
	cmp al, '2'
	jne skip_exit_option_option_two

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h
	
	jmp print_menu

skip_exit_option_option_two:
	
	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	mov ah, 09h
	lea dx, InvalidOptionMsg 
	int 21h
	
	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	mov ah, 02h	
	mov dl, 0Dh ; Character for going on to the next line
	int 21h
	mov dl, 0Ah ; Character for going to the start of the new line
	int 21h

	jmp exit_app

exit_app_safely:

	mov ah, 09h
	lea dx, ExitingAppProcessingMsg
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
run ENDP

code ENDS
END