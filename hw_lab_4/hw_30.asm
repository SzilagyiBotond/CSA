bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a dw 0111011101010111b
    b dd 0
    ; 0000000000000000
    ;the bits 0-3 of B are the same as the bits 1-4 of the result A XOR 0Ah
    ;the bits 4-11 of B are the same as the bits 7-14 of A
    ;the bits 12-19 of B have the value 0
    ;the bits 20-25 of B have the value 1
    ;the bits 26-31 of C are the same as the bits 3-8 of A complemented
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov eax, 0
        mov ebx,0
        mov bx,[a]
        xor bx,000Ah ; bx = bx xor 00001010b = 0111011101011101b
        and bx, 00000000000011110b ; separate the 1-4 bits of bx
        mov cl,1
        ror bx,cl 
        or eax,ebx ; the bits 0-3 of B are the same as the bits 1-4 of the result A XOR 0Ah
        
        mov bx,[a]
        and bx, 0111111110000000b; we isolate the 7-14 bits of A
        mov cl,3
        ror bx,cl
        or eax,ebx ; the bits 4-11 of B are the same as the bits 7-14 of A
        
        or eax, 00000000000000000000000000000000b ; the bits 12-19 of B have the value 0
       
        or eax , 00000011111100000000000000000000b ; the bits 20-25 of B have the value 1
        
        mov ebx,0
        mov bx, [a]
        neg bx ; complement of bx, an alternative is not bx; add bx, 1b; or if the exercise refers to the one's complement, then simply we say not bx
        and bx, 0000000111111000b ; we isolate the bits of 3-8 of A complement
        mov cl , 7
        rol bx,cl
        mov cl,16
        rol ebx,cl
        or eax,ebx ; the bits 26-31 of C are the same as the bits 3-8 of A complemented
        mov [b],eax
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
