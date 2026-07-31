#!/usr/bin/env python3
"""Fibonacci iterativo. Python maneja bigint nativo."""
from __future__ import annotations
import sys


def fib(n: int) -> int:
    a, b = 0, 1
    for _ in range(n):
        a, b = b, a + b
    return a


def fib_sum(n: int) -> int:
    total, a, b = 0, 0, 1
    for _ in range(n + 1):
        total += a
        a, b = b, a + b
    return total


def main() -> None:
    n = int(sys.stdin.read().strip())
    print(f"Part 1: {fib(n)}")
    print(f"Part 2: {fib_sum(n)}")


if __name__ == "__main__":
    main()
