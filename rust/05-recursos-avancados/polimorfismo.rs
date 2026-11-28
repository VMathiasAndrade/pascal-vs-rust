
trait Forma {
    fn nome(&self) -> &'static str;
    fn area(&self) -> f64;
}

struct Circulo {
    raio: f64,
}

struct Retangulo {
    largura: f64,
    altura: f64,
}

impl Forma for Circulo {
    fn nome(&self) -> &'static str {
        "circulo"
    }

    fn area(&self) -> f64 {
        3.14159 * self.raio * self.raio
    }
}

impl Forma for Retangulo {
    fn nome(&self) -> &'static str {
        "retangulo"
    }

    fn area(&self) -> f64 {
        self.largura * self.altura
    }
}

fn imprimir_area(forma: &dyn Forma) {
    println!(
        "Area do {}: {:.2}",
        forma.nome(),
        forma.area()
    );
}

fn main() {
    let circulo = Circulo { raio: 2.0 };

    let retangulo = Retangulo {
        largura: 4.0,
        altura: 3.0,
    };

    imprimir_area(&circulo);
    imprimir_area(&retangulo);
}
