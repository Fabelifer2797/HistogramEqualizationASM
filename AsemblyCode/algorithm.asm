;------------------------------------
;Stage 1

IE1:

    pusha
    mov     eax, 0
    mov     esi, 0
    mov     ecx, 0

.LEFD:

    cmp     esi, 8
    je      .CFD
    mov     byte[frequencyDist + esi], 0
    inc     esi
    jmp     .LEFD

.CFD:

    cmp     ecx, dword[tempBufferDW]
    je      .Finished
    mov     al, byte[imageBuffer + ecx]
    mov     dl, byte[frequencyDist + eax]
    inc     edx
    mov     byte[frequencyDist + eax], dl
    inc     ecx
    jmp     .CFD


.Finished:

    popa
    ret


;------------------------------------
;Stage 2

IE2:

    pusha
    mov     ecx, 0
    mov     esi, 0
    mov     al, byte[frequencyDist + ecx]
    mov     byte[frequencyCum + esi],al
    inc     ecx


.CDSF:

    cmp     ecx, 8
    je      .Finished
    mov     al, byte[frequencyDist + ecx]
    mov     dl, byte[frequencyCum + esi]
    add     al, dl
    inc     esi
    mov     byte[frequencyCum + esi], al
    inc     ecx
    jmp     .CDSF

.Finished:


    popa
    ret


;------------------------------------
;Stage 3

IE3:

    pusha
    mov     ecx, 0
    mov     eax, 0
    mov     al, byte[frequencyCum + 7]
    mov     ebx, 8
    div     ebx
    mov     esi, eax
    cmp     edx, 0
    je      .CM0
    jmp     .CMDO

.CM0:

    cmp     ecx, 8
    jmp     .Finished
    mov     byte[frequencyCumU + ecx], al
    inc     ecx
    jmp     .CM0

.CMDO:


    mov     ebx, 7
    mul     ebx
    mov     dl, byte[frequencyCum + 7]
    sub     edx, eax
    mov     byte[frequencyCumU + ecx], dl
    inc     ecx
    mov     eax, esi

.CMD02:

    cmp     ecx, 8
    je      .Finished
    mov     byte[frequencyCumU + ecx], al
    inc     ecx
    jmp     .CMD02


.Finished:


    popa
    ret



;------------------------------------
;Stage 4

IE4:

    pusha
    mov     ecx, 0
    mov     esi, 0
    mov     al, byte[frequencyCumU + ecx]
    mov     byte[frequencyCuFeq + esi],al
    inc     ecx


.CDSF:

    cmp     ecx, 8
    je      .Finished
    mov     al, byte[frequencyCumU  + ecx]
    mov     dl, byte[frequencyCuFeq + esi]
    add     al, dl
    inc     esi
    mov     byte[frequencyCuFeq + esi], al
    inc     ecx
    jmp     .CDSF

.Finished:

    popa
    ret


;------------------------------------
;Stage 5

IE5:

    pusha
    mov     eax, 0
    mov     edx, 0
    mov     ecx, 0
    mov     ebx, 0
    mov     ebp, 0
    mov     esi, 7
    mov     edi, 0


.CPM:

    cmp     ecx, 8
    je      .Finished
    mov     bl, byte[frequencyCum + ecx]
    jmp     .BBM

.FBBM:

    mov     eax, edi
    mov     byte[pixelMap + ecx], al
    inc     ecx
    mov     ebp, 0
    mov     esi, 7
    jmp     .CPM

.BBM:


    mov     edi, 0
    add     edi, ebp
    add     edi, esi
    sar     edi, 1
    mov     dl, byte[frequencyCuFeq + edi]
    cmp     edx, ebx
    je      .FBBM
    cmp     edi, ebp
    je      .EVA1
    cmp     edx, ebx
    jg      .ALS
    jmp     .ALI

.ALS:
    
    mov     esi, edi
    jmp     .BBM

.ALI:

    mov     ebp, edi
    jmp     .BBM

.EVA1:

    mov     al, byte[frequencyCuFeq + ebp]
    mov     dl, byte[frequencyCuFeq + esi]

.EVA2:

    cmp     al, bl
    je      .AR2
    cmp     dl, bl
    je      .AR3
    mov     edi, ebx
    sub     edi, eax
    mov     eax, edi
    mov     edi, ebx
    sub     edi, edx
    mov     edx, edi
    cmp     eax, 0
    jg      .CEVA2
    jmp     .ABS1

.CEVA2:

    cmp     edx, 0
    jg      .FEVA2
    jmp     .ABS2

.FEVA2:

    cmp     eax, edx
    jg      .AR3
    jmp     .AR2

.AR2:

    mov     edi, ebp
    jmp     .FBBM

.AR3:

    mov     edi, esi
    jmp     .FBBM

.ABS1:

    mov     edi, 0
    sub     edi, eax
    mov     eax, edi
    jmp     .CEVA2

.ABS2:

    mov     edi, 0
    sub     edi,edx
    mov     edx, edi
    jmp     .FEVA2


.Finished:

    popa
    ret

;------------------------------------
;Stage 6


IE6:

    pusha
    mov     ecx, 0


.CE:

    cmp     ecx, dword[tempBufferDW]
    je      .Finished
    mov     dl, byte[imageBuffer + ecx]
    mov     bl, byte[pixelMap + edx]
    mov     byte[imageBufferHE + ecx], bl
    inc     ecx
    jmp     .CE

.Finished:

    popa
    ret
                                       


