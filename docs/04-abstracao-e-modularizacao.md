# Bloco 4 — Abstração, encapsulamento e módulos (tópicos 21–25)

**Responsável:** Integrante 4 — Tariky Campos  
**Slides:** 8–9 · **Tempo previsto:** 3min45s  
**Código-fonte:** [`pascal/04-abstracao-e-modularizacao/`](../pascal/04-abstracao-e-modularizacao/) · [`rust/04-abstracao-e-modularizacao/`](../rust/04-abstracao-e-modularizacao/)  
**Exemplo equivalente lado a lado:** [`comparacoes/exemplos-equivalentes/04-abstracao-encapsulamento.md`](../comparacoes/exemplos-equivalentes/04-abstracao-encapsulamento.md)  
**Saídas dos experimentos:** [`comparacoes/experimentos/04-abstracao-e-modularizacao/`](../comparacoes/experimentos/04-abstracao-e-modularizacao/)

---

## Ambiente de desenvolvimento

| Item | Versão / Especificação | Status na máquina |
|---|---|---|
| Sistema operacional | Ubuntu 24.04.2 LTS (`noble`) | Verificado |
| Pascal (norma de referência) | Pascal clássico — ISO/IEC 7185:1990 | Referência teórica |
| Pascal (compilador) | Free Pascal Compiler (`fpc`) 3.2.2 (`3.2.2+dfsg-32`, modos `-Miso` e padrão FPC) | Instalado e testado |
| Rust | `rustc 1.99.1 (58cf8f9c3 2026-10-13)`, edição 2024 (via `rustup 1.29.3`) | Instalado e testado |

> **Nota metodológica:** A norma ISO 7185 (Pascal clássico) não possui `unit`, cláusula `uses`, `class` nem modificadores `private`/`public`. Recursos modulares como `unit` (`interface`/`implementation`) pertencem a extensões históricas de dialetos posteriores (UCSD Pascal, Turbo Pascal) e a implementações modernas como o Free Pascal 3.2.2. Ao longo deste documento, cada mecanismo é explicitamente atribuído ao Pascal clássico (ISO 7185) ou ao Free Pascal.

---

## 21. Abstração

**Exigência da especificação:** Abstração de processos e abstração de dados.

### Pascal (ISO 7185 e Free Pascal 3.2.2)
- **Abstração de processos:** realizada por `procedure` (executa uma sequência de comandos sem valor de retorno) e `function` (calcula e retorna um valor associado ao nome da função). O Pascal clássico permite **aninhamento de subprogramas** (`Incrementar`, `Decrementar` e `Consultar` declarados dentro de `ExecutarContador` em [`contador.pas`](../pascal/04-abstracao-e-modularizacao/contador.pas)), permitindo decompor um algoritmo em operações auxiliares com acesso às variáveis do bloco envolvente.
- **Abstração de dados:** no Pascal ISO 7185, é feita pela declaração `type` (subfaixas como `0..10`, enumerados, `array`, `set` e `record`). Contudo, o tipo `record` apenas agrupa dados (produto cartesiano) sem associar métodos nem ocultar seus campos. Para abstrair um estado mutável como o do contador, recorre-se a uma variável local presa ao escopo de um procedimento envolvente.

### Rust (edição 2024, `rustc 1.99.1`)
- **Abstração de processos:** feita por funções (`fn`), closures e funções associadas/métodos definidos em blocos `impl`.
- **Abstração de dados:** feita por `struct` e `enum` combinados a blocos `impl`, nos quais dados e operações (`new`, `incrementar`, `decrementar`, `consultar`) compõem uma unidade semântica coesa. Em [`contador.rs`](../rust/04-abstracao-e-modularizacao/contador.rs), o consumidor interage apenas com os métodos públicos do tipo `Contador`, sem depender de como o estado é armazenado internamente (`i32` ou outra representação).

### Comparação e trade-offs
- **Decisão de projeto e diferença:** Pascal clássico separa rigorosamente dados (`type`/`var`) de operações (`procedure`/`function`) e usa aninhamento léxico para estruturar sub-rotinas; Rust acopla representação e comportamento em `struct` + `impl` (influência de TADs e orientação a objetos sem herança clássica).
- **Mecanismo → vantagem → desvantagem → trade-off:**
  - *Pascal:* o aninhamento de procedimentos oferece simplicidade conceitual e ótima clareza didática para algoritmos autocontidos, mas não permite reutilizar o estado abstraído como um tipo independente de múltiplas instâncias.
  - *Rust:* `struct` + `impl` promove alta **reusabilidade** e **modificabilidade** (pode-se mudar a representação interna sem quebrar chamadores), ao custo de maior carga sintática e conceitual inicial (`self`, `&self`, `&mut self`).

