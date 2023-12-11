bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,printf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import printf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a dw 8
    b db 5
    k equ 14
    format db "%c",0
    number resb 1
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov eax,0
        mov ax, [a]
        div byte [b]
        mov bl,k
        mul bl ; ax=(a/b)*k
        mov bl,2
        mov esi,number
        div bl
        push eax
        mov [esi],ah
        add byte[esi], byte 48
        push dword [number]
        push dword format
        call [printf]
        add esp,4*2
        pop eax
        ;dec esi
        divide:
        mov ah,0
        div bl
        push eax
        mov [esi],ah
        add byte[esi],byte 48
        push dword [number]
        push dword format
        call [printf]
        add esp,4*2
        pop eax
        ;dec esi
        cmp al,0
        jne divide
        add esp,4
       ; push dword [number]
       ; push dword [number+4]
       ; push dword [number+8]
       ; push dword [number+12]
       ; push dword format
       ; call [printf]
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
