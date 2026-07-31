# Benchmarks

Corre con `./compile --day N --benchmark` (usa [hyperfine](https://github.com/sharkdp/hyperfine)).

## Notas de metodología

- Cada solución lee stdin y termina cuando imprime `Part 2`.
- Rust y Haskell se compilan una vez y se benchmarkea el binario.
- Python y TypeScript pagan el startup del intérprete en cada run.
- La comparación es *end-to-end* (arranque + parse + solve + print), no solo el hot loop.

## Resultados

### Fibonacci N=50 (`./compile --example fibonacci --benchmark`)

Baseline sintético — algoritmo iterativo bigint idéntico en los 5 lenguajes.
Máquina: WSL2 sobre Windows 11, Ryzen-clase.

| Lenguaje    | Tiempo medio     | σ       | Runs | Factor vs. Rust |
|-------------|------------------|---------|------|-----------------|
| Rust        | **645.6 µs**     | 65.3 µs | 2193 | 1×              |
| Python      | 6.4 ms           | 0.3 ms  | 417  | 9.87×           |
| Haskell     | 11.0 ms          | 0.1 ms  | 257  | 17.01×          |
| Nix         | 284.0 ms         | 2.1 ms  | 10   | 439.92×         |
| TypeScript  | 424.4 ms         | 12.5 ms | 10   | 657.35×         |

**Observaciones:**
- Rust triunfa por machine code + bigint compilado.
- Python/Haskell son competitivos; Python cargó su intérprete y evaluó todo en ~6ms.
- Haskell aquí es más lento que Python — el binario es rápido pero paga fork+exec y print de Integer via `show`.
- TypeScript paga ~400ms de startup de `tsx`/Node; el algoritmo en sí es instantáneo.
- Nix es lento (~284ms) pero **funciona**: cada eval es un bootstrap completo de nix-portable si no está el store local caliente.

### Días reales

| Día | Python | Haskell | Rust | TypeScript | Nix |
|-----|--------|---------|------|------------|-----|
| 01  |        |         |      |            |     |
| 02  |        |         |      |            |     |