---

## 22. Tipos Abstratos de Dados (TADs)

**Exigência da especificação:** Formas de implementação de Tipos Abstratos de Dados e proteção de invariantes.

### Pascal (ISO 7185 e Free Pascal 3.2.2)
- **Suporte no Pascal clássico (ISO 7185):** a linguagem **não possui TADs completos** no sentido moderno (tipo exportável com representação opaca e operações acopladas). Em [`contador.pas`](../pascal/04-abstracao-e-modularizacao/contador.pas), o invariante `0 <= valor <= 10` é mantido por `ExecutarContador`: `valor` nasce em `0`, `Incrementar` testa `if valor < 10` e `Decrementar` testa `if valor > 0`.
- **Limitação estrutural:** esse padrão cria apenas **uma instância ligada à execução de `ExecutarContador`**. Se o programador definisse `type TContador = record valor: integer; end;` para ter várias instâncias, qualquer código que declarasse uma variável `TContador` poderia escrever `c.valor := -10` diretamente, violando o invariante.
- **Em dialetos modernos (Free Pascal):** com `unit` ([`u_contador.pas`](../pascal/04-abstracao-e-modularizacao/u_contador.pas)), ainda há estado único na seção `implementation`; para TADs com múltiplas instâncias e proteção de invariantes, recorre-se a extensões orientadas a objetos (`object`/`class` com `private`, ou `{$MODESWITCH ADVANCEDRECORDS}`), recursos que não pertencem ao Pascal ISO 7185.

### Rust (edição 2024, `rustc 1.99.1`)
- **Implementação idiomática:** um TAD é construído com `pub struct` (campos privados por padrão) e `impl` público ([`contador.rs`](../rust/04-abstracao-e-modularizacao/contador.rs)).
- **Proteção de invariantes:**
  1. `Contador::new()` é o único ponto de criação externo, inicializando `valor: 0`.
  2. `incrementar(&mut self)` e `decrementar(&mut self)` preservam `0 <= self.valor <= 10`.
  3. Como `valor` é privado, código externo não consegue construir `Contador { valor: -10 }` nem alterar `c.valor` diretamente.
  4. Diferentemente do truque de escopo em Pascal, é possível criar quantas instâncias independentes de `Contador` forem necessárias e passá-las como valores entre funções.

### Comparação e trade-offs
- **Decisão de projeto e diferença:** Pascal foi desenhado entre 1968–1970 antes da consolidação de TADs em linguagens comerciais (como CLU, Modula-2 e Ada); Rust incorpora décadas de evolução em TADs e sistemas de tipos para garantir invariantes estaticamente.
- **Consequências para propriedades:**
  - **Confiabilidade:** em Rust, a manutenção do invariante é garantida pelo compilador em toda fronteira de módulo; em Pascal ISO 7185, depende do isolamento por escopo de procedimento (única instância) ou da disciplina do programador caso use `record`.
  - **Reusabilidade:** Rust permite instanciar, compor e armazenar `Contador` em coleções; o padrão de escopo em Pascal não escala para múltiplas instâncias independentes.
  - **Facilidade de aprendizado:** o modelo de Pascal exige apenas entender blocos e procedimentos; o de Rust exige compreender módulos, visibilidade e regras de empréstimo (`&self` vs `&mut self`).

---

## 23. Encapsulamento

**Exigência da especificação:** Mecanismos para ocultação da representação e controle de visibilidade.

### Pascal (ISO 7185 e Free Pascal 3.2.2)
- **Pascal ISO 7185:** não possui palavras-chave como `public`, `private` ou `protected`. O único controle de visibilidade disponível é o **escopo léxico**: identificadores declarados dentro de `ExecutarContador` (como `valor`) são invisíveis fora desse procedimento.
- **Evidência observada ([`erros/erro_escopo.pas`](../pascal/04-abstracao-e-modularizacao/erros/erro_escopo.pas)):** ao tentar `valor := -10` no bloco principal do programa, o compilador `fpc -Miso` rejeitou por inexistência do identificador naquele escopo: `erro_escopo.pas(46,3) Error: Identifier not found "valor"` (registrado em [`pascal_erro_escopo_compilador.txt`](../comparacoes/experimentos/04-abstracao-e-modularizacao/pascal_erro_escopo_compilador.txt)).
- **Free Pascal (`unit`):** introduz fronteira de módulo entre `interface` (visível a quem usa `uses`) e `implementation` (oculta). Em [`u_contador.pas`](../pascal/04-abstracao-e-modularizacao/u_contador.pas), `var valor: Integer;` dentro de `implementation` fica oculta para [`programa_unit.pas`](../pascal/04-abstracao-e-modularizacao/programa_unit.pas).

