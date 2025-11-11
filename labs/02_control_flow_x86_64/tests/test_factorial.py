"""
Tests for Lab 02: Control Flow and Loops
"""
import subprocess
import sys
from pathlib import Path

# Add tooling to path
tooling_path = Path(__file__).parent.parent.parent.parent / "tooling" / "scripts"
sys.path.insert(0, str(tooling_path))

from run_bin import run_binary


def test_factorial_runs():
    """Test that factorial program executes successfully"""
    binary_path = Path(__file__).parent.parent / "factorial"
    assert binary_path.exists(), f"Binary not found: {binary_path}"

    result = run_binary(str(binary_path))
    assert result["returncode"] == 0, "Program should exit with status 0"


def test_factorial_output():
    """Test that factorial produces correct output"""
    binary_path = Path(__file__).parent.parent / "factorial"
    result = run_binary(str(binary_path))

    # Should output "Result: 120" for 5!
    assert "120" in result["stdout"], "Output should contain 120 (5! = 120)"


def test_factorial_result_message():
    """Test that output contains result message"""
    binary_path = Path(__file__).parent.parent / "factorial"
    result = run_binary(str(binary_path))

    assert "Result:" in result["stdout"], "Output should contain 'Result:'"


def test_factorial_newline():
    """Test that output ends with newline"""
    binary_path = Path(__file__).parent.parent / "factorial"
    result = run_binary(str(binary_path))

    assert result["stdout"].endswith("\n"), "Output should end with newline"


def test_factorial_exit_code():
    """Test that program exits cleanly"""
    binary_path = Path(__file__).parent.parent / "factorial"
    result = run_binary(str(binary_path))

    assert result["returncode"] == 0, "Program should exit with code 0"
