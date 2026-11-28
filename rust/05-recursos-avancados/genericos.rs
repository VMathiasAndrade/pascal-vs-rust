
fn maior<T: PartialOrd + Copy>(a: T, b: T) -> T {
    if a > b {
        a
    } else {
        b
    }
}

fn main() {
    println!("Maior inteiro: {}", maior(10, 20));
    println!("Maior real: {:.2}", maior(5.5, 3.2));
}
