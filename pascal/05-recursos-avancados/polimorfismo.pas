
program Polimorfismo;

type
  TTipoFigura = (circulo, retangulo);

  TFigura = record
    case tipo: TTipoFigura of
      circulo: (raio: real);
      retangulo: (largura, altura: real)
  end;

function calcularArea(figura: TFigura): real;
begin
  case figura.tipo of
    circulo:
      calcularArea := 3.14159 * figura.raio * figura.raio;

    retangulo:
      calcularArea := figura.largura * figura.altura
  end
end;

var
  figura: TFigura;

begin
  figura.tipo := circulo;
  figura.raio := 2.0;

  writeln('Area do circulo: ', calcularArea(figura):0:2);

  figura.tipo := retangulo;
  figura.largura := 4.0;
  figura.altura := 3.0;

  writeln('Area do retangulo: ', calcularArea(figura):0:2);
end.
