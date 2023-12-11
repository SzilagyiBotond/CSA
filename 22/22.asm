bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,fread,fopen,fclose,fprintf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import fread msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fprintf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    input_file_name db "input.txt",0
    output_file_name db "output.txt",0
    input_file_access db "r",0
    output_file_access db "w",0
    input_file_descriptor dd -1
    output_file_descriptor dd -1
    number resb 100
    input_format db "%s",0
    output_format db "%d",0ah,0
    digit dd 0
; our code starts here
segment code use32 class=code
    start:
        ; ...
        push dword input_file_access
        push dword input_file_name
        call [fopen]
        add esp,4*2
        
        mov [input_file_descriptor],eax
        cmp eax,0
        je final
        
        push dword [input_file_descriptor]
        push dword 100
        push dword 1
        push dword number
        call [fread]
        add esp,4*4
        
        push dword [input_file_descriptor]
        call [fclose]
        add esp,4
        
        push dword output_file_access
        push dword output_file_name
        call [fopen]
        
        mov [output_file_descriptor],eax
        cmp eax,0
        je final
        
        mov esi,number
        mov ecx,100
        write:
        cmp byte[esi],0
        je out_of_loop
        push ecx
        mov al,[esi]
        sub al,48
        mov [digit],al
        push dword [digit]
        push dword output_format
        push dword [output_file_descriptor]
        call [fprintf]
        add esp,4*3
        pop ecx
        inc esi
        mov byte[digit],0
        loop write
        push dword [output_file_descriptor]
        call [fclose]
        add esp,4
        out_of_loop:
        final:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
