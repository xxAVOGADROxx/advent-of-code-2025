# Advent of Code 2025 — Polyglot

Soluciones a [AoC 2025](https://adventofcode.com/2025) en **Python, Haskell, Rust, C++, TypeScript y Nix**, con un runner unificado que también hace benchmark.

Ejemplo de referencia funcionando en los 6 lenguajes: [`examples/fibonacci/`](examples/fibonacci/).

## Estructura

```
.
├── compile              # runner CLI: correr / benchmarkear / crear días
├── template/            # esqueleto por lenguaje que se copia al nuevo día
│   ├── python/
│   ├── haskell/
│   ├── rust/
│   ├── cpp/
│   └── typescript/
├── inputs/              # tus inputs personales (gitignored, AoC lo pide)
│   ├── day01.txt
│   ├── day02.txt
│   └── ...
├── day01/
│   ├── python/solution.py
│   ├── haskell/{Solution.hs, solution.cabal}
│   ├── rust/{Cargo.toml, src/main.rs}
│   ├── cpp/solution.cpp
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
./compile --day 1 --lang cpp
./compile --day 1 --lang typescript
./compile --day 1 --lang nix
```

Formatos abreviados aceptados: `py`, `hs`, `rs`, `cpp`/`c++`/`cc`/`cxx`, `ts`, `nix`.

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
Copia `template/` a `day03/` para los 6 lenguajes.

## Convención de I/O

Cada solución:
- **Lee input** desde stdin (o desde `inputs/dayNN.txt` si el runner lo pasa).
- **Escribe stdout** exactamente:
  ```
  Part 1: <respuesta>
  Part 2: <respuesta>
  ```

Esto permite que el runner compare y benchmark las 6 implementaciones sin fricción.

## Setup en una máquina nueva

Un solo comando reinstala todo lo necesario (idempotente, user-level, sin sudo salvo los prerrequisitos de apt):

```bash
git clone https://github.com/xxAVOGADROxx/advent-of-code-2025 && cd advent-of-code-2025
sudo apt install -y curl git pipx build-essential jq   # prerrequisitos únicos con sudo
./bootstrap.sh                                          # instala rustup, ghcup, nvm+node,
                                                        # ruff, pyright, poetry, pytest,
                                                        # nix-portable, gh, hyperfine
./bootstrap.sh --check                                  # verifica qué quedó
./compile --example fibonacci --all                     # smoke test: los 6 lenguajes
```

Luego una única vez: `gh auth login` (para push/clone privados).

## Toolchain instalado

| Herramienta   | Versión probada         | Origen                                         | Rol                                          |
|---------------|-------------------------|------------------------------------------------|----------------------------------------------|
| Python 3      | 3.10 / 3.11+            | sistema o pyenv                                | corre `solution.py`                          |
| ruff          | 0.16+                   | pipx                                           | linter + formatter (reemplaza black+flake8+isort) |
| pyright       | 1.1+                    | pipx (`pyright[nodejs]`)                       | type checker / LSP                           |
| poetry        | 2.4+                    | pipx                                           | dep manager Python (opcional)                |
| pytest        | 9+                      | pipx                                           | test runner                                  |
| GHC + cabal   | 9.6.7 + 3.14            | ghcup                                          | compilar Haskell + HLS                       |
| rustc + cargo | 1.95+                   | rustup                                         | compilar Rust                                |
| g++           | 13.3+                   | `build-essential` (apt)                        | compilar C++ (`-std=c++20 -O2`)              |
| Node.js       | v22 LTS                 | nvm                                            | correr TypeScript via `tsx`                  |
| nix-portable  | latest                  | GitHub release (binario estático)              | evalúa `.nix` sin root, sin `/nix`, sin systemd |
| gh            | 2.65+                   | GitHub release tarball                         | crear/pushear repos                          |
| hyperfine     | 1.20+                   | `cargo install`                                | benchmarking preciso para `--benchmark`      |

**Nix en WSL:** el instalador oficial de nixos.org y el de Determinate Systems fallan/se cuelgan en WSL sin systemd. `nix-portable` es un binario estático de 68 MB que evita todo eso — el runner lo detecta automáticamente si `nix-instantiate` no está en PATH.

## Benchmark de referencia (Fibonacci N=50)

Resultado real de `./compile --example fibonacci --benchmark` (Linux nativo, Nix nativo):

| Lenguaje    | Tiempo medio     | Factor vs. Rust |
|-------------|------------------|-----------------|
| Rust        | **378 µs**       | 1×              |
| C++         | 543 µs           | 1.44×           |
| Haskell     | 611 µs           | 1.61×           |
| Nix         | 9.6 ms           | 25×             |
| Python      | 28.9 ms          | 76×             |
| TypeScript  | 180 ms           | 476×            |

*Los tres compilados (Rust, C++, Haskell) quedan en el mismo orden de magnitud — a esta escala se mide sobre todo fork+exec, no el algoritmo. TypeScript paga el startup de `tsx`/Node; para puzzles largos el startup deja de dominar.*

*Los números de la corrida anterior en WSL2 (5 lenguajes, `nix-portable`) están en [`benchmarks/results.md`](benchmarks/results.md) — no son comparables con estos por hardware y por usar Nix portable en vez de nativo.*

## Reglas AoC

- **Nunca commitees los inputs**. Están en `inputs/` que ya está en `.gitignore`.
- No compartas las respuestas antes de que termine el día.

## Licencia

MIT.
