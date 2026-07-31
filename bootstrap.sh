#!/usr/bin/env bash
# Bootstrap del entorno para AoC 2025 polyglot.
# Idempotente: skipea lo que ya está instalado. Todo user-level (nada de sudo
# excepto lo que aptas al principio).
#
# Uso:
#   ./bootstrap.sh              # instala todo
#   ./bootstrap.sh --check      # solo verifica qué falta

set -euo pipefail

CHECK_ONLY=false
[ "${1:-}" = "--check" ] && CHECK_ONLY=true

# Source de toolchains en ubicaciones conocidas (mismo patrón que ./compile).
# Sin esto, --check reporta "falta" cuando en realidad están en ~/.cargo, ~/.ghcup, ~/.nvm.
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
[ -s "$HOME/.nvm/nvm.sh" ] && . "$HOME/.nvm/nvm.sh" >/dev/null 2>&1
[ -d "$HOME/.ghcup/bin" ] && export PATH="$HOME/.ghcup/bin:$PATH"
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"

# ---------- utilidades ----------
c_reset='\033[0m'
c_green='\033[32m'; c_yellow='\033[33m'; c_red='\033[31m'; c_blue='\033[34m'
info() { printf "${c_blue}%s${c_reset}\n" "$*"; }
ok()   { printf "${c_green}✓ %s${c_reset}\n" "$*"; }
warn() { printf "${c_yellow}⚠ %s${c_reset}\n" "$*"; }
err()  { printf "${c_red}✗ %s${c_reset}\n" "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }

skip_or_run() {
  local name="$1"; shift
  if $CHECK_ONLY; then
    if "$@"; then ok "$name"; else warn "$name  falta"; fi
  else
    if "$@"; then ok "$name  ya instalado"; else info "instalando $name..."; return 1; fi
  fi
}

# ---------- 0. prerequisitos del sistema (los únicos con sudo) ----------
check_apt_deps() {
  local missing=()
  for p in curl git pipx build-essential jq; do
    dpkg -s "$p" >/dev/null 2>&1 || missing+=("$p")
  done
  if [ ${#missing[@]} -gt 0 ]; then
    err "faltan paquetes del sistema. Corre:"
    echo "    sudo apt update && sudo apt install -y ${missing[*]}"
    return 1
  fi
  ok "apt deps (${missing[*]:-todos ok})"
}

info "== 0. prerequisitos de apt =="
check_apt_deps || { $CHECK_ONLY || exit 1; }

# ---------- 1. ~/.local/bin en PATH ----------
mkdir -p "$HOME/.local/bin"
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

# ---------- 2. Rust (rustup) ----------
info "== 2. Rust =="
if have cargo && have rustc; then
  ok "cargo $(cargo --version | awk '{print $2}')"
else
  $CHECK_ONLY && warn "rustup falta" || {
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
    . "$HOME/.cargo/env"
    ok "cargo instalado"
  }
fi

# ---------- 3. Haskell (ghcup + GHC 9.6.7 + cabal) ----------
info "== 3. Haskell =="
if have ghc && have cabal; then
  ok "ghc $(ghc --numeric-version), cabal $(cabal --numeric-version)"
else
  $CHECK_ONLY && warn "ghcup falta" || {
    BOOTSTRAP_HASKELL_NONINTERACTIVE=1 \
    BOOTSTRAP_HASKELL_INSTALL_STACK=1 \
    BOOTSTRAP_HASKELL_INSTALL_HLS=1 \
    BOOTSTRAP_HASKELL_ADJUST_BASHRC=P \
    curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
    export PATH="$HOME/.ghcup/bin:$PATH"
    ok "ghcup + ghc + cabal + HLS instalados"
  }
fi

# ---------- 4. Node.js (nvm + LTS) ----------
info "== 4. Node =="
if have node; then
  ok "node $(node --version)"
else
  $CHECK_ONLY && warn "node falta" || {
    export NVM_DIR="$HOME/.nvm"
    if [ ! -d "$NVM_DIR" ]; then
      curl -sSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    fi
    . "$NVM_DIR/nvm.sh"
    nvm install --lts
    ok "node $(node --version) instalado"
  }
fi

# ---------- 5. tsx (para TypeScript) ----------
info "== 5. tsx =="
if have tsx || (have node && npm ls -g tsx --depth=0 >/dev/null 2>&1); then
  ok "tsx disponible (via npx o global)"
else
  $CHECK_ONLY && warn "tsx falta (usar npx --yes tsx funciona sin instalar)" || {
    npm install -g tsx typescript
    ok "tsx + typescript globales"
  }
fi

# ---------- 6. Python: pyright, ruff, poetry, pytest via pipx ----------
info "== 6. Python tooling =="
python3 --version >/dev/null 2>&1 && ok "python3 $(python3 --version | awk '{print $2}')" || err "python3 falta"

for tool in ruff pytest poetry; do
  if have "$tool"; then
    ok "$tool $($tool --version 2>&1 | head -1 | awk '{print $NF}' | tr -d '()')"
  else
    $CHECK_ONLY && warn "$tool falta" || { pipx install "$tool" && ok "$tool"; }
  fi
done

if have pyright; then
  ok "pyright $(pyright --version 2>&1 | tail -1)"
else
  $CHECK_ONLY && warn "pyright falta" || {
    # pyright[nodejs] bundlea node estático, evita fallo si no hay node en PATH
    pipx install 'pyright[nodejs]' && ok "pyright con nodejs bundleado"
  }
fi

# ---------- 7. Nix (nix-portable, sin root ni /nix ni systemd) ----------
info "== 7. Nix =="
if have nix-instantiate; then
  ok "nix nativo ($(nix-instantiate --version))"
elif have nix-portable; then
  ok "nix-portable"
else
  $CHECK_ONLY && warn "nix falta" || {
    curl -sSL -o "$HOME/.local/bin/nix-portable" \
      https://github.com/DavHau/nix-portable/releases/latest/download/nix-portable-x86_64
    chmod +x "$HOME/.local/bin/nix-portable"
    ok "nix-portable descargado a ~/.local/bin/"
  }
fi

# ---------- 8. gh CLI ----------
info "== 8. gh CLI =="
if have gh; then
  ok "gh $(gh --version | head -1 | awk '{print $3}')"
else
  $CHECK_ONLY && warn "gh falta" || {
    V=$(curl -sSL https://api.github.com/repos/cli/cli/releases/latest | grep '"tag_name"' | cut -d '"' -f4)
    VC=${V#v}
    curl -sSL "https://github.com/cli/cli/releases/download/${V}/gh_${VC}_linux_amd64.tar.gz" -o /tmp/gh.tgz
    tar -xzf /tmp/gh.tgz -C /tmp
    cp "/tmp/gh_${VC}_linux_amd64/bin/gh" "$HOME/.local/bin/gh"
    chmod +x "$HOME/.local/bin/gh"
    rm -rf "/tmp/gh_${VC}_linux_amd64" /tmp/gh.tgz
    ok "gh $VC en ~/.local/bin/"
    warn "recuerda: gh auth login  (para push/clone privados)"
  }
fi

# ---------- 9. hyperfine (opcional, para --benchmark) ----------
info "== 9. hyperfine =="
if have hyperfine; then
  ok "hyperfine $(hyperfine --version | awk '{print $2}')"
else
  $CHECK_ONLY && warn "hyperfine falta (opcional, solo para --benchmark)" || {
    if have cargo; then
      cargo install hyperfine
      ok "hyperfine instalado via cargo"
    else
      warn "cargo no disponible aún — reejecuta el bootstrap"
    fi
  }
fi

# ---------- resumen ----------
echo
info "== resumen =="
if $CHECK_ONLY; then
  echo "Corre sin --check para instalar lo que falte."
else
  cat <<'EOF'

✓ Bootstrap completo. Añade a ~/.bashrc si no está ya:

    export PATH="$HOME/.local/bin:$PATH"
    [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
    [ -s "$HOME/.nvm/nvm.sh" ] && . "$HOME/.nvm/nvm.sh"
    [ -d "$HOME/.ghcup/bin" ] && export PATH="$HOME/.ghcup/bin:$PATH"

Verifica todo con:
    ./bootstrap.sh --check
    ./compile --example fibonacci --all

Para push a GitHub (una sola vez):
    gh auth login
EOF
fi
