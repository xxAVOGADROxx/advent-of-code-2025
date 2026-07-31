# Fibonacci en Nix (lenguaje funcional, lazy, sin stdin nativo).
# El runner lo invoca así:
#   nix-instantiate --eval --strict --argstr inputPath /ruta/input.txt --json solution.nix
# y parsea el string JSON.
{ inputPath }:
let
  # Nix no tiene stdin — leemos el archivo directamente.
  raw = builtins.readFile inputPath;

  # trim y parse a entero
  trimmed = builtins.head (builtins.split "\n" raw);
  n = builtins.fromJSON trimmed;

  # Fibonacci iterativo con recursión de cola-like (Nix es lazy, esto NO desborda stack)
  fibStep = state: _:
    { a = state.b; b = state.a + state.b; };

  # itera fibStep n veces sobre {a=0; b=1}
  iterate = f: init: k:
    if k == 0 then init
    else iterate f (f init 0) (k - 1);

  fibN = n:
    let final = iterate fibStep { a = 0; b = 1; } n;
    in final.a;

  # suma fib(0..n) — reutilizamos la misma iteración manteniendo un acumulador
  fibSumStep = state: _:
    { a = state.b; b = state.a + state.b; total = state.total + state.a; };
  fibSum = n:
    (iterate fibSumStep { a = 0; b = 1; total = 0; } (n + 1)).total;

in
  "Part 1: ${toString (fibN n)}\nPart 2: ${toString (fibSum n)}\n"
