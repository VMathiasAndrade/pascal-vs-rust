#!/usr/bin/env bash
# Compila e executa todos os exemplos do bloco 04 (abstracao, encapsulamento e modulos) e grava as saidas.
# Uso (na raiz de pascal-vs-rust): bash scripts/rodar_04_abstracao.sh
# Requer: Free Pascal (fpc 3.2.2) e Rust (rustc com suporte a edition 2024, ex: +1.99.1)
set -u
RAIZ="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$RAIZ/comparacoes/experimentos/04-abstracao-e-modularizacao"

if [ -f "$HOME/.cargo/env" ]; then
  # shellcheck source=/dev/null
  source "$HOME/.cargo/env"
fi

if ! command -v fpc >/dev/null 2>&1; then
  echo "Erro: compilador 'fpc' nao encontrado. Instale com: sudo apt install -y fp-compiler-3.2.2" >&2
  exit 1
fi

if ! command -v rustc >/dev/null 2>&1; then
  echo "Erro: compilador 'rustc' nao encontrado no PATH." >&2
  exit 1
fi

mkdir -p "$OUT"

if command -v rustup >/dev/null 2>&1 && rustup toolchain list | grep -q '^1\.99\.1'; then
  RUSTC=(rustc +1.99.1)
else
  RUSTC=(rustc)
fi

{
  echo "fpc: $(fpc -iV)"
  "${RUSTC[@]}" --version
} > "$OUT/versoes.txt"

# Pascal (ISO 7185 via fpc -Miso)
cd "$RAIZ/pascal/04-abstracao-e-modularizacao" || exit 1
fpc -Miso contador.pas > "$OUT/pascal_contador_compilacao.txt" 2>&1
./contador > "$OUT/pascal_contador.txt" 2>&1
echo "exit=$?" >> "$OUT/pascal_contador.txt"

# Pascal (extensao unit do Free Pascal: compilacao separada)
fpc u_contador.pas > "$OUT/pascal_unit_compilacao.txt" 2>&1
fpc programa_unit.pas > "$OUT/pascal_programa_unit_compilacao.txt" 2>&1
./programa_unit > "$OUT/pascal_programa_unit.txt" 2>&1
echo "exit=$?" >> "$OUT/pascal_programa_unit.txt"

# Pascal: erro de encapsulamento por escopo lexico (falha ESPERADA)
fpc -Miso erros/erro_escopo.pas > "$OUT/pascal_erro_escopo_compilador.txt" 2>&1
echo "exit=$?" >> "$OUT/pascal_erro_escopo_compilador.txt"

# Rust (edicao 2024: biblioteca separada + binario)
cd "$RAIZ/rust/04-abstracao-e-modularizacao" || exit 1
"${RUSTC[@]}" --edition=2024 --crate-name contador_lib --crate-type=rlib lib.rs > "$OUT/rust_lib_compilacao.txt" 2>&1
"${RUSTC[@]}" --edition=2024 main.rs --extern contador_lib=libcontador_lib.rlib -o main > "$OUT/rust_main_compilacao.txt" 2>&1
./main > "$OUT/rust_main.txt" 2>&1
echo "exit=$?" >> "$OUT/rust_main.txt"

# Rust: erro de encapsulamento por visibilidade privada (falha ESPERADA)
"${RUSTC[@]}" --edition=2024 erros/erro_privacidade.rs --extern contador_lib=libcontador_lib.rlib -o erro_privacidade > "$OUT/rust_erro_privacidade_compilador.txt" 2>&1
echo "exit=$?" >> "$OUT/rust_erro_privacidade_compilador.txt"

# Limpa binarios e artefatos de compilacao gerados
cd "$RAIZ"
find pascal/04-abstracao-e-modularizacao rust/04-abstracao-e-modularizacao -type f \
  ! -name "*.pas" ! -name "*.rs" ! -name "*.md" -delete

echo "Saidas gravadas em $OUT"
