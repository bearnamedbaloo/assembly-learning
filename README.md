# Assembly Learning Labs

[![CI](https://github.com/bearnamedbaloo/assembly-learning/workflows/CI/badge.svg)](https://github.com/bearnamedbaloo/assembly-learning/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A comprehensive, hands-on learning environment for low-level programming with assembly language. This repository provides guided labs, reproducible tooling, automated tests, and AI-friendly documentation to help you master x86-64 assembly programming on Linux.

## Features

- **Progressive Learning Path**: Start with "Hello World" and advance through increasingly complex concepts
- **Reproducible Environment**: Full devcontainer support for consistent development experience
- **Automated Testing**: Every lab includes pytest-based tests to verify correctness
- **CI/CD Integration**: GitHub Actions ensures all labs build and pass tests
- **AI-Friendly**: Structured documentation enables effective AI-assisted learning
- **Production-Ready Tools**: NASM, GCC, GDB, and all essential debugging tools included

## Quick Start

### Option 1: GitHub Codespaces (Easiest)

1. Click the green "Code" button above
2. Select "Codespaces" tab
3. Click "Create codespace on main"
4. Wait for the environment to build (1-2 minutes)
5. Start learning!

### Option 2: Local Development with VS Code

**Prerequisites**: Docker and VS Code with the Remote-Containers extension

1. Clone this repository:
   ```bash
   git clone https://github.com/bearnamedbaloo/assembly-learning.git
   cd assembly-learning
   ```

2. Open in VS Code:
   ```bash
   code .
   ```

3. When prompted, click "Reopen in Container" (or use Command Palette: "Remote-Containers: Reopen in Container")

4. Wait for the container to build

### Option 3: Local Development without Containers

**Prerequisites**: Ubuntu/Debian Linux (or WSL2)

1. Install dependencies:
   ```bash
   sudo apt-get update
   sudo apt-get install -y nasm gcc make gdb lldb python3 python3-pip binutils
   pip3 install pytest
   ```

2. Clone and start:
   ```bash
   git clone https://github.com/bearnamedbaloo/assembly-learning.git
   cd assembly-learning
   ```

## Running Your First Lab

```bash
# Navigate to Lab 00
cd labs/00_hello_x86_64

# Build the program
make

# Run it
./hello

# Run tests
make test

# Clean up
make clean
```

Expected output:
```
Hello, world!
```

## Labs Overview

Each lab introduces new concepts while building on previous knowledge.

| Lab | Topic | Concepts Covered |
|-----|-------|------------------|
| [00](labs/00_hello_x86_64/) | Hello World | Syscalls, program structure, sections |
| [01](labs/01_stack_and_calls_x86_64/) | Functions & ABI | Calling convention, stack frames, C interop |
| _More labs coming soon..._ | | |

## Repository Structure

```
.
├─ labs/                        # Learning labs (start here!)
│  ├─ 00_hello_x86_64/          # Lab 00: Hello World
│  ├─ 01_stack_and_calls_x86_64/ # Lab 01: Functions
│  └─ _TEMPLATE_LAB/            # Template for new labs
├─ tooling/                     # Shared build infrastructure
│  ├─ Makefile.common           # Common make rules
│  └─ scripts/
│     └─ run_bin.py             # Test runner utility
├─ .devcontainer/               # VS Code devcontainer config
├─ .github/workflows/           # CI/CD workflows
├─ ai/                          # AI collaboration docs
│  ├─ AGENT_PROMPT.md           # Context for AI agents
│  └─ INSTRUCTIONS_FOR_AI.md    # How to add new labs
├─ LICENSE                      # MIT License
└─ README.md                    # This file
```

## Learning Path

### Prerequisites

- Basic programming knowledge (any language)
- Understanding of binary/hexadecimal numbers
- Familiarity with command-line interfaces
- Patience and curiosity!

### Recommended Progression

1. **Lab 00**: Hello World - Get comfortable with assembly syntax and syscalls
2. **Lab 01**: Functions - Learn the System V calling convention
3. **More labs**: Coming soon! Topics will include:
   - Control flow (branches, loops)
   - Memory operations (arrays, strings)
   - Bitwise operations
   - File I/O
   - Data structures
   - Advanced topics (signals, threading, etc.)

### Key Resources

- [Linux Syscall Table](https://filippo.io/linux-syscall-table/)
- [System V ABI Specification](https://refspecs.linuxbase.org/elf/x86_64-abi-0.99.pdf)
- [Intel® 64 and IA-32 Architectures Software Developer Manuals](https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html)
- [NASM Documentation](https://www.nasm.us/doc/)
- [GDB Tutorial](https://www.gdbtutorial.com/)

## Development Workflow

### Building a Lab

```bash
cd labs/XX_lab_name/
make              # Build the binary
make run          # Build and run
make test         # Build and run tests
make debug        # Launch in GDB
make disasm       # View disassembly
make clean        # Remove build artifacts
```

### Running Tests

```bash
# Test a specific lab
cd labs/00_hello_x86_64
pytest tests/ -v

# Test all labs from root
pytest labs/ -v

# Test with coverage
pytest labs/ -v --cov
```

### Debugging

```bash
# Launch GDB
make debug

# Useful GDB commands:
# break _start          - Set breakpoint at entry
# run                   - Start program
# stepi (or si)         - Step one instruction
# nexti (or ni)         - Step over calls
# info registers        - Show all registers
# print $rax            - Show specific register
# x/8xg $rsp            - Examine stack (8 quadwords, hex)
# disassemble           - Show current function disassembly
# backtrace (or bt)     - Show call stack
# quit                  - Exit GDB
```

## Adding a New Lab

Interested in contributing? See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

For AI agents, see [ai/INSTRUCTIONS_FOR_AI.md](ai/INSTRUCTIONS_FOR_AI.md) for detailed instructions.

**Quick steps**:

1. Copy the template:
   ```bash
   cp -r labs/_TEMPLATE_LAB labs/NN_topic_name_x86_64
   ```

2. Implement your lab (assembly code, tests, README)

3. Update this README with your lab in the table above

4. Test thoroughly:
   ```bash
   cd labs/NN_topic_name_x86_64
   make test
   ```

5. Submit a pull request!

## Architecture Support

**Current**: x86-64 Linux (primary focus)

**Future**: ARM64 and RISC-V support is planned. Contributions welcome!

## Contributing

Contributions are welcome! Whether you're fixing a typo, improving documentation, or adding a new lab, please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

Areas where we'd love help:
- Additional x86-64 labs
- ARM64 port of existing labs
- RISC-V examples
- Improved test coverage
- Documentation improvements
- Bug fixes

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Inspired by the need for practical, testable assembly learning resources
- Built with tools from the amazing open-source community
- Thanks to all contributors and learners!

## Support

- **Issues**: [GitHub Issues](https://github.com/bearnamedbaloo/assembly-learning/issues)
- **Discussions**: [GitHub Discussions](https://github.com/bearnamedbaloo/assembly-learning/discussions)

## Star History

If you find this repository helpful, please consider giving it a star! ⭐

---

**Happy Learning!** 🚀

Remember: Assembly language gives you direct control over the machine. With great power comes great responsibility (and great debugging sessions)!
