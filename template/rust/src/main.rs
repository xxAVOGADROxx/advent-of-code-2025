use std::io::{self, Read};

fn parse(raw: &str) -> Vec<&str> {
    raw.trim_end().lines().collect()
}

fn part1(_data: &[&str]) -> String {
    "TODO".to_string()
}

fn part2(_data: &[&str]) -> String {
    "TODO".to_string()
}

fn main() {
    let mut raw = String::new();
    io::stdin().read_to_string(&mut raw).unwrap();
    let data = parse(&raw);
    println!("Part 1: {}", part1(&data));
    println!("Part 2: {}", part2(&data));
}
