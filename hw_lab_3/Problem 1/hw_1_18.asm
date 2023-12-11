bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a db 1
    b dw 2
    c dd 3
    d dq 4
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov eax, dword[d+0]
        mov edx, dword[d+4] ; edx:eax = d
        mov ebx, dword[d+0] 
        mov ecx, dword[d+4] ; ecx:ebx = d
        clc ; clear carry flag
        add eax,ebx 
        adc edx,ecx ; edx:eax = d+d
        clc
        mov ebx,0
        mov ecx,0
        mov bl,byte[a]; ecx:ebx=a
        sub eax,ebx
        sbb edx,ecx;edx:eax=(d+d)-a
        clc
        mov ebx,0
        mov ecx,0
        mov bx,word[b]; ecx:ebx=b
        sub eax,ebx
        sbb edx,ecx;edx:eax=(d+d)-a-b
        clc
        mov ecx,0
        mov ebx,dword[c];ecx:ebx=c
        sub eax,ebx
        sbb edx,ecx;edx:eax=(d+d)-a-b-c
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
