# Makefile for Lab 01: Stack and Function Calls
# This lab demonstrates calling conventions and C/assembly interop

# Target binary name
TARGET := sum_program

# Include common rules and variables
include ../../tooling/Makefile.common

# Default target
all: $(TARGET)

# Build the sum_program binary (link assembly and C together)
$(TARGET): sum_two.o main.o
	$(CC) $(CC_FLAGS) sum_two.o main.o -o $(TARGET)

# C compilation
main.o: main.c
	$(CC) $(CC_FLAGS) -c main.c -o main.o

# Assembly compilation
sum_two.o: sum_two.asm

# Test target
test: $(TARGET)
	pytest tests/ -v
