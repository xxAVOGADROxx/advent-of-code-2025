# Fibonacci — Demo poliglota

Ejemplo que verifica que los 6 runtimes funcionan y devuelven lo mismo.

**Input** (stdin): un entero `N`.

**Output**:
```
Part 1: <fib(N)>              # el N-ésimo Fibonacci (0-indexed: fib(0)=0, fib(1)=1, ...)
Part 2: <suma de fib(0..N)>   # suma acumulada, útil para verificar overflow/bigint
```

Todas las implementaciones son **iterativas O(N)** (no recursión naïve — Nix y TS morirían con recursión sin memoization en `N=50`).

Todas usan **precisión arbitraria** salvo Nix (que solo tiene enteros de 64 bits). C++ no trae bigint en la stdlib, así que `cpp/solution.cpp` implementa uno mínimo en base 10^9 — verificado contra Python hasta `N=1000`.

## Correr

```bash
./compile --example fibonacci --lang python
./compile --example fibonacci --all         # los 6 lenguajes
./compile --example fibonacci --benchmark   # comparativa
```

## Resultados esperados (para N=50)

```
Part 1: 12586269025
Part 2: 32951280098
```

Si algún lenguaje da distinto → hay bug en su implementación.
