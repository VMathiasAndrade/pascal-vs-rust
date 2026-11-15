# 02 — Ponteiros, variáveis/constantes e gerenciamento de memória (tópicos 11–13)

**Responsável:**  Rafaella Ferreira Pinherio Silva
**Código:** [`pascal/02-memoria-e-seguranca/`](../pascal/02-memoria-e-seguranca/) · [`rust/02-memoria-e-seguranca/`](../rust/02-memoria-e-seguranca/)
**Saídas dos experimentos:** [`comparacoes/experimentos/02-memoria-e-seguranca/`](../comparacoes/experimentos/02-memoria-e-seguranca/)

## Ambiente utilizado

| Item | Versão |
|---|---|
| Pascal (implementação) | Free Pascal Compiler (`fpc`) 3.2.2, modo padrão FPC |
| Rust | `rustc` 1.75.0 (sem dependências externas, sem Cargo) |
| Sistema | Ubuntu 24.04 |

> **Observação importante:** a linguagem Pascal (Wirth, 1970; padronizada na ISO 7185) é diferente do Free Pascal. Recursos como o operador `@`, aritmética de ponteiros (`{$POINTERMATH}`) e a unit `heaptrc` pertencem à **implementação** Free Pascal, não ao Pascal original. Quando algo for específico do FPC, isso é indicado no texto.

## Como executar

Na raiz do repositório:

```bash
bash scripts/rodar_02_memoria.sh
```

Ou manualmente:

```bash
# Pascal
cd pascal/02-memoria-e-seguranca
fpc lista_dinamica.pas && ./lista_dinamica
fpc variaveis_constantes.pas && ./variaveis_constantes
fpc ponteiro_pendente.pas && ./ponteiro_pendente     # termina com Runtime error 204 (esperado)
fpc -gh vazamento.pas && ./vazamento                 # heaptrc acusa 1 bloco não liberado

# Rust
cd ../../rust/02-memoria-e-seguranca
rustc lista_dinamica.rs && ./lista_dinamica
rustc variaveis_constantes.rs && ./variaveis_constantes
rustc erros/erro_move.rs      # ERRO DE COMPILAÇÃO ESPERADO (E0382)
rustc erros/erro_borrow.rs    # ERRO DE COMPILAÇÃO ESPERADO (E0502)
```

> Os arquivos em `rust/02-memoria-e-seguranca/erros/` são **intencionalmente inválidos**. Falhar na compilação é o resultado correto; não são testes aprovados.

---

## Tópico 11 — Ponteiros e referências

### Como Pascal trata
- Ponteiros são **tipados**: `type PNo = ^TNo;`. Acesso por desreferência `p^`; valor especial `nil`.
- `New(p)` aloca no heap e `Dispose(p)` libera. Não existe coleta de lixo.
- O Pascal padrão não tem operador de endereço nem aritmética de ponteiros (Wirth restringiu ponteiros a dados dinâmicos). O Free Pascal acrescenta `@` e aritmética opcional.
- **Nada impede**: ponteiro pendente (usar/liberar memória já liberada), *aliasing* livre, vazamento, desreferenciar `nil`.

### Como Rust trata
- **Referências** `&T` (compartilhada, somente leitura) e `&mut T` (exclusiva, leitura/escrita), sempre válidas, verificadas pelo *borrow checker*.
- **Ponteiros inteligentes**: `Box<T>` (dono único no heap), `Rc<T>`/`Arc<T>` (contagem de referências).
- **Não há `null` em Rust seguro**: a ausência é representada por `Option<T>`, e o compilador obriga a tratar o caso `None`.
- Ponteiros crus (`*const T`, `*mut T`) existem, mas só podem ser desreferenciados dentro de `unsafe`.

### Diferenças e decisão de projeto
| Aspecto | Pascal | Rust |
|---|---|---|
| Valor "nulo" | `nil` (pode ser desreferenciado por engano) | `Option<T>` (obriga tratamento) |
| Aliasing | Livre | Restrito: ou N leitores, ou 1 escritor |
| Validade do ponteiro | Responsabilidade do programador | Garantida em compilação (lifetimes) |
| Modo "sem proteção" | Padrão | Explícito com `unsafe` |

