// EXPERIMENTO - DEVE FALHAR AO COMPILAR (erro E0502: borrow mutavel + imutavel)
// rustc erro_borrow.rs
fn main() {
    let mut v = vec![1, 2, 3];
    let primeiro = &v[0]; // referencia imutavel
    v.push(4);            // ERRO: push pode realocar o vetor e invalidar `primeiro`
    println!("{}", primeiro);
}