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

## Setup en una máquina nueva

Un solo comando reinstala todo lo necesario (idempotente, user-level, sin sudo salvo los prerrequisitos de apt):

```bash
git clone https://github.com/xxAVOGADROxx/advent-of-code-2025 && cd advent-of-code-2025
sudo apt install -y curl git pipx build-essential jq   # prerrequisitos únicos con sudo
./bootstrap.sh                                          # instala rustup, ghcup, nvm+node,
                                                        # ruff, pyright, poetry, pytest,
                                                        # nix-portable, gh, hyperfine
./bootstrap.sh --check                                  # verifica qué quedó
./compile --example fibonacci --all                     # smoke test: los 5 lenguajes
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
| Node.js       | v22 LTS                 | nvm                                            | correr TypeScript via `tsx`                  |
| nix-portable  | latest                  | GitHub release (binario estático)              | evalúa `.nix` sin root, sin `/nix`, sin systemd |
| gh            | 2.65+                   | GitHub release tarball                         | crear/pushear repos                          |
| hyperfine     | 1.20+                   | `cargo install`                                | benchmarking preciso para `--benchmark`      |

**Nix en WSL:** el instalador oficial de nixos.org y el de Determinate Systems fallan/se cuelgan en WSL sin systemd. `nix-portable` es un binario estático de 68 MB que evita todo eso — el runner lo detecta automáticamente si `nix-instantiate` no está en PATH.

## Benchmark de referencia (Fibonacci N=50)

Resultado real de `./compile --example fibonacci --benchmark` en WSL2:

| Lenguaje    | Tiempo medio     | Factor vs. Rust |
|-------------|------------------|-----------------|
| Rust        | **646 µs**       | 1×              |
| Python      | 6.4 ms           | 10×             |
| Haskell     | 11.0 ms          | 17×             |
| Nix         | 284 ms           | 440×            |
| TypeScript  | 424 ms           | 657×            |

*Rust gana con margen enorme (bigint compilado a machine code). TypeScript y Nix pagan el startup del intérprete/eval; para puzzles largos el startup deja de dominar.*

## Reglas AoC

- **Nunca commitees los inputs**. Están en `inputs/` que ya está en `.gitignore`.
- No compartas las respuestas antes de que termine el día.

## Licencia

MIT.
