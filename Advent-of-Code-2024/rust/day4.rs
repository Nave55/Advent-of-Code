use tools::{nbrs, Dirs};

fn main() {
    solution()
}

const DIR: [(i32, i32); 24] = [
    (-3, -3),
    (-2, -2),
    (-1, -1),
    (-3, 3),
    (-2, 2),
    (-1, 1),
    (3, -3),
    (2, -2),
    (1, -1),
    (3, 3),
    (2, 2),
    (1, 1),
    (-3, 0),
    (-2, 0),
    (-1, 0),
    (3, 0),
    (2, 0),
    (1, 0),
    (0, -3),
    (0, -2),
    (0, -1),
    (0, 3),
    (0, 2),
    (0, 1),
];

fn solution() {
    let con = std::fs::read_to_string("../inputs/day4.txt").expect("Bad File Name");

    let mat: Vec<Vec<char>> = con
        .split("\r\n\r\n")
        .flat_map(|line| line.lines())
        .map(|s| s.chars().collect())
        .collect();

    let pt1 = check_xmas(&mat);
    let pt2 = check_x(&mat);
    println!("Part 1: {pt1}\nPart 2: {pt2}")
}

fn check_xmas(mat: &[Vec<char>]) -> i32 {
    mat.iter()
        .enumerate()
        .flat_map(|(r, row)| {
            row.iter().enumerate().filter_map(move |(c, &ch)| {
                if ch == 'X' {
                    Some((r as i32, c as i32))
                } else {
                    None
                }
            })
        })
        .flat_map(|(x, y)| {
            DIR.iter()
                .scan(Vec::with_capacity(3), move |buf, &(dx, dy)| {
                    let nx = x + dx;
                    let ny = y + dy;
                    let ch = mat
                        .get(nx as usize)
                        .and_then(|row| row.get(ny as usize))
                        .copied()
                        .unwrap_or('0');
                    buf.push(ch);
                    if buf.len() == 3 {
                        let chunk = std::mem::take(buf);
                        Some(Some(chunk))
                    } else {
                        Some(None)
                    }
                })
                .filter_map(|opt_chunk| opt_chunk)
                .filter(|chunk| chunk == &['S', 'A', 'M'])
                .map(|_| 1)
        })
        .sum()
}

fn check_x(mat: &[Vec<char>]) -> i32 {
    mat.iter()
        .enumerate()
        .flat_map(|(r, row)| {
            row.iter().enumerate().filter_map(move |(c, &ch)| {
                if ch == 'A' {
                    Some((r as i32, c as i32))
                } else {
                    None
                }
            })
        })
        .filter_map(|(x, y)| {
            nbrs(mat, (x, y), Dirs::Diags).and_then(|(_, vals)| {
                matches!(
                    vals.iter().collect::<String>().as_str(),
                    "MMSS" | "SSMM" | "SMSM" | "MSMS"
                )
                .then_some(1)
            })
        })
        .sum()
}
