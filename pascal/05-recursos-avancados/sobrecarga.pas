
program Sobrecarga;

type
  TComplexo = record
    real: integer;
    imaginario: integer;
  end;

function somar_complexos(a, b: TComplexo): TComplexo;
begin
  somar_complexos.real := a.real + b.real;
  somar_complexos.imaginario := a.imaginario + b.imaginario;
end;

var
  a, b, resultado: TComplexo;

begin
  a.real := 3;
  a.imaginario := 2;

  b.real := 1;
  b.imaginario := 4;

  resultado := somar_complexos(a, b);

  writeln('Resultado: ', resultado.real, ' + ',
          resultado.imaginario, 'i');
end.
