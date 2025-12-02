use std::collections::{HashMap, HashSet};
use std::fs::read_to_string;

type TI = (i32, i32);
type STI = HashSet<TI>;
type MTII = HashMap<TI, i32>;
type Mat = [[char; 130]; 130];

const ROWS: usize = 130;
const COLS: usize = 130;
const DIRS: [TI; 4] = [(-1, 0), (0, 1), (1, 0), (0, -1)];

fn main() {
    let (pos, mat, locs) = parse_file();
    let visited = solution(&pos, &mat);
    let pt2 = solution2(&pos, &mat, &locs, &visited);
    println!("Part 1: {}\nPart 2: {}", visited.len(), pt2)
}

fn parse_file() -> (TI, Mat, MTII) {
    let con = read_to_string("../inputs/day6.txt").unwrap();

    let mut start: TI = (0, 0);
    let mut mat: Mat = [['.'; ROWS]; COLS];
    let mut locs: MTII = HashMap::new();

    con.split("\r\n").enumerate().for_each(|(r_ind, row)| {
        row.chars().enumerate().for_each(|(c_ind, col)| {
            mat[r_ind][c_ind] = col;
            if col == '#' {
                locs.insert((r_ind as i32, c_ind as i32), 0);
            } else if col == '^' {
                start = (r_ind as i32, c_ind as i32);
            }
        })
    });

    return (start, mat, locs);
}

fn arr_value(mat: &Mat, loc: &TI) -> char {
    mat[loc.0 as usize][loc.1 as usize]
}

fn add_tups(x: TI, y: TI) -> TI {
    (x.0 + y.0, x.1 + y.1)
}

fn is_within_bounds(pos: TI) -> bool {
    pos.0 > 0 && (pos.0 as usize) < ROWS - 1 && pos.1 > 0 && (pos.1 as usize) < COLS - 1
}

fn solution(pos: &TI, mat: &Mat) -> STI {
    let mut facing = 0;
    let mut pos = *pos;
    let mut visited: STI = HashSet::new();

    while is_within_bounds(pos) {
        let next_pos = add_tups(pos, DIRS[facing]);
        if arr_value(mat, &next_pos) == '#' {
            facing += 1;
            facing = facing % 4
        } else {
            visited.insert(pos);
            pos = next_pos;
        }
    }
    visited.insert(pos);

    visited
}

fn solution2(pos: &TI, mat: &Mat, locs: &MTII, empty: &STI) -> i32 {
    let mut locs = locs.clone();
    let mut mat = *mat;
    let mut ttl = 0;

    for i in empty {
        let mut facing = 0;
        let mut pos = *pos;
        mat[i.0 as usize][i.1 as usize] = '#';
        locs.insert(*i, 0);

        while is_within_bounds(pos) {
            let next_pos = add_tups(pos, DIRS[facing]);
            if arr_value(&mat, &next_pos) == '#' {
                facing += 1;
                if let Some(value) = locs.get_mut(&next_pos) {
                    *value += 1;
                }
                if locs[&next_pos] == 4 {
                    ttl += 1;
                    break;
                }
                facing = facing % 4
            } else {
                pos = next_pos;
            }
        }
        mat[i.0 as usize][i.1 as usize] = '.';
        for value in locs.values_mut() {
            *value = 0;
        }
        locs.remove(&i);
    }

    ttl
}
