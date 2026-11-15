#!/usr/bin/env bash
# Compila e executa todos os exemplos do topico 02 (memoria) e grava as saidas.
# Uso (na raiz do repositorio): bash scripts/rodar_02_memoria.sh
# Requer: Free Pascal (fpc) e Rust (rustc)
set -u
RAIZ="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$RAIZ/comparacoes/experimentos/02-memoria-e-seguranca"
mkdir -p "$OUT"
{ echo "fpc: $(fpc -iV)"; rustc --version; } > "$OUT/versoes.txt"

cd "$RAIZ/pascal/02-memoria-e-seguranca" || exit 1
for f in lista_dinamica variaveis_constantes ponteiro_pendente; do
  fpc "$f.pas" > /dev/null 2>&1; ./"$f" > "$OUT/pascal_$f.txt" 2>&1; echo "exit=$?" >> "$OUT/pascal_$f.txt"
done
fpc -gh vazamento.pas > /dev/null 2>&1; ./vazamento > "$OUT/pascal_vazamento_heaptrc.txt" 2>&1

cd "$RAIZ/rust/02-memoria-e-seguranca" || exit 1
for f in lista_dinamica variaveis_constantes; do
  rustc "$f.rs" 2>&1 && ./"$f" > "$OUT/rust_$f.txt" 2>&1
done
cd erros || exit 1
for f in erro_move erro_borrow; do
  rustc "$f.rs" > "$OUT/rust_${f}_erro_compilador.txt" 2>&1   # falha ESPERADA
done

# limpa binarios e objetos gerados
cd "$RAIZ"
find pascal/02-memoria-e-seguranca rust/02-memoria-e-seguranca -type f ! -name "*.pas" ! -name "*.rs" ! -name "*.md" -delete
echo "Saidas gravadas em $OUT"
