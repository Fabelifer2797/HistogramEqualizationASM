%include 'printingFunctions.asm'
%include 'fileManagement.asm'
%include 'algorithm.asm'

SECTION .data
filename   db 'image.txt', 0h
filenameHE db 'imageHE.txt', 0h
lineFeed   db  0Ah 

SECTION .bss
imageBuffer    resb 200000
imageBufferHE  resb 200000
tempBuffer1    resb 1
tempBuffer3    resb 3  
tempBufferDW   RESD 1
frequencyDist  RESD 256
frequencyCum   RESD 256
frequencyCumU  RESD 256
frequencyCuFeq RESD 256
pixelMap       RESD 256

SECTION .text
global  _start
 
_start:

    ;Open the file image.txt

    mov     ebx, filename      ;The name of the file we want to open
    call    openFile           ;Call the subroutine for open the file       

    ;Subroutine for read the file recently opened
    ;The file descriptor was returned in the eax register, after the openFile subroutine was executed
    
    call    readFile

    ;Subroutine for applying the histogram equalization algorithm
    call    IE1
    call    IE2
    call    IE3
    call    IE4
    call    IE5
    call    IE6

    ;Open the file imageHE.txt
    
    mov     ebx, filenameHE    ;The name of the file we want to open
    call    openFile           ;Call the subroutine for open the file

    ;Subroutine for write the output file

    call    writeFile

    ;Subroutine for exit the program

    call    quit               