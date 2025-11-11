# Lab 05: File I/O (x86-64)

## Overview

This lab teaches file input/output operations using Linux system calls. You'll learn how to open, read, write, and close files, handle errors, and manage buffers. The example program copies a file while counting the bytes transferred.

## Learning Objectives

- Use file-related syscalls (open, read, write, close)
- Understand file descriptors
- Handle errors from syscalls
- Work with buffers for efficient I/O
- Understand file permissions and flags
- Implement proper resource cleanup

## Key Concepts

### File Descriptors

In Unix/Linux, files are accessed through file descriptors (FDs):
- **0** = stdin (standard input)
- **1** = stdout (standard output)
- **2** = stderr (standard error)
- **3+** = opened files

File descriptors are small non-negative integers returned by `open()` and used by other file operations.

### File Operations Syscalls

#### 1. sys_open (syscall 2)

Open or create a file.

```asm
mov rax, 2          ; sys_open
mov rdi, filename   ; pointer to filename (null-terminated)
mov rsi, flags      ; open flags
mov rdx, mode       ; permission mode (for creating files)
syscall             ; returns fd in rax, or -1 on error
```

**Common flags**:
- `O_RDONLY` (0) - Read only
- `O_WRONLY` (1) - Write only
- `O_RDWR` (2) - Read and write
- `O_CREAT` (64) - Create if doesn't exist
- `O_TRUNC` (512) - Truncate to zero length
- `O_APPEND` (1024) - Append to end

**Combine flags with OR**: `O_WRONLY | O_CREAT | O_TRUNC = 1 | 64 | 512 = 577`

**Permission modes** (octal):
- `0644` - rw-r--r-- (owner read/write, others read)
- `0755` - rwxr-xr-x (owner all, others read/execute)

#### 2. sys_read (syscall 0)

Read data from a file.

```asm
mov rax, 0          ; sys_read
mov rdi, fd         ; file descriptor
mov rsi, buffer     ; pointer to buffer
mov rdx, count      ; maximum bytes to read
syscall             ; returns bytes read in rax, 0 = EOF, -1 = error
```

**Return values**:
- `> 0` - Number of bytes read
- `0` - End of file (EOF)
- `< 0` - Error

#### 3. sys_write (syscall 1)

Write data to a file.

```asm
mov rax, 1          ; sys_write
mov rdi, fd         ; file descriptor
mov rsi, buffer     ; pointer to data
mov rdx, count      ; number of bytes to write
syscall             ; returns bytes written in rax, -1 = error
```

#### 4. sys_close (syscall 3)

Close a file descriptor.

```asm
mov rax, 3          ; sys_close
mov rdi, fd         ; file descriptor to close
syscall             ; returns 0 on success, -1 on error
```

### Error Handling

Syscalls return negative values on error:

```asm
syscall
cmp rax, 0
jl .error       ; Jump if rax < 0 (error)
```

Actual error codes (errno) can be found as positive values:
- `-ENOENT` (-2) - No such file
- `-EACCES` (-13) - Permission denied
- `-EBADF` (-9) - Bad file descriptor

### Buffer Management

Use a buffer to read/write data in chunks:

```asm
section .bss
    buffer resb 4096    ; 4KB buffer

; Read loop:
.read_loop:
    mov rax, 0          ; sys_read
    mov rdi, input_fd
    mov rsi, buffer
    mov rdx, 4096       ; Read up to 4KB
    syscall

    test rax, rax
    jz .eof             ; If 0 bytes read, EOF
    jl .error           ; If negative, error

    ; Process data in buffer...

    jmp .read_loop
.eof:
```

## Files

- `file_copy.asm`: File copy program with byte counting
- `input.txt`: Sample input file
- `Makefile`: Build configuration

## Building and Running

```bash
# Build the program
make

# Run the program (copies input.txt to output.txt)
./file_copy

# View the copied file
cat output.txt

# Run tests
make test

# Clean up
make clean

# Disassemble
make disasm
```

## Expected Output

```
File copied successfully!
Bytes copied: 156
```

(The exact byte count depends on the input.txt content)

## Code Walkthrough

### Opening Input File (Read Mode)

```asm
mov rax, 2              ; sys_open
mov rdi, input_file     ; "input.txt"
mov rsi, 0              ; O_RDONLY
mov rdx, 0              ; mode not needed for reading
syscall

cmp rax, 0
jl .error_open          ; Check for error

mov r12, rax            ; Save file descriptor
```

### Opening Output File (Write Mode)

