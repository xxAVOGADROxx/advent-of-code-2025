# Benchmarks

Corre con `./compile --day N --benchmark` (usa [hyperfine](https://github.com/sharkdp/hyperfine)).

## Notas de metodología

- Cada solución lee stdin y termina cuando imprime `Part 2`.
- Rust, C++ y Haskell se compilan una vez y se benchmarkea el binario.
- Python y TypeScript pagan el startup del intérprete en cada run.
- La comparación es *end-to-end* (arranque + parse + solve + print), no solo el hot loop.

## Resultados

### Fibonacci N=50 (`./compile --example fibonacci --benchmark`)

#### Corrida actual — Linux nativo, 6 lenguajes

Baseline sintético — algoritmo iterativo bigint idéntico en los 6 lenguajes.
Nix **nativo** (no `nix-portable`), g++ 13.3, GHC 9.10.3, rustc 1.97.1, Node v22.

| Lenguaje    | Tiempo medio     | σ       | Runs | Factor vs. Rust |
|-------------|------------------|---------|------|-----------------|
| Rust        | **378.3 µs**     | 55.1 µs | 3976 | 1×              |
| C++         | 543.0 µs         | 52.7 µs | 3448 | 1.44×           |
| Haskell     | 610.6 µs         | 67.3 µs | 3082 | 1.61×           |
| Nix         | 9.6 ms           | 0.6 ms  | 266  | 25.38×          |
| Python      | 28.9 ms          | 0.5 ms  | 103  | 76.32×          |
| TypeScript  | 179.9 ms         | 2.6 ms  | 16   | 475.52×         |

**Observaciones:**
- Rust, C++ y Haskell caen todos en cientos de µs — a esa escala domina fork+exec, no el cómputo. Las diferencias entre ellos están dentro de ~1.5× y su σ se solapa.
- C++ usa un bigint propio en base 10^9 (~40 líneas) porque la stdlib no trae uno; aun así queda a la par de `num-bigint` y de `Integer`.
- Nix nativo es ~30× más rápido que la corrida vieja con `nix-portable` (9.6 ms vs 284 ms): allí cada eval arrancaba el runtime portable en frío.

#### Corrida histórica — WSL2, 5 lenguajes (antes de C++)

No comparable con la de arriba: distinto hardware y `nix-portable` en vez de Nix nativo.
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

| Día | Python | Haskell | Rust | C++ | TypeScript | Nix |
|-----|--------|---------|------|-----|------------|-----|
| 01  |        |         |      |     |            |     |
| 02  |        |         |      |     |            |     |
