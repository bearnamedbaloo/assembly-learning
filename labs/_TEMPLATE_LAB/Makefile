# Makefile for Lab XX: [Lab Name]
# [Brief description]

# Target binary name
TARGET := program_name

# Include common rules and variables
include ../../tooling/Makefile.common

# Default target
all: $(TARGET)

# Build the binary
$(TARGET): skeleton.o
	$(LD) $(LD_FLAGS) skeleton.o -o $(TARGET)

# Assembly compilation
skeleton.o: skeleton.asm

# Test target
test: $(TARGET)
	pytest tests/ -v
