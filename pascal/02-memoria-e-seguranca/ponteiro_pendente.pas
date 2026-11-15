{ Experimento: ponteiro pendente (dangling) e dupla liberacao em Pascal.
  O compilador aceita o codigo; o comportamento e decidido em execucao.
  Compilar: fpc ponteiro_pendente.pas
  Executar: ./ponteiro_pendente }
program PonteiroPendente;

type
  PInt = ^Integer;

var
  p, q: PInt;

begin
  New(p);
  p^ := 7;
  q := p;                 { aliasing: dois ponteiros para o mesmo bloco }
  Dispose(p);             { libera o bloco... }
  WriteLn('p <> nil ? ', p <> nil);   { p continua apontando para memoria liberada }
  WriteLn('Dispose(q) a seguir (dupla liberacao):');
  Dispose(q);             { comportamento indefinido; FPC costuma abortar em execucao }
  WriteLn('Chegou aqui');
end.