use std::fs;
use std::path::Path;

struct FileInfo {
    val: i32,
    pos: usize,
    size: usize,
}

type VI = Vec<i32>;
type VFI = Vec<FileInfo>;

fn parse_input(path: &Path) -> (VI, VFI, VFI) {
    let input = fs::read_to_string(path)
        .expect("Failed to read file")
        .trim()
        .chars()
        .enumerate()
        .map(|(i, c)| (i, c.to_digit(10).expect("Non-digit character") as usize))
        .collect::<Vec<_>>();

    let (arr, filled, empty, _, _) = input.iter().fold(
        (Vec::new(), Vec::new(), Vec::new(), 0, 0),
        |(mut arr, mut filled, mut empty, mut f_val, mut idx), &(ind, times)| {
            if ind % 2 == 0 {
                arr.extend(std::iter::repeat(f_val).take(times));
                if times > 0 {
                    filled.push(FileInfo {
                        val: f_val,
                        pos: idx,
                        size: times,
                    });
                    f_val += 1;
                }
            } else {
                arr.extend(std::iter::repeat(-1).take(times));
                if times > 0 {
                    empty.push(FileInfo {
                        val: -1,
                        pos: idx,
                        size: times,
                    });
                }
            }
            idx += times;
            (arr, filled, empty, f_val, idx)
        },
    );

    (arr, filled, empty)
}

fn solution(arr: &mut VI) -> u64 {
    let mut ttl: u64 = 0;
    let mut j = arr.len() - 1;

    for i in 0..arr.len() {
        if arr[i] == -1 {
            while j > i && arr[j] < 0 {
                j -= 1;
            }
            if j <= i {
                break;
            }
            arr[i] = arr[j];
            arr[j] = -1;
        }
        if arr[i] >= 0 {
            ttl += i as u64 * arr[i] as u64
        }
    }

    ttl
}

fn solution_two(filled: &mut VFI, empty: &mut VFI) -> u64 {
    for i in filled.iter_mut().rev() {
        for j in empty.iter_mut() {
            if i.pos <= j.pos {
                break;
            }
            if i.size <= j.size {
                i.pos = j.pos;
                j.size -= i.size;
                j.pos += i.size;
                break;
            }
        }
    }

    filled
        .iter()
        .flat_map(|i| (i.pos..i.pos + i.size).map(move |ind| i.val as u64 * ind as u64))
        .sum()
}

fn main() {
    let (mut arr, mut filled, mut empty) = parse_input(Path::new("../inputs/day9.txt"));
    let pt1 = solution(&mut arr);
    let pt2 = solution_two(&mut filled, &mut empty);
    println!("Part 1: {pt1}\nPart 2: {pt2}")
}
