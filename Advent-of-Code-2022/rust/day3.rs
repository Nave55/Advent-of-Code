use std::collections::{HashMap, HashSet};

fn main() {
    let input = std::fs::read_to_string("../inputs/day3.txt").unwrap();
    solution(&input)
}

fn solution(input: &str) {
    let mut alphabet: HashMap<char, u32> = HashMap::new();

    for i in 1..27 {
        alphabet.insert((i as u8 + 96) as char, i);
        alphabet.insert((i as u8 + 64) as char, i + 26);
    }

    let pt1 = input
        .split("\r\n\r\n")
        .flat_map(|elf| elf.lines())
        .map(|s| {
            let a: HashSet<_> = s[..(s.len() / 2)].chars().collect();
            let b: HashSet<_> = s[(s.len() / 2)..].chars().collect();
            alphabet[a.intersection(&b).next().unwrap()]
        })
        .sum::<u32>();

    let pt2 = input
        .split("\r\n\r\n")
        .flat_map(|elf| elf.lines())
        .map(|set| {
            let a: HashSet<_> = set.chars().collect();
            a
        })
        .collect::<Vec<_>>()
        .chunks(3)
        .map(|line| {
            alphabet[line[0]
                .intersection(&line[1])
                .cloned()
                .collect::<HashSet<_>>()
                .intersection(&line[2])
                .next()
                .unwrap()]
        })
        .sum::<u32>();

    println!("Part 1: {}\nPart 2: {}", pt1, pt2);
}
