# Rust — Polimorfismo, Generics, Sobrecarga e Tratamento de Erros

**Responsável:** Integrante 5.

Esta seção reúne os exemplos práticos referentes aos tópicos 26–29, desenvolvidos em Rust, com o objetivo de demonstrar os recursos da linguagem e permitir a comparação com Pascal.

## Exemplos desenvolvidos

| Tópico | Arquivo | Propósito |
|---|---|---|
| 26 — Polimorfismo | `polimorfismo.rs` | Demonstrar o uso de traits para implementar comportamentos diferentes por meio de uma interface comum. |
| 27 — Generics | `genericos.rs` | Demonstrar o uso de funções genéricas para trabalhar com diferentes tipos de dados. |
| 28 — Sobrecarga | `sobrecarga.rs` | Demonstrar a sobrecarga de operadores por meio da trait `Add`, utilizando o operador `+` com números complexos. |
| 29 — Tratamento de erros | `erros.rs` | Demonstrar o tratamento explícito de erros utilizando `Result`, `Ok`, `Err` e `match`. |

## Ambiente de execução

- **Linguagem:** Rust
- **Compilador:** rustc 1.100.0
- **Edição:** 2024

## Compilação e execução

Os exemplos podem ser compilados e executados individualmente pelo terminal, a partir da pasta `rust/05-recursos-avancados`.

```powershell
rustc --edition=2024 polimorfismo.rs -o polimorfismo.exe
.\polimorfismo.exe

rustc --edition=2024 genericos.rs -o genericos.exe
.\genericos.exe

rustc --edition=2024 sobrecarga.rs -o sobrecarga.exe
.\sobrecarga.exe

rustc --edition=2024 erros.rs -o erros.exe
.\erros.exe
```

## Resultados esperados

**26 — Polimorfismo**
```text
Area do circulo: 12.57
Area do retangulo: 12.00
```

**27 — Generics**
```text
Maior inteiro: 20
Maior real: 5.50
```

**28 — Sobrecarga**
```text
Resultado: 4 + 6i
```

**29 — Tratamento de erros**
```text
Erro: divisao por zero
```

## Comparação

A análise comparativa dos recursos apresentados está documentada em [`docs/05-recursos-avancados.md`](../../docs/05-recursos-avancados.md).