use num_bigint::BigUint;
use std::io::{self, Read};

fn fib(n: u32) -> BigUint {
    let mut a = BigUint::from(0u32);
    let mut b = BigUint::from(1u32);
    for _ in 0..n {
        let next = &a + &b;
        a = b;
        b = next;
    }
    a
}

fn fib_sum(n: u32) -> BigUint {
    let mut total = BigUint::from(0u32);
    let mut a = BigUint::from(0u32);
    let mut b = BigUint::from(1u32);
    for _ in 0..=n {
        total += &a;
        let next = &a + &b;
        a = b;
        b = next;
    }
    total
}

fn main() {
    let mut raw = String::new();
    io::stdin().read_to_string(&mut raw).unwrap();
    let n: u32 = raw.trim().parse().unwrap();
    println!("Part 1: {}", fib(n));
    println!("Part 2: {}", fib_sum(n));
}
