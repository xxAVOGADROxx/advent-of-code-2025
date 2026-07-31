# Template AoC (Nix). Invocado por el runner con:
#   nix-instantiate --eval --strict --argstr inputPath /ruta --json solution.nix
# El valor final debe ser un string; el runner lo desempaqueta con `jq -r`.
{ inputPath }:
let
  raw = builtins.readFile inputPath;

  # split por líneas (elimina strings vacíos que `split` mete entre matches)
  parse = s: builtins.filter builtins.isString (builtins.split "\n" s);
  lines = parse raw;

  part1 = _: "TODO";
  part2 = _: "TODO";

in
  "Part 1: ${toString (part1 lines)}\nPart 2: ${toString (part2 lines)}\n"
