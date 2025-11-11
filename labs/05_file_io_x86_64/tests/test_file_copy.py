"""
Tests for Lab 05: File I/O
"""
import subprocess
import sys
from pathlib import Path

# Add tooling to path
tooling_path = Path(__file__).parent.parent.parent.parent / "tooling" / "scripts"
sys.path.insert(0, str(tooling_path))

from run_bin import run_binary


def test_file_copy_runs():
    """Test that file_copy program executes successfully"""
    binary_path = Path(__file__).parent.parent / "file_copy"
    assert binary_path.exists(), f"Binary not found: {binary_path}"

    result = run_binary(str(binary_path))
    assert result["returncode"] == 0, "Program should exit with status 0"


def test_output_file_created():
    """Test that output file is created"""
    binary_path = Path(__file__).parent.parent / "file_copy"
    output_file = Path(__file__).parent.parent / "output.txt"

    # Remove output file if it exists
    if output_file.exists():
        output_file.unlink()

    # Run the program
    result = run_binary(str(binary_path))

    # Check that output file was created
    assert output_file.exists(), "Output file should be created"


def test_file_content_copied():
    """Test that file content is correctly copied"""
    binary_path = Path(__file__).parent.parent / "file_copy"
    input_file = Path(__file__).parent.parent / "input.txt"
    output_file = Path(__file__).parent.parent / "output.txt"

    # Remove output file if it exists
    if output_file.exists():
        output_file.unlink()

    # Run the program
    result = run_binary(str(binary_path))

    # Read both files
    input_content = input_file.read_text()
    output_content = output_file.read_text()

    # Compare content
    assert input_content == output_content, "Output file should match input file"


def test_success_message():
    """Test that success message is displayed"""
    binary_path = Path(__file__).parent.parent / "file_copy"
    result = run_binary(str(binary_path))

    assert "success" in result["stdout"].lower(), \
        "Output should contain success message"


def test_bytes_counted():
    """Test that bytes copied are counted and displayed"""
    binary_path = Path(__file__).parent.parent / "file_copy"
    input_file = Path(__file__).parent.parent / "input.txt"

    result = run_binary(str(binary_path))

    # Get actual file size
    file_size = len(input_file.read_bytes())

    # Check that byte count is in output
    assert "Bytes" in result["stdout"] or "bytes" in result["stdout"], \
        "Output should mention bytes"
    assert str(file_size) in result["stdout"], \
        f"Output should contain correct byte count ({file_size})"


def test_exit_code():
    """Test that program exits cleanly"""
    binary_path = Path(__file__).parent.parent / "file_copy"
    result = run_binary(str(binary_path))

    assert result["returncode"] == 0, "Program should exit with code 0"
