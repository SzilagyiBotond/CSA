bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,fopen,fclose,fread,fprintf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fopen msvcrt.dll
import fclose msvcrt.dll
import fread msvcrt.dll
import fprintf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    input_file_name db "input.txt",0
    input_file_acces db "r",0
    input_file_descriptor dd -1
    output_file_name db "output.txt",0
    output_file_acces db "w",0
    output_file_descriptor dd -1
    string resb 100
    len equ 100
    x db "X",0
    div_2 dd 2
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
        
        push dword [input_file_descriptor]
        push dword len
        push dword 1
        push dword string
        call [fread]
        add esp,4*4
        
        push dword [input_file_descriptor]
        call [fclose]
        add esp,4
        
        mov ecx,100
        mov esi,string
        mov edi,0
        replacing:
        cmp byte[esi],0
        je out_of_loop
        cmp byte[esi],48
        jl not_digit
        cmp byte[esi],57
        jg not_digit
        mov eax,edi
        mov edx,0
        div dword[div_2]
        cmp edx,0
        jne no_replace
        mov al,[x]
        mov [esi],al
        no_replace:
        not_digit:
        inc esi
        inc edi
        loop replacing
        
        out_of_loop:
        push dword output_file_acces
        push dword output_file_name
        call [fopen]
        add esp,4*2
        
        mov [output_file_descriptor],eax
        cmp eax,0
        je final
        
        push dword string
        push dword [output_file_descriptor]
        call [fprintf]
        add esp,4*2
        
        push dword [output_file_descriptor]
        call [fclose]
        add esp,4
        final:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
