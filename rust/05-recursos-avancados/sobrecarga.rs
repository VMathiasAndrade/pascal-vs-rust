
use std::ops::Add;

struct Complexo {
    real: i32,
    imaginario: i32,
}

impl Add for Complexo {
    type Output = Complexo;

    fn add(self, outro: Complexo) -> Complexo {
        Complexo {
            real: self.real + outro.real,
            imaginario: self.imaginario + outro.imaginario,
        }
    }
}

fn main() {
    let a = Complexo {
        real: 3,
        imaginario: 2,
    };

    let b = Complexo {
        real: 1,
        imaginario: 4,
    };

    let resultado = a + b;

    println!(
        "Resultado: {} + {}i",
        resultado.real,
        resultado.imaginario
    );
}
