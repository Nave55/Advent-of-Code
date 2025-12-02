use std::{collections::HashSet, fs};

fn main() {
    let (left, right) = parse_file();
    let pt1 = solution(&left, &right);
    let pt2 = solution2(&left, &right);
    println!("Part 1: {}\nPart 2: {}", pt1, pt2);
}

fn parse_file() -> (Vec<i32>, Vec<i32>) {
    let con = fs::read_to_string("../inputs/day1.txt").expect("Failed to read file");

    let pairs: Vec<(i32, i32)> = con
        .lines()
        .filter_map(|line| {
            let mut nums = line
                .split_whitespace()
                .filter_map(|s| s.parse::<i32>().ok());
            Some((nums.next()?, nums.next()?))
        })
        .collect();

    let mut left: Vec<i32> = pairs.iter().map(|(left, _)| *left).collect();
    let mut right: Vec<i32> = pairs.iter().map(|(_, right)| *right).collect();

    left.sort_unstable();
    right.sort_unstable();

    (left, right)
}

fn solution(left: &[i32], right: &[i32]) -> i32 {
    left.iter()
        .zip(right.iter())
        .map(|(l, r)| (l - r).abs())
        .sum()
}

fn solution2(left: &[i32], right: &[i32]) -> i32 {
    let l_set: HashSet<i32> = left.iter().copied().collect();

    right.iter().filter(|r| l_set.contains(r)).sum()
}
