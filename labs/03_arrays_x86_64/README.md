# Lab 03: Working with Arrays (x86-64)

## Overview

This lab introduces array manipulation in assembly language. You'll learn how to define arrays, traverse them using loops, and use different memory addressing modes. The example finds the maximum value in an array of integers.

## Learning Objectives

- Define and initialize arrays in the data section
- Calculate array length at assembly time
- Use scaled index addressing mode
- Traverse arrays with loops
- Implement array algorithms (find maximum)
- Understand memory layout of arrays

## Key Concepts

### Array Definition

Arrays in assembly are simply contiguous blocks of memory. Define them in the `.data` section:

```asm
section .data
    array dq 10, 20, 30, 40, 50      ; Array of 5 quad-words (64-bit)
    array_len equ ($ - array) / 8     ; Calculate length
```

**Key points**:
- `dq` (define quad-word) creates 64-bit values
- `$` represents the current location counter
- `$ - array` gives the total bytes
- Divide by 8 (bytes per quad-word) to get element count

**Other data sizes**:
- `db` (byte) - 8 bits
- `dw` (word) - 16 bits
- `dd` (double-word) - 32 bits
- `dq` (quad-word) - 64 bits

### Memory Addressing Modes

x86-64 supports several addressing modes for accessing memory:

**1. Direct addressing**:
```asm
mov rax, [array]        ; Load first element
```

**2. Base + Offset**:
```asm
mov rax, [array + 8]    ; Load second element (8 bytes offset)
```

**3. Base + Index**:
```asm
mov rax, [rdi + rcx]    ; rdi = base, rcx = offset
```

**4. Scaled Index** (most useful for arrays):
```asm
mov rax, [rdi + rcx * 8]  ; rdi = base, rcx = index, 8 = element size
```

The general form is: `[base + index * scale + displacement]`

**Scale values**: 1, 2, 4, or 8 (matching common data sizes)

### Array Traversal Pattern

```asm
    mov rdi, array      ; Base address
    mov rsi, length     ; Number of elements
    mov rcx, 0          ; Index

.loop:
    cmp rcx, rsi        ; Compare index with length
    jge .done           ; Exit if index >= length

    ; Access element: array[index]
    mov rax, [rdi + rcx * 8]

    ; Process element...

    inc rcx             ; index++
    jmp .loop
.done:
```

### Finding Maximum Algorithm

```
max = array[0]
for i from 1 to n-1:
    if array[i] > max:
        max = array[i]
return max
```

## Files

- `array_max.asm`: Find maximum value in an array
- `Makefile`: Build configuration

## Building and Running

```bash
# Build the program
make

# Run the program
./array_max

# Run tests
make test

# Clean up
make clean

# Disassemble
make disasm
```

## Expected Output

```
Maximum value: 93
```

(The array contains: 42, 17, 93, 8, 56, 31, 74, 19, 65, 28)

## Code Walkthrough

### Array Definition

```asm
section .data
    array dq 42, 17, 93, 8, 56, 31, 74, 19, 65, 28
    array_len equ ($ - array) / 8
```

This creates an array of 10 quad-words (64-bit integers) and calculates its length.

### Finding Maximum

```asm
find_max:
    mov rax, [rdi]          ; max = array[0]
    mov rcx, 1              ; index = 1

.loop:
    cmp rcx, rsi            ; if index >= length
    jge .done               ; exit

    mov rbx, [rdi + rcx * 8]  ; rbx = array[index]
    cmp rbx, rax            ; compare with max
    jle .not_greater        ; skip if not greater

    mov rax, rbx            ; update max

.not_greater:
    inc rcx                 ; index++
    jmp .loop
```

**Key instruction**: `mov rbx, [rdi + rcx * 8]`
- `rdi` = base address of array
- `rcx` = current index (0, 1, 2, ...)
- `8` = size of each element in bytes
- Result: accesses `array[index]`

## Challenge Exercises

1. **Find minimum**: Modify to find the minimum value instead
2. **Find both**: Return both min and max (use rax and rdx)
3. **Calculate sum**: Sum all elements in the array
4. **Calculate average**: Sum divided by count
5. **Find index**: Return the index of the maximum value, not the value itself
6. **Reverse array**: Reverse the array in-place
7. **Linear search**: Find if a specific value exists in the array
8. **Count occurrences**: Count how many times a value appears
9. **Sort array**: Implement bubble sort or selection sort
10. **Two-dimensional array**: Work with a 2D array (matrix)

## Advanced: Two-Dimensional Arrays

For a 2D array (matrix) stored in row-major order:

```asm
; 3x4 matrix (3 rows, 4 columns)
matrix dq 1, 2, 3, 4
       dq 5, 6, 7, 8
       dq 9, 10, 11, 12

; Access element at row i, column j:
; address = base + (i * num_columns + j) * element_size
; Example: matrix[1][2] (row 1, col 2) = 7
mov rax, 1              ; row
mov rbx, 4              ; num_columns
imul rax, rbx           ; rax = row * num_columns
add rax, 2              ; rax = row * num_columns + column
mov rcx, [matrix + rax * 8]  ; Load element
```

## Debugging Tips

```bash
# Debug with GDB
gdb ./array_max

# Useful commands:
(gdb) break find_max
(gdb) run
(gdb) x/10gx $rdi              # Examine 10 quad-words at array address
(gdb) print $rax               # Current max value
(gdb) print $rcx               # Current index
(gdb) display $rax             # Auto-display max
(gdb) display $rcx             # Auto-display index
```

**View array contents**:
```bash
(gdb) x/10dg $rdi       # Examine 10 quad-words in decimal
(gdb) x/10xg $rdi       # Examine 10 quad-words in hex
```

## Common Pitfalls

1. **Wrong scale**: Remember to use correct scale for element size (8 for quad-words)
2. **Off-by-one**: Ensure loop condition is `<` length, not `<=`
3. **Uninitialized max**: Always initialize max before the loop
4. **Empty arrays**: Check for zero-length arrays
5. **Register clobbering**: Save callee-saved registers (rbx, r12-r15)
6. **Signed vs unsigned**: Use appropriate comparison (jl vs jb, jg vs ja)

## References

- [x86-64 Addressing Modes](https://www.felixcloutier.com/x86/)
- [Intel Manual Vol. 1, Chapter 3: Basic Execution Environment](https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html)
- [NASM Manual: Pseudo-Instructions](https://www.nasm.us/doc/nasmdoc3.html)
