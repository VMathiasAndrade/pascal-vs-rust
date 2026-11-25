// Experimento de encapsulamento em Rust: tentativa de acesso direto a campo privado.
// Este arquivo falha propositalmente na compilacao (E0616).
use contador_lib::Contador;

fn main() {
    let mut c = Contador::new();
    c.valor = -10;
    println!("Valor: {}", c.consultar());
}
