#!/usr/bin/env python3
"""
Simple binary runner for testing assembly programs.
Executes a binary and captures stdout, stderr, and exit code.
"""

import subprocess
import sys
from pathlib import Path


def run_binary(binary_path: str, *args, stdin_data: str = None) -> dict:
    """
    Run a binary and return its output and exit code.

    Args:
        binary_path: Path to the binary to execute
        args: Command-line arguments to pass to the binary
        stdin_data: Optional data to send to stdin

    Returns:
        dict with keys: stdout, stderr, returncode
    """
    binary = Path(binary_path)
    if not binary.exists():
        raise FileNotFoundError(f"Binary not found: {binary_path}")

    if not binary.is_file():
        raise ValueError(f"Not a file: {binary_path}")

    # Make sure it's executable
    binary.chmod(0o755)

    # Run the binary
    try:
        result = subprocess.run(
            [str(binary)] + list(args),
            capture_output=True,
            text=True,
            input=stdin_data,
            timeout=10  # 10 second timeout
        )
        return {
            "stdout": result.stdout,
            "stderr": result.stderr,
            "returncode": result.returncode
        }
    except subprocess.TimeoutExpired:
        raise TimeoutError(f"Binary execution timed out: {binary_path}")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: run_bin.py <binary_path> [args...]", file=sys.stderr)
        sys.exit(1)

    binary_path = sys.argv[1]
    args = sys.argv[2:]

    try:
        result = run_binary(binary_path, *args)
        print(result["stdout"], end="")
        if result["stderr"]:
            print(result["stderr"], end="", file=sys.stderr)
        sys.exit(result["returncode"])
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)
