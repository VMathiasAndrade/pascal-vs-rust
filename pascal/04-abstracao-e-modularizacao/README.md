# Pascal — Abstração, encapsulamento e módulos

Responsável: Integrante 4 (Tariky Campos). Códigos relativos aos tópicos 21–25 e documentados em [`docs/04-abstracao-e-modularizacao.md`](../../docs/04-abstracao-e-modularizacao.md).

## Arquivos
- `contador.pas`: implementação do contador `[0, 10]` em Pascal clássico (ISO 7185), usando encapsulamento por escopo léxico (`ExecutarContador`).
  - Compilação e execução: `fpc -Miso contador.pas && ./contador`
- `erros/erro_escopo.pas`: tentativa propositalmente inválida de acessar `valor` no programa principal, demonstrando a proteção por escopo léxico.
  - Compilação (erro esperado): `fpc -Miso erros/erro_escopo.pas`
- `u_contador.pas` e `programa_unit.pas`: demonstração da extensão `unit` do Free Pascal / Turbo Pascal (não existente no ISO 7185) para modularização (`interface`/`implementation`) e compilação separada (`.ppu`/`.o`).
  - Compilação e execução: `fpc u_contador.pas && fpc programa_unit.pas && ./programa_unit`

Saídas verificadas com `fpc 3.2.2` (`3.2.2+dfsg-32`) registradas em [`comparacoes/experimentos/04-abstracao-e-modularizacao/`](../../comparacoes/experimentos/04-abstracao-e-modularizacao/).
