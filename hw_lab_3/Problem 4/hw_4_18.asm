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
    a db 1
    b db 2
    c dw 3
    e dd 4
    x dq 5
    ;(a+b*c+2/c)/(2+a)+e+x - signed
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov al,[b]
        cbw
        imul word[c] ; dx:ax=b*c
        push dx
        push ax
        pop ebx ; ebx = b*c
        mov al,[a]
        cbw
        cwde ; eax =a
        add ebx,eax; ebx=a+b*c
        mov eax,0
        mov dx,0
        mov ax,2
        idiv word[c] ; ax=2/c
        cwde ; eax = 2/c
        add ebx,eax ; ebx = a+b*c+2/c
        mov al,2
        add al, [a]
        cbw ; ax=2+a
        mov cx,ax ; cx = 2+a
        push ebx
        pop ax
        pop dx ; dx:ax=a+b*c+2/c
        idiv cx ; ax=(a+b*c+2/c)/(2+a)
        cwde ; eax = (a+b*c+2/c)/(2+a)
        mov edx,0
        add edx,[e] ; edx=e
        add eax,edx ; eax=(a+b*c+2/c)/(2+a)+e
        cdq ; edx:eax=(a+b*c+2/c)/(2+a)+e
        mov ebx, dword[x+0]
        mov ecx, dword[x+4]; ecx:ebx = x
        clc
        add eax,ebx
        adc edx,ecx ; edx:eax =  (a+b*c+2/c)/(2+a)+e+x
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
