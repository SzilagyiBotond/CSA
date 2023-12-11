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
    b dw -2
    c dd 3
    d dq 4
    ;(d-b)-a-(b-c)
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov ebx, dword[d+0] 
        mov ecx, dword[d+4] ; ecx:ebx = d
        mov ax,[b]
        cwde
        cdq ; edx:eax=b
        clc
        sub ebx,eax
        sbb ecx,edx ; ecx:ebx = d-b
        
        mov al,[a]
        cbw
        cwde
        cdq ; edx:eax=a
        clc
        sub ebx,eax
        sbb ecx,edx; ecx:ebx = (d-b)-a
        mov eax,0
        mov edx,[c]
        mov ax,[b]
        cwde ; eax=b
        sub eax,edx 
        mov edx,0
        cdq ; edx:eax=(b-c)
        sub ebx,eax
        sbb ecx,edx ; ecx:ebx = (d-b)-a-(b-c)
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
