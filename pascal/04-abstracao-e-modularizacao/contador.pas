{ Topico 21-25 - Contador em Pascal ISO 7185 (encapsulamento por escopo lexico)
  Compilar: fpc -Miso contador.pas
  Executar: ./contador }
program Contador(output);

procedure ExecutarContador;
var
  valor: integer;
  i: integer;

  procedure Incrementar;
  begin
    if valor < 10 then
      valor := valor + 1
  end;

  procedure Decrementar;
  begin
    if valor > 0 then
      valor := valor - 1
  end;

  function Consultar: integer;
  begin
    Consultar := valor
  end;

begin
  valor := 0;
  writeln('Valor inicial: ', Consultar:1);
  Incrementar;
  Incrementar;
  writeln('Apos incrementar: ', Consultar:1);
  Decrementar;
  writeln('Apos decrementar: ', Consultar:1);
  Decrementar;
  Decrementar;
  writeln('Limite inferior: ', Consultar:1);
  for i := 1 to 12 do
    Incrementar;
  writeln('Limite superior: ', Consultar:1)
end;

begin
  ExecutarContador
end.
