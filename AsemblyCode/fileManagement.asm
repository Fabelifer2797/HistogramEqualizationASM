;------------------------------------------
;The finalization character in the txt file is the letter F (70d in ASCII code)

readFile:

    pusha                                       ;Preserve the values of all registers
    mov     ebx, eax                            ;Move the file descriptor to ebx
    mov     ecx, 0                              ;Initialize the seek cursor in 0
    mov     edi, 0                              ;Counter of the tempBuffer3 address
    mov     esi, 0                              ;Counter of the amount of bytes that will be store in the imageBuffer

.checkEOL:

    call    seekCUR                             ;Call the subroutine to set up the cursor(pointer) in the file
    call    readByte                            ;Call the subroutine to read one byte of the file
    cmp     byte[tempBuffer1], 70               ;Compare if the byte just read is 70 (F)
    je      .finished                           ;If equals jump to the label finished
    cmp     byte[tempBuffer1], 10               ;Compare the character just read with the 0x0A ASCII Value (line feed)
    je      .atoiTempB                          ;If equals jump to the label atoiTempB
    mov     edx, tempBuffer3                    ;Store in edx the tempBuffer3 address
    mov     al,  byte[tempBuffer1]              ;Move the byte recently read to the lowest byte of the eax register (al)
    mov     byte[edx + edi], al                 ;Store in the correct address of tempBuffer3 the character
    inc     edi                                 ;Increment the character counter
    inc     ecx                                 ;Increment the bytes of the seek cursor
    jmp     .checkEOL                           ;Return to the checkEOL(Check end of line/file)



.atoiTempB:

    mov     eax, tempBuffer3                    ;Store the tempBuffer3 adddress in eax
    call    atoi                                ;Call the ascii to integer subroutine
    mov     byte[imageBuffer + esi], al         ;Store the integer value in the imageBuffer correct address
    inc     esi                                 ;Increment the esi counter
    inc     ecx                                 ;Increment the seek cursor counter
    mov     edi, 0                              ;Reset the edi counter
    call    resetTempB                          ;Call the subroutine to reset the tempBuffer3
    jmp     .checkEOL                           ;Return to the checkEOL label
        

.finished:
  
    mov      dword[tempBufferDW], esi           ;Store how many bytes were saved in the imageBuffer
    call     printImageBuffer                   ;Print in console the imageBuffer data    
    popa                                        ;Restore all the registers
    ret                                         ;Return to the point where the function was called



;------------------------------------------     
seekCUR:

    pusha                                       ;Preserve the values of all registers
    mov     edx, 0                              ;Whence argument of the SYS_ISEEK (In this case is SEEK_SET: beginning of the file)
    mov     eax, 19                             ;Opcode for SYS_ISEEK
    int     80h                                 ;Call the kernel
    popa                                        ;Restore all the resgisters
    ret                                         ;Return to the point where the  function was called

;------------------------------------------
readByte:

    pusha                                       ;Preserve the values of all registers
    mov     edx, 1                              ;Number of bytes we're going to read
    mov     ecx, tempBuffer1                    ;Memory address where we want to saved the character
    mov     eax, 3                              ;Opcode for SYS_READ
    int     80h                                 ;Call the kernel
    popa                                        ;Restore all the registers
    ret                                         ;Return to the point where tha function was called

;------------------------------------------
resetTempB:

    mov    byte[tempBuffer3], 0                 ;Set in 0 the tempBuffer3[0]
    mov    byte[tempBuffer3 + 1], 0             ;Set in 0 the tempBuffer3[1]
    mov    byte[tempBuffer3 + 2], 0             ;Set in 0 the tempBuffer3[2]
    ret                                         ;Return to the point where tha function was called

;-----------------------------------------
printImageBuffer:

    pusha                                       ;Preserve the values of all registers
    mov     ecx, 0                              ;Set the counter in 0

.cycle:

    cmp     ecx, esi                            ;Compare the counter with the number of bytes we have to travel in
    je      .finished                           ;If equals jump to the label finished
    mov     al, byte[imageBuffer + ecx]         ;Move the current imageBuffer value to the eax register
    call    iprintLF                            ;Call the integer printing subroutine
    inc     ecx                                 ;Increment the counter
    jmp     .cycle                              ;Return to the cycle


