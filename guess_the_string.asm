; --------------------------------------------------------------------------------------------
; # "Guess the string!"
;
; This is my first assembly program!
; 
; It really isn't anything special but I'm pretty happy
; to have got it working with pretty limited knowledge
; or resources other than an instructions reference.
; 
; ## Issues/Comments:
;
;   - I'd like to look next at actually using "functions" properly, i.e. using the stack
;     with pushing and popping, and storing variables, rather than only working with registers
;     for now, but that's fine for the moment I think!
;
;   - I don't actually know what the syntax `$ - something` does yet to get the length of a
;     string, I know you can do compile-time arithmatic to a degree with nasm so presumably
;     this is some special syntax that does that, I guess.
; --------------------------------------------------------------------------------------------

%include "definitions.asm"

; Set that addresses are relative by default
DEFAULT REL

BITS 64

section .text
    global _main

_main:

    ; Print the opening message
    mov     rax, SYS_WRITE
    mov     rdi, STDOUT
    lea     rsi, [msg_opening]
    mov     rdx, msg_opening.len
    syscall

    .loop:

        call    input_get

        ; Whether the answer is right
        mov     rax, 0

        call    input_check

        ; Check if the answer was correct (1 == correct here)
        cmp     rax, 1
        je      .exit

        ; Write failed message
        mov     rax, SYS_WRITE
        mov     rdi, STDOUT
        lea     rsi, [msg_wrong]
        mov     rdx, msg_wrong.len
        syscall

        jmp     .loop
    
    .exit:

        ; Write success message
        mov     rax, SYS_WRITE
        mov     rdi, STDOUT
        lea     rsi, [msg_right]
        mov     rdx, msg_right.len
        syscall

        ; Exit with code 0
        mov     rax, SYS_EXIT
        xor     rdi, rdi
        syscall

        ret

; Get the input, leaving it in the `input` bss variable.
input_get:

    ; Write the opening message.
    mov     rax, SYS_WRITE
    mov     rdi, STDOUT
    lea     rsi, [msg_prompt]
    mov     rdx, msg_prompt.len
    syscall

    ; Get input
    mov     rax, SYS_READ
    mov     rdi, STDIN
    lea     rsi, [input]
    mov     rdx, expected_str.len
    syscall

    ret

 ; Check user input is equal to the expected input.
input_check:

    ; Probably not needed, but setting registers to 0.
    mov     rax, 0
    mov     rbx, 0

    ; Which byte we're checking currently.
    mov     rcx, 0

    ; Byte offset to load from.
    mov     rdx, 0

    ; Check bytes are correct between the two strings.
    .check_byte:

        ; Check if we're at the end
        cmp     rcx, expected_str.len - 1
        je      .on_right
        
        ; Load input byte
        lea     rdx, [input]
        add     rdx, rcx
        mov     al, byte [rdx]

        ; Load expected byte
        lea     rdx, [expected_str]
        add     rdx, rcx
        mov     ah, byte [rdx]

        ; Compare if they're the same
        cmp     al, ah
        jne     .on_wrong

        ; Increment the index
        inc     rcx

        jmp     .check_byte
    
    .on_wrong:
        mov     rax, 0
        ret
    
    .on_right:
        mov     rax, 1
        ret

section .bss
input:              resb    expected_str.len

section .rodata
msg_opening:        db      "Guess the text!", NEWLINE
    .len:           equ     $ - msg_opening

msg_prompt:         db      "Enter some text!: "
    .len:           equ     $ - msg_prompt

msg_wrong:          db      "Wrong. Try again: ", NEWLINE
    .len:           equ     $ - msg_wrong

msg_right:          db      "Correct! bye", NEWLINE
    .len:           equ     $ - msg_right

expected_str:       db      "whoa some message!!!!", NEWLINE
    .len:           equ     $ - expected_str