```asm
mov rax, 2              ; sys_open
mov rdi, output_file    ; "output.txt"
mov rsi, 577            ; O_WRONLY | O_CREAT | O_TRUNC
mov rdx, 0644           ; rw-r--r-- permissions
syscall

mov r13, rax            ; Save file descriptor
```

### Read-Write Loop

```asm
.read_loop:
    ; Read from input
    mov rax, 0
    mov rdi, r12            ; input fd
    mov rsi, buffer
    mov rdx, 4096
    syscall

    cmp rax, 0
    jl .error_read
    je .close_files         ; EOF

    mov r14, rax            ; Save bytes read

    ; Write to output
    mov rax, 1
    mov rdi, r13            ; output fd
    mov rsi, buffer
    mov rdx, r14            ; write same amount as read
    syscall

    jmp .read_loop
```

### Closing Files

```asm
.close_files:
    ; Close input
    mov rax, 3
    mov rdi, r12
    syscall

    ; Close output
    mov rax, 3
    mov rdi, r13
    syscall
```

## Challenge Exercises

1. **Append mode**: Modify to append to output file instead of truncating

2. **Multiple files**: Copy multiple input files into one output file

3. **File statistics**: Count lines, words, and characters (like `wc`)

4. **File comparison**: Compare two files byte-by-byte (like `cmp`)

5. **Text transformation**: Convert to uppercase/lowercase while copying

6. **Binary file copy**: Ensure it works with binary files (test with images)

7. **Buffered line reader**: Read file line-by-line

8. **File seek**: Use `sys_lseek` to jump to specific positions

9. **Directory operations**: Use `sys_getdents` to list directory contents

10. **Error messages**: Print specific error messages based on error code

## Advanced: File Metadata

Use `sys_stat` (syscall 4) to get file information:

```asm
section .bss
    stat_buf resb 144       ; struct stat buffer

; Get file stats
mov rax, 4                  ; sys_stat
mov rdi, filename
mov rsi, stat_buf
syscall

; stat_buf contains:
; - File size (bytes 48-55)
; - Permissions (bytes 24-27)
; - Timestamps
; - etc.
```

## Debugging Tips

```bash
# Debug with GDB
gdb ./file_copy

# Useful commands:
(gdb) break _start
(gdb) run
(gdb) print $rax            # Check syscall return value
(gdb) print $r12            # Input file descriptor
(gdb) print $r13            # Output file descriptor
(gdb) x/100c buffer         # View buffer contents

# Use strace to trace syscalls
strace ./file_copy

# This shows all syscalls with arguments and return values:
# open("input.txt", O_RDONLY) = 3
# open("output.txt", O_WRONLY|O_CREAT|O_TRUNC, 0644) = 4
# read(3, "Hello...", 4096) = 156
# write(4, "Hello...", 156) = 156
# close(3) = 0
# close(4) = 0
```

## Common Pitfalls

1. **Not checking errors**: Always check syscall return values
2. **Forgetting to close**: File descriptors are limited; always close files
3. **Wrong flags**: Remember to combine flags with OR, not add
4. **Permissions on create**: Specify mode when using O_CREAT
5. **Buffer size**: Use appropriate buffer size (4KB is common)
6. **Partial writes**: `write()` may write fewer bytes than requested
7. **File descriptor leaks**: Always close in error paths too
8. **Null-terminated filenames**: Filenames must end with 0

## File Operations Summary

| Syscall | Number | Arguments | Return |
|---------|--------|-----------|--------|
| `open` | 2 | rdi=filename, rsi=flags, rdx=mode | fd or -1 |
| `read` | 0 | rdi=fd, rsi=buffer, rdx=count | bytes or 0/- 1 |
| `write` | 1 | rdi=fd, rsi=buffer, rdx=count | bytes or -1 |
| `close` | 3 | rdi=fd | 0 or -1 |
| `lseek` | 8 | rdi=fd, rsi=offset, rdx=whence | offset or -1 |
| `stat` | 4 | rdi=filename, rsi=statbuf | 0 or -1 |

## References

- [Linux Syscall Reference](https://filippo.io/linux-syscall-table/)
- [open(2) man page](https://man7.org/linux/man-pages/man2/open.2.html)
- [read(2) man page](https://man7.org/linux/man-pages/man2/read.2.html)
- [write(2) man page](https://man7.org/linux/man-pages/man2/write.2.html)
- [File Permissions](https://en.wikipedia.org/wiki/File_system_permissions#Numeric_notation)
