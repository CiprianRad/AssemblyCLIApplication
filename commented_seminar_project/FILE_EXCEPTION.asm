ASSUME DS:data
data SEGMENT public 'DATA'

	PUBLIC FileException
	PUBLIC ImproperFileReadException
	PUBLIC FileOpeningException
	PUBLIC FileReadException
	PUBLIC FileCloseException

	FileException db 'There was a problem when handling the file! $'	
	ImproperFileReadException db 'Could not read characters from file properly! $'
	FileOpeningException db 'There was a problem when opening the file! $'
	FileReadException db 'There was a problem when reading from file! $'
	FileCloseException db 'There was a problem when closing the file! $'
	
data ENDS
END