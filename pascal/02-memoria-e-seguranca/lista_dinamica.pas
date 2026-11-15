{ Topicos 11, 12 e 13 - Ponteiros, variaveis/constantes e memoria
  Lista encadeada dinamica em Pascal (alocacao e liberacao MANUAIS).
  Compilar: fpc lista_dinamica.pas
  Executar: ./lista_dinamica }
program ListaDinamica;

const
  MAX_ITENS = 5;            { constante: valor fixo, resolvido em compilacao }

type
  PNo = ^TNo;               { tipo ponteiro para TNo }
  TNo = record
    valor: Integer;
    prox: PNo;
  end;

var
  cabeca, atual, aux: PNo;  { variaveis globais (segmento de dados) }
  i: Integer;
  soma: Integer;

begin
  cabeca := nil;

  { Insercao no inicio: cada New aloca um no no HEAP }
  for i := 1 to MAX_ITENS do
  begin
    New(aux);
    aux^.valor := i * 10;
    aux^.prox := cabeca;
    cabeca := aux;
  end;

  { Percurso }
  soma := 0;
  atual := cabeca;
  while atual <> nil do
  begin
    Write(atual^.valor, ' ');
    soma := soma + atual^.valor;
    atual := atual^.prox;
  end;
  WriteLn;
  WriteLn('Soma = ', soma);

  { Liberacao MANUAL: responsabilidade do programador }
  while cabeca <> nil do
  begin
    aux := cabeca;
    cabeca := cabeca^.prox;
    Dispose(aux);
  end;
end.