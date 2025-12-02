use std::collections::HashSet;

fn main() {
    let input = std::fs::read_to_string("../inputs/day4.txt").unwrap();
    let pt1 = solution(&input, 1);
    let pt2 = solution(&input, 2);
    println!("Part 1: {}\nPart 2: {}", pt1, pt2)
}

fn hash_inter(arr: Vec<i32>, sol_num: u8) -> u32 {
    let set1: HashSet<_> = (arr[0]..arr[1] + 1).collect();
    let set2: HashSet<_> = (arr[2]..arr[3] + 1).collect();
    let set3: HashSet<_> = set1.intersection(&set2).cloned().collect();

    if sol_num == 1 {
        if set1 == set3 || set2 == set3 {
            return 1;
        } else {
            return 0;
        }
    } else {
        if set3.len() > 0 {
            return 1;
        } else {
            return 0;
        }
    }
}

fn solution(input: &str, sol_num: u8) -> u32 {
    input
        .replace(",", "-")
        .split("\r\n\r\n")
        .flat_map(|item| item.lines())
        .map(|s| {
            hash_inter(
                s.split("-")
                    .map(|r| r.parse::<i32>().unwrap())
                    .collect::<Vec<_>>(),
                sol_num,
            )
        })
        .sum::<u32>()
}