### Rust (edição 2024, `rustc 1.99.1`)
- **Privacidade por padrão:** em Rust, todo item e todo campo de `struct` é privado ao módulo onde foi definido (e seus submódulos filhos). Expor algo exige marcação explícita com `pub` (ou restrições granulares como `pub(crate)`, `pub(super)`, `pub(in path)`).
- **Evidência observada ([`erros/erro_privacidade.rs`](../rust/04-abstracao-e-modularizacao/erros/erro_privacidade.rs)):** `Contador` é visível em `main.rs` via `use contador_lib::Contador;`, mas tentar `c.valor = -10;` foi rejeitado pelo `rustc 1.99.1` com `error[E0616]: field `valor` of struct `Contador` is private`.

### Comparação e trade-offs

| Aspecto | Pascal clássico (ISO 7185) | Free Pascal (`unit`) | Rust (Edição 2024) |
|---|---|---|---|
| Controle padrão | Tudo visível no mesmo escopo ou abaixo dele | Público na `interface`, oculto na `implementation` | **Privado por padrão** no módulo |
| Ocultação de campo em tipo | Não suportada em `record` | Não suportada em `record` puro (exige `class`/`object`) | Nativa por campo (`valor` sem `pub`) |
| Mecanismo do experimento de erro | Escopo léxico: `valor` não existe fora de `ExecutarContador` | Escopo de `implementation` | Controle de visibilidade: tipo visível, campo privado (`E0616`) |

- **Trade-off:** a regra "privado por padrão" de Rust reduz vazamentos acidentais de representação e melhora a **modificabilidade** e **confiabilidade** em projetos grandes, ao custo de exigir `pub` e organização explícita de módulos mesmo em programas pequenos; o escopo léxico de Pascal é extremamente simples, porém insuficiente para ocultar a representação de tipos reutilizáveis.

---

## 24. Modularização

**Exigência da especificação:** Módulos, pacotes, namespaces ou mecanismos equivalentes.

### Pascal (ISO 7185 e Free Pascal 3.2.2)
- **Pascal ISO 7185:** **não possui módulos, pacotes nem namespaces**. Todo código-fonte padrão forma um único `program Nome(...); ... end.`. Para Wirth, o foco era manter a linguagem enxuta para ensino e compilação rápida em máquinas da época.
- **Free Pascal (extensão `unit`):** adotou o modelo de `unit` popularizado pelo UCSD/Turbo Pascal. Uma unit possui cabeçalho `unit Nome;`, seção `interface` (declarações exportadas), seção `implementation` (detalhes e corpos privados) e é importada com `uses Nome;`. Como `uses` traz os identificadores públicos diretamente para o escopo do importador, colisões de nomes são possíveis (resolvidas qualificando `u_contador.Consultar`).

### Rust (edição 2024, `rustc 1.99.1`)
- **Árvore de módulos e crates:**
  - **Crate:** unidade raiz de biblioteca (`lib.rs`) ou executável (`main.rs`).
  - **Módulo (`mod`):** organiza o código em árvore hierárquica dentro do crate. Em [`lib.rs`](../rust/04-abstracao-e-modularizacao/lib.rs), `mod contador;` carrega [`contador.rs`](../rust/04-abstracao-e-modularizacao/contador.rs) mantendo-o privado internamente, enquanto `pub use contador::Contador;` reexporta somente o tipo `Contador` na API pública da biblioteca `contador_lib`.
  - **Namespaces e `use`:** em [`main.rs`](../rust/04-abstracao-e-modularizacao/main.rs), `use contador_lib::Contador;` importa explicitamente o símbolo a partir do namespace do crate externo, evitando poluição implícita de escopo.

