bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,fread,fopen,fclose,fprintf,printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fread msvcrt.dll
import fprintf msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fprint msvcrt.dll
import printf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    to_read db "input.txt",0
    mode_acces_input db "r",0
    file_descriptor_input dd -1
    to_write db "output.txt",0
    mode_acces_output db "w",0
    file_descriptor_output dd -1
    len equ 100
    input times len db 0    
    output times len db 0
    c_to_add db 'c',0
    format db "%s",0
; our code starts here
segment code use32 class=code
    start:
        ; ...
        push dword mode_acces_input
        push dword to_read
        call [fopen]
        add esp,4*2
        mov [file_descriptor_input],eax
        cmp eax,0
        je final
        push dword [file_descriptor_input]
        push dword len
        push dword 1
        push dword input
        call [fread]
        add esp,4*4
        
        push dword [file_descriptor_input]
        call [fclose]
        add esp,4
        
        mov esi,input
        mov edi,output
        mov ecx,len
        mov eax,0
        mov bl,47
        mov bh,57
        copy:
            cmp byte[esi],bl
            jl add_c
            cmp byte[esi],bh
            jg add_c
            mov al, byte[c_to_add]
            mov byte[edi],al
            jmp final_of_loop
            add_c:
                mov al, byte[esi]
                mov byte[edi],al
            final_of_loop:
            inc edi
            inc esi
        loop copy
        mov eax,0
        
        push dword mode_acces_output
        push dword to_write
        call [fopen]
        add esp,4*2
        mov [file_descriptor_output],eax
        cmp eax,0
        je final
        
        push dword output
        push dword [file_descriptor_output]
        call [fprintf]
        add esp, 2*4
        
        
        push dword [file_descriptor_output]
        call [fclose]
        add esp,4
        final:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
