bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,fopen,fread,fclose,printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fopen msvcrt.dll
import fread msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    consoane db "aeiouAEIOU",0
    input_text db "text.txt",0
    input_file_descriptor dd -1
    acces_mode db "r",0
    string resb 100
    nr dd 0
    output_format db "%d",0
    len equ 100
    end_of_letters db "z",0
    start_of_letters db "A",0
; our code starts here
segment code use32 class=code
    start:
        ; ...
        push dword acces_mode
        push dword input_text
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
        
        mov ecx,len
        mov esi,string
        consonant:
        cmp byte[esi],9
        jle dont_add
        mov bl,[end_of_letters]
        cmp byte[esi],bl
        jg dont_add
        mov bl,[start_of_letters]
        cmp byte[esi],bl
        jl dont_add
        push ecx
        mov ecx,10
        mov edi,consoane
        consoana:
        mov bl,[edi]
        cmp byte[esi],bl
        je here
        inc edi
        loop consoana        
        inc dword[nr]
        here:
        pop ecx
        dont_add:
        
        inc esi
        loop consonant
        
        push dword [nr]
        push dword output_format
        call [printf]
        add esp,4*2
        final:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
