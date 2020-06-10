global scheduler

extern startCo
extern endCo
extern resume
extern k
extern N
extern R


section .data
    activeDrones: dd 0
section .rodata

section .text
    mov ecx,dword[N]
    mov [activeDrones],ecx
    mov ecx,0 ;; counter for the k
    mov edx,0 ;; counter for the R
    mov ebx,2
scheduler:
    inc ebx
    inc ecx
    inc edx
    call resume
    inc ecx
    cmp ecx,dword[k]
    jb noPrint
    push ebx
    mov ebx,2 ;;printed cor
    call resume
    pop ebx
    mov ecx,0
noPrint:
        ;;if (i/N)%R == 0 && i%(N-1) ==0 //R rounds have passed
        ;; edx deals with the Round Robih
    pushad
    mov esi,edx ;; esi = i
    mov ecx,edx
    mov eax,[N]
    div ecx     ;; eax = i/N
    mov ebx,eax
    mov eax,[R]
    div ebx     ;; (i/N) % R = edx
    cmp edx,0
    jne noElimination
    mov eax,esi ;; eax=i
    mov ecx,[N]
    dec ecx
    div ecx
    cmp edx,0 ;; edx = i % (N-1)
    jne noElimination
    popad 
    mov edx,0 ;; start another round
    ;; here call the func to eliminate one of the drones
        ;; todo
    dec [activeDrones]
noElimination:
    popad
    inc edx
    cmp [activeDrones],1
    je theWinner
    cmp ebx,[N]
    je here
    jmp scheduler
here:
    mov ebx,2
    jmp scheduler

theWinner: ;; todo
    call endCo