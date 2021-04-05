%include 'printingFunctions.asm'
%include 'fileManagement.asm'

SECTION .data
filename   db 'image.txt', 0h
filenameHE db 'imageHE.txt', 0h
lineFeed   db  0Ah 

SECTION .bss
imageBuffer   resb 700000
imageBufferHE resb 700000
tempBuffer1   resb 1
tempBuffer3   resb 3 
tempBufferDW  RESD 1  

SECTION .text
global  _start
 
_start:

    ;Open the file image.txt

    mov     ebx, filename      ;The name of the file we want to open
    call    openFile           ;Call the subroutine for open the file       

    ;Subroutine for read the file recently opened
    ;The file descriptor was returned in the eax register, after the openFile subroutine was executed
    
    call    readFile

    ;Open the file imageHE.txt
    
    mov     ebx, filenameHE    ;The name of the file we want to open
    call    openFile           ;Call the subroutine for open the file

    ;Subroutine for write the output file

    call    writeFile

    ;Subroutine for exit the program

    call    quit               