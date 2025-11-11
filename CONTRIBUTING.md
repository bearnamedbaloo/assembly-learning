# Contributing to Assembly Learning Labs

Thank you for your interest in contributing! This document provides guidelines for contributing to this project.

## Code of Conduct

This project adheres to a code of conduct. By participating, you are expected to uphold this code:

- Be respectful and inclusive
- Welcome newcomers
- Focus on constructive feedback
- Prioritize education and learning

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates.

When creating a bug report, include:

- **Clear title** describing the issue
- **Steps to reproduce** the problem
- **Expected behavior** vs. actual behavior
- **Environment details**: OS, architecture, Docker/local setup
- **Lab name** and any relevant error messages

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. When creating an enhancement suggestion:

- **Use a clear title** describing the enhancement
- **Provide detailed description** of the suggested functionality
- **Explain why** this enhancement would be useful
- **List alternatives** you've considered

### Pull Requests

1. **Fork the repository** and create your branch from `main`
2. **Make your changes** following our coding standards
3. **Test your changes** thoroughly
4. **Update documentation** as needed
5. **Submit a pull request**

## Development Process

### Setting Up Your Development Environment

1. Fork and clone the repository:
   ```bash
   git clone https://github.com/YOUR_USERNAME/assembly-learning.git
   cd assembly-learning
   ```

2. Open in VS Code with the devcontainer (recommended):
   ```bash
   code .
   # Then: "Reopen in Container"
   ```

3. Install pre-commit hooks:
   ```bash
   pip install pre-commit
   pre-commit install
   ```

### Branch Naming

Use descriptive branch names:

- `feature/lab-XX-topic-name` - For new labs
- `fix/lab-XX-bug-description` - For bug fixes
- `docs/section-improvement` - For documentation
- `refactor/component-name` - For refactoring

### Commit Messages

Follow conventional commit format:

```
type(scope): subject

body (optional)

footer (optional)
```

**Types**:
- `feat`: New feature or lab
- `fix`: Bug fix
- `docs`: Documentation changes
- `test`: Adding or updating tests
- `refactor`: Code refactoring
- `chore`: Maintenance tasks
- `ci`: CI/CD changes

**Examples**:
```
feat(lab-02): add control flow and loops lab

docs(readme): update quick start instructions

fix(lab-00): correct syscall number in comments
```

## Adding a New Lab

### Step-by-Step Guide

1. **Plan your lab**:
   - Choose appropriate difficulty level
   - Identify 1-2 key concepts to teach
   - Ensure it builds on previous labs

2. **Copy the template**:
   ```bash
   cp -r labs/_TEMPLATE_LAB labs/NN_topic_name_x86_64
   cd labs/NN_topic_name_x86_64
   ```

3. **Implement the lab**:
   - Write well-commented assembly code
   - Create comprehensive tests
   - Write detailed README with learning objectives

4. **Update files**:
   - Root README.md (add to labs table)
   - CI workflow if needed (`.github/workflows/ci.yml`)

5. **Test thoroughly**:
   ```bash
   make clean
   make all
   make test
   ```

6. **Verify CI**:
   ```bash
   # From repository root
   pytest labs/NN_topic_name_x86_64/tests/ -v
   ```

### Lab Quality Checklist

- [ ] Assembly code has detailed comments
- [ ] README includes all required sections
- [ ] At least 3 test cases
- [ ] All tests pass
- [ ] Makefile follows project conventions
- [ ] Code assembles without warnings
- [ ] Challenge exercises included
- [ ] Debugging tips provided
- [ ] References to relevant documentation

## Coding Standards

### Assembly Code

**Comments**:
```asm
; GOOD: Explains purpose and context
mov rax, 1          ; syscall number for sys_write (output to file)
mov rdi, 1          ; file descriptor 1 (stdout)

; AVOID: Just repeating the instruction
mov rax, 1          ; move 1 to rax
```

**Structure**:
- Use clear section declarations (`.data`, `.bss`, `.text`)
- Align data appropriately
- Use meaningful label names
- Include function prologues/epilogues when appropriate

**Style**:
- 4-space indentation for instructions
- Labels at column 0 (no indentation)
- One instruction per line
- Comments aligned at column 24 (when possible)

### Python Test Code

Follow PEP 8:
- 4-space indentation
- Descriptive function names
- Docstrings for test functions
- Clear assertions with helpful messages

**Example**:
```python
def test_basic_functionality():
    """Test that program executes and produces expected output"""
    result = run_binary(str(binary_path))
    assert result["returncode"] == 0, "Program should exit cleanly"
    assert "expected" in result["stdout"], "Output should contain expected string"
```

### Documentation

**README files**:
- Use clear, educational language
- Include code examples
- Provide context and motivation
- Link to relevant specifications
- Offer debugging tips

**Comments**:
- Explain the "why", not just the "what"
- Reference ABI or syscall numbers
- Note any non-obvious behavior

## Testing

### Writing Tests

Every lab must have comprehensive tests:

1. **Basic functionality** - Does it work at all?
2. **Expected output** - Does it produce correct results?
3. **Edge cases** - Zero, negative, large values, empty input
4. **Exit codes** - Does it exit cleanly?
5. **Error handling** - Does it handle invalid input gracefully?

### Running Tests

```bash
# Single lab
cd labs/00_hello_x86_64
pytest tests/ -v

# All labs
pytest labs/ -v

# With coverage
pytest labs/ --cov=tooling --cov-report=html
```

### CI/CD

All pull requests must pass CI checks:

- ✓ All labs build successfully
- ✓ All tests pass
- ✓ Pre-commit hooks pass
- ✓ No linting errors

## Review Process

1. **Automated checks**: CI must pass
2. **Code review**: At least one maintainer review
3. **Testing**: Verify functionality manually if needed
4. **Documentation**: Check for clarity and completeness
5. **Merge**: Squash and merge with clean commit message

## Release Process

Releases follow semantic versioning:

- **Major** (1.0.0): Breaking changes or major new features
- **Minor** (0.1.0): New labs or significant improvements
- **Patch** (0.0.1): Bug fixes and minor updates

## Recognition

Contributors are recognized in:
- GitHub contributors page
- Release notes (for significant contributions)
- Lab READMEs (for lab authors)

## Questions?

- **General questions**: Open a [Discussion](https://github.com/bearnamedbaloo/assembly-learning/discussions)
- **Bug reports**: Open an [Issue](https://github.com/bearnamedbaloo/assembly-learning/issues)
- **Feature proposals**: Open an [Issue](https://github.com/bearnamedbaloo/assembly-learning/issues) with the "enhancement" label

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for helping make assembly programming more accessible! 🎉
