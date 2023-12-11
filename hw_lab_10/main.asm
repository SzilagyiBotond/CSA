bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,scanf
extern biggest          ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import scanf msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    sir resb 10
    nr dd 0
    format db "%d",0
    save dd 0
; our code starts here
segment code use32 class=code
    start:
        ; ...
        push dword nr
        push dword format
        call [scanf]
        add esp,4*2
        mov ebx,dword[nr]
        mov [save],ebx
        mov esi,sir
        init:
        push dword nr
        push format
        call [scanf]
        add esp,4*2
        mov al,[nr]
        mov [esi],al
        inc esi
        
        mov ecx,ebx
        dec ebx
        loop init
        
        push dword [save]
        push dword sir
        call biggest
        add esp,4*2
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
