bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,scanf,fopen,fclose,fprintf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import scanf msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fprintf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    output_file db "17.txt",0
    output_file_descriptor dd -1
    output_acces_mode db "w",0
    numar dd 0
    input_format db "%d",0
    format db "%d ",0
; our code starts here
segment code use32 class=code
    start:
        ; ...
        push dword output_acces_mode
        push dword output_file
        call [fopen]
        add esp,4*2
        mov [output_file_descriptor],eax
        cmp eax,0
        je final
        citire:
        push dword numar
        push dword input_format
        call [scanf]
        add esp,4*2
        cmp dword[numar],0
        je final
        mov ax,[numar]
        mov dx,[numar+2]
        mov bx,7
        div bx
        cmp dx,0
        jne dont_add
        push dword [numar]
        push dword format
        push dword [output_file_descriptor]
        call [fprintf]
        add esp,4*3
        dont_add:
        jmp citire
        final:
        push dword [output_file_descriptor]
        call [fclose]
        add esp,4
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
