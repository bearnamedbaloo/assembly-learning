# Makefile for Lab 00: Hello World
# This lab demonstrates basic syscalls in x86-64 assembly

# Target binary name
TARGET := hello

# Include common rules and variables
include ../../tooling/Makefile.common

# Default target
all: $(TARGET)

# Build the hello binary
$(TARGET): hello.o
	$(LD) $(LD_FLAGS) hello.o -o $(TARGET)

# Specify dependencies
hello.o: hello.asm

# Test target
test: $(TARGET)
	pytest tests/ -v
