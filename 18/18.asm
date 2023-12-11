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
    input_file db "input.txt",0
    input_file_acces_mode db "r",0
    input_file_descriptor dd -1
    content resb 100
    line db "-",0
    point db ".",0
    nr_of_letters dd 0
    nr_of_words dd 0
    len equ 100
    format2 db "number of words %d, %s",0
    lengths resb 100
    longest db 0
    longest_word resb 100
; our code starts here
segment code use32 class=code
    start:
        ; ...
        push dword input_file_acces_mode
        push dword input_file
        call [fopen]
        add esp,4*2
        mov [input_file_descriptor],eax
        cmp eax,0
        je final
        push dword [input_file_descriptor]
        push dword len
        push dword 1
        push dword content
        call [fread]
        add esp,4*4
        push dword [input_file_descriptor]
        call [fclose]
        add esp,4
        mov ecx,len
        mov esi,content
        mov edi,content
        mov ebx,lengths
        count_words:
        
        cmp byte[esi],0
        je out_of_the_loop
        
        mov al,byte[esi]
        
        cmp byte[line],al
        je end_of_word
        
        cmp byte[point],al
        je end_of_word
        jmp no_end
        end_of_word:
        cmp dword[nr_of_letters],0
        je no_word
        
        mov edx,[nr_of_letters]
        mov [ebx],edx
        mov dl,[longest]
        cmp byte[ebx],dl
        jle not_bigger
        mov dl ,byte[ebx]
        mov [longest],dl
        mov edi,esi
        sub edi,[nr_of_letters]
        not_bigger:
        inc ebx
        inc dword[nr_of_words]
        mov dword[nr_of_letters],0
        jmp no_word
        no_end:
        inc dword[nr_of_letters]
        no_word:
        inc esi
        loop count_words
        out_of_the_loop:
        mov ecx,0
        mov cl,[longest]
        mov esi,longest_word
        athelyez:
        mov dl,[edi]
        mov [esi],dl
        inc edi
        inc esi
        loop athelyez
        push dword longest_word
        push dword [nr_of_words]
        push dword format2
        call [printf]
        add esp,4*3
        final:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