**Decisão de projeto:** Pascal (anos 1970) buscava ser uma linguagem didática e estruturada, restringindo ponteiros a tipos dinâmicos, mas sem verificar seu uso. Rust (anos 2010) foi projetada para programação de sistemas com **segurança de memória sem coletor de lixo**, então empurra a verificação para o compilador.

### Consequências
- **Confiabilidade:** em Pascal, erros de ponteiro aparecem em execução (ou nem aparecem). Em Rust, classes inteiras de erros (use-after-free, dupla liberação, ponteiro nulo) são rejeitadas em compilação em código seguro.
- **Legibilidade/redigibilidade:** `p^.valor` em Pascal é simples e direto; em Rust, `Option<Box<No>>` e anotações de empréstimo são mais verbosas e exigem mais tempo de aprendizado.
- **Facilidade de aprendizado:** o modelo de ponteiros de Pascal é mais fácil de aprender; o de Rust é mais difícil, mas ensina regras que evitam erros depois.
- **Trade-off:** flexibilidade e simplicidade conceitual (Pascal) × garantias estáticas ao custo de restrições de uso e curva de aprendizado (Rust).

### Evidência experimental
- `ponteiro_pendente.pas`: após `Dispose(p)`, `p <> nil` continua `TRUE`; a segunda liberação via `q` faz o programa terminar com `Runtime error 204` (saída: `comparacoes/experimentos/02-memoria-e-seguranca/pascal_ponteiro_pendente.txt`). O compilador aceita o código sem aviso.
- `erro_borrow.rs`: o compilador rejeita com **E0502**, pois `v.push(4)` poderia realocar o vetor e invalidar a referência `primeiro` (saída em `rust_erro_borrow_erro_compilador.txt`).

---

## Tópico 12 — Variáveis e constantes

### Como Pascal trata
- Variáveis declaradas em bloco `var` **antes** do `begin`; tipo sempre explícito.
- Todas as variáveis são mutáveis. Constantes em bloco `const` (`const MAX = 5;`), com valor definido em compilação; atribuir a uma constante é erro de compilação.
- *Constantes tipadas* no Free Pascal podem ser modificáveis dependendo do modo/diretiva (`{$J}`/`{$WRITEABLECONST}`), comportamento específico da implementação.
- Tempo de vida: globais existem durante todo o programa; locais existem durante a chamada (pilha); dinâmicas existem de `New` até `Dispose`.

### Como Rust trata
- `let x = 5;` é **imutável por padrão**; `let mut x` habilita alteração.
- `const MAX: i32 = 5;` exige tipo explícito, é avaliada em compilação e sempre imutável.
- **Inferência de tipos** (`let raio = 2.0;` → `f64`) e *shadowing* (`let x = x * 2;` cria uma nova variável).
- Tempo de vida determinado pelo escopo; ao sair dele, o valor é destruído (`Drop`).

### Diferenças e decisão de projeto
- Pascal: declaração explícita separada do código, mutabilidade como padrão (modelo imperativo clássico).
- Rust: **imutabilidade por padrão**, herdada de influências funcionais, reduz efeitos colaterais acidentais e facilita raciocínio sobre concorrência.

### Consequências
- **Legibilidade:** o bloco `var` de Pascal dá uma visão geral das variáveis do subprograma; Rust declara perto do uso e marca explicitamente o que muda (`mut`).
- **Confiabilidade:** em Rust, a imutabilidade padrão evita alterações acidentais; em Pascal isso depende da disciplina do programador.
- **Redigibilidade:** inferência de tipos deixa Rust mais conciso.
- **Trade-off:** explicitude uniforme e simplicidade (Pascal) × concisão e segurança por padrão ao custo de conceitos extras como `mut` e *shadowing* (Rust).

---

## Tópico 13 — Gerenciamento de memória