### Comparação e trade-offs
- **Decisão de projeto:** a ausência de módulos no Pascal ISO 7185 refletia a limitação de projetos monolíticos didáticos dos anos 1970 (corrigida já pelo próprio Wirth em Modula e Modula-2, e no ecossistema Pascal via `unit`). Rust já nasce no século XXI com sistema hierárquico de crates e módulos para suportar bibliotecas de grande porte e ecossistema distribuído (`crates.io` / Cargo).
- **Consequências:**
  - **Ortogonalidade e legibilidade:** a separação entre organização interna (`mod contador;`) e API pública (`pub use contador::Contador;`) em Rust permite refatorar arquivos internos sem alterar o código dos clientes.
  - **Simplicidade:** um programa Pascal clássico inteiro cabe em um único arquivo sem configuração de árvore de módulos ou crates, sendo mais imediato para scripts e exercícios introdutórios.

---

## 25. Compilação separada

**Exigência da especificação:** Possibilidade e mecanismo para trabalhar com múltiplas unidades de código.

### Pascal (ISO 7185 e Free Pascal 3.2.2)
- **Pascal ISO 7185:** não especifica compilação separada; um programa padrão é compilado de forma monolítica (`fpc -Miso contador.pas`).
- **Free Pascal 3.2.2:** suporta compilação separada no nível de `unit`. Ao executar `fpc u_contador.pas`, o compilador gera o arquivo de interface binária `u_contador.ppu` e o objeto `u_contador.o`. Quando `fpc programa_unit.pas` é executado, o FPC verifica o `.ppu` (incluindo checksum da interface) e realiza a ligação sem precisar recompilar `u_contador.pas`, a menos que sua `interface` tenha mudado.

### Rust (edição 2024, `rustc 1.99.1`)
- **Unidade de compilação = Crate:** em Rust, arquivos individuais ligados por `mod` dentro de um mesmo crate **não** são compilados separadamente entre si; todos pertencem ao mesmo crate para viabilizar checagem global de tipos, traits, lifetimes e otimizações interprocedurais.
- **Compilação separada entre crates:** ocorre compilando um crate de biblioteca em um artefato `.rlib` (ou `.so`/`.dylib`) e passando-o com `--extern` ao crate consumidor:
  1. `rustc +1.99.1 --edition=2024 --crate-name contador_lib --crate-type=rlib lib.rs` → gera `libcontador_lib.rlib`.
  2. `rustc +1.99.1 --edition=2024 main.rs --extern contador_lib=libcontador_lib.rlib -o main` → compila `main.rs` usando apenas a biblioteca pré-compilada.

### Comparação e trade-offs
- **Decisão de projeto e diferença:**
  - Em Free Pascal, a fronteira de compilação separada é a `unit` (`.ppu` + `.o`), com recompilação rápida e simples mesmo sem gerenciador de builds.
  - Em Rust, a fronteira é o **crate** (`.rlib`), que armazena metadados ricos de tipos, generics e código objeto. Isso preserva otimizações agressivas dentro do crate e permite compilar dependências em paralelo via `cargo`, mas torna a invocação manual direta com `rustc` mais verbosa (`--crate-name`, `--crate-type`, `--extern`).
- **Eficiência × praticidade:** compilar por crate dá ao Rust excelente potencial de otimização e verificação semântica forte através de fronteiras de biblioteca, ao passo que a compilação de `unit`s em Pascal oferece ciclos de compilação extremamente rápidos e modelo mental simples.

---

## Experimento prático

O experimento implementa o mesmo TAD **Contador** limitado ao intervalo `[0, 10]` (inicia em `0`, incrementa até `10`, decrementa até `0`) e testa a violação direta do estado interno (`valor = -10`):

1. **Pascal clássico (ISO 7185):** [`contador.pas`](../pascal/04-abstracao-e-modularizacao/contador.pas) encapsula `valor` dentro de `ExecutarContador`; [`erros/erro_escopo.pas`](../pascal/04-abstracao-e-modularizacao/erros/erro_escopo.pas) tenta atribuir `valor := -10` no programa principal.
2. **Free Pascal (`unit`):** [`u_contador.pas`](../pascal/04-abstracao-e-modularizacao/u_contador.pas) e [`programa_unit.pas`](../pascal/04-abstracao-e-modularizacao/programa_unit.pas) demonstram modularização e compilação separada fora da norma ISO 7185.
3. **Rust (Edição 2024):** biblioteca em [`lib.rs`](../rust/04-abstracao-e-modularizacao/lib.rs) + [`contador.rs`](../rust/04-abstracao-e-modularizacao/contador.rs), binário cliente em [`main.rs`](../rust/04-abstracao-e-modularizacao/main.rs) e violação intencional de privacidade em [`erros/erro_privacidade.rs`](../rust/04-abstracao-e-modularizacao/erros/erro_privacidade.rs).

