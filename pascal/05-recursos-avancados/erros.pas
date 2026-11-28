
program Erros;

var
  numerador, denominador: integer;

begin
  numerador := 10;
  denominador := 0;

  if denominador = 0 then
    writeln('Erro: divisao por zero!')
  else
    writeln('Resultado: ', numerador div denominador);
end.
