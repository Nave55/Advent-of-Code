use std::collections::HashSet;

#[derive(Debug)]
struct Directory {
    path: String,
    size: u32,
}

fn main() {
    let input = std::fs::read_to_string("../inputs/day7.txt").expect("Failed to open file");
    let mut directories: Vec<Directory> = Vec::new();
    let mut tmp_dir: Vec<String> = Vec::new();
    let mut dir_names: HashSet<String> = HashSet::new();

    input
        .split("\r\n\r\n")
        .flat_map(|s| s.lines())
        .for_each(|line| {
            if line.len() > 5 && &line[2..3] == "c" && &line[5..6] != "." {
                tmp_dir.push(line[5..].to_string());
                dir_names.insert(tmp_dir.join("-"));
            } else if line.len() > 5 && &line[5..6] == "." {
                tmp_dir.pop();
            } else if line.chars().next().unwrap_or('\0').is_digit(10) {
                let path = tmp_dir.join("-");
                let size = line[..line.find(' ').unwrap()].parse::<u32>().unwrap();
                directories.push(Directory { path, size });
            }
        });

    let total_sizes: Vec<u32> = dir_names
        .iter()
        .map(|dir_name| {
            directories
                .iter()
                .filter(|dir| dir.path.contains(dir_name))
                .map(|dir| dir.size)
                .sum()
        })
        .collect();

    let pt1 = total_sizes
        .iter()
        .filter(|&&size| size <= 100_000)
        .sum::<u32>();
    let pt2 = total_sizes
        .iter()
        .filter(|&&size| size >= total_sizes.iter().max().unwrap() - 40_000_000)
        .min()
        .unwrap();
    println!("Part 1: {}\nPart 2: {}", pt1, pt2);
}
