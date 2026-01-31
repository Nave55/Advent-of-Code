use std::{collections::HashSet, fs, path::Path};
use tools::*;

type Mat = Vec<Vec<u32>>;

fn main() {
    let mat = parse_input(Path::new("../inputs/day10.txt"));
    let (pt1, pt2) = solution(&mat);
    println!("Part 1: {pt1}\nPart 2: {pt2}")
}

fn parse_input(path: &Path) -> Mat {
    fs::read_to_string(path)
        .expect("Failed to read file")
        .lines()
        .map(|line| {
            line.chars()
                .map(|c| c.to_digit(10).expect("Failed to parse char to digit"))
                .collect::<Vec<u32>>()
        })
        .collect::<Vec<Vec<u32>>>()
}

fn bfs(mat: &Mat, pos: Ti, visited: &mut HashSet<Ti>, target: u32) -> u32 {
    let mut l_visited: HashSet<Ti> = HashSet::new();
    let mut queue: Vec<Ti> = Vec::new();
    let mut ttl = 0;

    queue.push(pos);
    visited.insert(pos);
    l_visited.insert(pos);

    while queue.len() > 0 {
        let current = queue.pop().expect("Failed to Pop from Queue");
        if fetch_val(mat, current).unwrap() == target {
            ttl += 1;
        }

        let (locs, nums) = nbrs(mat, current, Dirs::Udlr).unwrap();
        for (ind, val) in locs.iter().enumerate() {
            let val_i = tt_to_ti(*val).unwrap();
            if nums[ind] == fetch_val(mat, current).unwrap() + 1 && !l_visited.contains(&val_i) {
                queue.push(val_i);
                l_visited.insert(val_i);
                visited.insert(val_i);
            }
        }
    }

    ttl
}

fn dfs(mat: &Mat, pos: Ti, visited: &mut HashSet<Ti>, target: u32) -> u32 {
    let mut res = 0;
    if fetch_val(mat, pos).unwrap() == target {
        return 1;
    }

    visited.insert(pos);
    let (locs, _) = nbrs(mat, pos, Dirs::Udlr).unwrap();
    for nbr in locs.iter() {
        let val_i = tt_to_ti(*nbr).unwrap();

        if !visited.contains(&val_i)
            && fetch_val(mat, val_i).unwrap() == fetch_val(mat, pos).unwrap() + 1
        {
            res += dfs(mat, val_i, visited, 9);
        }

        visited.remove(&pos);
    }

    res
}

fn solution(mat: &Mat) -> (u32, u32) {
    let mut pt1 = 0;
    let mut pt2 = 0;
    let mut pt1_visited: HashSet<Ti> = HashSet::new();
    let mut pt2_visited: HashSet<Ti> = HashSet::new();

    for (r_ind, r_val) in mat.iter().enumerate() {
        for (c_ind, c_val) in r_val.iter().enumerate() {
            if *c_val == 0 {
                let tmp = (r_ind as i32, c_ind as i32);

                if !pt1_visited.contains(&tmp) {
                    pt1 += bfs(mat, tmp, &mut pt1_visited, 9)
                }

                pt2 += dfs(mat, tmp, &mut pt2_visited, 9)
            }
        }
    }

    (pt1, pt2)
}
