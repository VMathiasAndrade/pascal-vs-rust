# Comparação histórica — obrigatória

Selecionar **pelo menos três diferenças significativas**. Não presumir “antiga = ruim” / “moderna = boa”. Valorizar também simplicidade, controle e previsibilidade de Pascal quando aplicáveis.

## 1. Memória e segurança (Integrante 2)
- Mecanismo em Pascal e Rust: [preencher]
- Decisão histórica de projeto: [preencher]
- Benefícios e custos das duas estratégias: [preencher]
- Evidências de experimentos e referências: [preencher]

## 2. Tipagem, legibilidade e mutabilidade (Integrante 1)
- Mecanismo e decisão: [preencher]
- Benefícios, custos e trade-off: [preencher]
- Evidências e referências: [preencher]

## 3. Abstração, TADs e modularização (Integrante 4)
- **Mecanismo e decisão:**
  - *Pascal clássico (ISO 7185, 1970/1990):* não possui sistema nativo de módulos, compilação separada nem modificadores de visibilidade (`public`/`private`). A ocultação de estado é obtida apenas por escopo léxico em subprogramas aninhados (`procedure`/`function` dentro de outro procedimento), decisão coerente com uma linguagem enxuta, didática e compilável em uma única passada. Implementações posteriores como UCSD/Turbo Pascal e Free Pascal adicionaram `unit` (`interface`/`implementation`) e compilação separada (`.ppu`/`.o`), além de extensões OO (`object`/`class`).
  - *Rust (Edição 2024, `rustc 1.99.1`):* adota `struct`/`enum` + `impl`, privacidade por padrão por módulo, reexportação explícita (`pub use`) e compilação separada no nível de *crates* (`.rlib`), refletindo a necessidade moderna de construir bibliotecas reutilizáveis com invariantes verificados estaticamente e zero custo em execução.
- **Benefícios, custos e trade-off:**
  - *Onde a solução histórica ainda brilha:* para programas pequenos e ensino de programação estruturada, o modelo de Pascal em arquivo único e escopo léxico é simples, previsível e dispensa gerenciamento de crates, flags `--extern` ou regras de visibilidade.
  - *Trade-off:* simplicidade conceitual e compilação direta (Pascal ISO 7185) × encapsulamento por campo, TADs com múltiplas instâncias, proteção estática de invariantes e modularidade escalável ao custo de maior complexidade inicial (Rust).
- **Evidências e referências:**
  - [`pascal/04-abstracao-e-modularizacao/contador.pas`](../pascal/04-abstracao-e-modularizacao/contador.pas), [`erros/erro_escopo.pas`](../pascal/04-abstracao-e-modularizacao/erros/erro_escopo.pas) (`Error: Identifier not found "valor"` verificado em `fpc 3.2.2 -Miso`) e [`u_contador.pas`](../pascal/04-abstracao-e-modularizacao/u_contador.pas).
  - [`rust/04-abstracao-e-modularizacao/lib.rs`](../rust/04-abstracao-e-modularizacao/lib.rs), [`contador.rs`](../rust/04-abstracao-e-modularizacao/contador.rs), [`main.rs`](../rust/04-abstracao-e-modularizacao/main.rs) e [`erros/erro_privacidade.rs`](../rust/04-abstracao-e-modularizacao/erros/erro_privacidade.rs) (`error[E0616]` verificado em `rustc 1.99.1`).
  - Detalhamento completo e referências em [`docs/04-abstracao-e-modularizacao.md`](04-abstracao-e-modularizacao.md).
