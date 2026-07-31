# Advent of Code 2025 — Polyglot

Soluciones a [AoC 2025](https://adventofcode.com/2025) en **Python, Haskell, Rust y TypeScript**, con un runner unificado que también hace benchmark.

## Estructura

```
.
├── compile              # runner CLI: correr / benchmarkear / crear días
├── template/            # esqueleto por lenguaje que se copia al nuevo día
│   ├── python/
│   ├── haskell/
│   ├── rust/
│   └── typescript/
├── inputs/              # tus inputs personales (gitignored, AoC lo pide)
│   ├── day01.txt
│   ├── day02.txt
│   └── ...
├── day01/
│   ├── python/solution.py
│   ├── haskell/Solution.hs
│   ├── rust/{Cargo.toml, src/main.rs}
│   └── typescript/{package.json, solution.ts}
├── day02/ ...
└── benchmarks/results.md
```

## Uso

### Correr una solución
```bash
./compile --day 1 --lang python
./compile --day 1 --lang haskell
./compile --day 1 --lang rust
./compile --day 1 --lang typescript
```

Formatos abreviados aceptados: `py`, `hs`, `rs`, `ts`.

### Correr todos los lenguajes de un día
```bash
./compile --day 1 --all
```
Imprime la salida y el tiempo de cada uno, útil para verificar que todos dan la misma respuesta.

### Benchmark
```bash
./compile --day 1 --benchmark            # con hyperfine si está disponible
./compile --day 1 --benchmark --lang rs  # solo un lenguaje
```

### Crear un nuevo día (bootstrap)
```bash
./compile new-day 3
```
Copia `template/` a `day03/` para los 4 lenguajes.

## Convención de I/O

Cada solución:
- **Lee input** desde stdin (o desde `inputs/dayNN.txt` si el runner lo pasa).
- **Escribe stdout** exactamente:
  ```
  Part 1: <respuesta>
  Part 2: <respuesta>
  ```

Esto permite que el runner compare y benchmark las 4 implementaciones sin fricción.

## Requerimientos

| Lenguaje    | Versión probada     | Instalación                  |
|-------------|---------------------|------------------------------|
| Python      | 3.11+               | pyenv                        |
| Haskell     | GHC 9.6+            | ghcup                        |
| Rust        | 1.75+ (edition 2024)| rustup                       |
| TypeScript  | Node 22 + tsx       | `npm i -g tsx typescript`    |
| Benchmark   | hyperfine (opcional)| `cargo install hyperfine`    |

## Reglas AoC

- **Nunca commitees los inputs**. Están en `inputs/` que ya está en `.gitignore`.
- No compartas las respuestas antes de que termine el día.

## Licencia

MIT.
