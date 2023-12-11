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
; our code starts here
;(a+b*c+2/c)/(2+a)+e+x - unsigned
segment code use32 class=code
    start:
        ; ...
        mov al,[b]
        mov ah,0
        mul word[c] ; dx:ax=b*c
        mov bl,[a]
        mov bh,0  
        mov cx,0 ; cx:bx=a
        clc
        add ax,bx
        adc dx,cx ; dx:ax=a+b*c
        mov cx,dx
        mov bx,ax ; cx:bx=a+b*c
        mov dx,0
        mov ax,2
        div word[c] ; ax=2/c
        mov dx,0 ; dx:ax=2/c
        clc
        add ax,bx
        adc dx,cx ; dx:ax=a+b*c+2/c
        mov cl,2
        add cl, [a]
        mov ch , 0 ; cx=2+a
        div cx ; ax=(a+b*c+2/c)/(2+a)
        mov edx,0
        mov dx,ax ; edx=(a+b*c+2/c)/(2+a)
        add edx,[e] ; edx=(a+b*c+2/c)/(2+a)+e
        mov eax,edx 
        mov edx,0 ; edx:eax=(a+b*c+2/c)/(2+a)+e
        mov ebx, dword[x+0]
        mov ecx, dword[x+4]; ecx:ebx = x
        clc
        add eax,ebx
        adc edx,ecx ; edx:eax =  (a+b*c+2/c)/(2+a)+e+x
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
