bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,fscanf,printf,fopen,fclose               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fscanf msvcrt.dll
import printf msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    input_file_name db "input.txt",0
    input_file_acces db "r",0
    input_file_descriptor dd -1
    input_format db "%d",0
    numbers resd 20
    smallest dd 0ffffffffh
; our code starts here
segment code use32 class=code
    start:
        ; ...
        push dword input_file_acces
        push dword input_file_name
        call [fopen]
        add esp,4*2
        mov [input_file_descriptor],eax
        cmp eax,0
        je final
        mov esi,numbers
        mov ecx,20
        read:
        push ecx
        
        push esi
        push dword input_format
        push dword [input_file_descriptor]
        call [fscanf]
        add esp,4*3
        cmp eax,0ffffffffh
        je out_of_loop
        mov edx,[smallest]
        cmp edx,[esi]
        jb not_smaller
        mov edx,[esi]
        mov [smallest],edx
        not_smaller:
        add esi,4
        pop ecx
        loop read
        
        
        out_of_loop:
        push dword [input_file_descriptor]
        call [fclose]
        add esp,4
        
        push dword [smallest]
        push dword input_format
        call [printf]
        add esp,4*3
        final:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
