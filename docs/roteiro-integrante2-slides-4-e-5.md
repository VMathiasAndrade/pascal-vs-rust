# Roteiro — Integrante 2 (slides 4 e 5) — 3min45s

## Slide 4 — Ponteiros, memória e ownership (2:15)
**Conteúdo do slide:** duas colunas lado a lado.
- Pascal: `New(p)` ... `Dispose(p)` — quem aloca, libera. Ponteiro pode ser `nil` ou pendente.
- Rust: `Box<No>`, `Option`, ownership e borrowing — o compilador decide a liberação.
- Rodapé: "Nenhuma das duas usa coletor de lixo."

**Fala sugerida:**
1. As duas linguagens evitam garbage collector, então não há pausas e o controle é determinístico. A pergunta é: quem garante que a memória é usada corretamente?
2. Em Pascal, o programador: `New` aloca, `Dispose` libera. A lista encadeada que testamos funciona, mas se esquecermos o `Dispose` ou liberarmos duas vezes, o compilador aceita.
3. Em Rust, cada valor tem um dono; ao sair de escopo é liberado automaticamente. Referências são emprestadas com regras: ou vários leitores, ou um escritor.
4. Decisão de projeto: Pascal (1970) foi pensada para ensino e simplicidade; Rust (2010s) para sistemas com segurança de memória.
5. Trade-off: simplicidade e liberdade × garantias estáticas e curva de aprendizado.

## Slide 5 — Experimento de segurança (1:30)
**Conteúdo do slide:** três pequenos blocos.
- Pascal `ponteiro_pendente.pas`: compila sem aviso; execução termina com `Runtime error 204`.
- Pascal `vazamento.pas` com `-gh`: `1 unfreed memory blocks`.
- Rust `erro_borrow.rs`: `error[E0502]: cannot borrow v as mutable because it is also borrowed as immutable`.

**Fala sugerida:**
1. Em Pascal, o erro de ponteiro aparece (se aparecer) só na execução; o vazamento só é visto com `heaptrc`.
2. Em Rust, o mesmo tipo de erro é barrado em compilação. Mostrar a mensagem e explicar: `push` pode realocar o vetor e invalidar a referência `primeiro`.
3. Custo: algumas estruturas (grafos, listas duplamente encadeadas) ficam mais difíceis em Rust seguro; compilar exige entender as regras.
4. Fechar: o modelo de Pascal ainda é bom para entender pilha/heap e programas pequenos; Rust é melhor quando erro de memória é custoso.

## Perguntas prováveis
- Rust não tem vazamento? Pode ter (ciclos de `Rc`, `mem::forget`); não é considerado "memory unsafe".
- O que é `unsafe`? Bloco onde o programador assume garantias que o compilador não verifica.
- Pascal tem ponteiros nulos? Sim, `nil`; desreferenciar causa erro em execução.
- Por que `Box` e não só `&`? `Box` é dono do dado no heap; `&` apenas empresta.
