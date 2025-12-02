use std::collections::HashSet;

fn main() {
    let input = std::fs::read_to_string("../inputs/day6.txt").expect("Incorrect File Path");
    let pt1 = solution(&input, 4);
    let pt2 = solution(&input, 14);
    println!("Part 1: {}\nPart 2: {}", pt1, pt2)
}

fn solution(input: &str, window: usize) -> usize {
    input
        .split("\r\n\r\n")
        .flat_map(|line| line.lines())
        .map(|s| {
            (0..=s.len().saturating_sub(window))
                .find(|&i| s[i..i + window].chars().collect::<HashSet<char>>().len() == window)
                .map_or(0, |i| i + window)
        })
        .sum::<usize>()
}
