bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,fopen,fprintf,fclose,scanf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fopen msvcrt.dll
import fclose msvcrt.dll
import fprintf msvcrt.dll
import scanf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    input_word resb 100
    input_format db "%s",0
    output_file db "output.txt",0
    output_acces_mode db "w",0
    output_file_descriptor dd -1
    output_format db "%s",10,0
    new_line db "  ",0
    hastag db "$"
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
        mov ecx,0
    
        read:
        push ecx
        push dword input_word
        push dword input_format
        call [scanf]
        mov bl,[hastag]
        cmp bl,[input_word]
        je out_of_loop
        
        mov ecx,100
        mov esi,input_word
        contains_digit:
        cmp byte[esi],48
        jl not_digit
        cmp byte[esi],57
        jg not_digit
        jmp print_to_file
        not_digit:
        inc esi
        loop contains_digit
        jmp dont_print
        
        print_to_file:
        push dword input_word
        push dword input_format
        push dword [output_file_descriptor]
        call [fprintf]
        add esp,4*3
        push dword new_line
        push dword [output_file_descriptor]
        call [fprintf]
        add esp,4*2
        dont_print:
        mov ecx,100
        mov esi,input_word
        clear:
        mov byte[esi],0
        inc esi
        loop clear
        pop ecx
        loop read
        out_of_loop:
        final:
        push dword [output_file_descriptor]
        call [fclose]
        add esp,4
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