---

## Instruções de compilação e execução

Para reproduzir todos os testes automaticamente na raiz do repositório (após instalar `fp-compiler-3.2.2` e `rustc 1.99.1`):

```bash
bash scripts/rodar_04_abstracao.sh
```

Comandos manuais equivalentes:

```bash
# 1. Pascal ISO 7185 (a partir da raiz do repositorio)
cd pascal/04-abstracao-e-modularizacao
fpc -Miso contador.pas
./contador
fpc -Miso erros/erro_escopo.pas    # erro de compilacao esperado

# 2. Free Pascal com unit separada (extensao FPC)
fpc u_contador.pas                 # gera u_contador.ppu e u_contador.o
fpc programa_unit.pas              # usa a unit compilada separadamente
./programa_unit

# 3. Rust 1.99.1 (a partir de rust/04-abstracao-e-modularizacao)
cd ../../rust/04-abstracao-e-modularizacao
rustc +1.99.1 --edition=2024 --crate-name contador_lib --crate-type=rlib lib.rs
rustc +1.99.1 --edition=2024 main.rs --extern contador_lib=libcontador_lib.rlib -o main
./main
rustc +1.99.1 --edition=2024 erros/erro_privacidade.rs --extern contador_lib=libcontador_lib.rlib -o erro_privacidade  # erro E0616 esperado
```

---

## Resultados obtidos

### Rust (`rustc 1.99.1 (58cf8f9c3 2026-10-13)`, edição 2024) — **Executado e verificado**

1. **Compilação separada da biblioteca (`lib.rs`):** gerou `libcontador_lib.rlib` (`13518` bytes) sem erros ou avisos.
2. **Compilação e execução de `main.rs` (`./main`) — saída gravada em [`rust_main.txt`](../comparacoes/experimentos/04-abstracao-e-modularizacao/rust_main.txt):**
```text
Valor inicial: 0
Apos incrementar: 2
Apos decrementar: 1
Limite inferior: 0
Limite superior: 10
```
3. **Teste de encapsulamento (`erros/erro_privacidade.rs`) — saída gravada em [`rust_erro_privacidade_compilador.txt`](../comparacoes/experimentos/04-abstracao-e-modularizacao/rust_erro_privacidade_compilador.txt):**
```text
error[E0616]: field `valor` of struct `Contador` is private
 --> erros/erro_privacidade.rs:7:7
  |
7 |     c.valor = -10;
  |       ^^^^^ private field

error: aborting due to 1 previous error

For more information about this error, try `rustc --explain E0616`.
```

### Pascal (`fpc 3.2.2+dfsg-32`) — **Executado e verificado**

1. **Pascal clássico (`fpc -Miso contador.pas` e `./contador`) — compilação ([`pascal_contador_compilacao.txt`](../comparacoes/experimentos/04-abstracao-e-modularizacao/pascal_contador_compilacao.txt)) e saída ([`pascal_contador.txt`](../comparacoes/experimentos/04-abstracao-e-modularizacao/pascal_contador.txt)):**
```text
Valor inicial: 0
Apos incrementar: 2
Apos decrementar: 1
Limite inferior: 0
Limite superior: 10
```
2. **Compilação separada com `unit` (`fpc u_contador.pas`, `fpc programa_unit.pas` e `./programa_unit`) — saídas em [`pascal_unit_compilacao.txt`](../comparacoes/experimentos/04-abstracao-e-modularizacao/pascal_unit_compilacao.txt), [`pascal_programa_unit_compilacao.txt`](../comparacoes/experimentos/04-abstracao-e-modularizacao/pascal_programa_unit_compilacao.txt) e [`pascal_programa_unit.txt`](../comparacoes/experimentos/04-abstracao-e-modularizacao/pascal_programa_unit.txt):**
   - `u_contador.pas` compilou separadamente (`39 lines compiled, 0.0 sec`), `programa_unit.pas` compilou e ligou (`25 lines compiled, 0.0 sec`), produzindo a mesma saída (`0`, `2`, `1`, `0`, `10`).
