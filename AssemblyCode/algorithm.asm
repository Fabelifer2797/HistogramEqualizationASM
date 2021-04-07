;------------------------------------
;Stage 1

IE1:

    pusha
    mov     ebx, 0
    mov     esi, 0
    mov     ecx, 0

.LEFD:

    cmp     esi, 1024
    je      .CFD
    mov     dword[frequencyDist + esi], 0
    add     esi, 4
    jmp     .LEFD

.CFD:

    cmp     ecx, dword[tempBufferDW]
    je      .Finished
    mov     ebx, 0
    mov     bl, byte[imageBuffer + ecx]
    shl     ebx, 2
    mov     edx, dword[frequencyDist + ebx]
    inc     edx
    mov     dword[frequencyDist + ebx], edx
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
    mov     eax, dword[frequencyDist + ecx]
    mov     dword[frequencyCum + esi],eax
    add     ecx, 4


.CDSF:

    cmp     ecx, 1024
    je      .Finished
    mov     eax, dword[frequencyDist + ecx]
    mov     edx, dword[frequencyCum + esi]
    add     eax, edx
    add     esi, 4
    mov     dword[frequencyCum + esi], eax
    add     ecx, 4
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
    mov     eax, dword[frequencyCum + 1020]
    mov     ebx, 256
    div     ebx
    mov     esi, eax
    cmp     edx, 0
    je      .CM0
    jmp     .CMDO

.CM0:

    cmp     ecx, 1024
    jmp     .Finished
    mov     dword[frequencyCumU + ecx], eax
    add     ecx, 4
    jmp     .CM0

.CMDO:


    mov     ebx, 255
    mul     ebx
    mov     edx, dword[frequencyCum + 1020]
    sub     edx, eax
    mov     dword[frequencyCumU + ecx], edx
    add     ecx, 4
    mov     eax, esi

.CMD02:

    cmp     ecx, 1024
    je      .Finished
    mov     dword[frequencyCumU + ecx], eax
    add     ecx, 4
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
    mov     eax, dword[frequencyCumU + ecx]
    mov     dword[frequencyCuFeq + esi],eax
    add     ecx, 4


.CDSF:

    cmp     ecx, 1024
    je      .Finished
    mov     eax, dword[frequencyCumU  + ecx]
    mov     edx, dword[frequencyCuFeq + esi]
    add     eax, edx
    add     esi, 4
    mov     dword[frequencyCuFeq + esi], eax
    add     ecx, 4
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
    mov     esi, 255
    mov     edi, 0


.CPM:

    cmp     ecx, 1024
    je      .Finished
    mov     ebx, dword[frequencyCum + ecx]
    jmp     .BBM

.FBBM:

    mov     eax, edi
    mov     dword[pixelMap + ecx], eax
    add     ecx, 4
    mov     ebp, 0
    mov     esi, 255
    jmp     .CPM

.BBM:


    mov     edi, 0
    add     edi, ebp
    add     edi, esi
    sar     edi, 1
    mov     edx, edi
    shl     edx, 2
    mov     edx, dword[frequencyCuFeq + edx]
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

    mov     eax, ebp
    shl     eax, 2
    mov     eax, dword[frequencyCuFeq + eax]
    mov     edx, esi
    shl     edx, 2
    mov     edx, dword[frequencyCuFeq + edx]

.EVA2:

    cmp     eax, ebx
    je      .AR2
    cmp     edx, ebx
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
    mov     edx, 0

.CE:

    cmp     ecx, dword[tempBufferDW]
    je      .Finished
    mov     edx, 0
    mov     dl, byte[imageBuffer + ecx]
    shl     edx, 2
    mov     ebx, dword[pixelMap + edx]
    mov     byte[imageBufferHE + ecx], bl
    inc     ecx
    jmp     .CE

.Finished:

    popa
    ret

