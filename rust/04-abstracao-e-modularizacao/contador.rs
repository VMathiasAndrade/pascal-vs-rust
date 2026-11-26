pub struct Contador {
    valor: i32,
}

impl Contador {
    pub fn new() -> Self {
        Self { valor: 0 }
    }

    pub fn incrementar(&mut self) {
        if self.valor < 10 {
            self.valor += 1;
        }
    }

    pub fn decrementar(&mut self) {
        if self.valor > 0 {
            self.valor -= 1;
        }
    }

    pub fn consultar(&self) -> i32 {
        self.valor
    }
}
