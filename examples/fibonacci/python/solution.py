#!/usr/bin/env python3
"""Fibonacci iterativo. Python maneja bigint nativo."""

from __future__ import annotations
import sys


def fib_jose(n: int) -> int:
    if n == 0:
        return 0
    elif n == 1:
        return 1
    else:
        return fib_jose(n - 1) + fib_jose(n - 2)


""""""
from functools import lru_cache


@lru_cache
def fib_jose_cached(n: int) -> int:
    if n == 0:
        return 0
    elif n == 1:
        return 1
    else:
        return fib_jose_cached(n - 1) + fib_jose_cached(n - 2)


""""""
"f_{n}   = f_{n-1} + f_{n-2} = b + a"
"f_{n+1} = f_{n} + f_{n-1}   = (b + a) + b"
"f_{n+2} = f_{n+1} + f_{n}   = (b + a) + b"


def fib(n: int) -> int:
    a, b = 0, 1
    for _ in range(n):
        # asignacion simultanea: el lado derecho se evalua entero con los
        # valores viejos, asi que 'a + b' usa el 'a' de antes, no el nuevo.
        a, b = b, a + b
    return a


""""""
"f_0 = [0]"
"f_1 = [0,1]"
"f_2 = [0,1,1]"
"f_3 = [0,1,1,2]"
"f_4 = [0,1,1,2,3]"


def fib_array(n: int) -> int:
    f = [0] * (n + 1)
    f[1] = 1
    for i in range(2, n + 1):
        f[i] = f[i - 1] + f[i - 2]
    return f[n]


""""""


def fib_sum(n: int) -> int:
    total, a, b = 0, 0, 1
    for _ in range(n + 1):
        total += a
        a, b = b, a + b
    return total


def main() -> None:
    n = int(sys.stdin.read().strip())
    print(f"Part 1: {fib(n)}")
    # print(f"Part 2: {fib_sum(n)}")
    # print(f"Part 3: {fib_jose(n)}")
    # print(f"Part 4: {fib_jose_cached(n)}")
    # print(f"Part 5: {fib_array(n)}")


if __name__ == "__main__":
    main()
