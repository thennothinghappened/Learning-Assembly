
section .text
    global _main

ALIGN 8
_main:
    mov     rax, 0x02000004
    mov     rdi, 1
    mov     rsi, message
    mov     rdx, message.len
    syscall

    mov     rax, 0x02000001
    xor     rdi, rdi
    syscall

    jp      blah

blah:
    jp      _main

section .data
message:        db      "hi!"
    .len:       equ     $ - message
