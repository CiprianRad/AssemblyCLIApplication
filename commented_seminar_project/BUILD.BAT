@echo off
rem Step 1: Clean up ONLY the build artifacts
del *.obj
if exist MAIN.EXE del MAIN.EXE
if exist MAIN.MAP del MAIN.MAP

rem Step 2: Assemble each module individually 
tasm /zi main.asm
tasm /zi printer.asm
tasm /zi rotator.asm
tasm /zi VALIDA~1.asm
tasm /zi WORD_M~1.asm
tasm /zi BYTE_S~1.asm
tasm /zi EXCEPT~1.asm
tasm /zi sorter.asm
tasm /zi CONVER~1.asm
tasm /zi FILE_E~1.asm
tasm /zi UI.asm

rem Step 3: Link if assembly was successful
if not exist main.obj goto fail

tlink /v @LINKFILE.LNK
echo Build Successful!
goto end

:fail
echo Assembly failed. Check the errors listed above.
pause

:end