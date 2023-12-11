bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,printf,fread,fclose,fopen               ; tell nasm that exit exists even if we won't be defining it
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
    input_file_acces_mode db "r",0
    input_file_descriptor dd -1
    number_digits dd 0
    biggest_number dd 0
    line db "-",0
    len equ 100
    string resb 100
    szorzo dd 1
    output db "%d",0
    constant dd 10
; our code starts here ; 48 - 0 digit
segment code use32 class=code
    start:
        ; ...
        push dword input_file_acces_mode
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
        
        mov ecx,len
        mov esi,string
        function:
        mov al,[line]
        cmp byte[esi],0
        je out_of_the_loop
        cmp [esi],al
        je end_of_number
        inc dword[number_digits]
        jmp repetitie
        
        
        end_of_number:
        push ecx
        mov ecx,[number_digits]
        mov ebx,0
        mov edi,esi
        mov dword[szorzo],1
        build_number:
        sub edi,1
        mov eax,0
        mov al,[edi]
        sub al,48
        mul dword[szorzo]
        add ebx,eax
        mov eax,[szorzo]
        mul dword [constant]
        mov [szorzo],eax
        loop build_number
        mov dword[number_digits],0
        cmp ebx,dword[biggest_number]
        jle not_bigger
        mov dword[biggest_number],ebx
        not_bigger:
        pop ecx
        
        repetitie:
        inc esi
        loop function
        out_of_the_loop:
        push dword [biggest_number]
        push dword output
        call [printf]
        add esp,4*2
        final:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
