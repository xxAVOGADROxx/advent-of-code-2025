# Advent of Code 2025 — Polyglot

Soluciones a [AoC 2025](https://adventofcode.com/2025) en **Python, Haskell, Rust, TypeScript y Nix**, con un runner unificado que también hace benchmark.

Ejemplo de referencia funcionando en los 5 lenguajes: [`examples/fibonacci/`](examples/fibonacci/).

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
│   ├── haskell/{Solution.hs, solution.cabal}
│   ├── rust/{Cargo.toml, src/main.rs}
│   ├── typescript/{package.json, solution.ts}
│   └── nix/solution.nix
├── day02/ ...
├── examples/
│   └── fibonacci/          # demo: mismo algoritmo en los 5 lenguajes
└── benchmarks/results.md
```

## Uso

### Correr una solución
```bash
./compile --day 1 --lang python
./compile --day 1 --lang haskell
./compile --day 1 --lang rust
./compile --day 1 --lang typescript
./compile --day 1 --lang nix
```

Formatos abreviados aceptados: `py`, `hs`, `rs`, `ts`, `nix`.

También funciona con ejemplos (usa `examples/NAME/input.txt` como input):
```bash
./compile --example fibonacci --all
```

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

| Lenguaje    | Versión probada         | Instalación                                    |
|-------------|-------------------------|------------------------------------------------|
| Python      | 3.11+                   | pyenv                                          |
| Haskell     | GHC 9.6 + cabal 3.0+    | ghcup                                          |
| Rust        | 1.75+ (edition 2021)    | rustup                                         |
| TypeScript  | Node 22 + tsx           | `npm i -g tsx typescript`                      |
| Nix         | nix 2.20+ o nix-portable| [nix-portable](https://github.com/DavHau/nix-portable) (binario estático, sin root, sin `/nix`) |
| Benchmark   | hyperfine (opcional)    | `cargo install hyperfine`                      |

**Nix sin root en WSL/Windows:** `curl -L https://github.com/DavHau/nix-portable/releases/latest/download/nix-portable-x86_64 -o ~/.local/bin/nix-portable && chmod +x ~/.local/bin/nix-portable`. El runner lo detecta automáticamente si `nix-instantiate` no está en PATH.

## Reglas AoC

- **Nunca commitees los inputs**. Están en `inputs/` que ya está en `.gitignore`.
- No compartas las respuestas antes de que termine el día.

## Licencia

MIT.
