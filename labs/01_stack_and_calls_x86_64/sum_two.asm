; sum_two.asm - Function that adds two integers
; Platform: x86-64 Linux
; Assembler: NASM
; Calling convention: System V AMD64 ABI
;
; This program demonstrates:
; - Function definition in assembly
; - System V calling convention (arguments in rdi, rsi)
; - Return values in rax
; - Interoperability with C

section .text
    global sum_two          ; Make sum_two visible to linker

; Function: sum_two
; Description: Adds two integers and returns the result
; Calling convention: System V AMD64 ABI
;
; Arguments:
;   rdi: first integer (a)
;   rsi: second integer (b)
;
; Returns:
;   rax: sum of a and b
;
; The System V ABI specifies:
; - First 6 integer args in: rdi, rsi, rdx, rcx, r8, r9
; - Return value in rax
; - Caller-saved: rax, rcx, rdx, rsi, rdi, r8-r11
; - Callee-saved: rbx, rsp, rbp, r12-r15

sum_two:
    ; Function prologue (not strictly necessary for this simple function)
    ; but included for educational purposes
    push rbp                ; Save old base pointer
    mov rbp, rsp            ; Set up new base pointer

    ; Function body
    mov rax, rdi            ; Move first argument to rax
    add rax, rsi            ; Add second argument to rax
                            ; Result is now in rax (return value register)

    ; Function epilogue
    pop rbp                 ; Restore old base pointer
    ret                     ; Return to caller (result in rax)
