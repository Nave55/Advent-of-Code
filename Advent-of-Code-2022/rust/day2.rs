use std::{collections::HashMap, fs::read_to_string};

fn main() {
    let input = read_to_string("../inputs/day2.txt").unwrap();
    solution(&input);
}

fn solution(input: &str) {
    let rps = HashMap::from([
        ("A X", [4, 3]),
        ("B X", [1, 1]),
        ("C X", [7, 2]),
        ("A Y", [8, 4]),
        ("B Y", [5, 5]),
        ("C Y", [2, 6]),
        ("A Z", [3, 8]),
        ("B Z", [9, 9]),
        ("C Z", [6, 7]),
    ]);

    let pt1 = input
        .split("\r\n\r\n")
        .flat_map(|elf| elf.lines())
        .map(|s| rps[s][0])
        .sum::<u32>();

    let pt2 = input
        .split("\r\n\r\n")
        .flat_map(|elf| elf.lines())
        .map(|s| rps[s][1])
        .sum::<u32>();

    println!("Part 1: {pt1}\nPart 2: {pt2}")
}
