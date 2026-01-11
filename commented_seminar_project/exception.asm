ASSUME DS:data
data SEGMENT public 'DATA'
	PUBLIC EmptyStringLengthException
	PUBLIC InvalidStringLengthException
	PUBLIC InvalidHexaCharacterException
	PUBLIC LargeStringException
	PUBLIC InsufficientHexaCharacterException
	PUBLIC InvalidNumberOfBytesException
	
	EmptyStringLengthException db 'Invalid String! Empty strings not allowed! $'
	InvalidStringLengthException db 'Invalid String length! Less than 16 characters are not allowed! $'
	InvalidHexaCharacterException db 'Invalid String input! Only hexa characters and space: (_) are allowed! $'
	LargeStringException db 'Invalid String input! Maximum 32 characters are allowed! $'
	InsufficientHexaCharacterException db 'Invalid String input! Provide at least 8 hexa characters! $'
	InvalidNumberOfBytesException db 'Invalid String input! Provide an even number of hexa characters! $'
data ENDS
END