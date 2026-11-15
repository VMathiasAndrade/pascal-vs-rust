// EXPERIMENTO - DEVE FALHAR AO COMPILAR (erro E0382: use after move)
// rustc erro_move.rs
fn consome(v: Vec<i32>) -> usize {
    v.len()
}

fn main() {
    let v = vec![1, 2, 3];
    let n = consome(v);   // ownership de `v` e movido para a funcao
    println!("{} {:?}", n, v); // ERRO: `v` ja foi movido
}