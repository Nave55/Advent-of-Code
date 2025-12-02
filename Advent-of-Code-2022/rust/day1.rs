use itertools::Itertools;

fn main() {
    let input = std::fs::read_to_string("../inputs/day1.txt").expect("Failed to read file");
    let part1_result = pt1(&input);
    let part2_result = pt2(&input);
    println!("Part 1: {}\nPart 2: {}", part1_result, part2_result);
}

fn pt1(input: &str) -> u32 {
    input
        .split("\r\n\r\n")
        .map(|group| {
            group
                .lines()
                .filter_map(|line| line.parse::<u32>().ok())
                .sum::<u32>()
        })
        .max()
        .unwrap_or(0)
}

fn pt2(input: &str) -> u32 {
    input
        .split("\r\n\r\n")
        .map(|group| {
            group
                .lines()
                .filter_map(|line| line.parse::<u32>().ok())
                .sum::<u32>()
        })
        .sorted_by(|a, b| b.cmp(a))
        .take(3)
        .sum()
}
