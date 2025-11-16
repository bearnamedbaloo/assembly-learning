; array_max.asm - Find maximum value in an array
; Platform: x86-64 Linux
; Assembler: NASM
;
; This program demonstrates:
; - Array definition and initialization
; - Memory addressing modes (base + index * scale + displacement)
; - Array traversal using loops
; - Finding maximum value

DEFAULT REL                 ; Use RIP-relative addressing by default (recommended for modern code)

section .data
    ; Define an array of integers (64-bit values)
    array dq 42, 17, 93, 8, 56, 31, 74, 19, 65, 28
    array_len equ ($ - array) / 8  ; Calculate number of elements (8 bytes each)

    msg_max db "Maximum value: ", 0
    msg_max_len equ $ - msg_max
    newline db 10

section .bss
    num_buffer resb 20      ; Buffer for number to string conversion

section .text
    global _start

_start:
    ; Find maximum value in array
    mov rdi, array          ; Address of array
    mov rsi, array_len      ; Number of elements
    call find_max

    ; Result is in rax
    mov r12, rax            ; Save max value

    ; Print message
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, msg_max
    mov rdx, msg_max_len
    syscall

    ; Print the maximum value
    mov rdi, r12            ; Restore max value
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

; Function: find_max
; Description: Find the maximum value in an array of 64-bit integers
; Arguments:
;   rdi: pointer to array
;   rsi: number of elements
; Returns:
;   rax: maximum value
; Algorithm:
;   max = array[0]
;   for i from 1 to n-1:
;       if array[i] > max:
;           max = array[i]
;   return max
find_max:
    push rbp
    mov rbp, rsp
    push rbx                ; Save callee-saved register

    ; Check if array is empty
    test rsi, rsi
    jz .empty_array

    ; Initialize: max = array[0], index = 1
    mov rax, [rdi]          ; max = array[0]
    mov rcx, 1              ; index = 1

    ; Check if array has only one element
    cmp rsi, 1
    jle .done

.loop:
    ; Check if index >= length
    cmp rcx, rsi
    jge .done

    ; Load array[index] using scaled index addressing
    ; Address = base + index * scale
    ; For 64-bit values, scale = 8
    mov rbx, [rdi + rcx * 8]  ; rbx = array[index]

    ; Compare with current max
    cmp rbx, rax
    jle .not_greater        ; If array[index] <= max, skip

    ; Update max
    mov rax, rbx            ; max = array[index]

.not_greater:
    ; Increment index
    inc rcx
    jmp .loop

.empty_array:
    xor rax, rax            ; Return 0 for empty array

.done:
    pop rbx
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
