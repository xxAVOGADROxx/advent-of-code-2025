import { readFileSync } from "node:fs";

function parse(raw: string): string[] {
  return raw.trimEnd().split("\n");
}

function part1(_data: string[]): string | number {
  return "TODO";
}

function part2(_data: string[]): string | number {
  return "TODO";
}

const raw = readFileSync(0, "utf8");
const data = parse(raw);
console.log(`Part 1: ${part1(data)}`);
console.log(`Part 2: ${part2(data)}`);