3. **Teste de encapsulamento por escopo léxico (`fpc -Miso erros/erro_escopo.pas`) — saída gravada em [`pascal_erro_escopo_compilador.txt`](../comparacoes/experimentos/04-abstracao-e-modularizacao/pascal_erro_escopo_compilador.txt):**
```text
Free Pascal Compiler version 3.2.2+dfsg-32 [2024/01/05] for x86_64
Copyright (c) 1993-2021 by Florian Klaempfl and others
Target OS: Linux for x86-64
Compiling erros/erro_escopo.pas
erro_escopo.pas(46,3) Error: Identifier not found "valor"
erro_escopo.pas(48) Fatal: There were 1 errors compiling module, stopping
Fatal: Compilation aborted
Error: /usr/bin/ppcx64 returned an error exitcode
```

---

## Vantagens, desvantagens e trade-offs

| Linguagem / Mecanismo | Vantagens | Desvantagens | Trade-off principal |
|---|---|---|---|
| **Pascal ISO 7185** (escopo léxico, bloco único) | Sintaxe simples, compilação de passagem única, fácil de ensinar e prever | Sem módulos, sem compilação separada, impossível ocultar campos de `record` reutilizáveis | Simplicidade pedagógica × escalabilidade e reutilização de TADs |
| **Free Pascal** (`unit` com `interface`/`implementation`) | Compilação separada rápida (`.ppu`/`.o`), oculta variáveis da `implementation` | Campos de `record` em `interface` continuam públicos sem extensões OO (`class`/`object`); `uses` importa símbolos no escopo | Simplicidade de compilação modular × controle granular de visibilidade |
| **Rust** (`struct` + `impl`, `mod`, crates `.rlib`) | Privacidade por padrão, invariantes protegidos em múltiplas instâncias, API controlada via `pub use`, verificação estática sem custo em execução | Curva de aprendizado maior (`pub`, `mod`, `&self`/`&mut self`), compilação manual sem Cargo exige flags explícitas | Garantias estáticas e modularidade em larga escala × maior complexidade inicial |

---

## Conclusão do bloco

O contraste entre Pascal clássico (ISO 7185) e Rust (Edição 2024) mostra diretamente como o contexto histórico molda os mecanismos de abstração e modularização:

1. No Pascal de Wirth (1970), o objetivo era construir uma linguagem limpa para ensino de programação estruturada e compilação simples; o escopo léxico de procedimentos aninhados conseguia esconder variáveis locais, mas não fornecia TADs instanciáveis, módulos nem compilação separada — lacunas que levaram aos dialetos com `unit` (UCSD/Turbo/Free Pascal) e às sucessoras Modula-2 e Oberon.
2. Em Rust, abstração de dados (`struct`/`enum`), comportamento (`impl`), privacidade por padrão e fronteiras de módulo/crate trabalham juntos para proteger invariantes em tempo de compilação sem adicionar custo em execução, atendendo às exigências de sistemas modernos de grande porte.

---

## Referências

1. ISO/IEC 7185:1990 — *Information technology — Programming languages — Pascal* (especificação clássica; blocos, escopo léxico e subprogramas). Disponível para consulta técnica em: <https://standardpascal.org/iso7185.html>.
2. Free Pascal Compiler — *Reference Guide* (seções sobre Procedures/Functions, Scope, Units e modos `-Miso` / `-Mfpc`). <https://www.freepascal.org/docs.html>.
3. Free Pascal Compiler — *User's Guide* (opções de compilação e geração de arquivos `.ppu`/`.o`). <https://www.freepascal.org/docs.html>.
4. *The Rust Reference* — seções *Visibility and Privacy*, *Crates and source files* e *Modules*. <https://doc.rust-lang.org/reference/visibility-and-privacy.html>.
5. Klabnik, S.; Nichols, C. *The Rust Programming Language* — cap. 5 (*Using Structs to Structure Related Data*) e cap. 7 (*Managing Growing Projects with Packages, Crates, and Modules*). <https://doc.rust-lang.org/book/>.
6. *The rustc book* — argumentos de linha de comando (`--edition`, `--crate-name`, `--crate-type`, `--extern`). <https://doc.rust-lang.org/rustc/command-line-arguments.html>.
7. *Rust Compiler Error Index* — código `E0616` (*field of struct is private*). <https://doc.rust-lang.org/error_codes/E0616.html>.