### Como Pascal trata
- **Pilha:** variáveis locais e parâmetros. **Dados estáticos:** variáveis globais. **Heap:** `New`/`Dispose` (ou `GetMem`/`FreeMem` no FPC).
- **Gerenciamento manual:** o programador decide quando alocar e liberar. Sem GC, sem ownership.
- O FPC oferece ferramenta de diagnóstico em execução: a unit `heaptrc` (opção `-gh`).

### Como Rust trata
- **Pilha** para valores de tamanho conhecido; **heap** via `Box`, `Vec`, `String`, `Rc`, etc.
- **Ownership:** cada valor tem exatamente um dono; ao sair de escopo o valor é liberado automaticamente (RAII/`Drop`), sem GC e sem `free` manual.
- **Move:** atribuir ou passar um valor não-`Copy` transfere o ownership; o original deixa de ser utilizável.
- **Borrowing:** empréstimo por `&`/`&mut`, com regras verificadas em compilação.

### Quem é responsável por quê

| Responsabilidade | Pascal | Rust |
|---|---|---|
| Decidir quando liberar | Programador | Compilador (via escopo/ownership) |
| Garantir ausência de use-after-free | Programador | Compilador (código seguro) |
| Detectar vazamentos | Ferramenta em execução (`heaptrc`) | Em geral evitados pelo escopo; ainda possíveis (ex.: ciclos de `Rc`, `mem::forget`) |
| Custo em execução | Nenhum extra (sem GC) | Nenhum extra (sem GC) |

### Diferenças e decisão de projeto
Ambas **evitam coleta de lixo**, o que dá desempenho previsível e controle sobre o hardware. A diferença é *quem* garante a correção: em Pascal, o programador; em Rust, o compilador, ao custo de regras de ownership/borrowing que o programador precisa aprender e respeitar.

### Consequências e trade-offs
- **Segurança:** Rust impede em compilação os erros ilustrados em `erro_move.rs` (E0382, uso após move) e `erro_borrow.rs` (E0502). Pascal aceita código equivalente e só detecta problemas em execução.
- **Previsibilidade/eficiência:** ambas liberam em pontos determinísticos, sem pausas de GC.
- **Complexidade de programação:** Pascal tem regra simples ("quem aloca, libera") mas propensa a erro; Rust tem regras mais complexas, porém verificadas. Algumas estruturas (listas duplamente encadeadas, grafos) são mais difíceis de escrever em Rust seguro.
- **Quando a solução histórica ainda é interessante:** para programas pequenos, ensino do modelo de máquina (pilha/heap) e controle direto da alocação, o modelo simples de Pascal é transparente e fácil de entender.

### Evidência experimental
- `lista_dinamica.pas` e `lista_dinamica.rs` produzem a mesma saída (`50 40 30 20 10` / `Soma = 150`). No Pascal, o laço final com `Dispose` é obrigatório; no Rust, a liberação é inserida pelo compilador.
- `vazamento.pas` compilado com `-gh`: o programa roda normalmente e o `heaptrc` reporta `1 unfreed memory blocks` ao final (`pascal_vazamento_heaptrc.txt`). Sem `-gh`, nada é reportado.
- `erro_move.rs`: o compilador rejeita o uso de `v` após ser movido para `consome(v)` (E0382, com sugestão de emprestar ou clonar).

---

## Referências 

1. Klabnik, S.; Nichols, C. *The Rust Programming Language* — caps. 4 (Ownership), 8, 15 (Smart Pointers). <https://doc.rust-lang.org/book/>
2. *The Rust Reference* — seções sobre referências, ponteiros crus e `unsafe`. <https://doc.rust-lang.org/reference/>
3. *Rust Compiler Error Index* — E0382 e E0502. <https://doc.rust-lang.org/error_codes/>
4. *Free Pascal Reference Guide* — seções "Pointers", "Constants", "Variables". <https://www.freepascal.org/docs.html>
5. *Free Pascal User's Guide* — opção `-gh` e unit `heaptrc`. <https://www.freepascal.org/docs.html>
6. ISO/IEC 7185:1990 — *Programming languages — Pascal*.