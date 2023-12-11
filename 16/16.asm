bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,fopen,fclose,fread,printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fopen msvcrt.dll
import fclose msvcrt.dll
import fread msvcrt.dll
import printf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    input_file_name db "input.txt",0
    input_file_access db "r",0
    input_file_descriptor dd -1
    output_format db "number of y=%d, number of z=%d",0
    y_number dd 0
    z_number dd 0
    string resb 100
    z db "z",0
    y db "y",0
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
        push dword string
        call [fread]
        add esp,4*4
        
        push dword [input_file_descriptor]
        call [fclose]
        add esp,4
        
        mov esi,string
        mov ecx,100
        count:
        cmp byte[esi],0
        je out_of_loop
        mov al,[z]
        mov ah,[y]
        cmp al,[esi]
        jne dont_add_z
        inc dword [z_number]
        dont_add_z:
        cmp ah,[esi]
        jne dont_add
        inc dword [y_number]
        dont_add:
        inc esi
        
        
        loop count
        out_of_loop:
        push dword [z_number]
        push dword [y_number]
        push dword output_format
        call [printf]
        add esp,4*3
        final:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
