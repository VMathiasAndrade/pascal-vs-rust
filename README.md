# Pascal × Rust — Estudo Comparativo de Linguagens de Programação

**Universidade:** Universidade Federal de Viçosa — Campus Florestal  
**Disciplina:** Linguagens de Programação  
**Professor:** Lucas Bragança da Silva  
**Integrantes:** [inserir os cinco nomes]

> **Estado inicial:** estrutura e roteiros preparados; análises, experimentos e resultados estão **pendentes de pesquisa e testes**. Não confundir os modelos com resultados já validados.

## Objetivo e motivação
Comparar como Pascal e Rust organizam programas e tratam legibilidade, segurança e confiabilidade. Pascal enfatiza programação estruturada e clareza; Rust traz verificação de memória por ownership e borrowing. Investigar as decisões de projeto, suas vantagens, desvantagens e trade-offs.

## Contexto histórico
- Pascal: [indicar contexto e versão histórica escolhida; citar fontes]
- Rust: [indicar contexto e versão usada; citar fontes]

**Decisão pendente:** especificar **qual Pascal histórico será comparado e qual compilador/versão será utilizado para executar exemplos**. Diferenciar recursos do Pascal clássico das extensões de Free Pascal ou outro dialeto.

## Ambiente e reprodutibilidade
| Item | Versão | Instalação |
|---|---|---|
| Sistema operacional | [preencher] | — |
| Pascal e compilador | [preencher] | [link/comando] |
| Rust, rustc, cargo | [preencher] | [link/comando] |
| Dependências | [preencher] | [instruções] |

**Como executar:** em cada experimento, documentar caminho, comandos reais de compilação e execução, versões, saída observada e eventuais erros esperados.

## Pesquisa obrigatória: 29 tópicos
| Integrante | Tópicos | Documento |
|---|---|---|
| 1 | 1–10 | [Contexto histórico, paradigmas e tipos](docs/01-contexto-e-tipos.md) |
| 2 | 11–13 | [Ponteiros, memória e segurança](docs/02-memoria-e-seguranca.md) |
| 3 | 14–20 | [Expressões, comandos e funções](docs/03-expressoes-e-funcoes.md) |
| 4 | 21–25 | [Abstração, encapsulamento e módulos](docs/04-abstracao-e-modularizacao.md) |
| 5 | 26–29 | [Polimorfismo, generics e erros](docs/05-recursos-avancados.md) |

## Códigos e comparações
- [Exemplos Pascal](pascal/)
- [Exemplos Rust](rust/)
- [Experimentos equivalentes](comparacoes/exemplos-equivalentes/)
- [Protocolos de experimentos](comparacoes/experimentos/)
- [Resultados](comparacoes/resultados.md)

**Padrão:** para cada conceito comparar Pascal e Rust, decisão de projeto, vantagem, desvantagem e trade-off. Usar exemplos equivalentes e registrar resultados reais.

## Síntese e conclusão
- [Três diferenças históricas e trade-offs](docs/comparacao-historica.md)
- [Conclusão e respostas obrigatórias](docs/conclusao.md)
- [Roteiro oral de 20 minutos](docs/roteiro-apresentacao.md)

## Apresentação
O seminário deve selecionar comparações relevantes, não recitar os 29 tópicos. **Todos os 29** devem constar no GitHub. Incluir URL deste repositório nos slides e entregar apresentação em PDF no PVANet/Moodle dentro do prazo. O arquivo final pode ser salvo em `docs/apresentacao.pdf`.

## Referências
[Fontes e documentação](docs/referencias.md). Verificar cada afirmação técnica em especificação, manual ou documentação confiável. A IA não é fonte bibliográfica.

## Uso de Inteligência Artificial
ChatGPT foi utilizado para organizar a estrutura inicial, divisão de temas e modelos de documentação. O grupo deverá confirmar e atualizar ferramentas utilizadas e suas finalidades; conferir tecnicamente os conteúdos e testes.

## Checklist
- [ ] Escolher a versão/dialeto Pascal e registrar ambiente
- [ ] Documentar os 29 tópicos das duas linguagens
- [ ] Comparar pelo menos 3 propriedades desejáveis
- [ ] Incluir exemplos e experimentos reproduzíveis, quando aplicável
- [ ] Relacionar mecanismo → decisão → vantagem → desvantagem → trade-off
- [ ] Discutir ao menos 3 diferenças históricas com trade-offs
- [ ] Preencher conclusão obrigatória, referências e uso de IA
- [ ] Incluir link do repositório nos slides
- [ ] Publicar PDF no PVANet/Moodle
- [ ] Ensaiar com todos os cinco integrantes (máximo 20 min)
