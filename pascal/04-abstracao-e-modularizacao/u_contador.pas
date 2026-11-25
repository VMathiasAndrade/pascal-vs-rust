{ Topicos 24-25 - Modularizacao e compilacao separada em Free Pascal (extensao nao presente no ISO 7185).
  Compilar unit separadamente: fpc u_contador.pas }
unit u_contador;

interface

procedure Inicializar;
procedure Incrementar;
procedure Decrementar;
function Consultar: Integer;

implementation

var
  valor: Integer; { privado a unit: nao acessivel em quem faz `uses u_contador` }

procedure Inicializar;
begin
  valor := 0;
end;

procedure Incrementar;
begin
  if valor < 10 then
    valor := valor + 1;
end;

procedure Decrementar;
begin
  if valor > 0 then
    valor := valor - 1;
end;

function Consultar: Integer;
begin
  Consultar := valor;
end;

end.
