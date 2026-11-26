# Exemplo equivalente — TAD Contador, encapsulamento e modularização (Pascal × Rust)

**Tópicos relacionados:** 21 (abstração), 22 (TADs), 23 (encapsulamento), 24 (modularização) e 25 (compilação separada)  
**Responsável:** Integrante 4 — Tariky Campos  
**Código-fonte completo:** [`pascal/04-abstracao-e-modularizacao/`](../../pascal/04-abstracao-e-modularizacao/) · [`rust/04-abstracao-e-modularizacao/`](../../rust/04-abstracao-e-modularizacao/)  
**Ambiente:** `fpc 3.2.2` (`3.2.2+dfsg-32`, modos `-Miso` e `unit`) · `rustc 1.99.1 (58cf8f9c3 2026-10-13)` (edição 2024) — Ubuntu 24.04.2 LTS

## O problema

Implementar um contador inteiro limitado ao intervalo `[0, 10]` (iniciando em `0`, sem ultrapassar `10` ao incrementar nem ficar abaixo de `0` ao decrementar) e verificar como cada linguagem impede que o programa principal corrompa esse invariante com `valor = -10`.

## Solução em Pascal clássico (ISO 7185)

Em [`contador.pas`](../../pascal/04-abstracao-e-modularizacao/contador.pas), o estado `valor` é ocultado por **escopo léxico** dentro do procedimento `ExecutarContador`:

```pascal
procedure ExecutarContador;
var
  valor: integer;
  procedure Incrementar; begin if valor < 10 then valor := valor + 1 end;
  procedure Decrementar; begin if valor > 0 then valor := valor - 1 end;
  function Consultar: integer; begin Consultar := valor end;
begin
  { usa Incrementar, Decrementar e Consultar }
end;
```

Ao tentar `valor := -10` no programa principal ([`erros/erro_escopo.pas`](../../pascal/04-abstracao-e-modularizacao/erros/erro_escopo.pas)), o compilador `fpc -Miso` rejeitou com `erro_escopo.pas(46,3) Error: Identifier not found "valor"` (saída em [`pascal_erro_escopo_compilador.txt`](../experimentos/04-abstracao-e-modularizacao/pascal_erro_escopo_compilador.txt)). Na execução válida (`./contador` e `./programa_unit`), a saída observada foi idêntica à do Rust (`0`, `2`, `1`, `0`, `10`). Contudo, o padrão de escopo em ISO 7185 não cria um tipo reutilizável com múltiplas instâncias independentes nem separação em módulos (o que só aparece em dialetos posteriores como `unit` em Free Pascal, demonstrada em [`u_contador.pas`](../../pascal/04-abstracao-e-modularizacao/u_contador.pas)).

## Solução em Rust (Edição 2024)

Em Rust, a biblioteca separa representação privada e API pública em múltiplos arquivos com **compilação separada**:

- [`contador.rs`](../../rust/04-abstracao-e-modularizacao/contador.rs): `pub struct Contador { valor: i32 }` (campo privado por padrão) + `impl Contador`.
- [`lib.rs`](../../rust/04-abstracao-e-modularizacao/lib.rs): `mod contador; pub use contador::Contador;` (compilado como `libcontador_lib.rlib`).
- [`main.rs`](../../rust/04-abstracao-e-modularizacao/main.rs): consome `use contador_lib::Contador;` via `--extern contador_lib=libcontador_lib.rlib`.

```bash
rustc +1.99.1 --edition=2024 --crate-name contador_lib --crate-type=rlib lib.rs
rustc +1.99.1 --edition=2024 main.rs --extern contador_lib=libcontador_lib.rlib -o main
./main
```

**Saída observada (`rustc 1.99.1`):**

```text
Valor inicial: 0
Apos incrementar: 2
Apos decrementar: 1
Limite inferior: 0
Limite superior: 10
```

**Violação testada em [`erros/erro_privacidade.rs`](../../rust/04-abstracao-e-modularizacao/erros/erro_privacidade.rs):**

```text
error[E0616]: field `valor` of struct `Contador` is private
 --> erros/erro_privacidade.rs:7:7
  |
7 |     c.valor = -10;
  |       ^^^^^ private field
```

## Comparação resumida

| Critério | Pascal clássico (ISO 7185) | Free Pascal (`unit`) | Rust (Edição 2024) |
|---|---|---|---|
| Ocultação de `valor` | Escopo léxico do procedimento | Variável na seção `implementation` | Campo privado por padrão na `struct` |
| Múltiplas instâncias encapsuladas | Não (sem `class`/`object`) | Exige `class`/`object` (extensão OO) | Sim (`Contador::new()`) |
| Fronteira modular | Nenhuma (arquivo único) | `unit` (`interface`/`implementation`) | `mod` + crate (`.rlib`) |
| Compilação separada | Não prevista na norma | Por `unit` (`.ppu` + `.o`) | Por crate (`--crate-type=rlib` + `--extern`) |
