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
    input db 1,2,3,6,2,7
    len equ $-input 
    output resb len
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov esi,input
        mov edi,output
        mov ebx, output
        mov edx,output
        mov ecx,len
        jecxz skip
        myloop:
            mov al,[esi]
            inc esi
            check:
                cmp [ebx],al
                je dontadd
                dec ebx
                cmp ebx,edx
            jge check
            mov [edi],al
            inc edi
            mov ebx,edi
            dontadd:
        loop myloop
        ; exit(0)
        skip:
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program

        
        