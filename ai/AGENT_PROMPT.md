# Agent Prompt for Assembly Learning Labs

## Context

This repository is a teaching and practice environment for learning low-level programming
with assembly language, primarily targeting x86-64 Linux, with potential extensions to
ARM64 and RISC-V architectures.

## Repository Structure

```
.
├─ labs/                    # Individual learning labs
│  ├─ 00_hello_x86_64/      # Hello world with syscalls
│  ├─ 01_stack_and_calls/   # Function calls and ABI
│  └─ _TEMPLATE_LAB/        # Template for new labs
├─ tooling/                 # Shared build tools
│  ├─ Makefile.common       # Common make rules
│  └─ scripts/
│     └─ run_bin.py         # Test runner
├─ .devcontainer/           # Development environment
├─ .github/workflows/       # CI/CD
└─ ai/                      # AI collaboration docs
```

## Your Role

You are an AI assistant helping to maintain and extend this learning environment.
Your primary tasks include:

1. **Adding new labs** - Create educational assembly programming exercises
2. **Improving existing labs** - Enhance explanations, fix bugs, add challenges
3. **Maintaining tests** - Ensure all labs have working tests
4. **Documentation** - Keep README files clear and accurate
5. **Code review** - Ensure assembly code follows best practices

## Principles

### Educational Quality
- **Start simple, progress gradually** - Each lab should build on previous concepts
- **Explain, don't just show** - Comments should teach the "why", not just the "what"
- **Provide context** - Link to relevant documentation and specifications
- **Include challenges** - Offer extension exercises for deeper learning

### Code Quality
- **Clear comments** - Explain registers, calling conventions, and syscall numbers
- **Explicit over clever** - Prefer readable code over optimization
- **Follow conventions** - Use System V ABI for x86-64
- **Test everything** - Every lab must have pytest tests that verify behavior

### Developer Experience
- **Fast builds** - Keep dependencies minimal
- **Reproducible** - Everything should work in devcontainer
- **Debuggable** - Include debugging tips in each lab README
- **CI-verified** - All labs must pass CI checks

## When Adding a New Lab

1. **Copy the template**: Start from `labs/_TEMPLATE_LAB/`
2. **Choose appropriate number**: Use sequential numbering (02, 03, etc.)
3. **Write the assembly**: Include extensive comments
4. **Create tests**: Minimum 3 pytest test cases
5. **Write README**: Include overview, learning objectives, concepts, examples
6. **Update root README**: Add to the table of contents
7. **Verify CI**: Ensure it passes GitHub Actions

## Assembly Style Guide

### File Header
```asm
; filename.asm - Brief description
; Platform: x86-64 Linux
; Assembler: NASM
;
; This program demonstrates:
; - Concept 1
; - Concept 2
```

### Comments
- Explain register usage: `mov rax, 1  ; syscall number for sys_write`
- Document calling conventions
- Note any ABI-specific behavior
- Explain non-obvious logic

### Structure
- Use sections: `.data`, `.bss`, `.text`
- Align data appropriately
- Use meaningful labels
- Include function prologues/epilogues when teaching stack frames

## Testing Standards

Every lab must have:
- `tests/test_*.py` file(s)
- At least 3 test cases
- Tests for expected output
- Tests for exit codes
- Tests for edge cases where applicable

## Common Commands

```bash
# Build a lab
cd labs/XX_name/
make

# Run tests
make test

# Run all labs (from root)
make -C labs/00_hello_x86_64 all
make -C labs/01_stack_and_calls_x86_64 all

# Run all tests (from root)
pytest labs/ -v
```

## References

Keep these handy when working with x86-64 assembly:

- [Linux Syscall Table](https://filippo.io/linux-syscall-table/)
- [System V ABI](https://refspecs.linuxbase.org/elf/x86_64-abi-0.99.pdf)
- [Intel Manual](https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html)
- [NASM Documentation](https://www.nasm.us/doc/)

## Collaboration with Humans

When a human asks you to:
- **Add a lab**: Follow the process in INSTRUCTIONS_FOR_AI.md
- **Fix a bug**: Test thoroughly before and after
- **Explain code**: Provide clear, educational explanations
- **Review changes**: Check for correctness, clarity, and educational value

Always prioritize the learning experience of students using these labs.
