import { readFileSync } from "node:fs";

// BigInt nativo evita overflow para N grande.
function fib(n: number): bigint {
  let a = 0n;
  let b = 1n;
  for (let i = 0; i < n; i++) {
    [a, b] = [b, a + b];
  }
  return a;
}

function fibSum(n: number): bigint {
  let total = 0n;
  let a = 0n;
  let b = 1n;
  for (let i = 0; i <= n; i++) {
    total += a;
    [a, b] = [b, a + b];
  }
  return total;
}

const raw = readFileSync(0, "utf8");
const n = parseInt(raw.trim(), 10);
console.log(`Part 1: ${fib(n)}`);
console.log(`Part 2: ${fibSum(n)}`);
