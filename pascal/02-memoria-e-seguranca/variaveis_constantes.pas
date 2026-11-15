{ Topico 12 - Variaveis e constantes em Pascal
  Compilar: fpc variaveis_constantes.pas }
program VarConst;

const
  PI_APROX = 3.14159;       { constante (nao pode ser alterada) }
  NOME = 'Pascal';

var
  contador: Integer;        { toda variavel e mutavel; declarada antes do begin }
  raio, area: Real;

procedure Demo;
var
  local: Integer;           { variavel local: vive na PILHA durante a chamada }
begin
  local := 1;
  contador := contador + local;
end;

begin
  contador := 0;
  Demo;
  raio := 2.0;
  area := PI_APROX * raio * raio;
  WriteLn(NOME, ' contador=', contador, ' area=', area:0:2);
  { PI_APROX := 3.0;   <- erro de compilacao: nao e possivel atribuir a constante }
end.