"""
Tests for Lab 00: Hello World
"""
import subprocess
import sys
from pathlib import Path

# Add tooling to path
tooling_path = Path(__file__).parent.parent.parent.parent / "tooling" / "scripts"
sys.path.insert(0, str(tooling_path))

from run_bin import run_binary


def test_hello_output():
    """Test that hello binary prints 'Hello, world!' to stdout"""
    binary_path = Path(__file__).parent.parent / "hello"
    assert binary_path.exists(), f"Binary not found: {binary_path}"

    result = run_binary(str(binary_path))

    assert result["returncode"] == 0, "Program should exit with status 0"
    assert "Hello, world!" in result["stdout"], "Output should contain 'Hello, world!'"


def test_hello_exit_code():
    """Test that hello binary exits with status 0"""
    binary_path = Path(__file__).parent.parent / "hello"
    result = run_binary(str(binary_path))
    assert result["returncode"] == 0, "Program should exit cleanly with status 0"


def test_hello_newline():
    """Test that output ends with a newline"""
    binary_path = Path(__file__).parent.parent / "hello"
    result = run_binary(str(binary_path))
    assert result["stdout"].endswith("\n"), "Output should end with a newline"
