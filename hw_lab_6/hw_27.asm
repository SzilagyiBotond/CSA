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
    sir dw 1234h,4567h,1111h,2222h,3333h,3444h
    len equ ($-sir)/2
    d resb 0
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov ecx, len
        dec ecx
        mov esi,sir
        mov edi ,sir+2
        mov dl,1
        mov dh,1
        cld
        myloop:
            cmpsw
            jle add_to_list
            mov dl,0
            add_to_list:
            inc dl
            cmp dl,dh
            jl no_new_max
            mov dh,dl
            no_new_max:
        loop myloop
        mov [d],dh
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
