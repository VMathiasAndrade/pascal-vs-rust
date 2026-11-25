use contador_lib::Contador;

fn main() {
    let mut c = Contador::new();
    println!("Valor inicial: {}", c.consultar());
    c.incrementar();
    c.incrementar();
    println!("Apos incrementar: {}", c.consultar());
    c.decrementar();
    println!("Apos decrementar: {}", c.consultar());
    c.decrementar();
    c.decrementar();
    println!("Limite inferior: {}", c.consultar());
    for _ in 0..12 {
        c.incrementar();
    }
    println!("Limite superior: {}", c.consultar());
}
