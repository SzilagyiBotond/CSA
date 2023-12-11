bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global biggest     

; declare external functions needed by our program
extern exit ,fopen,fprintf,fclose,printf            ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import fopen msvcrt.dll
import fprintf msvcrt.dll
import fclose msvcrt.dll
import printf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    format db "%x",0
    mode_acces db "w",0
    file_name db "max.txt",0
    fd dd 0
; our code starts here
segment code use32 class=code
    biggest:
        ; ...
        mov ebx,0
        mov ecx,[esp+8]
        mov esi,[esp+4]
        mov bl,0ffh
        bigger:
        cmp bl,[esi]
        jg dont_add
        mov bl,[esi]
        dont_add:
        inc esi
        loop bigger
        push dword mode_acces
        push dword file_name
        call [fopen]
        add esp,4*2
        mov [fd],eax
        cmp eax,0
        je final
        push ebx
        push dword format
        ;call [printf]
        push dword [fd]
        call [fprintf]
        add esp,4*3
        push dword[fd]
        call [fclose]
        add esp,4*2
        final:
        ret
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
