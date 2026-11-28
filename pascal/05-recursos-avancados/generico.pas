
program Genericos;

function maior_inteiro(a, b: integer): integer;
begin
  if a > b then
    maior_inteiro := a
  else
    maior_inteiro := b
end;

function maior_real(a, b: real): real;
begin
  if a > b then
    maior_real := a
  else
    maior_real := b
end;

begin
  writeln('Maior inteiro: ', maior_inteiro(10, 20));
  writeln('Maior real: ', maior_real(5.5, 3.2):0:2);
end.
