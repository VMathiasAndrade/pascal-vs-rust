// Topicos 11, 12 e 13 - Lista encadeada em Rust com ownership.
// Compilar: rustc lista_dinamica.rs
// Executar: ./lista_dinamica

const MAX_ITENS: i32 = 5; // constante: tipo obrigatorio, avaliada em compilacao

struct No {
    valor: i32,
    prox: Option<Box<No>>, // Box<T>: ponteiro com dono unico, alocado no heap
}

fn main() {
    let mut cabeca: Option<Box<No>> = None;

    // Insercao no inicio: o ownership do no antigo e movido para o novo no
    for i in 1..=MAX_ITENS {
        let novo = Box::new(No { valor: i * 10, prox: cabeca });
        cabeca = Some(novo);
    }

    // Percurso por referencia imutavel (borrow): nao toma posse da lista
    let mut soma = 0;
    let mut atual = &cabeca;
    while let Some(no) = atual {
        print!("{} ", no.valor);
        soma += no.valor;
        atual = &no.prox;
    }
    println!();
    println!("Soma = {}", soma);

    // Nao ha free/Dispose: ao fim de main, `cabeca` sai de escopo e o compilador
    // insere automaticamente a liberacao (Drop) de todos os nos.
}