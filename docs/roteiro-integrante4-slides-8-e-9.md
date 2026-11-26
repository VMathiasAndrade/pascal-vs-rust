# Roteiro — Integrante 4 (slides 8 e 9) — 3min45s

## Slide 8 — TADs e encapsulamento (2:00)
**Conteúdo do slide:** comparação lado a lado do TAD Contador (`[0, 10]`).
- **Pascal clássico (ISO 7185):** `valor` preso como variável local de `ExecutarContador` + procedimentos aninhados (`Incrementar`, `Decrementar`, `Consultar`). Tentar `valor := -10` no `begin ... end.` principal falha por escopo léxico (`Identifier not found "valor"`).
- **Rust (Edição 2024):** `pub struct Contador { valor: i32 }` + `impl Contador` com métodos públicos. Tentar `c.valor = -10` falha com `error[E0616]: field valor of struct Contador is private`.
- **Rodapé:** "Mesmo comportamento em execução; mecanismos de proteção completamente diferentes."

**Fala sugerida:**
1. O objetivo dos dois códigos é o mesmo: manter um contador entre `0` e `10` sem que o código cliente burle esse invariante.
2. No Pascal clássico (ISO 7185), não existem `public`, `private` nem módulos. A única forma de esconder `valor` é prendê-lo no escopo léxico de um procedimento envolvente (`ExecutarContador`). Isso protege o invariante, mas impede criar várias instâncias independentes de um tipo `Contador` reutilizável.
3. Em Rust, `struct` e `impl` unem dados e operações em um TAD completo, com **privacidade por padrão**: `Contador` é público, mas seu campo `valor` é privado. Posso ter quantos contadores eu quiser, e nenhum código externo consegue alterar `c.valor` diretamente (`E0616`).
4. Trade-off: Pascal prioriza simplicidade sintática e didática; Rust prioriza encapsulamento forte e reutilização em sistemas grandes, ao custo de mais conceitos (`pub`, `&self`, `&mut self`).

## Slide 9 — Modularização e compilação separada (1:45)
**Conteúdo do slide:** diagrama de arquivos e compilação separada.
- **Pascal ISO 7185:** programa monolítico único (`program Contador`), sem compilação separada.
- **Dialetos modernos (Free Pascal):** `unit u_contador` (`interface` / `implementation`) → gera `.ppu` + `.o` consumidos por `uses u_contador;`.
- **Rust:** árvore `lib.rs` (`mod contador; pub use contador::Contador;`) → `libcontador_lib.rlib` consumida por `main.rs` via `--extern`.

**Fala sugerida:**
1. É importante não confundir o Pascal clássico com seus dialetos modernos: a norma ISO 7185 não tem módulos nem compilação separada, pois Wirth projetou um compilador simples de passagem única para ensino.
2. Só mais tarde, em UCSD Pascal, Turbo Pascal e no Free Pascal, surgiu o conceito de `unit` com `interface` e `implementation`, compilando cada unit em `.ppu` e `.o`. Mesmo assim, campos de um `record` comum na `interface` continuam públicos sem extensões de orientação a objetos.
3. Em Rust, módulos (`mod`) organizam o código internamente e `pub use` define exatamente o que compõe a API pública; a compilação separada acontece no nível de **crate** (`.rlib`), permitindo checagem de tipos e otimizações em toda a biblioteca antes de ligá-la ao executável.

## Perguntas prováveis
- *Pascal não tem `private`?* O Pascal ISO 7185 não tem. `private`/`public` existem em extensões orientadas a objetos posteriores (Object Pascal / Free Pascal com `class` ou `object`).
- *Em Rust, cada arquivo `.rs` é compilado separadamente?* Não. Módulos dentro de um mesmo crate são compilados juntos; a compilação separada em `.rlib` ocorre entre crates distintos.
- *Qual a vantagem de `pub use` no `lib.rs`?* Permite reorganizar módulos internos (`contador.rs`) sem quebrar o caminho público (`contador_lib::Contador`) usado pelos clientes.
