extern createTarget
extern x_target
extern y_target
extern Randomxy
extern lfsr
extern initState
extern resume
extern createTarget
extern curr_cor
extern firstDrone
extern printf

align 16

section .bss
    stateNumber: resb 16
    mulNumber: resb 4
    currDrone: resd 1
    oldAlpha: resw 1
    oldSpd: resd 1
section .data
    delta_alpha: qd 0
    newSpeed: qd 0
    bias: dd 0

section .rodata
    error: db "Drone not found",10,0


section .text

drones:
    finit
    call randomAlpha
    call speedChange
    call newPos
    call mayDestroy

randomAlpha:
    push ebp
    mov ebp,esp

    call Randomxy
    mov ax,word[lfsr]
    mov word[initState],ax
    mov dword[stateNumber],65535
    mov dword[mulNumber],120
    fld dword[lfsr]
    fidiv dword[stateNumber]
    fimul dword[mulNumber]
    mov dword[bias],60
    fisub dword[bias]
    fstp qword[delta_alpha]

    mov esp,ebp
    pop ebp
    ret

speedChange:
    push ebp
    mov ebp,esp

    call Randomxy
    mov ax,word[lfsr]
    mov word[initState],ax
    mov dword[stateNumber],65535
    mov dword[mulNumber],20
    fld dword[lfsr]
    fidiv dword[stateNumber]
    fimul dword[mulNumber]
    mov dword[bias],10
    fisub dword[bias]
    fstp qword[newSpeed]

    mov esp,ebp
    pop ebp
    ret

newPos:
    push ebp
    mov ebp,esp

    mov ebx, firstDrone
    mov eax,dword[ebx]
    cmp eax,dword[curr_cor]
    je foundHim
nextDrone:
    mov ebx,dword[ebx+32]
    cmp ebx,0
    je errorSearch
    mov eax,dword[ebx]
    cmp eax,dword[curr_cor]
    je foundHim
    jmp nextDrone
foundHim:;;ebx points to the right drone
    mov ax, word[ebx+20]
    mov word[oldAlpha],ax
    mov eax,dword[ebx+52]
    mov dword[oldSpd],eax
    

    mov esp,ebp
    pop ebp
    ret

errorSearch:
    push error
    call printf
    add esp,4

    mov eax,0
    mov ebx,1
    int 0x80