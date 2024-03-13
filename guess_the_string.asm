%include "definitions.asm"

; Set that addresses are relative by default
DEFAULT REL

BITS 64

section .text
    global _main

ALIGN 32
_main:

    .loop:

        call    input_get

        ; Whether the answer is right
        mov     rax, 0

        call    input_check

        cmp     rax, 1
        je      .exit

        ; Write failed message
        mov     rax, SYS_WRITE
        mov     rdi, STDOUT
        mov     rsi, msg_wrong
        mov     rdx, msg_wrong.len
        syscall

        jmp     .loop
    
    ALIGN 16
    .exit:

        ; Write success message
        mov     rax, SYS_WRITE
        mov     rdi, STDOUT
        mov     rsi, msg_right
        mov     rdx, msg_right.len
        syscall

        ; Exit with code 0
        mov     rax, SYS_EXIT
        xor     rdi, rdi
        syscall

        ret

; Get the input, leaving it in the `input` bss variable.
ALIGN 32
input_get:

    ; Write the opening message.
    mov     rax, SYS_WRITE
    mov     rdi, STDOUT
    mov     rsi, opening_message
    mov     rdx, opening_message.len
    syscall

    ; Get input
    mov     rax, SYS_READ
    mov     rdi, STDIN
    mov     rsi, input
    mov     rdx, expected_str.len
    syscall

    ret

 ; Check user input is equal to the expected input.
ALIGN 32
input_check:

    mov     rax, 0
    mov     rbx, 0

    ; Which byte we're checking currently.
    mov     rcx, 0

    ; Byte offset to load from.
    mov     rdx, 0

    ; Check bytes are correct between the two strings.
    ALIGN 32
    .check_byte:

        ; Check if we're at the end
        cmp     rcx, expected_str.len - 1
        je      .on_right
        
        ; Load input byte
        mov     rdx, input
        add     rdx, rcx
        mov     al, byte [rdx]

        ; Load expected byte
        mov     rdx, expected_str
        add     rdx, rcx
        mov     bl, byte [rdx]

        ; Compare if they're the same
        cmp     al, bl
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

section .data
opening_message:    db      "Enter some text!: "
    .len:           equ     $ - opening_message

msg_wrong:          db      "Wrong. Try again: ", NEWLINE
    .len:           equ     $ - msg_wrong

msg_right:          db      "Correct! bye", NEWLINE
    .len:           equ     $ - msg_right

expected_str:       db      "whoa you'll never guess this one", NEWLINE
    .len:           equ     $ - expected_str
