# Lab 02: Control Flow and Loops (x86-64)

## Overview

This lab introduces control flow in assembly language through conditional jumps and loops. You'll learn how to implement decision-making and iteration, which are fundamental to any non-trivial program. The example calculates factorials using a loop.

## Learning Objectives

- Understand conditional jump instructions (je, jne, jl, jg, jle, jge)
- Implement loops using comparison and jumps
- Use the compare instruction (cmp) with jumps
- Perform integer arithmetic (multiplication)
- Convert integers to strings for output

## Key Concepts

### Conditional Jumps

x86-64 provides various conditional jump instructions that change program flow based on the state of flags set by previous operations (usually `cmp` or `test`):

| Instruction | Meaning | Condition |
|-------------|---------|-----------|
| `je` / `jz` | Jump if Equal / Zero | ZF = 1 |
| `jne` / `jnz` | Jump if Not Equal / Not Zero | ZF = 0 |
| `jl` / `jnge` | Jump if Less (signed) | SF ≠ OF |
| `jle` / `jng` | Jump if Less or Equal (signed) | ZF = 1 or SF ≠ OF |
| `jg` / `jnle` | Jump if Greater (signed) | ZF = 0 and SF = OF |
| `jge` / `jnl` | Jump if Greater or Equal (signed) | SF = OF |

### The Compare Instruction

```asm
cmp operand1, operand2
```

The `cmp` instruction subtracts `operand2` from `operand1` and sets flags, but doesn't store the result. It's typically followed by a conditional jump.

**Example**:
```asm
cmp rax, 5      ; Compare rax with 5
jl .less_than   ; Jump if rax < 5
jge .greater_equal  ; Jump if rax >= 5
```

### Implementing Loops

Loops in assembly are created using:
1. A label for the loop start
2. Loop body code
3. A comparison to check loop condition
4. A conditional jump back to the loop start or forward to exit

**Pattern**:
```asm
    mov rcx, 0          ; Initialize counter
.loop_start:
    cmp rcx, 10         ; Check if counter < 10
    jge .loop_end       ; Exit if counter >= 10

    ; Loop body here

    inc rcx             ; Increment counter
    jmp .loop_start     ; Jump back to loop start
.loop_end:
```

### Factorial Algorithm

Factorial (n!) = n × (n-1) × (n-2) × ... × 2 × 1

**Iterative implementation**:
```
if n <= 1:
    return 1
result = 1
for i from 2 to n:
    result = result * i
return result
```

## Files

- `factorial.asm`: Factorial calculator demonstrating loops and conditionals
- `Makefile`: Build configuration

## Building and Running

```bash
# Build the program
make

# Run the program (calculates 5!)
./factorial

# Run tests
make test

# Clean up
make clean

# Disassemble to see the compiled code
make disasm
```

## Expected Output

```
Result: 120
```

(5! = 5 × 4 × 3 × 2 × 1 = 120)

## Code Walkthrough

### Main Structure

1. **Setup**: Load the number to calculate (default: 5)
2. **Calculate**: Call `factorial` function
3. **Output**: Print the result
4. **Exit**: Clean exit via sys_exit

### Factorial Function

```asm
factorial:
    cmp rdi, 1          ; Compare n with 1
    jle .base_case      ; If n <= 1, return 1

    mov rax, 1          ; result = 1
    mov rcx, 2          ; counter = 2

.loop:
    cmp rcx, rdi        ; Compare counter with n
    jg .done            ; If counter > n, exit loop

    imul rax, rcx       ; result *= counter
    inc rcx             ; counter++
    jmp .loop           ; Continue loop
```

**Key points**:
- Uses `cmp` followed by `jle` (jump if less or equal)
- Loop continues while counter <= n
- `imul` performs signed multiplication
- `inc` increments the counter

### Print Number Function

Converts integer to ASCII string by repeatedly dividing by 10 and converting remainders to digit characters.

## Challenge Exercises

1. **Command-line input**: Modify to accept N as a command-line argument (requires parsing `argc`/`argv`)
2. **Fibonacci sequence**: Implement Fibonacci(n) using loops
3. **Loop with counter register**: Rewrite using the `loop` instruction (uses `rcx` automatically)
4. **Sum of series**: Calculate sum = 1 + 2 + 3 + ... + n
5. **Power function**: Implement `power(base, exponent)` using repeated multiplication
6. **Prime checker**: Determine if a number is prime using a loop to test divisors

## Debugging Tips

```bash
# Debug with GDB
gdb ./factorial

# Useful GDB commands:
(gdb) break factorial          # Break at factorial function
(gdb) run                      # Run program
(gdb) stepi                    # Step one instruction
(gdb) info registers           # Show all registers
(gdb) print $rax               # Print value in rax
(gdb) print $rcx               # Print loop counter
(gdb) display $rax             # Auto-display rax after each step
(gdb) watch $rcx               # Break when rcx changes
```

**Watch the loop**:
```bash
(gdb) break factorial
(gdb) run
(gdb) break *factorial + <offset_of_loop>  # Set breakpoint in loop
(gdb) continue
(gdb) display $rax             # Watch result
(gdb) display $rcx             # Watch counter
```

## Common Pitfalls

1. **Off-by-one errors**: Carefully choose between `jl`, `jle`, `jg`, `jge`
2. **Infinite loops**: Ensure loop counter is updated and exit condition is reachable
3. **Register clobbering**: Remember which registers are caller-saved vs callee-saved
4. **Overflow**: Factorial grows quickly; 21! overflows 64-bit integer
5. **Flag dependencies**: Flags are set by many instructions; `cmp` result can be overwritten

## References

- [x86 Jump Instructions](https://www.felixcloutier.com/x86/jcc)
- [CMP Instruction](https://www.felixcloutier.com/x86/cmp)
- [Intel Manual Vol. 1, Chapter 7: Programming with General-Purpose Instructions](https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html)