.finished:

    popa                                        ;Restore all the registers
    ret                                         ;Return to the point where tha function was called


;-----------------------------------------
writeFile:

    pusha                                       ;Preserve the values of all registers
    mov     ebx, eax                            ;Move the file descriptor into ebx register
    mov     ebp, 0                              ;Initialize the imageBuffer counter in 0
    mov     edi, 0                              ;Initialize the seek cursor in 0

.cycle:

    cmp     ebp, dword[tempBufferDW]            ;Compare the counter with the total amount of bytes
    je      .finished                           ;If equals jump to the lable finished
    mov     al, byte[imageBuffer + ebp]         ;Move the current byte of the imageBuffer to the eax register
    call    itoaByte                            ;Call the integer to ascii subroutine
    call    writeLineFeed                       ;Call the write line feed in the txt file subroutine
    inc     edi                                 ;Increment the seek cursor
    inc     ebp                                 ;Increment the imageBuffer counter
    jmp     .cycle                              ;Return to the cycle label


.finished:

    popa                                        ;Restore all the registers
    ret                                         ;Return to the point where tha function was called


;-----------------------------------------
writeByte:

    pusha                                       ;Preserve the values of all registers
    mov     ecx, edi                            ;Move the seek cursor to ecx register
    call    seekCUR                             ;Call the seek cursor subroutine
    mov     ecx, eax                            ;Move the ascii character address store in eax to ecx
    mov     edx, 1                              ;Number of bytes to write
    mov     eax, 4                              ;Opcode for SYS_WRITE
    int     80h                                 ;Call the kernel
    popa                                        ;Restore all the registers
    ret                                         ;Return to the point where tha function was called

;-----------------------------------------
writeLineFeed:

    pusha                                       ;Preserve the values of all registers
    mov     ecx, edi                            ;Move the seek cursor to ecx register
    call    seekCUR                             ;Call the seek cursor subroutine
    mov     ecx, lineFeed                       ;Move the ascii character address 0xA (linefeed) to ecx
    mov     edx, 1                              ;Number of bytes to write
    mov     eax, 4                              ;Opcode for SYS_WRITE
    int     80h                                 ;Call the kernel
    popa                                        ;Restore all the registers
    ret                                         ;Return to the point where tha function was called


;-----------------------------------------
itoaByte:

    push    ecx                                 ;Preserve the value of ecx register
    push    eax                                 ;Preserve the value of eax register
    push    edx                                 ;Preserve the value of edx register
    push    esi                                 ;Preserve the value of esi register
    mov     ecx, 0                              ;Counter of how many bytes we need to print in the end
 
.divideLoop:
    inc     ecx                                 ;Count each byte to print - number of characters
    mov     edx, 0                              ;Empty edx
    mov     esi, 10                             ;Mov 10 into esi
    idiv    esi                                 ;Divide eax by esi
    add     edx, 48                             ;Convert edx to it's ascii representation - edx holds the remainder after a divide instruction
    push    edx                                 ;Push edx (string representation of an intger) onto the stack
    cmp     eax, 0                              ;Can the integer be divided anymore?
    jnz     .divideLoop                         ;Jump if not zero to the label divideLoop
 
.writeLoop:
    dec     ecx                                 ;Count down each byte that we put on the stack
    mov     eax, esp                            ;Mov the stack pointer into eax for printing
    call    writeByte                           ;Call the writeByte subroutine
    inc     edi                                 ;Increment the seek cursor
    pop     eax                                 ;Remove last character from the stack to move esp forward
    cmp     ecx, 0                              ;Have we printed all bytes we pushed onto the stack?
    jnz     .writeLoop                          ;Jump is not zero to the label printLoop
    pop     ecx                                 ;Restore the value of ecx register
    pop     eax                                 ;Restore the value of eax register
    pop     edx                                 ;Restore the value of edx register
    pop     esi                                 ;Restore the value of esi register
    ret                                         ;Return to the point where the function was called


;-----------------------------------------      
openFile:

    push    ecx                                  ;Push onto the stack the value of ecx
    mov     ecx, 2                               ;Flag for read and write mode                
    mov     eax, 5                               ;Opcode for SYS_OPEN
    int     80h                                  ;Call the kernel
    pop     ecx                                  ;Restore the value of ecx 
    ret                                          ;Return to the point where the function was called
