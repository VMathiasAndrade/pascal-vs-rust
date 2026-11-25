# Rust — Abstração, encapsulamento e módulos

Responsável: Integrante 4 (Tariky Campos). Códigos relativos aos tópicos 21–25 e documentados em [`docs/04-abstracao-e-modularizacao.md`](../../docs/04-abstracao-e-modularizacao.md).

## Arquivos
- `contador.rs`: definição do TAD `Contador` (`struct` com campo privado `valor: i32` e bloco `impl` público).
- `lib.rs`: raiz do crate de biblioteca (`mod contador; pub use contador::Contador;`).
- `main.rs`: programa cliente que consome `contador_lib::Contador` compilado separadamente.
- `erros/erro_privacidade.rs`: tentativa propositalmente inválida (`c.valor = -10;`) que dispara `error[E0616]`.

## Compilação e execução verificadas (`rustc 1.99.1`, edição 2024)
```bash
rustc +1.99.1 --edition=2024 --crate-name contador_lib --crate-type=rlib lib.rs
rustc +1.99.1 --edition=2024 main.rs --extern contador_lib=libcontador_lib.rlib -o main
./main
rustc +1.99.1 --edition=2024 erros/erro_privacidade.rs --extern contador_lib=libcontador_lib.rlib -o erro_privacidade
```
Saídas registradas em [`comparacoes/experimentos/04-abstracao-e-modularizacao/`](../../comparacoes/experimentos/04-abstracao-e-modularizacao/).
