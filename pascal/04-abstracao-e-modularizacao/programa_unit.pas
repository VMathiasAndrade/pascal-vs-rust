{ Topicos 24-25 - Programa cliente que consome a unit u_contador compilada separadamente.
  Compilar: fpc u_contador.pas && fpc programa_unit.pas
  Executar: ./programa_unit }
program ProgramaUnit;

uses
  u_contador;

var
  i: Integer;
begin
  Inicializar;
  WriteLn('Valor inicial: ', Consultar);
  Incrementar;
  Incrementar;
  WriteLn('Apos incrementar: ', Consultar);
  Decrementar;
  WriteLn('Apos decrementar: ', Consultar);
  Decrementar;
  Decrementar;
  WriteLn('Limite inferior: ', Consultar);
  for i := 1 to 12 do
    Incrementar;
  WriteLn('Limite superior: ', Consultar);
end.
