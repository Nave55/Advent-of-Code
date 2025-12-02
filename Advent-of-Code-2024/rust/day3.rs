use regex::Regex;
use std::fs;

fn main() {
    let file = fs::read_to_string("../inputs/day3.txt").expect("Bad File Name");
    solution(&file);
}

fn solution(file: &str) {
    let re = Regex::new(r"mul\((\d+,\d+)\)|(do(?:n't)?\(\))").unwrap();

    let results: Vec<_> = re
        .find_iter(file)
        .map(|i| {
            let parts = i
                .as_str()
                .trim_start_matches("mul(")
                .trim_end_matches(")")
                .split(',');

            parts
                .map(|part| match part.trim() {
                    "do(" => 1,
                    "don't(" => 0,
                    _ => part.parse::<i32>().unwrap_or_default(),
                })
                .collect::<Vec<_>>()
        })
        .collect();

    let mut mul = true;
    let mut ttl = 0;
    let mut ttl2 = 0;
    for i in results {
        if i.len() == 1 {
            mul = if i[0] == 0 { false } else { true }
        } else {
            ttl += i[0] * i[1];
            if mul {
                ttl2 += i[0] * i[1];
            }
        }
    }
    println!("{ttl}, {ttl2}")
}
