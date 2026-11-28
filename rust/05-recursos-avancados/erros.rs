
fn dividir(a: i32, b: i32) -> Result<i32, String> {
    if b == 0 {
        Err(String::from("divisao por zero"))
    } else {
        Ok(a / b)
    }
}

fn main() {
    let resultado = dividir(10, 0);

    match resultado {
        Ok(valor) => println!("Resultado: {}", valor),
        Err(erro) => println!("Erro: {}", erro),
    }
}
