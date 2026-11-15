// Topico 12 - Variaveis e constantes em Rust
// Compilar: rustc variaveis_constantes.rs
const PI_APROX: f64 = 3.14159; // constante: sempre imutavel, tipo explicito

fn demo(contador: &mut i32) {
    let local = 1; // variavel local na pilha, imutavel por padrao
    *contador += local;
}

fn main() {
    let mut contador = 0; // `mut` e necessario para permitir alteracao
    demo(&mut contador);

    let raio = 2.0; // tipo inferido: f64
    let area = PI_APROX * raio * raio;
    println!("Rust contador={} area={:.2}", contador, area);

    let x = 5;
    let x = x * 2; // shadowing: NOVA variavel com o mesmo nome
    println!("x = {}", x);
    // x = 7;  // erro E0384: nao se pode atribuir duas vezes a variavel imutavel
}