# Benchmarks

Corre con `./compile --day N --benchmark` (usa [hyperfine](https://github.com/sharkdp/hyperfine)).

## Notas de metodología

- Cada solución lee stdin y termina cuando imprime `Part 2`.
- Rust y Haskell se compilan una vez y se benchmarkea el binario.
- Python y TypeScript pagan el startup del intérprete en cada run.
- La comparación es *end-to-end* (arranque + parse + solve + print), no solo el hot loop.

## Resultados

| Día | Python | Haskell | Rust | TypeScript |
|-----|--------|---------|------|------------|
| 01  |        |         |      |            |
| 02  |        |         |      |            |

_(pega aquí la salida de hyperfine cuando corras el benchmark)_
