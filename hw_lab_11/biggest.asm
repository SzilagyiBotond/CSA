bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global _biggest     

; declare external functions needed by our program
   ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions



; our data is declared here (the variables needed by our program)
segment data public data use32 class=data
    ; ...

; our code starts here
segment code public code use32 class=code
    _biggest:
        ; ...
        push ebp
        mov ebp,esp
        ; ebp - return address - array - number
        mov ebx,0
        mov eax,0
        mov ecx,[ebp+8] ; number of elements
        mov esi,[ebp+12] ; array 
        mov ebx,0ffffffffh
        bigger:
        cmp ebx,dword[esi]
        jg dont_add
        mov ebx,dword[esi]
        dont_add:
        add esi,4
        loop bigger
        mov eax,ebx
        mov esp,ebp
        pop ebp
        ret
        ; exit(0)
        
