{ Experimento: vazamento de memoria em Pascal.
  O compilador NAO reclama; so o heaptrc (opcao -gh) acusa em tempo de execucao.
  Compilar: fpc -gh vazamento.pas
  Executar: ./vazamento }
program Vazamento;

type
  PInt = ^Integer;

var
  p: PInt;

begin
  New(p);
  p^ := 42;
  WriteLn('Valor = ', p^);
  { Esquecemos Dispose(p): o programa compila e roda normalmente. }
end.