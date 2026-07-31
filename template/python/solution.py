#!/usr/bin/env python3
"""AoC 2025 — template. Lee stdin, imprime Part 1 y Part 2."""
from __future__ import annotations
import sys


def parse(raw: str) -> list[str]:
    return raw.rstrip("\n").split("\n")


def part1(data: list[str]) -> int | str:
    return "TODO"


def part2(data: list[str]) -> int | str:
    return "TODO"


def main() -> None:
    data = parse(sys.stdin.read())
    print(f"Part 1: {part1(data)}")
    print(f"Part 2: {part2(data)}")


if __name__ == "__main__":
    main()
