# Exemplo equivalente — Usar memória depois de liberada (Pascal × Rust)

**Tópicos relacionados:** 11 (ponteiros/referências) e 13 (gerenciamento de memória)
**Responsável:** Integrante 2
**Código-fonte completo:** [`pascal/02-memoria-e-seguranca/ponteiro_pendente.pas`](../../pascal/02-memoria-e-seguranca/ponteiro_pendente.pas) · [`rust/02-memoria-e-seguranca/erros/erro_move.rs`](../../rust/02-memoria-e-seguranca/erros/erro_move.rs)
**Ambiente:** Free Pascal 3.2.2 · rustc 1.75.0 (Ubuntu 24.04) — *atualize com as versões que você usou*

## A situação

Um bloco de memória no heap é liberado (ou tem sua posse transferida) e, em seguida, o programa tenta usá-lo de novo. É o erro clássico de *use-after-free* / dupla liberação. A pergunta é: **em que momento a linguagem detecta o problema, e quem é o responsável?**

## Código em Pascal

```pascal
program PonteiroPendente;
type
  PInt = ^Integer;
var
  p, q: PInt;
begin
  New(p);
  p^ := 7;
  q := p;                 { aliasing: dois ponteiros para o mesmo bloco }
  Dispose(p);             { libera o bloco }
  WriteLn('p <> nil ? ', p <> nil);   { p continua apontando para memória liberada }
  WriteLn('Dispose(q) a seguir (dupla liberacao):');
  Dispose(q);             { comportamento indefinido }
  WriteLn('Chegou aqui');
end.
```

```bash
fpc ponteiro_pendente.pas && ./ponteiro_pendente
```

**Resultado observado:** o compilador **aceita** o código sem aviso. Em execução:

```
p <> nil ? TRUE
Dispose(q) a seguir (dupla liberacao):
Runtime error 204 at $0000000000419484
```

O programa termina com código de saída 204. O endereço varia de execução para execução. O comportamento exato é **dependente da implementação** (Free Pascal); o Pascal padrão (ISO 7185) trata isso como erro do programa, sem definir o que acontece.

## Código equivalente em Rust

```rust
fn consome(v: Vec<i32>) -> usize {
    v.len()
}

fn main() {
    let v = vec![1, 2, 3];
    let n = consome(v);        // ownership de `v` é movido (e liberado ao fim de `consome`)
    println!("{} {:?}", n, v); // ERRO: `v` já foi movido
}
```

```bash
rustc erro_move.rs
```

**Resultado observado:** o compilador **rejeita** o código; nenhum executável é gerado.

```
error[E0382]: borrow of moved value: `v`
  --> erro_move.rs:10:28
   |
 8 |     let v = vec![1, 2, 3];
   |         - move occurs because `v` has type `Vec<i32>`, which does not implement the `Copy` trait
 9 |     let n = consome(v);
   |                     - value moved here
10 |     println!("{} {:?}", n, v);
   |                            ^ value borrowed here after move
```

> Este arquivo falha de propósito. A falha de compilação é o resultado **correto**, não um teste aprovado.

## Comparação

| Aspecto | Pascal (FPC 3.2.2) | Rust (1.75.0) |
|---|---|---|
| Mecanismo | `New`/`Dispose` manuais; ponteiros livres | Ownership + move; liberação automática ao sair de escopo |
| Quando o erro é detectado | Em execução (ou nunca) | Em compilação |
| Quem garante a correção | O programador | O compilador (em código seguro) |
| Estado do ponteiro após liberar | Continua não-`nil` (pendente) | A variável movida não pode mais ser usada |
| Custo em execução | Nenhum extra | Nenhum extra (a verificação é toda estática) |

## Análise (mecanismo → decisão de projeto → vantagem → desvantagem → trade-off)

- **Pascal:** mecanismo manual e simples (`New`/`Dispose`). A decisão de projeto, nos anos 1970, foi manter a linguagem pequena e fácil de ensinar, sem verificação de uso de ponteiros. *Vantagem:* modelo mental simples e controle direto da memória. *Desvantagem:* o erro passa despercebido pelo compilador e pode causar falhas imprevisíveis em execução (confiabilidade menor). *Trade-off:* simplicidade e liberdade × responsabilidade total do programador.
- **Rust:** mecanismo de ownership verificado estaticamente. A decisão de projeto foi garantir segurança de memória **sem coletor de lixo**, transferindo a verificação para o compilador. *Vantagem:* a classe inteira de erros de uso-após-liberação é impedida antes de o programa rodar, sem custo em tempo de execução. *Desvantagem:* regras novas a aprender e código às vezes mais verboso ou restrito (por exemplo, é preciso emprestar com `&` ou clonar). *Trade-off:* garantias estáticas × curva de aprendizado e menor flexibilidade em certas estruturas.

## Observação

Os dois programas **não são idênticos em comportamento**: o Pascal faz dupla liberação por *aliasing*, e o Rust usa uso-após-*move*. São construções equivalentes quanto ao problema (usar memória que já não é mais válida), e o contraste está justamente em *quando* e *por quem* o erro é capturado.

## Referências

- Rust: *The Rust Programming Language*, cap. 4 (Ownership) — <https://doc.rust-lang.org/book/>; Índice de erros do compilador, E0382 — <https://doc.rust-lang.org/error_codes/E0382.html>
- Free Pascal: *Reference Guide* (seção Pointers) e *Programmer's Guide* — <https://www.freepascal.org/docs.html>
- Código escrito pelo grupo para este trabalho; as afirmações devem ser conferidas nas fontes acima.
