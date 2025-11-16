; factorial.asm - Calculate factorial using loops and conditionals
; Platform: x86-64 Linux
; Assembler: NASM
;
; This program demonstrates:
; - Conditional jumps (je, jle, jmp)
; - Loop implementation using comparison and jumps
; - Multiplication operation
; - Converting integer to string for output

DEFAULT REL                 ; Use RIP-relative addressing by default (recommended for modern code)

section .data
    prompt db "Factorial of ", 0
    prompt_len equ $ - prompt
    equals db " = ", 0
    equals_len equ $ - equals
    newline db 10
    result_msg db "Result: ", 0
    result_msg_len equ $ - result_msg

section .bss
    num_buffer resb 20      ; Buffer for number to string conversion

section .text
    global _start

_start:
    ; Calculate factorial of 5 (default)
    mov rdi, 5              ; Number to calculate factorial for
    call factorial

    ; Result is in rax
    mov rdi, rax            ; Save result

    ; Print "Result: "
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, result_msg
    mov rdx, result_msg_len
    syscall

    ; Convert result to string and print
    mov rdi, [rsp - 8]      ; Get saved result (we need to save it properly)
    ; Actually, let's recalculate or save better
    mov rdi, 5
    call factorial
    mov rdi, rax            ; Result to convert
    call print_number

    ; Print newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; Exit
    mov rax, 60
    xor rdi, rdi
    syscall

; Function: factorial
; Description: Calculate factorial of a number
; Arguments:
;   rdi: number (n)
; Returns:
;   rax: factorial(n)
; Algorithm:
;   if n <= 1 return 1
;   result = 1
;   for i = 2 to n:
;       result *= i
;   return result
factorial:
    push rbp
    mov rbp, rsp

    ; Check if n <= 1
    cmp rdi, 1
    jle .base_case          ; If n <= 1, return 1

    ; Initialize result = 1, counter = 2
    mov rax, 1              ; result
    mov rcx, 2              ; counter (start from 2)

.loop:
    ; Check if counter > n
    cmp rcx, rdi
    jg .done                ; If counter > n, we're done

    ; result *= counter
    imul rax, rcx           ; rax = rax * rcx

    ; counter++
    inc rcx

    ; Continue loop
    jmp .loop

.base_case:
    mov rax, 1              ; Return 1 for base case

.done:
    pop rbp
    ret

; Function: print_number
; Description: Convert integer to string and print it
; Arguments:
;   rdi: number to print
; Returns: nothing
print_number:
    push rbp
    mov rbp, rsp
    push rbx
    push r12

    mov rax, rdi            ; Number to convert
    lea rbx, [num_buffer + 19]  ; Point to end of buffer
    mov byte [rbx], 0       ; Null terminate
    dec rbx

    mov r12, 10             ; Divisor

    ; Handle zero special case
    test rax, rax
    jnz .convert_loop
    mov byte [rbx], '0'
    jmp .print

.convert_loop:
    test rax, rax
    jz .print               ; If rax == 0, done converting

    xor rdx, rdx            ; Clear rdx for division
    div r12                 ; Divide rax by 10, quotient in rax, remainder in rdx

    add dl, '0'             ; Convert remainder to ASCII
    mov [rbx], dl           ; Store digit
    dec rbx                 ; Move buffer pointer

    jmp .convert_loop

.print:
    inc rbx                 ; Adjust pointer to first digit

    ; Calculate length
    lea rdx, [num_buffer + 19]
    sub rdx, rbx            ; length = end - start

    ; Print the number
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, rbx            ; Buffer with number string
    syscall

    pop r12
    pop rbx
    pop rbp
    ret
