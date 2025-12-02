#![allow(dead_code)]
use std::convert::TryInto;
use std::ops::Add;

type Tu = (usize, usize);
type Ti = (i32, i32);

#[derive(Debug)]
pub enum FileVec {
    Strings(Vec<Vec<String>>),
    Ints(Vec<Vec<i32>>),
}

pub enum FileVecType {
    Ints,
    Strings,
}

pub enum Dirs {
    Diags,
    Udlr,
    All,
}

pub fn file_to_vector(path: &str, kind: FileVecType) -> FileVec {
    let file = std::fs::read_to_string(path).expect("Failed to Open File");

    match kind {
        FileVecType::Strings => FileVec::Strings(
            file.lines()
                .map(|line| line.split_whitespace().map(|s| s.to_string()).collect())
                .collect::<Vec<Vec<String>>>(),
        ),
        FileVecType::Ints => FileVec::Ints(
            file.lines()
                .map(|line| {
                    line.split_whitespace()
                        .filter_map(|s| s.parse::<i32>().ok())
                        .collect()
                })
                .collect::<Vec<Vec<i32>>>(),
        ),
    }
}

pub fn inbounds<T>(mat: &[Vec<T>], pos: Ti) -> bool {
    pos.0 >= 0 && pos.0 < mat.len() as i32 && pos.1 >= 0 && pos.1 < mat[0].len() as i32
}

pub fn fetch_val<T: Copy>(mat: &[Vec<T>], pos: Ti) -> Option<T> {
    if inbounds(mat, pos) {
        Some(mat[pos.0 as usize][pos.1 as usize])
    } else {
        None
    }
}

pub fn add_tups<T: Add<Output = T>>(a: (T, T), b: (T, T)) -> (T, T) {
    (a.0 + b.0, a.1 + b.1)
}

pub fn tt_to_tu<T: TryInto<usize>>(pair: (T, T)) -> Option<(usize, usize)> {
    Some((pair.0.try_into().ok()?, pair.1.try_into().ok()?))
}

pub fn dirs_pos<T: Copy>(mat: &[Vec<T>], arr: &[Ti], pos: Ti) -> (Vec<Tu>, Vec<T>) {
    arr.iter()
        .filter_map(|&offset| {
            let new_pos = add_tups(pos, offset);
            let p = tt_to_tu(new_pos)?;
            let val = fetch_val(mat, new_pos)?;
            Some(((p.0, p.1), val))
        })
        .collect::<Vec<(Tu, T)>>()
        .into_iter()
        .unzip()
}

pub fn nbrs<T: Copy>(mat: &[Vec<T>], pos: Ti, dir: Dirs) -> Option<(Vec<Tu>, Vec<T>)> {
    if !inbounds(mat, pos) {
        return None;
    }

    let diags = [(-1, -1), (-1, 1), (1, -1), (1, 1)];
    let udlr = [(-1, 0), (1, 0), (0, -1), (0, 1)];
    let all = [
        (-1, -1),
        (-1, 0),
        (-1, 1),
        (0, -1),
        (0, 1),
        (1, -1),
        (1, 0),
        (1, 1),
    ];

    match dir {
        Dirs::Diags => Some(dirs_pos(mat, &diags, pos)),
        Dirs::Udlr => Some(dirs_pos(mat, &udlr, pos)),
        Dirs::All => Some(dirs_pos(mat, &all, pos)),
    }
}
